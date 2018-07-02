install.packages('factoextra')
install.packages('cluster')
library(cluster)
library(dendextend)
library(ggplot2)
library(factoextra)

head(USArrests)
df <- na.omit(USArrests)
df <- scale(df)

# Determine number of clusters using the elbow method
set.seed(7)
k.max <- 15 # Maximum number of clusters
wss <- sapply(1:k.max, function(k){kmeans(df, k, nstart=10 )$tot.withinss})  ## Compute wss for k = 2 to k = 15
plot(1:k.max, wss, type="b", pch = 19, frame = FALSE, xlab="Number of clusters K", ylab="Total within-clusters sum of squares")  ## Plot WSS

#################### k-means ###########################
set.seed(7)
km.res <- kmeans(df, 4, nstart = 25)  ## Running the k-means algorithm with 4 clusters (determined by the elbow graph)
print(km.res)
km.res$withinss  ## Within cluster sum of squares for each cluster; Other options include the cluster centers, size of each cluster and cluster assignment

aggregate(USArrests, by=list(cluster=km.res$cluster), mean) ## Cluster-wise mean for each attribute; Other options include median, standard deviation

plot(df, col = km.res$cluster, pch = 19, main = "K-means with k = 4")  ## Plotting cluster points with their centroids
points(km.res$centers, col = 1:4, pch = 8, cex = 2)

clusplot(df, km.res$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)  ## Another plot for the clusters

#################### Partitioning around mediods (PAM) ###########################
pam.res <- pam(df, 4)  ## PAM method for clustering
print(pam.res)

clusplot(pam.res, main = "Cluster plot, k = 4", color = TRUE)  ## Plotting the results
plot(silhouette(pam.res),  col = 2:5)  ## Silhouette plot; Each horizontal line corresponds to an element. The length of the lines corresponds to silhouette width, which is the similarity of each element to its own cluster minus the mean similarity to the next most similar cluster
pam.res$silinfo  ## Silhouette information

#################### CLARA ###########################
clara.res <- clara(df, 4, samples=50)
clara.res$silinfo
plot(silhouette(clara.res),  col = 2:5)


#################### Hierarchical Clustering ###########################
d <- dist(df, method = "euclidean")  ## Dissimilarity matrix (pairwise distances using Euclidean distance)
hc.res <- hclust(d, method = "ward.D2" )  ## Hierarchical clustering using Ward's method; Method options : ward.D, ward.D2, single, complete, average, mcquitty, median or centroid
plot(hc.res, cex = 0.6, hang = -1)  ## Plot the obtained dendrogram


agnes.res <- agnes(df, method = "ward")  ## Agglomerative Nesting (AGNES) : bottom-up approach based on combining most similar clusters
agnes.res$ac  # Agglomerative coefficient
pltree(agnes.res, cex = 0.6, hang = -1, main = "AGNES")  ## Dendogram plots
plot(as.hclust(agnes.res), cex = 0.6, hang = -1, main = "AGNES")

diana.res <- diana(df)  ## Divise Analysis (DIANA) : top down approach based on dividing the most heterogenous cluster into two
pltree(diana.res, cex = 0.6, hang = -1, main = "DIANA")  ## Plot the tree


##### Cutting the dendogram to obtain clusters ######
grp <- cutree(hc.res, k = 4)  # Cut tree into 4 groups
print(grp)

plot(hc.res, cex = 0.6)
rect.hclust(hc.res, k = 5, border = 2:5)  ## Plot the clusters in the dendogram

