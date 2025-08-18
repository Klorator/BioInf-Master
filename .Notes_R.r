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
  df1$my_x[i] <- df1$my_x[i-1] *1.2
  } else if (i < 40) {
      df1$my_x[i] <- df1$my_x[i-1] *1.6
  } else {
      df1$my_x[i] <- df1$my_x[i-1] *3

  }
}

df1$my_x <- log10(df1$my_x)

  ## Scatterplot
library(ggplot2)
ggplot(df1) +
  aes(my_x, my_y) +
  geom_pointrange(aes(ymin = my_y - std_dev, # for adding points with standard deviation
                    ymax = my_y + std_dev)
  ) +
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
predictionPoints <- data.frame(my_x = seq(min(df1$my_x),
                                          max(df1$my_x), 
                                          length.out = nrow(df1))
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
  geom_pointrange(aes(ymin = my_y - std_dev, # for adding points with standard deviation
                      ymax = my_y + std_dev),
                  color = "blue"

  ) +
 scale_x_log10() +
 geom_line(
  data = df_curve,
  linewidth = 2
)



# https://stackoverflow.com/questions/63568848/fitting-a-sigmoidal-curve-to-points-with-ggplot
## Example data
drug <- c("drug_1", "drug_1", "drug_1", "drug_1", "drug_1", 
  "drug_1", "drug_1", "drug_1", "drug_2", "drug_2", "drug_2", 
        "drug_2", "drug_2", "drug_2", "drug_2", "drug_2")

conc <- c(100.00, 33.33, 11.11, 3.70, 1.23, 0.41, 0.14, 
        0.05, 100.00, 33.33, 11.11, 3.70, 1.23, 0.41, 0.14, 0.05)

mean_response <- c(1156, 1833, 1744, 1256, 1244, 1088, 678, 489, 
        2322, 1867, 1333, 944, 567, 356, 200, 177)

std_dev <- c(117, 317, 440, 200, 134, 38, 183, 153, 719,
      218, 185, 117, 166, 167, 88, 50)

df <- data.frame(drug, conc, mean_response, std_dev)

## analysis

p1 <- nls(
  mean_response ~ SSlogis(conc, Asym, xmid, scal), 
  data = df,
  subset = (drug == "drug_1" & conc < 100)
    ## , weights=1/std_dev^2  ## error in qr.default: NA/NaN/Inf ...
)

## I can't get this to work with the weights
# library(nls2)
# p1B <- nls2(mean_response~SSlogis(conc,Asym,xmid,scal),data=df,
#             subset=(drug=="drug_1" & conc<100),
#             weights=1/std_dev^2
#           )

p2 <- update(p1, subset = (drug == "drug_2"))
# p2B <- update(p1B,subset=(drug=="drug_2"))

pframe0 <- data.frame(
  conc = 10^seq(log10(min(df$conc)),
                log10(max(df$conc)), 
                length.out=100)
)
pp <- rbind(
    data.frame(pframe0, mean_response = predict(p1, pframe0),
               drug = "drug_1", wts = FALSE),
    data.frame(pframe0, mean_response = predict(p2, pframe0),
               drug = "drug_2", wts = FALSE)#,
    #data.frame(pframe0, mean_response = predict(p1B, pframe0),
    #           drug = "drug_1", wts = TRUE),
    #data.frame(pframe0, mean_response = predict(p2B, pframe0),
    #           drug = "drug_2", wts = TRUE)
)

library(ggplot2); theme_set(theme_classic())
ggplot(
  df,
  aes(conc, mean_response, colour = drug)
  ) +
 geom_pointrange(aes(ymin = mean_response - std_dev,
                     ymax = mean_response + std_dev)
  ) +
 scale_x_log10() +
 geom_line(
  data = pp,
  aes(linetype = wts), 
      linewidth = 2
  )






# another try
library(sicegar)
# simulate sigmoidal data
time <- seq(3, 24, 0.5)

noise_parameter <- 0.1
intensity_noise <- runif(n = length(time), min = 0, max = 1) * noise_parameter
intensity <- sigmoidalFitFormula(time, maximum = 4, slope = 1, midPoint = 8)
intensity <- intensity + intensity_noise
dataInputSigmoidal <- data.frame(intensity = intensity, time = time)

# simulate double-sigmoidal data
noise_parameter <- 0.2
intensity_noise <- runif(n = length(time),min = 0,max = 1) * noise_parameter
intensity <- doublesigmoidalFitFormula(time,
                                    finalAsymptoteIntensityRatio = .3,
                                    maximum = 4,
                                    slope1 = 1,
                                    midPoint1Param = 7,
                                    slope2 = 1,
                                    midPointDistanceParam = 8)
intensity <- intensity + intensity_noise
dataInputDoubleSigmoidal <- data.frame(intensity = intensity, time = time)

# fit models to both datasets
fitObj_sm <- fitAndCategorize(dataInput = dataInputSigmoidal)
fitObj_dsm <- fitAndCategorize(dataInput = dataInputDoubleSigmoidal)

# sigmoidal raw data only
figureModelCurves(dataInput = fitObj_sm$normalizedInput)

# sigmoidal fit
figureModelCurves(dataInput = fitObj_sm$normalizedInput,
                  sigmoidalFitVector = fitObj_sm$sigmoidalModel)

# sigmoidal fit with parameter related lines
figureModelCurves(dataInput = fitObj_sm$normalizedInput,
                  sigmoidalFitVector = fitObj_sm$sigmoidalModel,
                  showParameterRelatedLines = TRUE)






# yet another try
