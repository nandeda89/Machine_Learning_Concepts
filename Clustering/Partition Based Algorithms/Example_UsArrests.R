##### The Guide for Clustering Analysis on a Real Data

#Load packages:
library(cluster)
library(factoextra)

# Load the data set
data(USArrests)

# Remove any missing value (i.e, NA values for not available)
# That might be present in the data
USArrests <- na.omit(USArrests)

# View the firt 6 rows of the data
head(USArrests, n = 6)

#descriptive statistics
desc_stats <- data.frame(
    Min = apply(USArrests, 2, min), # minimum
    Med = apply(USArrests, 2, median), # median
    Mean = apply(USArrests, 2, mean), # mean
    SD = apply(USArrests, 2, sd), # Standard deviation
    Max = apply(USArrests, 2, max) # Maximum
)
desc_stats <- round(desc_stats, 1)
head(desc_stats)

#Standardization
df<- scale(USArrests)

#Assessing the clusterability
library("factoextra")
res <- get_clust_tendency(df, 40, graph = FALSE)

# Hopskin statistic
res$hopkins_stat

# Visualize the dissimilarity matrix
res$plot

#The value of Hopkins statistic is significantly < 0.5, indicating that the data is highly clusterable. 

#  Estimate the number of clusters in the data
library("cluster")
set.seed(123)
# Compute the gap statistic
gap_stat <- clusGap(df, FUN = kmeans, nstart = 25, 
                    K.max = 10, B = 500) 
# Plot the result
library(factoextra)
fviz_gap_stat(gap_stat)

# The gap statistic suggests a 4 cluster solutions.

#Compute k-means clustering
set.seed(123)
km.res <- kmeans(df, 4, nstart = 25)
head(km.res$cluster, 20)

# Visualize clusters using factoextra
fviz_cluster(km.res, USArrests)

#Cluster validation statistics: Inspect cluster silhouette plot
sil <- silhouette(km.res$cluster, dist(df))
rownames(sil) <- rownames(USArrests)
head(sil[, 1:3])

fviz_silhouette(sil)

# It can be seen that there are some samples which have negative silhouette values. Some natural questions are
neg_sil_index <- which(sil[, "sil_width"] < 0)
sil[neg_sil_index, , drop = FALSE]

#eclust(): Enhanced clustering analysis
# Compute k-means
res.km <- eclust(df, "kmeans")

# Gap statistic plot
fviz_gap_stat(res.km$gap_stat)

# Silhouette plot
fviz_silhouette(res.km)

# Hierachical clustering using eclust()
# Enhanced hierarchical clustering
res.hc <- eclust(df, "hclust") # compute hclust
fviz_dend(res.hc, rect = TRUE) # dendrogam

fviz_silhouette(res.hc) # silhouette plot
fviz_cluster(res.hc) # scatter plot
