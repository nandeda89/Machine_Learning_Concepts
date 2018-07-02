#Clustofvar
library(ClustOfVar)

#quantitative variables
data(decathlon)
tree <- hclustvar(decathlon[,1:10])
plot(tree)

#qualitative variables with missing values
data(vnf)
tree_NA <- hclustvar(X.quali=vnf)
plot(tree_NA)
dev.new()
vnf2<-na.omit(vnf)
tree <- hclustvar(X.quali=vnf2)
plot(tree)

#mixture of quantitative and qualitative variables
data(wine)
X.quanti <- wine[,c(3:29)]
X.quali <- wine[,c(1,2)]
tree <- hclustvar(X.quanti,X.quali)
plot(tree)

#choice of the number of clusters
stability(tree,B=40)
part <- cutreevar(tree,4)
print(part)
summary(part)

#a random set of variables is chosen as the initial cluster centers, nstart=10 times
part1 <- kmeansvar(X.quanti,X.quali,init=5,nstart=10)
summary(part1)

#the partition from the hierarchical clustering is chosen as initial partition
part_init<-cutreevar(tree,5)$cluster
part2<-kmeansvar(X.quanti,X.quali,init=part_init,matsim=TRUE)
summary(part2)
part2$sim
