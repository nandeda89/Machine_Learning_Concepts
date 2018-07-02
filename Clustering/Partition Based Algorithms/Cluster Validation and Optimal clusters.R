##################################################################################################

# R example code for cluster analysis:                

##################################################################################################

## install.packages("pvclust")

#######################################    Partitioning Clustering  ###############################

library(cluster)
library(factoextra) #used to visualize clusters
library(NbClust) # to find number of clusters
library(clustertend) #for assessing clustering tendency
library(seriation) # for visually assessment of cluster tendency
library(ggplot2)  # Visualization
library(vegan) # Jaccard Coefficient
library(ade4)  # Binary, simple matching, jaccard etc
library(proxy) #Distance and Similarity Measures
library(clusterCrit) #Cluster Validation
library(stringdist) # string dist
library(clValid) #Cluster Validation
library(pvclust) # Calculate p value for hierarchical clustering

###############################################################################

#Assessing clustering tendency:


############  faithful dataset
# Load the data
data("faithful")
df <- faithful
head(df)

ggplot(df, aes(x=eruptions, y=waiting)) +
    geom_point() +  # Scatter plot
    geom_density2d() # Add 2d density estimation

############
#### Random uniformly distributed dataset

# Generate random dataset
set.seed(123)
n <- nrow(df)
random_df <- data.frame(
    x = runif(nrow(df), min(df$eruptions), max(df$eruptions)),
    y = runif(nrow(df), min(df$waiting), max(df$waiting)))

# Plot the data
ggplot(random_df, aes(x, y)) + 
    geom_point() +  # Scatter plot
    geom_density2d() # Add 2d density estimation

## Same as above
set.seed(123)
random_df1 <- data.frame(apply(df, 2, 
                   function(x, n){runif(n, min(x), (max(x)))}, n))

# Plot the data
ggplot(random_df1, aes(x=eruptions, y=waiting)) + 
    geom_point() +  # Scatter plot
    geom_density2d() # Add 2d density estimation

###############################

#Why assessing clustering tendency?
#As shown above, we know that faithful dataset contains 2 real clusters. 
#However the randomly generated dataset doesn't contain any meaningful clusters.

set.seed(123)
# K-means on faithful dataset
km.res1 <- kmeans(df, 2)
fviz_cluster(list(data = df, cluster = km.res1$cluster),
             frame.type = "norm", geom = "point", stand = FALSE)

# K-means on the random dataset
km.res2 <- kmeans(random_df, 2)
fviz_cluster(list(data = random_df, cluster = km.res2$cluster),
             frame.type = "norm", geom = "point", stand = FALSE)

# Hierarchical clustering on the random dataset
fviz_dend(hclust(dist(random_df)), k = 2,  cex = 0.5)

#It can be seen that, k-means algorithm and hierarchical clustering impose a classification 
#on the random uniformly distributed dataset even if there are no meaningful clusters present in it.

###############################
# Methods for assessing clustering tendency

#### Hopkins statistic
# Compute Hopkins statistic for faithful dataset
set.seed(123)
hopkins(faithful, n = nrow(faithful)-1)

# Compute Hopkins statistic for a random dataset
set.seed(123)
hopkins(random_df, n = nrow(random_df)-1)

#It can be seen that faithful dataset is highly clusterable (the H value = 0.15 which is far below the 
# threshold 0.5). However the random_df dataset is not clusterable (H=0.53H=0.53)

#### Visual Assessment of cluster Tendency (VAT) algorithm
## R functions for VAT

##We start by scaling the data using the function scale()
set.seed(123)
# faithful data: 
df_scaled <- scale(faithful)

## compute the dissimilarity matrix between observations using the function dist()
df_dist <- dist(df_scaled) 

## finally the function dissplot() [in the package seriation] is used to display an ordered dissimilarity image.
dissplot(df_dist)

## The gray level is proportional to the value of the dissimilarity between observations: pure black if 
#dist(xi,xj)=0dist(xi,xj)=0 and pure white if dist(xi,xj)=1dist(xi,xj)=1. Objects belonging to the same 
#cluster are displayed in consecutive order.

# faithful data: ordered dissimilarity image
set.seed(123)
df_scaled <- scale(faithful)
df_dist <- dist(df_scaled) 
dissplot(df_dist)
#The figure above suggests two clusters represented by two well-formed black blocks.

# perform k-means on faithful dataset and add cluster labels on the dissimilarity plot:
set.seed(123)
km.res <- kmeans(scale(faithful), 2)
dissplot(df_dist, labels = km.res$cluster)

# Random data: ordered dissimilarity image
set.seed(123)
random_df_scaled <- scale(random_df)
random_df_dist <- dist(random_df_scaled) 
dissplot(random_df_dist)
#It can be seen that the random_df dataset doesn't contain any evident clusters.

#### A single function for Hopkins statistic and VAT
# Cluster tendency
clustend <- get_clust_tendency(scale(faithful), 100)

# Hopkins statistic
clustend$hopkins_stat

# VAT Plot
clustend$plot

# Customize the plot
clustend$plot + 
    scale_fill_gradient(low = "steelblue", high = "white")
###############################################################################

#### Calculating distance maesure

# Pearson Correlation
res.dist <- get_dist(USArrests, stand = TRUE, method = "pearson")
fviz_dist(res.dist, 
          gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

## Euclidian
res.dist <- get_dist(USArrests, stand = TRUE, method = "euclidean")
fviz_dist(res.dist, 
          gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

### Manhattan
res.dist <- get_dist(USArrests, stand = TRUE, method = "manhattan")
fviz_dist(res.dist, 
          gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

### maximum
res.dist <- get_dist(USArrests, stand = TRUE, method = "maximum")
fviz_dist(res.dist, 
          gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

### canberra
res.dist <- get_dist(USArrests, stand = TRUE, method = "canberra")
fviz_dist(res.dist, 
          gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

### minkowski
res.dist <- get_dist(USArrests, stand = TRUE, method = "minkowski")
fviz_dist(res.dist, 
          gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

### spearman
res.dist <- get_dist(USArrests, stand = TRUE, method = "spearman")
fviz_dist(res.dist, 
          gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

### kendall
res.dist <- get_dist(USArrests, stand = TRUE, method = "kendall")
fviz_dist(res.dist, 
          gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

#### Other distances -"euclidean", "maximum", "manhattan", "canberra", "binary", 
# "minkowski", "pearson", "spearman" or "kendall".

### binary
## example of binary and canberra distances.
res.dist <- dist(varespec, method = "binary")
fviz_dist(res.dist, 
          gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

### jaccard
data(aviurba)
res.dist <- vegdist(aviurba$fau, method = "jaccard")
head(res.dist)
fviz_dist(res.dist, 
          gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

### Matching Coefficient
data(aviurba)
res.dist <- dist.binary(aviurba$fau, method = 1)
head(res.dist)

for (i in 1:10) {
    d <- dist.binary(aviurba$fau, method = i)
    cat(attr(d, "method"), is.euclid(d), "\n")}


### Russel/Rao
summary(pr_DB)
#https://cran.r-project.org/web/packages/proxy/vignettes/overview.pdf

res.dist <- dist(aviurba$fau, method = "Russel")
head(res.dist)
fviz_dist(res.dist, 
          gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

### Dice's Coefficient
res.dist <- dist(aviurba$fau, method = "Dice")
head(res.dist)
fviz_dist(res.dist, 
          gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

### Gower Distance
res.dist <- daisy(USArrests, metric = "gower")
head(res.dist)
fviz_dist(res.dist, 
          gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

### Chebyshev Distance/ supremum
res.dist <- dist(aviurba$fau, method = "supremum")
head(res.dist)
fviz_dist(res.dist, 
          gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

### cosine Distance
res.dist <- stringdistmatrix(c('foo','bar','boo','baz'),method ="cosine")
head(res.dist)
fviz_dist(res.dist, 
          gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

### Hamming Distance

# Method name Description
# osa Optimal string aligment, (restricted Damerau-Levenshtein distance).
# lv Levenshtein distance (as in R's native adist).
# dl Full Damerau-Levenshtein distance.
# hamming Hamming distance (a and b must have same nr of characters).
# lcs Longest common substring distance.
# qgram q-gram distance.
# cosine cosine distance between q-gram profiles
# jaccard Jaccard distance between q-gram profiles
# jw Jaro, or Jaro-Winker distance.
# soundex Distance based on soundex encoding (see below)

# computing a 'dist' object
res.dist <- stringdistmatrix(c('foo','bar','boo','baz'),method ="hamming")
head(res.dist)
fviz_dist(res.dist, 
          gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

plot(hclust(res.dist))

#stringdist("ABC","abc")


### Levenshtien Distance
x <- "Hello"
y <- "Hlelo"
res.dist <- dist(c(x,y), method = "Levenshtein")
head(res.dist)
fviz_dist(res.dist, 
          gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

###############################################################################

# Clustering Validation Statistics

# 1.Relative clustering validation
# 2.External clustering validation
# 3.Internal clustering validation
# 4.Clustering stability validation

#### Data preparation

# Load the data
data(iris)
head(iris)

# Remove species column (5) and scale the data
iris.scaled <- scale(iris[, -5])

################################
# 1. Relative measures: Determine the optimal number of clusters

# Compute the number of clusters
library(NbClust)
nb <- NbClust(iris.scaled, distance = "euclidean", min.nc = 2,
              max.nc = 10, method = "complete", index = "all")

# Visualize the result
library(factoextra)
fviz_nbclust(nb) + theme_minimal()

#####################

# Example of partitioning method results
# K-means clustering
km.res <- eclust(iris.scaled, "kmeans", k = 3,
                 nstart = 25, graph = FALSE)
# k-means group number of each observation
km.res$cluster

# Visualize k-means clusters
fviz_cluster(km.res, geom = "point", frame.type = "norm")

#############

# PAM clustering
pam.res <- eclust(iris.scaled, "pam", k = 3, graph = FALSE)
pam.res$cluster

# Visualize pam clusters
fviz_cluster(pam.res, geom = "point", frame.type = "norm")

#######################

#Example of hierarchical clustering results
# Enhanced hierarchical clustering
res.hc <- eclust(iris.scaled, "hclust", k = 3,
                 method = "complete", graph = FALSE) 
head(res.hc$cluster, 15)

# Dendrogram
fviz_dend(res.hc, rect = TRUE, show_labels = FALSE) 

##################################
# Internal clustering validation measures

# Silhouette coefficient of observations
sil <- silhouette(km.res$cluster, dist(iris.scaled))
head(sil[, 1:3], 10)

# Silhouette plot
plot(sil, main ="Silhouette plot - K-means")
fviz_silhouette(sil)

# Summary of silhouette analysis
si.sum <- summary(sil)

# Average silhouette width of each cluster
si.sum$clus.avg.widths

# The total average (mean of all individual silhouette widths)
si.sum$avg.width

# The size of each clusters
si.sum$clus.sizes

# Default plot
fviz_silhouette(km.res)

# Change the theme and color
fviz_silhouette(km.res, print.summary = FALSE) +
    scale_fill_brewer(palette = "Dark2") +
    scale_color_brewer(palette = "Dark2") +
    theme_minimal()+
    theme(axis.text.x = element_blank(), axis.ticks.x = element_blank())

# Silhouette information
silinfo <- km.res$silinfo
names(silinfo)

#Samples with a negative silhouette coefficient
# Silhouette width of observation
sil <- res.hc$silinfo$widths[, 1:3]

# Objects with negative silhouette
neg_sil_index <- which(sil[, 'sil_width'] < 0)
sil[neg_sil_index, , drop = FALSE]

#It can be seen that several samples have a negative silhouette coefficient in the hierarchical clustering. 
#This means that they are not in the right cluster.
#We can find the name of these samples and determine the clusters they are closer (neighbor cluster)
####################
# Dunn index
library(fpc)
# Compute pairwise-distance matrices
dd <- dist(iris.scaled, method ="euclidean")

# Statistics for k-means clustering
km_stats <- cluster.stats(dd,  km.res$cluster)

# (k-means) within clusters sum of squares
km_stats$within.cluster.ss

# (k-means) cluster average silhouette widths
km_stats$clus.avg.silwidths

# Display all statistics
km_stats

############################################
# External clustering validation

#library("fpc")
# Compute cluster stats
species <- as.numeric(iris$Species)
clust_stats <- cluster.stats(d = dist(iris.scaled), 
                             species, km.res$cluster)
# Corrected Rand index
clust_stats$corrected.rand

clust_stats$vi

############################################
#Using Clustercrit package

# Internal Criteria
x <- rbind(matrix(rnorm(100, mean = 0, sd = 0.5), ncol = 2),
           matrix(rnorm(100, mean = 1, sd = 0.5), ncol = 2),
           matrix(rnorm(100, mean = 2, sd = 0.5), ncol = 2))

cl <- kmeans(x, 3)

getCriteriaNames(TRUE)

intIdx <- intCriteria(x,cl$cluster,"all")
length(intIdx)
intIdx

#External croteria
part1<-sample(1:3,150,replace=TRUE)
part2<-sample(1:5,150,replace=TRUE)

getCriteriaNames(FALSE)
extIdx <- extCriteria(part1,part2,"all")
length(extIdx)
extIdx
##############################################
# Using clValid Package
#R function clValid()

# Load the data
data(mouse)
head(mouse)

# Extract gene expression data
exprs <- mouse[1:25,c("M1","M2","M3","NC1","NC2","NC3")]
rownames(exprs) <- mouse$ID[1:25]
head(exprs)

# Compute clValid

### Internal validation
clmethods <- c("hierarchical","kmeans","pam")
intern <- clValid(exprs, nClust = 2:6,
                  clMethods = clmethods, validation = "internal")
# Summary
summary(intern)

# plots of the connectivity, Dunn index, and silhouette width
plot(intern)

# Stability measures
clmethods <- c("hierarchical","kmeans","pam")
stab <- clValid(exprs, nClust = 2:6, clMethods = clmethods,
                validation = "stability")
# Display only optimal Scores
optimalScores(stab)

summary(stab)
plot(stab)
##############################################################################

# compute-p-value-for-hierarchical-clustering

# Load the data
data("lung")
head(lung[, 1:4])

# Dimension of the data
dim(lung)

set.seed(123)
ss <- sample(1:73, 30) # extract 30 samples out of
df <- lung[, ss]

# Compute P value
res.pv <- pvclust(df, method.dist="cor", 
                  method.hclust="average", nboot = 10)

# Default plot
plot(res.pv, hang = -1, cex = 0.5)
pvrect(res.pv)

#Values on the dendrogram are AU p-values (Red, left), BP values (green, right), and cluster labels 
#(grey, bottom). Clusters with AU > = 95% are indicated by the rectangles and are considered to be strongly 
#supported by data

# Create a parallel socket cluster
library(parallel)
cl <- makeCluster(2, type = "PSOCK")

# parallel version of pvclust
res.pv <- parPvclust(cl, df, nboot=1000)
stopCluster(cl)
###############################################################################

# Choosing the number of clusters k using the average silhouette width criterion.

##################### Using NbClust
#install.packages("NbClust")

#Compute only an index of interest
#The following example determine the number of clusters using gap statistics:
    
set.seed(123)
res.nb <- NbClust(food.std, distance = "euclidean",
                  min.nc = 2, max.nc = 10, 
                  method = "complete", index ="gap") 
res.nb # print the results
# All gap statistic values
res.nb$All.index

# Best number of clusters
res.nb$Best.nc

# Best partition
res.nb$Best.partition

## Compute all the 30 indices

nc <- NbClust(food.std, distance = "euclidean", min.nc = 2,
              max.nc = 10, method = "complete", index ="all")
# Print the result
nc
table(nc$Best.n[1,])
#visualize the result using the function fviz_nbclust() [in factoextra], as follow:
fviz_nbclust(nc) + theme_minimal()


################################
#Facto extra

#method
# the method to be used for estimating the optimal number of clusters. Possible values are 
    #"silhouette" (for average silhouette width), 
    #"wss" (for total within sum of square) and 
    #"gap_stat" (for gap statistics).

## Examples are provided only for kmeans, but we can also use cluster::pam (for pam) or
#  hcut (for hierarchical clustering)

    
#### WSS
    set.seed(123)
    fviz_nbclust(df, kmeans, method = "wss")

        # fviz_nbclust(df, kmeans, method = "wss") +
    #     geom_vline(xintercept = 3, linetype = 2)

#### silhouette
    set.seed(123)
    fviz_nbclust(df, kmeans, method = "silhouette")
    fviz_nbclust(df, hcut, method = "silhouette")
    fviz_nbclust(df, pam, method = "silhouette")

#### gap_stat
    set.seed(123)
    fviz_nbclust(df, FUNcluster = kmeans, method = "gap_stat")
    
    ### Gap statistic
    set.seed(123)
    
    # Compute gap statistic for kmeans
    # we used B = 10 for demo. Recommended value is ~500
    gap_stat <- clusGap(df, FUN = kmeans, nstart = 25,
                        K.max = 10, B = 10)
    
    print(gap_stat, method = "firstmax")
    fviz_gap_stat(gap_stat)
    
    # Gap statistic for hierarchical clustering
    gap_stat <- clusGap(df, FUN = hcut, K.max = 10, B = 10)
    fviz_gap_stat(gap_stat)
    

##############################################################

##  Plotting the WSS for several choices of k

################################

# This is a recommended method for choosing k in K-means clustering.
# For the cars data, let's consider letting k vary up to 5.

### CODE FOR WSS PLOT BEGINS HERE ###
##
#Enter name of the data matrix to be clustered here:

wssplot <- function(data, nc=15, seed=1234){
    wss <- (nrow(data)-1)*sum(apply(data,2,var))
    for (i in 2:nc){
        set.seed(seed)
        wss[i] <- sum(kmeans(data, centers=i)$withinss)}
    plot(1:nc, wss, type="b", xlab="Number of Clusters",
         ylab="Within groups sum of squares")}

my.k.choices <- 5
wssplot(food.std, my.k.choices)

##
### CODE FOR WSS PLOT ENDS HERE ###

# For what value of k does the elbow of the plot occur?

