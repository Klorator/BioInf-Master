# Notes for R

# Non-linear logistic regression
## Example data
df1 <- data.frame(
  my_y = 1:50,
  my_x = 1200,
  group = "g1",
  std_dev = rep_len(c(1:3), 50)
)

for (i in 2:length(df1$my_x)) {
  if (i < 15) {
    df1$my_x[i] <- df1$my_x[i - 1] * 1.2
  } else if (i < 40) {
    df1$my_x[i] <- df1$my_x[i - 1] * 1.6
  } else {
    df1$my_x[i] <- df1$my_x[i - 1] * 3
  }
}

df1$my_x <- log10(df1$my_x)

## Scatterplot
library(ggplot2)
ggplot(df1) +
  aes(my_x, my_y) +
  geom_pointrange(aes(
    ymin = my_y - std_dev, # for adding points with standard deviation
    ymax = my_y + std_dev
  )) +
  scale_x_log10()

## Fit model with nls()
model_logistic_1 <- nls(
  my_y ~ SSlogis(my_x, Asym, xmid, scal), # Fit a logistic function with SSlogis()
  data = df1,
  subset = (group == "g1")
)

## Get formula from result: y = Asym / ( 1 + e^((xmid - x) / scal) )
print(model_logistic_1)

## add another group
# model_logistic_2 <- update(model_logistic_1,
# subset = (group == "g2"))

## make points to predict, for creating a smooth line
predictionPoints <- data.frame(
  my_x = seq(min(df1$my_x), max(df1$my_x), length.out = nrow(df1))
)

df_curve <- rbind(
  data.frame(
    predictionPoints,
    my_y = predict(model_logistic_1, predictionPoints),
    group = "g1"
  )
  #, data.frame(
  #   predictionPoints,
  #   my_y = predict(model_logistic_2, predictionPoints),
  #   group = "g2"
  # )
)

## plot regression
library(ggplot2)
ggplot(df1) +
  aes(
    my_x,
    my_y,
    colour = group
  ) +
  theme_classic() +
  geom_pointrange(
    aes(
      ymin = my_y - std_dev, # for adding points with standard deviation
      ymax = my_y + std_dev
    ),
    color = "blue"
  ) +
  scale_x_log10() +
  geom_line(
    data = df_curve,
    linewidth = 2
  )
