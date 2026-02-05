#########################
# © Mateusz Garbulowski #
#########################

# R.ROSETTA works with UNIX and Windows OS. 
# However, UNIX operating systems (like MAC or Linux) require 32-bit Wine 
# - a free and open-source compatibility layer.

set.seed(1)
# install and load the library
install.packages("devtools")
library(devtools)
install_github("komorowskilab/R.ROSETTA")
library(R.ROSETTA)

# number of features
dim(autcon)[2]-1

# number of objects per each class
table(autcon$decision)

# run rosetta with autcon data
autconJohnson <- rosetta(autcon, roc = TRUE, clroc = "autism")
rules <- autconJohnson$main
qual <- autconJohnson$quality

# print top 12 rules
rlsAut <- viewRules(rules[rules$decision=="autism",], setLabels=TRUE, labels=c("low", "medium", "high"))
print(rlsAut[1:12,])

tabS<-table(rules[rules$pValue>0.05,]$decision)

# fraction of significant rules, in [%]
tabS[1]/sum(rules$decision=="autism")*100
tabS[2]/sum(rules$decision=="control")*100

# ROC curve
plotMeanROC(autconJohnson)

# analyze the rule-based model
gf <- getFeatures(rules, filter = T, filterType = "pvalue", thr = 0.05)
genesAutism <- gf$features$autism
genesControl <- gf$features$control

#set operators from "base" library
?union
?intersect
?setdiff

# recalculate the model
recAutconJohnson <- recalculateRules(autcon, rules)
subset_data <- recAutconJohnson[recAutconJohnson$decision=='control',]

topRuleInd <- # find index of the most significant rule for control
# set new labels for plots using parameter label=c()
plotRule(autcon, recAutconJohnson, type="heatmap", discrete=FALSE, ind=topRuleInd, label = c('low', 'medium'))
plotRule(autcon, recAutconJohnson, type="boxplot", discrete=FALSE, ind=topRuleInd, label= c('low', 'medium'))


#Hierarchical clustering of model rules
#subsetting the significant rules from the recalculated rules
sig_recAutconJohnson<- recAutconJohnson[recAutconJohnson$pValue < 0.05,]
clusterRules(autcon,sig_recAutconJohnson,fontsize = 20)




