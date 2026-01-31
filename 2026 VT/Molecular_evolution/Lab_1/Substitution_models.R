# Part 2 - substitution models

# Stuff on solander

short_lnl <- c(-174.517479, -173.673404, -166.723186)
short_tree <- c(0.07277, 0.07306, 0.07255)
long_lnl <- c(-38680.554957, -38285.478952, -37294.740084)
long_tree <- c(0.12381, 0.12842, 0.12893)
np <- c(4, 5, 9)

introns <- rbind(short_lnl, short_tree, long_lnl, long_tree, np)
colnames(introns) <- c("JC69", "K80", "REV")
introns

# Short intron model comparisons
## JC69 vs K80
pchisq(q = introns[1, "K80"] / introns[1, "JC69"], df = 1, lower.tail = FALSE)
## K80 vs REV
pchisq(q = introns[1, "REV"] / introns[1, "K80"], df = 4, lower.tail = FALSE)

# Long intron model comparisons
## JC69 vs K80
pchisq(q = introns[3, "K80"] / introns[3, "JC69"], df = 1, lower.tail = FALSE)
## K80 vs REV
pchisq(q = introns[3, "REV"] / introns[3, "K80"], df = 4, lower.tail = FALSE)
