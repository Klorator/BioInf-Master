####################################################################################################

# install required packages
# install.packages("rJava")
# install.packages("rmcfs")

####################################################################################################

# load packages
library(rmcfs)

####################################################################################################

# load dataset
alizadeh <- read.table("2026 VT/Knowledge_based_systems/Lab_5/alizadeh.csv")

####################################################################################################

# perform monte carlo feature selection (random reducts)
result <- mcfs(
  class ~ .,
  alizadeh,
  projections = 1500,
  projectionSize = 0.1,
  splits = 5,
  splitSetSize = 500,
  cutoffPermutations = 6,
  threadsNumber = 8
)

####################################################################################################

# render results
plot(result, type = "distances")

####################################################################################################

# fetch results
result2 <- result$RI[1:result$cutoff_value, ]

# prepare id graph plot
gid <- build.idgraph(result, size = 20)
plot.idgraph(gid, label_dist = 0.3)

####################################################################################################
