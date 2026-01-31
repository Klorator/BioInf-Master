# Quiz 2 - Selection and Allele Dynamics
a <- c(16, 16, 11) # number of offspring per genotype (absolute fitness)
n_ind <- sum(a) # total number of individuals in the population
max_fit <- max(a) # maximum fitness
rel_fit <- a / max_fit # relative fitness

geno_freq <- c(A1A1 = 0.65, A1A2 = 0.15, A2A2 = 0.2) # genotype frequencies
w_bar <- sum(rel_fit * geno_freq) # mean population fitness

## first calculate the allele frequencies
# define the total number of alleles
n_allele <- 2 * sum(a)

# calculate p
p <- ((a[1] * 2) + a[2]) / n_allele
# calculate q
q <- 1 - p

## now calculate the marginal fitness
w1 <- (p * rel_fit[1]) + (q * rel_fit[2])
w2 <- (p * rel_fit[2]) + (q * rel_fit[3])

# frequency of p in the next generation
p_t <- (p * w1) / w_bar

# change in p after one generation of selection
delta_p <- p_t - p

selection_model <- function(p, rel_fit) {
  # define q
  q <- 1 - p
  # calculate genotype frequencies (under HWE)
  gf <- c(p^2, 2 * (p * q), q^2)

  # calculate mean pop fitness
  w_bar <- sum(rel_fit * gf)

  # calculate marginal allele frequencies
  w1 <- (p * rel_fit[1]) + (q * rel_fit[2])
  w2 <- (p * rel_fit[2]) + (q * rel_fit[3])

  # calculate freq of p in the next generation
  p_t <- (p * w1) / w_bar
  # return the results
  return(p_t)
}

selection_model(p = 0.5, rel_fit = c(1, 1, 0.75))
selection_model(p = 0.5, rel_fit = c(1, 1, 0.5))
selection_model(p = 0.5, rel_fit = c(1, 1, 0.3))

# initialise values
p <- p_init <- 0.5
n_gen <- 100

# run the selection model across generations
p_vec <- sapply(1:n_gen, function(y) {
  p_t <- selection_model(p = p, rel_fit = c(1, 1, 0.75))
  p <<- p_t
})

# include the initial allele frequency
p_vec <- c(p_init, p_vec)


# new simulation
# initialise values
p <- p_init <- 0.5
n_gen <- 100

# run the selection model across generations
p_vec <- sapply(1:n_gen, function(y) {
  p_t <- selection_model(p = p, rel_fit = c(1, 1, 0.3))
  p <<- p_t
})

# include the initial allele frequency
p_vec <- c(p_init, p_vec)


# make a simulation/looping function
selection_sim <- function(p, rel_fit, n_gen) {
  p_init <- p
  my_rel_fit <- rel_fit
  p_vec <- sapply(1:n_gen, function(y) {
    p_t <- selection_model(p = p, rel_fit = my_rel_fit)
    p <<- p_t
  })
  p_vec <- c(p_init, p_vec)
  return(p_vec)
}

# Test the selection simulator
selection_sim(p = 0.5, rel_fit = c(1, 1, 0.75), n_gen = 1000)

library(tibble)

# set the vector for the relative fitness of A2A2
A2A2_rf <- seq(from = 0.2, to = 0.8, by = 0.2)

# run simulations for each
sel_sims <- sapply(A2A2_rf, function(z) {
  selection_sim(p = 0.5, rel_fit = c(1, 1, z), n_gen = 200)
})

# assign names to the matrix
colnames(sel_sims) <- paste0("w22=", A2A2_rf)

# create a generations vector
g <- seq(0, 200, 1)

sel_sims <- as_tibble(cbind(g, sel_sims))


# We can write a function to include also other information into our object such as
# mean population fitness, allele frequencies, genotype frequencies etc
selection_model <- function(p, rel_fit) {
  # define q
  q <- 1 - p

  # calculate genotype frequencies (under HWE)
  gf <- c(p^2, 2 * (p * q), q^2)

  # calculate mean population fitness
  w_bar <- sum(rel_fit * gf)

  # calculate marginal fitnesses of the alleles
  w1 <- (p * rel_fit[1]) + (q * rel_fit[2])
  w2 <- (p * rel_fit[2]) + (q * rel_fit[3])

  # calculate frequency of p in the next generation
  p_t <- (p * w1) / w_bar

  # return multiple outputs as a list
  output <- list(
    p = p,
    q = q,
    geno_freq = gf,
    w_bar = w_bar,
    w1 = w1,
    w2 = w2,
    p_t = p_t
  )
  return(output)
}

# install.packages("dplyr")
library(dplyr)
library(purrr) # should be part of base installation; if not use install.packages("purrr")

# run selection_model across generations and collect outputs
selection_sim <- function(p, rel_fit, n_gen) {
  sim <- sapply(
    1:n_gen,
    function(y) {
      out <- selection_model(p = p, rel_fit = rel_fit)
      p <<- out$p_t
      return(out)
    },
    simplify = FALSE
  )

  sim_data <- sim %>%
    map_dfr(magrittr::extract, c('p', 'q', 'w_bar', 'w1', 'w2', 'p_t'))

  return(sim_data)
}


# set generations
n_gen <- 50

# run simulation
dom <- selection_sim(p = 0.01, rel_fit = c(1, 1, 0.2), n_gen)


p_init <- 0.01 # Fixed starting allele frequency (A1)
n_gen <- 200 # set generations
s_vec <- c(0.05, 0.10, 0.30)

rel_fit_recessive <- function(s) c(1, 1, 1 - s)

# Run simulations
sims <- sapply(
  s_vec,
  function(s) {
    selection_sim(p = p_init, rel_fit = rel_fit_recessive(s), n_gen = n_gen)$p
  },
  simplify = "matrix"
)

#Plotting results
matplot(
  0:(n_gen - 1),
  sims,
  type = "l",
  xlab = "Generation",
  ylab = "Allele frequency p (A1)"
)
legend(
  "bottomright",
  legend = paste0("s = ", s_vec),
  col = 1:length(s_vec),
  lty = 1:length(s_vec),
  bty = "n"
)


p_init <- 0.01
n_gen <- 200
s <- 0.3

# Fitness schemes with identical s but different dominance
rel_fit_dom <- c(1, 1, 1 - s) # dominant A1
rel_fit_add <- c(1, 1 - s / 2, 1 - s) # additive
rel_fit_rec <- c(1, 1 - s, 1 - s) # recessive A1

# Run simulations
sims <- cbind(
  dominant = selection_sim(p = p_init, rel_fit = rel_fit_dom, n_gen = n_gen)$p,
  additive = selection_sim(p = p_init, rel_fit = rel_fit_add, n_gen = n_gen)$p,
  recessive = selection_sim(p = p_init, rel_fit = rel_fit_rec, n_gen = n_gen)$p
)

# Plotting results
matplot(
  0:(n_gen - 1),
  sims,
  type = "l",
  xlab = "Generation",
  ylab = "Allele frequency p (A1)"
)
legend(
  "bottomright",
  legend = c("Dominant A1", "Additive", "Recessive A1"),
  col = 1:3,
  lty = 1:3,
  bty = "n"
)
