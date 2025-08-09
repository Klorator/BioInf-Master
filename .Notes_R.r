# Notes for R


# Non-linear logistic regression
  ## Example data
reg_data <- data.frame(
  reg_y = 1:20, reg_x = 1)
for (i in 2:length(reg_data$reg_x)) {
  if (i < 6) {
  reg_data$reg_x[i] <- reg_data$reg_x[i-1] *1.5
  } else if (i < 16) {
      reg_data$reg_x[i] <- reg_data$reg_x[i-1] *2
  } else {
      reg_data$reg_x[i] <- reg_data$reg_x[i-1] *1.5

  }
}

  ## Scatterplots
library(ggplot2)
ggplot(reg_data) +
  aes(reg_x,
  reg_y) +
  geom_point()

ggplot(reg_data) +
  aes(log(reg_x),
  reg_y) +
  geom_point()

    ## Fit model with nls()
model_logistic <- nls(
  reg_y ~ SSlogis(log(reg_x), Asym, xmid, scal), # Fit a logistic function with SSlogis()
  data = reg_data
)

  ## Get formula from result: y = Asym / ( 1 + e^((xmid - x) / scal) )
print(model_logistic)
