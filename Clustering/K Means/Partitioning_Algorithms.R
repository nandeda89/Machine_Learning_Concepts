#######################################################################################################

############ K Means

#Load the packages
library(cluster)
library(factoextra)

set.seed(123)
# Two-dimensional data format
df <- rbind(matrix(rnorm(100, sd = 0.3), ncol = 2),
            matrix(rnorm(100, mean = 1, sd = 0.3), ncol = 2))

colnames(df) <- c("x", "y")
head(df)

# Compute k-means
set.seed(123)
km.res <- kmeans(df, 2, nstart = 25)

# Cluster number for each of the observations
km.res$cluster

# Cluster size
km.res$size

# Cluster means
km.res$centers

plot(df, col = km.res$cluster, pch = 19, frame = FALSE,
     main = "K-means with k = 2")

points(km.res$centers, col = 1:2, pch = 8, cex = 3)

####K = 4
set.seed(123)
km.res <- kmeans(df, 4, nstart = 25)

plot(df, col = km.res$cluster, pch = 19, frame = FALSE,
     main = "K-means with k = 4")

points(km.res$centers, col = 1:4, pch = 8, cex = 3)

# Print the result
km.res

set.seed(123)
# K-means with nstart = 1
km.res <- kmeans(df, 4, nstart = 1)
km.res$tot.withinss

# K-means with nstart = 25
km.res <- kmeans(df, 4, nstart = 25)
km.res$tot.withinss

######## K Means - Usarrests Examples
# Load the data set
data("USArrests")

# Remove any missing value (i.e, NA values for not available)
# That might be present in the data
df <- na.omit(USArrests)

# View the firt 6 rows of the data
head(df, n = 6)

desc_stats <- data.frame(
    Min = apply(df, 2, min), # minimum
    Med = apply(df, 2, median), # median
    Mean = apply(df, 2, mean), # mean
    SD = apply(df, 2, sd), # Standard deviation
    Max = apply(df, 2, max) # Maximum
)

desc_stats <- round(desc_stats, 1)
head(desc_stats)

#Standardize
df <- scale(df)
head(df)

#Number of clusters
library(factoextra)
set.seed(123)
fviz_nbclust(df, kmeans, method = "gap")

#Four clusters are suggested.

# Compute k-means clustering with k = 4
set.seed(123)
km.res <- kmeans(df, 4, nstart = 25)
print(km.res)

# mean of each of the variables in the clusters:
aggregate(USArrests, by=list(cluster=km.res$cluster), mean)

# If we have a multi-dimensional data set, a solution is to perform Principal Component Analysis (PCA) and 
#to plot data points according to the first two principal components coordinates.

#The function fviz_cluster() [in factoextra] can be easily used to visualize clusters. Observations are 
#represented by points in the plot, using principal components if ncol(data) > 2. An ellipse is drawn around 
#each cluster.

fviz_cluster(km.res, data = df)


################################################################################################################

############# PAM Clustering or k-medoids clustering

library("cluster")

# Load data
data("USArrests")

# Scale the data and compute pam with k = 4
pam.res <- pam(scale(USArrests), 4)

pam.res$medoids

head(pam.res$cluster)
clusplot(pam.res, main = "Cluster plot, k = 4", 
         color = TRUE)

fviz_cluster(pam.res)

plot(silhouette(pam.res),  col = 2:5) 
fviz_silhouette(silhouette(pam.res)) 

# Compute silhouette
sil <- silhouette(pam.res)[, 1:3]

# Objects with negative silhouette
neg_sil_index <- which(sil[, 'sil_width'] < 0)
sil[neg_sil_index, , drop = FALSE]

#pamK - FPC - no needto give k value
pam.res <- pamk(scale(USArrests))

############################################################################################3

#### CLARA Clustering Large Applications
set.seed(1234)

# Generate 500 objects, divided into 2 clusters.
x <- rbind(cbind(rnorm(200,0,8), rnorm(200,0,8)),
           cbind(rnorm(300,50,8), rnorm(300,50,8)))
head(x)

# Compute clara
clarax <- clara(x, 2, samples=50)

# Cluster plot
fviz_cluster(clarax, stand = FALSE, geom = "point",
             pointsize = 1)

# Silhouette plot
plot(silhouette(clarax),  col = 2:3, main = "Silhouette plot")  

# Medoids
clarax$medoids

# Clustering
head(clarax$clustering, 20)

#########################################################################################################

# R packages and functions for visualizing partitioning clusters

########## clusplot() function

set.seed(123)

# K-means clustering
km.res <- kmeans(scale(USArrests), 4, nstart = 25)

# Use clusplot function
library(cluster)
clusplot(scale(USArrests), km.res$cluster,  main = "Cluster plot",
         color=TRUE, labels = 4, lines = 0)

#########  fviz_cluster() function
library("factoextra")

# Visualize kmeans clustering
fviz_cluster(km.res, USArrests)

# Visualize pam clustering
pam.res <- pam(scale(USArrests), 4)
fviz_cluster(pam.res)

# Change frame type
fviz_cluster(pam.res, frame.type = "t")

# Remove ellipse fill color
# Change frame level
fviz_cluster(pam.res, frame.type = "t",
             frame.alpha = 0, frame.level = 0.7)

# Show point only
fviz_cluster(pam.res, geom = "point")

# Show text only
fviz_cluster(pam.res, geom = "text")

# Change the color and theme
fviz_cluster(pam.res) + 
    scale_color_brewer(palette = "Set2")+
    scale_fill_brewer(palette = "Set2") +
    theme_minimal()

#####################################################################################################