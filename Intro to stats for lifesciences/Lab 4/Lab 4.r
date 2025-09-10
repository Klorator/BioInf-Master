# Lab 4: ANOVA

# 4.1
diet_df <- readr::read_delim(
  file = "Intro to stats for lifesciences/Lab 4/diet.txt",
  delim = "\t",
  col_names = T
)
## Calculate weight loss
diet_df <- diet_df |>
  dplyr::mutate(
    weight.loss = pre.weight - weight6weeks
  )

## Boxplot
library(ggplot2)
ggplot(diet_df) +
  aes(
    x = Diet,
    y = weight.loss
  ) +
  geom_boxplot() +
  geom_hline(
    yintercept = 0,
    col = "blue"
  ) +
  labs(
    x = "Diet type",
    y = "Weight loss [kg]"
  )

## Create model
diet_model_1a <- aov(
  weight.loss ~ Diet,
  data = diet_df
)
diet_model_1b <- lm(
  weight.loss ~ Diet,
  data = diet_df
)

# 4.1a Model diagnostics
model_diagnostics <- function(model) {
  par(mfrow = c(2, 2))
  plot(model)
  par(mfrow = c(1, 1))
}
model_diagnostics(diet_model_1a)
model_diagnostics(diet_model_1b)
# Everything looks fine

hist(resid(diet_model_1a))

summary(diet_model_1a)
summary(diet_model_1b)

# 4.1b

# 4.1c

car::Anova(
  diet_model_1a,
  type = 2
)
car::Anova(
  diet_model_1b,
  type = 2
)

TukeyHSD(diet_model_1a)
plot(TukeyHSD(diet_model_1a))

# 4.1.d

# 4.2
diet_model_2a <- lm(
  weight.loss ~ Diet + sex,
  data = diet_df
)
model_diagnostics(diet_model_2a)

# 4.2a
summary(diet_model_2a)

# Two independent factors: Diet + sex
# Interaction: Diet:sex
# Independant and interaction: Diet * sex = Diet + sex + Diet:sex
diet_model_2b <- lm(
  weight.loss ~ Diet * sex,
  data = diet_df
)
model_diagnostics(diet_model_2b)
summary(diet_model_2b)
# Estimating the coefficients:
# Stuff that's missing is included in (intercept)
# (intercept) + treatment gives value for that group,
# just keep adding them together

# 4.2b
lattice::bwplot(
  weight.loss ~ Diet | sex,
  data = diet_df
)

plot(effects::allEffects(diet_model_2b))

# 4.3 GLM
A <- rpois(10000, 1)
B <- rpois(10000, 1.2)
pois_data <- data.frame(
  replicate = c(rep("A", 10000), rep("B", 10000)),
  result = c(A, B)
)

pois_model <- glm(
  result ~ replicate,
  data = pois_data,
  family = "poisson"
)
summary(pois_model)
car::Anova(pois_model)
pois_model_summary <- summary(pois_model)
coef <- data.frame(
  names = rownames(pois_model_summary$coefficients),
  coefficients = pois_model_summary$coefficients[, 1]
) |>
  dplyr::mutate(
    exp_coef = exp(coefficients) # need to add every row to intercept before exp()
  )


# 4.3a
binom_data <- data.frame(
  replicate = c(rep("A", 10000), rep("B", 10000)),
  result = c(rbinom(10000, 1, 0.2), rbinom(10000, 1, 0.1))
)

binom_model <- glm(
  result ~ replicate,
  data = binom_data,
  family = "binomial"
)
summary(binom_model)
car::Anova(binom_model)

### All testing is done on raw data transformed to a distribution.
### Must backtransform to raw data for it to make sense.

# 4.4 LME
jimson <- readr::read_delim(
  file = "Intro to stats for lifesciences/Lab 4/jimson.txt"
)
jimson <- jimson |>
  dplyr::mutate(
    Type = factor(
      Type,
      levels = c(1, 2),
      labels = c("G", "N")
    ),
    Pot = forcats::as_factor(Pot)
  )

fm1a <- aov(
  LenWid ~ Type * Pot,
  data = jimson
)
summary(fm1a)
