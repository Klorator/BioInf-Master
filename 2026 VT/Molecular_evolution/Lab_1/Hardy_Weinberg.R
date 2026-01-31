# Quiz 1 - Hardy-Weinberg Equilibrium

A1A1 <- c(147)
A1A2 <- c(128)
A2A2 <- c(25)
observed <- c(A1A1, A1A2, A2A2)

allele_total <- sum(observed) * 2
p_A1 <- (A1A1 * 2 + A1A2) / allele_total
q_A2 <- 1 - p_A1

expected_frequencies <- c(p_A1^2, 2 * p_A1 * q_A2, q_A2^2)
expected_counts <- expected_frequencies * sum(observed)

fish_data <- data.frame(
  Observed = observed,
  Expected = expected_counts
)
rownames(fish_data) <- c("A1A1", "A1A2", "A2A2")


fish_chi_statistic <- sum(
  (fish_data$Observed - fish_data$Expected)^2 / fish_data$Expected
)
# degrees of freedom = 3 categories - 1 - columns derived from data 1 (expected calculated from frequencies) = 3 - 1 - 1 = 1
fish_chi_p <- pchisq(fish_chi_statistic, df = 1, lower.tail = FALSE)

## New locus
B1B1 <- 156
B1B2 <- 2
B2B2 <- 42
observed_2 <- c(B1B1, B1B2, B2B2)

allele_total_B <- sum(observed_2) * 2
p_B1 <- (B1B1 * 2 + B1B2) / allele_total_B
q_B2 <- 1 - p_B1

expected_frequencies_B <- c(p_B1^2, 2 * p_B1 * q_B2, q_B2^2)
expected_counts_B <- expected_frequencies_B * sum(observed_2)

fish_data_B <- data.frame(
  Observed = observed_2,
  Expected = expected_counts_B
)
rownames(fish_data_B) <- c("B1B1", "B1B2", "B2B2")

fish_chi_statistic_B <- sum(
  (fish_data_B$Observed - fish_data_B$Expected)^2 / fish_data_B$Expected
)
fish_chi_p_B <- pchisq(fish_chi_statistic_B, df = 1, lower.tail = FALSE)
