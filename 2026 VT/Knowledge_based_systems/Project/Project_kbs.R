rm(list = ls())

#========MCFS======#
# load packages
library(rJava)
library(rmcfs)

####################################################################################################
setwd('C:/_Bioinformatics/Knowledge-Based Systems/Project')
# load dataset
df <- read.csv("Project3.csv")
df$protectionStatus <- factor(
  df$protectionStatus,
  levels = c("Prot", "NonProt")
)
table(df$protectionStatus)
####################################################################################################
# perform monte carlo feature selection (random reducts)
result <- mcfs(
  protectionStatus ~ .,
  df,
  projections = 3000,
  projectionSize = 0.05,
  splits = 3,
  splitSetSize = 50,
  cutoffPermutations = 100,
  threadsNumber = 8
)
head(result)
####################################################################################################
# render results
plot(result, type = "distances")
####################################################################################################
# fetch results
result$RI
result$RI[1:result$cutoff_value, ]
features <- result$RI[result$RI$RI > 0.05, ]$attribute
df_MCFS <- df[c(features, "protectionStatus")]
# prepare id graph plot
gid <- build.idgraph(result, size = 20)
plot.idgraph(gid, label_dist = 0.3)

####################################################################################################
library(devtools)
library(R.ROSETTA)

JohnsonParam <- list(
  Module = TRUE,
  BRT = TRUE,
  BRTprec = 0.99,
  Precompute = TRUE,
  Approximate = TRUE,
  Fraction = 0.99
)

ros_full <- rosetta(
  df,
  roc = TRUE,
  clroc = "Prot",
  cvNum = 5,
  JohnsonParam = JohnsonParam
)
ros_MCFS <- rosetta(
  df_MCFS,
  clroc = "Prot",
  roc = TRUE,
  cvNum = 5,
  JohnsonParam = JohnsonParam
)

print(ros_full$quality)
print(ros_MCFS$quality)

plotMeanROC(ros_full)
plotMeanROC(ros_MCFS)


#==========
rules <- ros_MCFS$main
rls_ros_MCFS <- viewRules(
  rules[rules$decision == "Prot", ],
  setLabels = TRUE,
  labels = c("low", "medium", "high")
)
print(rls_ros_MCFS[1:12, ])

rules_full <- ros_full$main
rls_ros_full <- viewRules(
  rules_full[rules_full$decision == "Prot", ],
  setLabels = TRUE,
  labels = c("low", "medium", "high")
)
print(rls_ros_full[1:12, ])

#======
rec_rules <- recalculateRules(df_MCFS, rules)
#rec_rules <- rec_rules[rec_rules$pValue < 0.05,]
rec_rls_ros_MCFS <- viewRules(
  rec_rules[rec_rules$decision == "Prot", ],
  setLabels = TRUE,
  labels = c("low", "medium", "high")
)
print(rec_rls_ros_MCFS[1:12, ])


library(RCy3)
library(csVisuNet)
cytoscapePing()
vis <- visunetcyto(rec_rules)


topRuleInd <- c(1) # find index of the most significant rule for control
# set new labels for plots using parameter label=c()
plotRule(
  df_MCFS,
  ros_MCFS,
  type = "heatmap",
  discrete = FALSE,
  ind = topRuleInd,
  label = c('low', 'medium')
)
plotRule(
  df_MCFS,
  ros_MCFS,
  type = "boxplot",
  discrete = FALSE,
  ind = topRuleInd,
  label = c('low', 'medium')
)


sig_rec_ros_MCFS <- rec_rls_ros_MCFS[rec_rls_ros_MCFS$pValue < 1, ]
clusterRules(df_MCFS, rec_rls_ros_MCFS, fontsize = 20)
