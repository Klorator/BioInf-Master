# lab 5 correlation & regression

# 5.1 Correlation
shared <- rnorm(1000, 0, 20)
private.A <- rnorm(1000, 0, 20)
private.B <- rnorm(1000, 0, 20)
env.A <- rnorm(1000, 0, 10)
env.B <- rnorm(1000, 0, 10)

A <- shared + private.A + env.A
B <- shared + private.B + env.B

plot(A, B)

# 5.1a
# Calc sample correlation
# r = cov(x,y) / sqrt(sd(x)^2 * sd(y)^2)
# sd(x)^2 == var(x)
AB_r <- cov(A, B) / sqrt(var(A) * var(B))
AB_r
cor(A, B)

# 5.1b
AB_r2 <- cov(A, B) / (sd(A) * sd(B))
AB_r2

# var(x) == cov(x, x)
var(shared)
cov(shared, shared)
cov(private.A, private.B) # theoretically 0

# 5.2 Linear regression
crime <- readr::read_delim(
  file = "Intro to stats for lifesciences/Lab 5/AmericanCrime.txt"
)

# 5.2a
model_diagnostics <- function(model) {
  par(mfrow = c(2, 2))
  plot(model)
  par(mfrow = c(1, 1))
}

simple.2a <- lm(
  violent.crime ~ police.funding,
  data = crime
)
model_diagnostics(simple.2a)

# 5.2b
## log transform crime rate & funding -- best result
simple.2a_log <- lm(
  log10(violent.crime) ~ log10(police.funding),
  data = crime
)
model_diagnostics(simple.2a_log)
summary(simple.2a_log)

plot(
  log10(violent.crime) ~ log10(police.funding),
  data = crime
)
abline(simple.2a_log)

# ## remove outlier 41 -- good but not prefered
# simple.2a <- lm(
#   violent.crime ~ police.funding,
#   data = crime[-41, ]
# )
# model_diagnostics(simple.2a)

# 5.2c
n_oranges <- rnorm(length(crime$violent.crime), 100, 10)
n_apples <- rnorm(length(crime$violent.crime), 100, 10)

multi.2c <- lm(
  log10(violent.crime) ~ log10(police.funding) + n_oranges + n_apples,
  data = crime
)
model_diagnostics(multi.2c)

anova(simple.2a_log, multi.2c)

library(MASS)
library(car)

simple.2d <- rlm(
  violent.crime ~ police.funding,
  data = crime
)
model_diagnostics(simple.2d)

summary(simple.2d)
car::Anova(simple.2d)

# 5.2d

# 5.3
# 5.3a
uni.3a <- lm(
  log10(violent.crime) ~ log10(police.funding),
  data = crime
)
uni.3b <- lm(
  log10(violent.crime) ~ perc.highschool,
  data = crime
)
uni.3c <- lm(
  log10(violent.crime) ~ log10(police.funding) + perc.highschool,
  data = crime
)
summary(uni.3c)

# 5.3b
library(scatterplot3d)
scatterplot3d::scatterplot3d(
  crime$police.funding,
  crime$perc.highschool,
  crime$violent.crime,
  pch = 20
)

multi.3b <- lm(
  log10(violent.crime) ~
    log10(crime.rate) + log10(police.funding) + perc.highschool + perc.college,
  data = crime
)
model_diagnostics(multi.3b)
summary(multi.3b)

# 5.3c
multi.3c <- lm(
  log10(violent.crime) ~ log10(police.funding) + perc.highschool + perc.college,
  data = crime
)
model_diagnostics(multi.3c)
summary(multi.3c)

corrplot::corrplot(cor(crime), method = "number")

RcmdrMisc::partial.cor(crime)
