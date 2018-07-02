
######################### K Means Clustering #####################

#K Means Clustering is an unsupervised learning algorithm that tries to 
#cluster data based on their similarity

getwd()
setwd("H:\\Analytics\\R\\Clustering\\Prototypes")

#Exploring the data
library(datasets)
head(iris)

library(ggplot2)
ggplot(iris, aes(Petal.Length, Petal.Width, color = Species)) + geom_point()

#1 standardize data
head(iris)
df <- scale(iris[-5])
head(df)

#Within groups sum of squares
wssplot <- function(data, nc = 15, seed = 1234) {
  wss <- (nrow(data) - 1) * sum(apply(data,2,var))
  for (i in 2:nc) {
    set.seed(seed)
    wss[i] <- sum(kmeans(data, centers = i)$withinss)
  }
  plot(1:nc, wss, type = "b", xlab = "Number of Clusters",
       ylab = "Within groups sum of squares")
}

wssplot(df)

#Clustering
#Cluster using Petal.Length, Petal.Width

# Find Number of clusters
#Hubert's gamma coefficient, the Dunn index
library(NbClust)
set.seed(1234)
nc <- NbClust(df[, 3:4], min.nc=2, max.nc=15, method="kmeans")
table(nc$Best.n[1,])

set.seed(20)
irisCluster <- kmeans(df[, 3:4], 3, nstart = 20)
irisCluster

#Cluster Output

#Cluster A vector of integers (from 1:k) 
#indicating the cluster to which each point is allocated
irisCluster$cluster

#The number of points in each cluster
irisCluster$size

#A matrix of cluster centres
irisCluster$centers

#The total sum of squares
irisCluster$totss

#within-cluster sum of squares
irisCluster$withinss

#Total within-cluster sum of squares, i.e. sum(withinss)
irisCluster$betweenss

#The between-cluster sum of squares, i.e. totss-tot.withinss
irisCluster$tot.withinss

#The number of (outer) iterations
irisCluster$iter

#Confusion Matrix/Contingency Table
ct_km <- table(irisCluster$cluster, iris$Species)

#agreement between type and cluster - corrected rand index
#It ranges from -1 (no agreement) to 1 (perfect agreement)
library(flexclust)
randIndex(ct_km)

# plot the data to see the clusters:
irisCluster$cluster <- as.factor(irisCluster$cluster)
ggplot(iris, aes(Petal.Length, Petal.Width, color = irisCluster$cluster)) + 
  geom_point()

# Cluster Plot against 1st 2 principal components

# vary parameters for most readable graph
library(cluster) 
clusplot(iris[, 3:4], irisCluster$cluster, color=TRUE, shade=TRUE, 
         labels=2, lines=0)

# Centroid Plot against 1st 2 discriminant functions
library(fpc)
plotcluster(iris[, 3:4], irisCluster$cluster)

###############################################################

#Assess the quality of clustering algorithms

#Entropy
#Purity.

#Class-based Precision and Recall
#Pair-wise Precision and Recall
#Adjusted Pair-wise Precision

#F-measure 
#Class-based 
#Pair-wise

#Normalized mutual information
#Gap statistic

#Rand Index
#Rand Index adjusted by Chance

#Matching Index
#Figure of Merit

#high intra-cluster similarity (documents within a cluster are similar)
#Cluster Cohesion

#low inter-cluster similarity (documents from different clusters are dissimilar)
#Cluster Separation

#Dunn index
#Hubert's gamma coefficient
#Davies-Bouldin index
#Silhouette coefficient
#Jaccard index
#Fowlkes-Mallows index
#Prediction strength of clustering

#Measuring Cluster Validity Via Correlation
#Edge Correlation

#Using Similarity Matrix for Cluster Validation
#Expected Density ??

#Determining Number of Clusters   -------- 
  #Elbow Method - 
  #x-means clustering
  #Information Criterion Approach
  #Percentage of Variance Explained (PVE)
  #Clustergram
