# Library
library(ape)
library(ggtree)
library(ggplot2)
library(grid)

# Read Newick string and create a 'phylo' object
newick <- "((Red_bellied_piranha_TERF2:0.3133772440,Zebrafish_TERF2:0.4276226397):0.1544804504,((Clownfish_TERF2:0.1645114741,Midas_cichild_TERF2:0.2364769847):0.2620989260,Salmon_TERF2:0.3728182665):0.1868774299,Fox_TERF2:0.7079591245);"
tr <- read.tree(text = newick)

# Plot
# Build base ggtree plot (no tip label text yet)
p <- ggtree(tr, branch.length = "branch.length") +
  theme_tree2() +
  # ggtitle("Phylogenetic tree for TERF2") +
  theme(
    plot.title = element_text(hjust = 0.5),
    # give extra right margin so long tip labels are not clipped
    plot.margin = grid::unit(c(0.5, 4.5, 0.5, 0.5), "cm"),
    # set x-axis tick label size
    axis.text.x = element_text(size = 12.5)
  )

# Tip label overrides: provide a named or ordered character vector to replace tip text
tip_label_override <- c(
  Clownfish_TERF2 = "Clown anemonefish",
  Midas_cichild_TERF2 = "Midas cichlid",
  Salmon_TERF2 = "Atlantic salmon",
  Fox_TERF2 = "Red fox",
  Red_bellied_piranha_TERF2 = "Red-bellied piranha",
  Zebrafish_TERF2 = "Zebrafish"
)

# tip_label_override <- NULL
replace_underscores <- TRUE
tip_label_size <- 4
tip_label_color <- "black"
tip_label_linesize <- 0.5

# Compute display_label for each tip (apply overrides and simple formatting)
is_tip <- p$data$node <= length(tr$tip.label)
orig_labels <- as.character(ifelse(is_tip, p$data$label, NA_character_))
display_label <- orig_labels

if (!is.null(tip_label_override)) {
  if (
    !is.null(names(tip_label_override)) &&
      any(names(tip_label_override) != "")
  ) {
    # Named mapping: replace matching original labels
    for (nm in names(tip_label_override)) {
      display_label[display_label == nm] <- tip_label_override[[nm]]
    }
  } else if (length(tip_label_override) == length(tr$tip.label)) {
    # Unnamed vector: assume order matches tr$tip.label
    tip_order <- tr$tip.label
    for (i in seq_along(tip_order)) {
      display_label[display_label == tip_order[i]] <- tip_label_override[i]
    }
  } else {
    warning(
      "tip_label_override length does not match number of tips and is not named; ignoring"
    )
  }
}

if (replace_underscores) {
  display_label <- gsub("_", " ", display_label)
}

# Attach display_label into the ggtree data and draw tip labels
p$data$display_label <- display_label
p <- p +
  geom_tiplab(
    aes(label = display_label),
    size = tip_label_size,
    align = TRUE,
    linesize = tip_label_linesize,
    color = tip_label_color
  )

# Prepare branch metadata: here we use branch lengths as a dN/dS proxy
branch_df <- data.frame(node = tr$edge[, 2], dnds = tr$edge.length)
p$data$dnds <- branch_df$dnds[match(p$data$node, branch_df$node)]

label_rows <- which(!is.na(p$data$dnds))
if (length(label_rows) > 0) {
  # Create a mapping of node -> (x,y,label)
  node_coords <- p$data[, c("node", "x", "y", "label")]

  # Get edge matrix (parent, child) from tree
  edges <- as.data.frame(tr$edge)
  names(edges) <- c("parent", "child")

  # Compute midpoint coordinates for each edge and prepare branch-label data
  y_range <- max(p$data$y, na.rm = TRUE) - min(p$data$y, na.rm = TRUE)
  y_offset <- y_range * 0.04

  label_df <- do.call(
    rbind,
    lapply(seq_len(nrow(edges)), function(i) {
      parent <- edges$parent[i]
      child <- edges$child[i]
      dnds_val <- branch_df$dnds[which(branch_df$node == child)]
      if (length(dnds_val) == 0 || is.na(dnds_val)) {
        return(NULL)
      }
      parent_row <- node_coords[node_coords$node == parent, ]
      child_row <- node_coords[node_coords$node == child, ]
      if (nrow(parent_row) == 0 || nrow(child_row) == 0) {
        return(NULL)
      }
      mid_x <- (parent_row$x + child_row$x) / 2
      mid_y <- (parent_row$y + child_row$y) / 2 + y_offset
      data.frame(
        child = child,
        tip_label = ifelse(
          is.null(child_row$label) || is.na(child_row$label),
          NA_character_,
          as.character(child_row$label)
        ),
        x = mid_x,
        y = mid_y,
        label = sprintf("%.3f", dnds_val),
        stringsAsFactors = FALSE
      )
    })
  )

  # Manual placement template: customize `custom_pos` (child node -> y_manual)
  custom_pos <- data.frame(
    child = c(1:6, 8:10),
    y_manual = c(2.2, 3.2, 5.2, 6.2, 4.2, 1.2, 2.7, 4.9, 5.7)
  )
  # custom_pos <- NULL
  # Apply manual overrides if provided (merge by child node)
  if (exists("custom_pos") && !is.null(custom_pos) && nrow(custom_pos) > 0) {
    label_df <- merge(
      label_df,
      custom_pos,
      by = "child",
      all.x = TRUE,
      sort = FALSE
    )
    label_df$y <- ifelse(
      !is.na(label_df$y_manual),
      label_df$y_manual,
      label_df$y
    )
    label_df$y_manual <- NULL
  }

  # Draw branch dN/dS labels above branches
  if (!is.null(label_df) && nrow(label_df) > 0) {
    p <- p +
      geom_text(
        data = label_df,
        aes(x = x, y = y, label = label),
        inherit.aes = FALSE,
        size = 4
      )
  }
}

# Reduce the x-axis (branch-length) empty space but keep tip labels visible.
# Tip labels (with align=TRUE) are placed at or beyond `max(p$data$x)`; using
# a smaller upper limit removed them. Expand slightly and disable clipping.
max_x <- max(p$data$x, na.rm = TRUE)
# Use a small padding so tip labels are inside the panel, and allow drawing
# outside the panel if needed.
p <- p + coord_cartesian(xlim = c(0, max_x * 1.02), clip = "off")

# Add a small custom legend (text box) with border and short descriptions
max_y <- max(p$data$y, na.rm = TRUE)
y_rng <- max_y - min(p$data$y, na.rm = TRUE)
legend_labels <- c(
  "Target: Atlantic salmon",
  "Outgroup: Elephant shark"
)
legend_xmin <- max_x * 0.005
legend_xmax <- max_x * 0.275
legend_ys <- max_y - c(0, y_rng * 0.06)
legend_df <- data.frame(
  x = rep(
    legend_xmax - (legend_xmax - legend_xmin) * 0.04,
    length(legend_labels)
  ),
  y = legend_ys,
  label = legend_labels,
  stringsAsFactors = FALSE
)

p <- p +
  annotate(
    "rect",
    xmin = legend_xmin,
    xmax = legend_xmax,
    ymin = min(legend_ys) - y_rng * 0.005,
    ymax = max(legend_ys) + y_rng * 0.08,
    fill = "white",
    alpha = 0.8,
    colour = "black",
    linewidth = 0.3
  ) +
  geom_text(
    data = legend_df,
    aes(x = x, y = y, label = label),
    inherit.aes = FALSE,
    hjust = 1,
    vjust = -1,
    size = 4
  )

label_df # Check the computed label positions and values for debugging
p

out_png <- file.path(
  # "2026 VT",
  # "Molecular_evolution",
  # "Project",
  "phylo_tree_ggtree.png"
)
ggsave(out_png, plot = p, width = 10, height = 6, dpi = 300)

##### Model comparison #####
# LRT calc. for comparing models
# LR = 2*( lnL(Model_B) - lnL(Model_A)) gives us the Likelihood ratio
# df = np(Model_B) - np(Model_A) gives us the degrees of freedom. np = number of parameters
# pchisq(q = LR, df = df, lower.tail = F)

lnL_A <- -816.580104
lnL_B <- -811.984041
lnL_C <- -807.975729
np_A <- 10
np_B <- 11
np_C <- 19

LR_AB <- 2 * (lnL_B - lnL_A)
df_AB <- np_B - np_A

LR_BC <- 2 * (lnL_C - lnL_B)
df_BC <- np_C - np_B

p_val_AB <- pchisq(q = LR_AB, df = df_AB, lower.tail = F)
p_val_BC <- pchisq(q = LR_BC, df = df_BC, lower.tail = F)

result_LRT <- list(
  Model_A_vs_B = list(LR = LR_AB, df = df_AB, p_value = p_val_AB),
  Model_B_vs_C = list(LR = LR_BC, df = df_BC, p_value = p_val_BC)
)
saveRDS(result_LRT, file = "result_LRT.rds")

## dN/dS calculations

dN_A <- 2.8314
dS_A <- 2.8314
dNdS_A <- dN_A / dS_A
dNdS_A

dN_B <- 2.3392
dS_B <- 4.6871
dNdS_B <- dN_B / dS_B
dNdS_B

dN_C <- 2.3332
dS_C <- 8.3416
dNdS_C <- dN_C / dS_C
dNdS_C

result_dNdS <- list(
  Model_A = dNdS_A,
  Model_B = dNdS_B,
  Model_C = dNdS_C
)
saveRDS(result_dNdS, file = "result_dNdS.rds")
