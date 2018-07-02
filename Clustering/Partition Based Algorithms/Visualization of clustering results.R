########## Visualization of clustering results

# Visual enhancement of clustering analysis
# Beautiful dendrogram visualizations
# Static and Interactive Heatmap

#######################################################################################################

# Visual enhancement of clustering analysis
#Load required packages:
library(factoextra)
library(cluster)

# Load and scale the dataset
data("USArrests")
df <- scale(USArrests)
head(df)

#Enhanced distance matrix computation and visualization
#get_dist() [in factoextra]: for computing distance matrix between rows of a data matrix. 
#Compared to the standard dist() function, it supports correlation-based distance measures including 
#"pearson", "kendall" and "spearman" methods.

#fviz_dist(): for visualizing a distance matrix

# Correlation-based distance method
res.dist <- get_dist(df, method = "pearson")
head(round(as.matrix(res.dist), 2))[, 1:6]

# Visualize the dissimilarity matrix
fviz_dist(res.dist, lab_size = 8)

#The ordered dissimilarity matrix image (ODI) displays the clustering tendency of the dataset. 
#Similar objects are close to one another. Red color corresponds to small distance and blue color indicates
#big distance between observation.

# Enhanced clustering analysis

# Load and scale the dataset
data("USArrests")
df <- scale(USArrests)

######## Simple Hierarchical clustering
# Compute dissimilarity matrix
res.dist <- dist(df, method = "euclidean")

# Compute hierarchical clustering
res.hc <- hclust(res.dist, method = "ward.D2")

# Visualize
plot(res.hc, cex = 0.5)

######### Clustering using hclust
#In this section we'll show some examples for enhanced k-means clustering and hierarchical clustering. 
#Note that the same analysis can be done for PAM, CLARA, FANNY, AGNES and DIANA.

library("factoextra")

# Enhanced k-means clustering
res.km <- eclust(df, "kmeans", nstart = 25)

# Gap statistic plot
fviz_gap_stat(res.km$gap_stat)

# Silhouette plot
fviz_silhouette(res.km)

# Optimal number of clusters using gap statistics
res.km$nbclust

# Print result
res.km

# Enhanced hierarchical clustering
res.hc <- eclust(df, "hclust") # compute hclust
fviz_dend(res.hc, rect = TRUE) # dendrogam

# Silhouette plot
fviz_silhouette(res.hc) # silhouette plot

# scatter plot
fviz_cluster(res.hc) 

eclust(df, "kmeans", k = 4)
#######################################################################################################

# Beautiful dendrogram visualizations

# Load data
data(USArrests)

# Compute distances and hierarchical clustering
dd <- dist(scale(USArrests), method = "euclidean")
hc <- hclust(dd, method = "ward.D2")

# Default plot
plot(hc)

# Put the labels at the same height: hang = -1
plot(hc, hang = -1, cex = 0.6)

# Convert hclust into a dendrogram and plot
hcd <- as.dendrogram(hc)

# Default plot
plot(hcd, type = "rectangle", ylab = "Height")

# Triangle plot
plot(hcd, type = "triangle", ylab = "Height")

# Zoom in to the first dendrogram
plot(hcd, xlim = c(1, 20), ylim = c(1,8))

# Define nodePar
nodePar <- list(lab.cex = 0.6, pch = c(NA, 19), 
                cex = 0.7, col = "blue")

# Customized plot; remove labels
plot(hcd, ylab = "Height", nodePar = nodePar, leaflab = "none")

# Horizontal plot
plot(hcd,  xlab = "Height",
     nodePar = nodePar, horiz = TRUE)

# Change edge color
plot(hcd,  xlab = "Height", nodePar = nodePar, 
     edgePar = list(col = 2:3, lwd = 2:1))

#Phylogenetic trees
# install.packages("ape")
library("ape")

# Default plot
plot(as.phylo(hc), cex = 0.6, label.offset = 0.5)

# Cladogram
plot(as.phylo(hc), type = "cladogram", cex = 0.6, 
     label.offset = 0.5)

# Unrooted
plot(as.phylo(hc), type = "unrooted", cex = 0.6,
     no.margin = TRUE)

# Fan
plot(as.phylo(hc), type = "fan")

# Radial
plot(as.phylo(hc), type = "radial")

# Cut the dendrogram into 4 clusters
colors = c("red", "blue", "green", "black")
clus4 = cutree(hc, 4)
plot(as.phylo(hc), type = "fan", tip.color = colors[clus4],
     label.offset = 1, cex = 0.7)

# Change the appearance
# change edge and label (tip)
plot(as.phylo(hc), type = "cladogram", cex = 0.6,
     edge.color = "steelblue", edge.width = 2, edge.lty = 2,
     tip.color = "steelblue")

#########
# ggdendro package : ggplot2 and dendrogram
# install.packages("ggdendro")

library("ggplot2")
library("ggdendro")

# Visualization using the default theme named theme_dendro()
ggdendrogram(hc)

# Rotate the plot and remove default theme
ggdendrogram(hc, rotate = TRUE, theme_dendro = FALSE)

#Extract dendrogram plot data
# Build dendrogram object from hclust results
dend <- as.dendrogram(hc)

# Extract the data (for rectangular lines)
# Type can be "rectangle" or "triangle"
dend_data <- dendro_data(dend, type = "rectangle")

# What contains dend_data
names(dend_data)

# Extract data for line segments
head(dend_data$segments)

# Extract data for labels
head(dend_data$labels)

# Plot line segments and add labels
p <- ggplot(dend_data$segments) + 
    geom_segment(aes(x = x, y = y, xend = xend, yend = yend))+
    geom_text(data = dend_data$labels, aes(x, y, label = label),
              hjust = 1, angle = 90, size = 3)+
    ylim(-3, 15)

print(p)

############
#dendextend package: Extending R's dendrogram functionality
#Chaining
#The chaining operator (%>%) turns x %>% f(y) into f(x, y) so you can use it to rewrite multiple operations 
#such that they can be read from left-to-right, top-to-bottom. For instance, the results of the two R codes 
#below are equivalent.

#Standard R code for creating a dendrogram:
data <- scale(USArrests)
dist.res <- dist(data)
hc <- hclust(dist.res, method = "ward.D2")
dend <- as.dendrogram(hc)
plot(dend)

#R code for creating a dendrogram using chaining operator:
    dend <- USArrests[1:5,] %>% # data
    scale %>% # Scale the data
    dist %>% # calculate a distance matrix, 
    hclust(method = "ward.D2") %>% # Hierarchical clustering 
    as.dendrogram # Turn the object into a dendrogram.
plot(dend)

# install.packages('dendextend')
# Loading:
library(dendextend)

#How to change a dendrogram
#The function set() can be used to change the parameters with dendextend.
#The format is:
 #set(object, what, value)

# object: a dendrogram object
# what: a character indicating what is the property of the tree that should be set/updated
# value: a vector with the value to set in the tree (the type of the value depends on the "what").

#Create a simple dendrogram
# Create a dendrogram and plot it
dend <- USArrests[1:5,] %>%  scale %>% 
    dist %>% hclust %>% as.dendrogram
dend %>% plot

# Get the labels of the tree
labels(dend)

#Change the color of branches
#The color for branches can be controlled using k-means clustering:
    
# Default colors
    dend %>% set("branches_k_color", k = 2) %>% 
    plot(main = "Default colors")

# Customized colors
dend %>% set("branches_k_color", 
             value = c("red", "blue"), k = 2) %>% 
    plot(main = "Customized colors")

#Adding colored rectangles
# Vertical plot
dend %>% set("branches_k_color", k = 3) %>% plot
dend %>% rect.dendrogram(k=3, border = 8, lty = 5, lwd = 2)

# Horizontal plot
dend %>% set("branches_k_color", k = 3) %>% plot(horiz = TRUE)
dend %>% rect.dendrogram(k = 3, horiz = TRUE, border = 8, lty = 5, lwd = 2)

#Adding colored bars
grp <- c(1,1,1, 2,2)
k_3 <- cutree(dend,k = 3, order_clusters_as_data = FALSE) 

# The FALSE above makes sure we get the clusters in the order of the
# dendrogram, and not in that of the original data. It is like:
# cutree(dend, k = 3)[order.dendrogram(dend)]
the_bars <- cbind(grp, k_3)
dend %>% set("labels", "") %>% plot
colored_bars(colors = the_bars, dend = dend)

#ggplot2 integration
dend <- iris[1:30,-5] %>% scale %>% dist %>% 
    hclust %>% as.dendrogram %>%
    set("branches_k_color", k=3) %>% set("branches_lwd", 1.2) %>%
    set("labels_colors") %>% set("labels_cex", c(.9,1.2)) %>% 
    set("leaves_pch", 19) %>% set("leaves_col", c("blue", "red"))

# plot the dend in usual "base" plotting engine:
plot(dend)

library(ggplot2)
# Rectangle dendrogram using ggplot2
ggd1 <- as.ggdend(dend)
ggplot(ggd1) 

# Change the theme to the default ggplot2 theme
ggplot(ggd1, horiz = TRUE, theme = NULL) 

# Theme minimal
ggplot(ggd1, theme = theme_minimal()) 

# Create a radial plot and remove labels
ggplot(ggd1, labels = FALSE) + 
    scale_y_reverse(expand = c(0.2, 0)) +
    coord_polar(theta="x")

#pvclust and dendextend
library(pvclust)
data(lung) # 916 genes for 73 subjects
set.seed(1234)

result <- pvclust(lung[1:100, 1:10], method.dist="cor", 
                  method.hclust="average", nboot=10)

# Default plot of the result
plot(result)
pvrect(result)

# pvclust and dendextend
result %>% as.dendrogram %>% 
    set("branches_k_color", k = 2, value = c("purple", "orange")) %>%
    plot
result %>% text
result %>% pvrect
#######################################################################################################

# Static and Interactive Heatmap

#Data
df <- as.matrix(scale(mtcars))

#Draw a heat map using R base function
# Default plot
heatmap(df, scale = "none")

## Use custom colors
col<- colorRampPalette(c("red", "white", "blue"))(256)
heatmap(scale(as.matrix(mtcars)), scale = "none",
        col =  col)

# Use RColorBrewer color palette names
library("RColorBrewer")
col <- colorRampPalette(brewer.pal(10, "RdYlBu"))(256)
heatmap(df, scale = "none", col =  col, 
        RowSideColors = rep(c("blue", "pink"), each = 16),
        ColSideColors = c(rep("purple", 5), rep("orange", 6)))

#Enhanced heat map
# install.packages("gplots")
library("gplots")
heatmap.2(df, scale = "none", col = bluered(100), 
          trace = "none", density.info = "none")

#Interactive heatmap
#install.packages("d3heatmap")
library("d3heatmap")

d3heatmap(scale(mtcars), colors = "RdBu",
          k_row = 4, k_col = 2)

#Enhancing heatmaps using dendextend
library(dendextend)

# order for rows
Rowv  <- mtcars %>% scale %>% dist %>% hclust %>% as.dendrogram %>%
    set("branches_k_color", k = 3) %>% set("branches_lwd", 1.2) %>%
    ladderize

# Order for columns
# We must transpose the data
Colv  <- mtcars %>% scale %>% t %>% dist %>% hclust %>% as.dendrogram %>%
    set("branches_k_color", k = 2, value = c("orange", "blue")) %>%
    set("branches_lwd", 1.2) %>%
    ladderize

# heatmap(scale(mtcars), Rowv = Rowv, Colv = Colv,
#         scale = "none")
# 
# library(gplots)
# heatmap.2(scale(mtcars), scale = "none", col = bluered(100), 
#           Rowv = Rowv, Colv = Colv,
#           trace = "none", density.info = "none")

library("d3heatmap")
d3heatmap(scale(mtcars), colors = "RdBu",
          Rowv = Rowv, Colv = Colv)


#######################################################################################################

#########3 K Modes - categorical data
library(klaR)

### a 5-dimensional toy-example:
## generate data set with two groups of data:
set.seed(1)
x <- rbind(matrix(rbinom(250, 2, 0.25), ncol = 5),
           matrix(rbinom(250, 2, 0.75), ncol = 5))

colnames(x) <- c("a", "b", "c", "d", "e")
## run algorithm on x:
(cl <- kmodes(x, 2))

## and visualize with some jitter:
plot(jitter(x), col = cl$cluster)
points(cl$modes, col = 1:5, pch = 8)


