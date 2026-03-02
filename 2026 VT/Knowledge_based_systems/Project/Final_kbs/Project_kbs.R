rm(list = ls())

#========MCFS======#
# load packages
library(rJava)
library(rmcfs)

####################################################################################################
setwd('C:/_Bioinformatics/Knowledge-Based Systems/Project')
# load dataset
df <- read.csv("Project3.csv")
df$protectionStatus <- factor(df$protectionStatus,
                              levels = c("Prot","NonProt")
)
table(df$protectionStatus)
####################################################################################################
# perform monte carlo feature selection (random reducts)
result <- mcfs(protectionStatus ~ ., df, projections = 1000, projectionSize = 0.5, splits = 8, splitSetSize = 50, cutoffPermutations = 100, threadsNumber = 8)
head(result)
####################################################################################################
# render results
plot(result, type = "distances")
####################################################################################################
# fetch results
result$RI
result$RI[1:result$cutoff_value,]
features <- result$RI[1:7,]$attribute
df_MCFS <- df[c(features, "protectionStatus")]
# prepare id graph plot
gid <- build.idgraph(result, size = 20) 
plot.idgraph(gid, label_dist = 0.3) 

####################################################################################################
library(devtools)
library(R.ROSETTA)

JohnsonParam <- list(Module=TRUE, BRT=TRUE, BRTprec=0.99,Precompute=TRUE, Approximate=TRUE, Fraction=0.99)

ros_MCFS <- rosetta(df_MCFS, 
                    clroc = "Prot", 
                    roc = TRUE,
                    cvNum = 5
                    ,reducer = "Genetic"
                    ,JohnsonParam=JohnsonParam
)


print(ros_MCFS$quality)
plotMeanROC(ros_MCFS)



#==========
rules <- ros_MCFS$main
rls_ros_MCFS <- viewRules(rules[rules$decision=="Prot",], setLabels=TRUE, labels=c("low", "medium", "high"))
print(rls_ros_MCFS[1:12,])

#======
rec_rules <- recalculateRules(df_MCFS, rules)
print(viewRules(rec_rules[rec_rules$decision=="Prot",], setLabels=TRUE, labels=c("low", "medium", "high"))[1:5,])
print(viewRules(rec_rules[rec_rules$decision=="NonProt",], setLabels=TRUE, labels=c("low", "medium", "high"))[1:5,])


sig_rec_ros_MCFS<- rec_rules[rec_rules$pValue < 1,]
clusterRules(df_MCFS, sig_rec_ros_MCFS, fontsize = 20)

print(viewRules(sig_rec_ros_MCFS, setLabels=TRUE, labels=c("low", "medium", "high")))

library(RCy3)
library(csVisuNet)
cytoscapePing ()

vis <- visunetcyto(rec_rules)
Arc_NonProt <- visuArc(vis,decision = 'NonProt')
Arc_Prot <- visuArc(vis,decision = 'Prot')



