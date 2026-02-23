# LRT calc. for comparing models
# LR = 2*( lnL(Model_B) - lnL(Model_A)) gives us the Likelihood ratio
# df = np(Model_B) - np(Model_A) gives us the degrees of freedom. np = number of parameters
# pchisq(q = LR, df = df, lower.tail = F)

lnL_A <- -16589.164039
lnL_B <- -16011.289303
lnL_C <- -16006.415281

np_A <- 8
np_B <- 9
np_C <- 15

LR_AB <- 2 * (lnL_B - lnL_A)
df_AB <- np_B - np_A

LR_BC <- 2 * (lnL_C - lnL_B)
df_BC <- np_C - np_B

pchisq(q = LR_AB, df = df_AB, lower.tail = F)
pchisq(q = LR_BC, df = df_BC, lower.tail = F)

dN_B <- 0.2118
dS_B <- 1.1453
dNdS_B <- dN_B / dS_B
dNdS_B
