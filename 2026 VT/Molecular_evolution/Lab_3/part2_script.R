# Lab 3 part 2

# ecoli_paralogs <- read.table(
#   '2026 VT/Molecular_evolution/Lab_3/Lab3/E_coli.gene_copy_numbers.txt'
# )
# colnames(ecoli_paralogs) <- c('Gene_name', 'Num_copies', 'Paralog_names')
# hist(
#   ecoli_paralogs$Num_copies,
#   xlab = 'Gene family size',
#   ylab = 'Frequency',
#   breaks = seq(1:max(ecoli_paralogs$Num_copies))
# )

Para_hist_count <- function(Table = 'E_coli.gene_copy_numbers.txt') {
  # Function to loop the histogram and paralog counts
  tab <- read.table(Table) # Reading the table input
  print(paste("Reading file", Table, sep = " ")) # Showing what is read E_coli has been set as default
  colnames(tab) <- c('Gene_name', 'Num_copies', 'Paralog_names') # Renaming the columns
  hist(
    tab$Num_copies,
    xlab = 'Gene family size',
    ylab = 'Frequency',
    breaks = seq(1:max(tab$Num_copies)),
    main = Table
  ) # Making the histogram with custom title to track
  paralog_count <- length(tab$Gene_name[tab$Num_copies > 1]) # calculating number of genes with paralogs
  print(paste("Paralogue count is", paralog_count, "in", Table)) # Printing the result
}

lab_dir <- "2026 VT/Molecular_evolution/Lab_3/Lab3"
list <- list.files(
  path = lab_dir,
  pattern = "gene_copy_numbers.txt"
) # Making a list of all files ending with this pattern
for (sp in list) {
  Para_hist_count(file.path(lab_dir, sp))
} # Looping the function across all files

# Data from your result table
df <- data.frame(
  Species = c(
    "Mycoplasma genitalium",
    "Borrelia burgdorferi B31",
    "Streptococcus agalactiae NEM316",
    "Pasteurella multocida",
    "Oceanobacillus iheyensis HTE831",
    "Escherichia coli K12",
    "Salmonella enterica Typhimurium str. LT2",
    "Pseudomonas aeruginosa PA01",
    "Mesorhizobium japonicum",
    "Bradyrhizobium japonicum USDA 110"
  ),
  GenomeSize_bp = c(
    580074,
    910724,
    2211485,
    2257487,
    3630528,
    4639221,
    4857432,
    6264403,
    7036074,
    9105828
  ),
  GeneCount = c(509, 1391, 2047, 2017, 3439, 4242, 4548, 5572, 6997, 8317),
  GenesWithParalogs = c(52, 551, 448, 339, 1000, 1375, 1527, 2277, 3147, 3947)
)

# Compute percent genes with paralogs
df$PercentParalogs <- df$GenesWithParalogs / df$GeneCount * 100

# Plot: genome size vs percent paralogs
plot(
  df$GenomeSize_bp,
  df$PercentParalogs,
  xlab = "Genome size (bp)",
  ylab = "% genes with paralogs",
  pch = 19
)

# label points
text(
  df$GenomeSize_bp,
  df$PercentParalogs,
  labels = df$Species,
  pos = 4,
  cex = 0.7
)
