#Clustering

#################      Hierarchical Clustering     ##########################

#rm(list = ls())
#installed.packages()
#Required package - stats

getwd()
setwd("/Clustering/")

#Read Data
food <-
    read.table(
        "http://www.stat.sc.edu/~hitchcock/foodstuffs.txt",
        header = T,
        stringsAsFactors = FALSE
    )
attach(food)
#write.table(food, "food.txt")

#Check Structure and other properties
nrow(food)
ncol(food)
str(food)
class(food)

head(food)
tail(food)

Column_Names <- names(food)
Column_Names

#Cluster function
#hclust  -  it requires a distance object be input

#Normalize/Standardize data

#install.packages("clusterSim")
library(clusterSim)
food.std <-
    round(data.Normalization(food[,-1], type = "n1", normalization = "column"),
          2)

# Arguments
# n0 - without normalization
# n1 - standardization ((x-mean)/sd)

#Distance measure - Euclidian distances
#Calculating pairwise Euclidean distances between the (standardized) objects:
dist.food <- round(dist(food.std), 2)
dist_food_matrix <- as.matrix(dist.food)

# Single linkage:
food.single.link <- hclust(d = dist.food, method = "single")
food.single.link

food.complete.link <- hclust(d = dist.food, method = "complete")
food.complete.link

food.average.link <- hclust(d = dist.food, method = "average")
food.average.link

food.centroid.link <- hclust(d = dist.food, method = "centroid")
food.centroid.link

food.ward.link <- hclust(d = dist.food, method = "ward.D2")
food.ward.link

# Plotting the single linkage dendrogram:
plclust(tree = food.single.link, ylab = "Distance")

plclust(tree = food.single.link,
        labels = Food,
        ylab = "Distance")

plclust(
    tree = food.single.link,
    labels = Food,
    ylab = "Distance",
    hang = -1
)

#'plclust' is deprecated use 'plot' instead
plot(x = food.single.link, ylab = "Distance", xlab = "Food")

plot(
    x = food.single.link,
    ylab = "Distance",
    xlab = "Food",
    hang = -1
)

plot(
    x = food.single.link,
    ylab = "Distance",
    xlab = "Food",
    hang = -1,
    labels = Food
)

#The fixed classification can be visually demonstrated with
#rect.hclust function

plot(
    x = food.single.link,
    ylab = "Distance",
    xlab = "Food",
    hang = -1,
    labels = Food
)

rect.hclust(tree = food.single.link, k = 3)

#We can extract classification in a certain level using function cutree
food.single.cutree.by3Clust <- cutree(food.single.link, k = 3)
food.single.cutree.by3Clust  # printing the "clustering vector"

food.single.clust3 <-
    lapply(1:3, function(nc)
        Food[food.single.cutree.by3Clust == nc])
food.single.clust3  # printing the clusters in terms of the Food labels

table(food.single.cutree.by3Clust)

food.single.cutree.byHeight2.5 <- cutree(food.single.link, h = 2.5)
food.single.cutree.byHeight2.5  # printing the "clustering vector"

food.single.clust.byHeight2.5 <-
    lapply(1:3, function(nc)
        Food[food.single.cutree.byHeight2.5 == nc])
food.single.clust.byHeight2.5   # printing the clusters in terms of the Food labels

table(food.single.cutree.byHeight2.5)

# table(cl, cutree(csin, 3))
#par(mfrow=c(1,3), mar=c(3,4,1,1)+.1)
#par(mfrow=c(1,1))

############# Visualization of Clusters:
### Via the scatterplot matrix:

pairs(
    food[, -1],
    panel = function(x, y)
        text(x, y, food.single.cutree.by3Clust)
)

# Cluster 1 seems to be the high-fat, high-energy foods (beef, ham, pork)
# Cluster 2 foods seem to have low iron (more white meats than red meats)
# Cluster 3 foods seems to be good in calcium (the clams)

##################  Reordering a Dendrogram  ##########################
#R has two alternative dendrogram presentations: the hclust result object
#and a general dendrogram object. 

food.single.link.den <- as.dendrogram(food.single.link)
plot(
    x = food.single.link.den,
    ylab = "Distance",
    xlab = "Food"
)


##############################################################################


##############         Divisive Methods of Clustering      ######################
# library(cluster)

data(iris)
names(iris)
# [1] "Sepal.Length" "Sepal.Width"  "Petal.Length" "Petal.Width"  "Species"  

y <- as.matrix(iris[,-5])[6*(1:25),]   # subsample to make the graphs
rownames(y) <- iris$Species[6*(1:25)]  # pretty

diana.result <- diana(dist(y))
print(diana.result)

plot(diana.result)

gps <- c("setosa","versicolor","virginica")[cutree(diana.result,3)]
table(true=rownames(y),pred=gps)  # make a "Confusion matrix"

diana.result <- diana(y,metric="manhattan")

plot(diana.result)

gps <- c("setosa","versicolor","virginica")[cutree(diana.result,3)]
table(true=rownames(y),pred=gps)  # make a "Confusion matrix"

# there is also a divisive method called 'mona' that is intended for
# use when all of the variables are binary (T/F, right/wrong,
# symptom/no-symptom, etc.)

######################################################################