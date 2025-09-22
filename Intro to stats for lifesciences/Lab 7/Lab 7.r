# lab 7 Ordination

# 7.1
tadpole <- readr::read_delim(
  "Intro to stats for lifesciences/Lab 7/tadpole_food.txt"
)
tadpole <- tadpole |>
  dplyr::mutate(
    Pop = factor(Pop),
    Food = factor(Food)
  )

dat <- scale(tadpole[3:9])

k2 <- kmeans(dat, centers = 2, nstart = 25)
k3 <- kmeans(dat, centers = 3, nstart = 25)
k4 <- kmeans(dat, centers = 4, nstart = 25)
k5 <- kmeans(dat, centers = 5, nstart = 25)

p2 <- factoextra::fviz_cluster(k2, geom = 'point', data = dat) +
  ggplot2::ggtitle("k = 2")
p3 <- factoextra::fviz_cluster(k3, geom = 'point', data = dat) +
  ggplot2::ggtitle("k = 3")
p4 <- factoextra::fviz_cluster(k4, geom = 'point', data = dat) +
  ggplot2::ggtitle("k = 4")
p5 <- factoextra::fviz_cluster(k5, geom = 'point', data = dat) +
  ggplot2::ggtitle("k = 5")

gridExtra::grid.arrange(p2, p3, p4, p5, nrow = 2)

# 7.1a
# k=2 is best but still not good.
# compare spread within cluster (Dim with high explained) to distance between cluster centroids.

factoextra::fviz_nbclust(dat, kmeans, method = 'silhouette') +
  ggplot2::labs(subtitle = 'Silhouette method')

# 7.1b
# k=2 optimal

k2$centers

# 7.1c

# 7.2
d <- dist(dat, method = 'euclidean') # Dissimilarity matrix

hc1 <- hclust(d, method = 'complete')

plot(hc1, cex = 0.6, hang = -1)
rect.hclust(hc1, k = 2, border = 2:5)

plot(hc1, cex = 0.6, hang = -1)
rect.hclust(hc1, k = 3, border = 2:5)

plot(hc1, cex = 0.6, hang = -1)
rect.hclust(hc1, k = 4, border = 2:5)

# 7.2a

# 7.3
snp <- readr::read_delim(
  "Intro to stats for lifesciences/Lab 7/SNPdata2.txt"
)
snp$Pop <- factor(snp$Pop)

dat2 <- as.matrix(snp[3:ncol(snp)])

d <- dist(dat2, method = 'euclidean')
fit <- cmdscale(d, k = 2)
fit

cols = c(
  'red',
  'blue',
  'black',
  'steelblue',
  "yellow",
  "black",
  "magenta",
  "green",
  "purple"
)
dev.off()

plot(
  fit,
  xlab = 'Coordinate 1',
  ylab = 'Coordinate 2',
  main = 'Classical MDS',
  type = 'n'
)
points(
  fit,
  col = snp$Pop,
  cex = 0.7,
  pch = 19
)
legend(
  'bottomleft',
  col = cols,
  legend = levels(snp$Pop),
  pch = 16,
  cex = 0.7
)

snp_pca <- prcomp(
  dat2,
  scale = F
)

ggplot2::autoplot(
  snp_pca,
  data = snp,
  col = cols[snp$Pop]
) +
  ggplot2::theme_classic()

# 7.3a
d2 <- dist(dat2, method = 'manhattan')

fit2 <- cmdscale(d, k = 2)

plot(
  fit2,
  xlab = 'Coordinate 1',
  ylab = 'Coordinate 2',
  main = 'Classical MDS',
  type = 'n'
)
points(
  fit2,
  col = snp$Pop,
  cex = 0.7,
  pch = 19
)
legend(
  'bottomleft',
  col = cols,
  legend = levels(snp$Pop),
  pch = 16,
  cex = 0.7
)
