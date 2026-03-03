# Intro to stats for lifesciences
# Lab 2

# Hypothetical data for 10 students/year
# true mean = 30, true SD = 10
year_1 <- rnorm(
  n = 10,
  mean = 30,
  sd = 10
)

year_4 <- rnorm(
  n = 10,
  mean = 30,
  sd = 10
)

# Plot histograms
par(mfrow = c(1, 2))
hist(year_1)
hist(year_4)
par(mfrow = c(1, 1))

# t-test
students_t.test <- t.test(
  year_1,
  year_4,
  var.equal = T
)
students_t.test

# Function: Simulate n repeated t-tests
simulate_students_test <- function(rep, n, mean, sd, p_val = 0.05) {
  if (length(mean) < 2) {
    mean <- c(mean, mean)
  }
  if (length(sd) < 2) {
    sd <- c(sd, sd)
  }
  # Simulate 1000 repeated t-tests
  p_values <- numeric(0)
  for (i in 1:rep) {
    # Hypothetical data for n students/year
    # true mean & true SD
    year_1 <- rnorm(
      n = n,
      mean = mean[1],
      sd = sd
    )
    year_4 <- rnorm(
      n = n,
      mean = mean[2],
      sd = sd
    )

    # t-test & store p-value
    p_values[i] <- t.test(
      year_1,
      year_4,
      var.equal = T
    )$p.value
  }
  # plot histogram p-values
  hist(p_values, breaks = 100)

  # summarize number of significant tests
  test_signif <- ifelse(p_values < p_val, T, F)
  sum(test_signif)

  return(sum(test_signif))
}

# 10 students/year
simulate_students_test(
  rep = 1000,
  n = 10,
  mean = 30,
  sd = 10
)


# Simulate 1000 repeated t-tests with n = 2000
simulate_students_test(
  rep = 1000,
  n = 2000,
  mean = 30,
  sd = 10
)
## Larger sample size lowers type-II error (false negative),
## but repeated t-test gives many type-I error (false positive)

# New experiment, year 1 mean = 29, SD = 10
simulate_students_test(
  rep = 1000,
  n = 10,
  mean = c(29, 30),
  sd = 10
)
# Same as before, ~50 signif tests

simulate_students_test(
  rep = 1000,
  n = 2000,
  mean = c(29, 30),
  sd = 10
)
# More signif tests, ~800

##############################
# New simulation
# Function:
simulate_students_test_2 <- function(
  rep,
  n,
  mean,
  year_4_mean_increase,
  sd,
  p_val = 0.05,
  p_adjust_method = "bonferroni"
) {
  if (length(mean) < 2) {
    mean <- c(mean, mean)
  }
  if (length(sd) < 2) {
    sd <- c(sd, sd)
  }
  # Simulate 1000 repeated t-tests
  p_values <- numeric(0)
  for (i in 1:rep) {
    # Hypothetical data for n students/year
    # true mean & true SD
    year_1 <- rnorm(
      n = n,
      mean = mean[1],
      sd = sd
    )
    year_4 <- rnorm(
      n = n,
      mean = mean[2] + rnorm(1, year_4_mean_increase, 1), # Add points to year 4 mean score
      sd = sd
    )

    # t-test & store p-value
    p_values[i] <- t.test(
      year_1,
      year_4,
      var.equal = T
    )$p.value
  }
  # Adjust p-value
  if (!rlang::is_na(p_adjust_method)) {
    p_values <- p.adjust(p_values, method = p_adjust_method)
  }
  # plot histogram p-values
  hist(p_values, breaks = 100)

  # summarize number of significant tests
  test_signif <- ifelse(p_values < p_val, T, F)
  sum(test_signif)

  return(sum(test_signif))
}


# n = 50, mean = 30, year 4 mean + 2
simulate_students_test_2(
  rep = 1000,
  n = 50,
  mean = 30,
  year_4_mean_increase = 2,
  sd = 10,
  p_adjust_method = NA
)
# ~190 (changing function to adjust p-values)

# With adjusted p-value
simulate_students_test_2(
  rep = 1000,
  n = 50,
  mean = 30,
  year_4_mean_increase = 2,
  sd = 10,
  p_adjust_method = "bonferroni"
)
# ~3, more reasonable

simulate_students_test_2(
  rep = 1000,
  n = 50,
  mean = 30,
  year_4_mean_increase = 2,
  sd = 10,
  p_adjust_method = "fdr"
)
# ~30

##########################################
# 2.3

# Simulated replicate variation (standardized)
bio_replicates <- rnorm(1000, mean = 0, sd = 1)
tech_replicates <- rnorm(1000, mean = 0, sd = 2)

total_replicates <- bio_replicates + tech_replicates

var(bio_replicates) # ~1
var(tech_replicates) # ~4
var(total_replicates) # ~5

# Variance = SD^2
my_SEM <- function(x) {
  SEM = var(x) / sqrt(length(x))
  return(SEM)
}

my_SEM(bio_replicates)
my_SEM(tech_replicates)

# Bonus:
# calculate the standard error of the mean expression of the gene (SE)
# for all three experimental designs (the original, increased biological
# replication, or increased technical replication).
