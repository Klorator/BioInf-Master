# lab 8: Bootstrapping, sampling, and Bayesian stats

# 8.1 Randomization
High <- rpois(10, lambda = 6) * rbinom(10, 1, 0.7) #you can change values
Low <- rpois(10, lambda = 3) * rbinom(10, 1, 0.9) #if you like.

par(mfrow = c(1, 2))
hist(High) #Look at the distributions
hist(Low) #Data do not look normal, so assumptions of parametric tests are not fulfilled.
par(mfrow = c(1, 1))

#Let’s calculate a test statistic. I choose the difference in means of the two groups:
obs.diff <- mean(High) - mean(Low)

#Let’s make a dataset of all samples from which to sample randomly with replacement:
total <- c(High, Low)

#Let’s do the randomization 10,000 times. We can use a for loop for that:
random.diff <- array(0, 10000) #create an array in which to store output
for (i in 1:10000) {
  #define number of simulations
  A <- sample(total, 10, replace = T) #create a random sample with same size as experiment
  B <- sample(total, 10, replace = T) #create a random sample with same size as experiment
  random.diff[i] <- mean(A) - mean(B) #calculate test statistic for each simulation and store it
}

hist(random.diff, xlim = c(-5, 5)) #histogram of statistic from randomizations
abline(v = obs.diff, col = "red", lwd = 3) #What was the statistic in the real sample?

2 * sum(ifelse(random.diff > obs.diff, 1, 0)) / 10000 #Get the two-sided p-value
t.test(High, Low, var.equal = T) #Compare to what you would get from a t-test

# Note that the t-test assumes a normal distribution – which is not correct!

# 8.2 Mantel test
library(ape)

q1 <- matrix(runif(36), nrow = 6) #Create a 6x6 matrix
q2 <- matrix(runif(36), nrow = 6) #One more

mantel.test(
  q1,
  q2,
  graph = TRUE,
  nperm = 999,
  alternative = "two.sided",
  main = "Mantel test: a random example with 6 X 6 matrices",
  xlab = "z-statistic",
  ylab = "Density",
  sub = "The vertical line shows the observed z-statistic"
)

q3 <- q1 + q2 #Create a third matrix from the first two.

mantel.test(
  q1,
  q3,
  graph = TRUE,
  nperm = 999,
  alternative = "two.sided",
  main = "Mantel test: a random example with 6 X 6 matrices",
  xlab = "z-statistic",
  ylab = "Density",
  sub = "The vertical line shows the observed z-statistic"
)

# 8.3 Bootstrapping
crime <- readr::read_delim(
  "Intro to stats for lifesciences/Lab 8/AmericanCrime.txt"
)

#First, let’s  look at what a parametric test looks like (Pearson’s moment correlation):
cor.test(crime$police.funding, crime$violent.crime)

#Now let’s perform non-parametric bootstrapping of the correlation. First, we need to download the #boot package
library(boot)

booting <- function(data, i) {
  #”data” is your dataset, and “i” is in index telling boot
  resamp <- data[i, ] #what to randomly sample (by rows, for all columns)
  cor_test <- cor(resamp$violent.crime, resamp$police.funding)

  # Store how many times outlier occurs in "i"
  included[loop_counter] <<- sum(outlier_row == i)
  # Increment index for next loop
  loop_counter <<- loop_counter + 1

  return(cor_test)
}

# Some global variables the "booting" function needs
outlier_row <- 41
included <- numeric(0)
loop_counter <- 0
# Bootstrap
crimeboot <- boot(crime, booting, R = 10000)

# Combine into dataframe for histogram showing outliers
t_outlier <- data.frame(test = crimeboot$t, included)

#Bootstrap estimate
mean(crimeboot$t)
median(crimeboot$t)

crimeboot

#We can use the bootstrap estimates to calculate confidence intervals (and all kinds of things)
boot.ci(crimeboot) #default is 95% CI:s

#Plot the bootstraps:
hist(crimeboot$t, 100)
abline(v = mean(crimeboot$t), col = "blue", lwd = 2) #Plot the mean of bootstrapped estimates
abline(v = median(crimeboot$t), col = "purple", lwd = 2) #Plot the median
abline(v = crimeboot$t0, col = "red", lwd = 2) #Plot the correlation in the raw data

# 8.3b
cor.test(log10(crime$police.funding), log10(crime$violent.crime))

# Histogram showing outlier
library(ggplot2)
library(RColorBrewer) # Needs to be installed

ggplot(t_outlier, aes(x = test, fill = factor(included))) +
  theme_classic() +
  geom_histogram(bins = 100, col = "grey50") +
  scale_fill_brewer(name = "Includes outlier") +
  geom_vline(xintercept = mean(crimeboot$t), col = "blue", lwd = 1) +
  geom_vline(xintercept = median(crimeboot$t), col = "purple", lwd = 1) +
  geom_vline(xintercept = crimeboot$t0, col = "red", lwd = 1)
