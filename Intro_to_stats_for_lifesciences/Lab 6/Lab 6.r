# Lab 6: multivariate analysis

crime <- readr::read_delim(
  "Intro to stats for lifesciences/Lab 6/AmericanCrime.txt"
)

plot(crime)
crime_log10 <- log10(crime)

PCA_crime <- prcomp(
  crime_log10[c("crime.rate", "violent.crime")],
  scale = T
)
PCA_crime
summary(PCA_crime)
# (Standard deviation)^2 = eigenvalue
# In prcomp(), 'center' contains eigenvalues
# Variance explained by PC: PC1_eigen / (sum all eigenvalues)

PCA_education <- prcomp(
  crime_log10[c("perc.highschool", "perc.college")],
  scale = T
)
PCA_education
summary(PCA_education)

# 6.1a
# Variance  PC1     PC2
# crime     0.85    0.15
# education 0.86    0.14

crime_log10$PC1_CrimeScore <- PCA_crime$x[, 1]
crime_log10$PC1_EducationScore <- PCA_education$x[, 1]

plot(crime_log10$PC1_CrimeScore, crime_log10$PC1_EducationScore)
# Plot PC against original values good for how they correlate.
plot(crime_log10)

crime_model <- lm(
  PC1_CrimeScore ~ police.funding + PC1_EducationScore,
  crime_log10
)
summary(crime_model)
coef(crime_model)
# Coefficient   Estimate  Interpretation
# Crime          -6.1078
# Funding         3.9311  More funding <=> more crime
# Education       0.2081  Little affect on crime

# 6.2
str(iris)

par(mfrow = c(2, 2))
for (i in 1:4) {
  hist(iris[iris$Species == "virginica", i], main = names(iris)[i])
}
par(mfrow = c(1, 1))

plot(iris[iris$Species == "setosa", 1:4])

PCA_iris <- prcomp(
  iris[1:4],
  scale = T
)
PCA_iris
summary(PCA_iris)

# 6.2b
#            Variance
# PC1 & PC2      96 %
# PC3             4 %

# I would keep PC1 & PC2

library(ggfortify)
# Project data over PC1 & PC2
autoplot(
  PCA_iris,
  data = iris,
  color = "Species",
  loadings = T,
  loadings.color = "blue",
  loadings.label = T,
  loadings.label.size = 3
) +
  theme_classic()

# 6.2c
# Setosa clusters different from Versicolor & Virginica

# 6.3
tadpole <- readr::read_delim(
  "Intro to stats for lifesciences/Lab 6/tadpole_food.txt"
)
tadpole <- tadpole |>
  dplyr::mutate(
    Pop = factor(Pop),
    Food = factor(Food)
  )
pca_tadpole <- prcomp(
  tadpole[3:9],
  scale = T
)
pca_tadpole
summary(pca_tadpole)

# 6.3a
# PC1 to PC5

ggplot2::autoplot(
  pca_tadpole,
  data = tadpole,
  color = 'Food',
  loadings = T,
  loadings.color = 'blue',
  loading.label = T,
  loadings.label.size = 3
) +
  ggplot2::theme_classic()

# 6.4 MANOVA
model_manova <- manova(
  as.matrix(tadpole[3:9]) ~ Food,
  data = tadpole
)
summary(model_manova)
model_manova

# 6.4a

model_manova2 <- manova(
  as.matrix(tadpole[3:9]) ~ Food * Pop,
  data = tadpole
)
summary(model_manova2)
model_manova2

# 6.4c
ggplot2::autoplot(
  pca_tadpole,
  data = tadpole,
  color = 'Pop',
  loadings = T,
  loadings.color = 'blue',
  loading.label = T,
  loadings.label.size = 3
) +
  ggplot2::theme_classic()
