# Lab 3 stuff

# Read DNA sequencing data of de-novo mutations
denovo_df <- readr::read_csv(file = "Intro to stats for lifesciences/Lab 3/two.sample.csv")

# Data distribution
par(mfrow = c(1, 2))
hist(denovo_df$mutations[denovo_df$parent.sex == "Mother"])
hist(denovo_df$mutations[denovo_df$parent.sex == "Mother"])
par(mfrow = c(1, 1))

# t-test
denovo_ttest <- t.test(
  mutations ~ parent.sex,
  var.equal = T,
  data = denovo_df
)
# p = 0.34

# t-test - paired
denovo_paired_df <- readr::read_csv(
  file = "Intro to stats for lifesciences/Lab 3/paired.csv"
)

denovo_paired_ttest <- t.test(
  denovo_paired_df$Mother,
  denovo_paired_df$Father,
  paired = T
)

  ## pivot longer
denovo_long <- denovo_paired_df |> 
  tidyr::pivot_longer(
    cols = c(Mother, Father),
    names_to = "parent",
    values_to = "mutations"
) |> 
  dplyr::mutate(
    trio = forcats::as_factor(trio)
)

# 3.1b
boxplot(
  mutations ~ parent.sex,
  data = denovo_df
)
boxplot(
  denovo_paired_df$Mother - denovo_paired_df$Father
)

# 3.2
# 3.2a
  ## mean = 10, sd = 2
pnorm( # probability to get 13 or more
  q = 13,
  mean = 10,
  sd = 2,
  lower.tail = F # upper end
)

qnorm( # value that 20 % of population is under
  p = 0.2,
  mean = 10,
  sd = 2,
  lower.tail = T # lower end
)

# 3.2b
gene_count <- rpois(
  n = 1000,
  lambda = 5
)
hist(gene_count)

gene_count2 <- rpois(
  n = 1000,
  lambda = 5
)
hist(gene_count2)

# 3 Analysis of frequencies
## 3.3a
sicle_cell <- rbind(
  malaria = c(AA = 0.4, Aa = 0.55, aa = 0.05),
  no_malaria = c(0.8, 0.19, 0.01)
) * 1000 # Scale back to counts

sicle_cell_chi2 <- chisq.test(
  sicle_cell
)
sicle_cell_chi2

## 3.3b Hardy-Weinberg Equilibrium (HWE)

