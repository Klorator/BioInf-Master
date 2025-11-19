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


######################################

df <- data.frame(
  sex = rep(c("M", "F"), 100),
  age = rep(c("A", "B", "C", "D"), 50),
  # crash = rbinom(200, 1, 0.3)
  crash = rep(c("Yes", "No", "No", "Yes", "No", "Yes", "Yes", "No"), 25)
)

df_count <- matrix(table(df))

df_count2 <- df |>
  dplyr::group_by(sex, age) |>
  dplyr::summarise(crash = dplyr::n()) |>
  tidyr::pivot_wider(names_from = age, values_from = crash)
df_count2

chisq.test(df_count)


# Calculate F-stat, P-val, & R2 for regression
## df_variables = 1
## df_obs = obs - 2
## F = SSreg / (SSerror / df_obs)
## P = pf(F, df_variables, df_obs)
## R2 = SSreg / (SSreg + SSerror)

library(MASS)
library(ggfortify)
# Load the data
data("crabs")
# Have a look at the data help file in order to better understand it
?crabs
# Run a PCA on all five morphological measurments for both sexes and both species
pca_all <- prcomp(crabs[, 4:8], scale = TRUE)
# Look at the output
summary(pca_all)
print(pca_all)
# Q1A: How much variance does PC3 explain and what is the loading for BD on PC2?
# Plot and color based on species
autoplot(
  pca_all,
  data = crabs,
  colour = 'sp',
  frame = FALSE,
  loadings = TRUE,
  loadings.colour = 'blue',
  loadings.label = TRUE,
  loadings.label.size = 3
)
# Plot and color based on sex
autoplot(
  pca_all,
  data = crabs,
  colour = 'sex',
  frame = FALSE,
  loadings = TRUE,
  loadings.colour = 'blue',
  loadings.label = TRUE,
  loadings.label.size = 3
)
# Q1B:
# In order to get a better look at the data we subset each sex and look at them seperately
dat_male <- crabs[crabs$sex == "M", ]
pca_male <- prcomp(dat_male[, 4:8], scale = TRUE)
autoplot(
  pca_male,
  data = dat_male,
  colour = 'sp',
  frame = FALSE,
  loadings = TRUE,
  loadings.colour = 'blue',
  loadings.label = TRUE,
  loadings.label.size = 3
)
dat_female <- crabs[crabs$sex == "F", ]
pca_female <- prcomp(dat_female[, 4:8], scale = TRUE)
autoplot(
  pca_female,
  data = dat_female,
  colour = 'sp',
  frame = FALSE,
  loadings = TRUE,
  loadings.colour = 'blue',
  loadings.label = TRUE,
  loadings.label.size = 3
)
# Q1C: Can you detect any differences between the two species when looking at the sexes separately?
#      And what would be your overall conclusion regarding morphological differences in these crabs?
