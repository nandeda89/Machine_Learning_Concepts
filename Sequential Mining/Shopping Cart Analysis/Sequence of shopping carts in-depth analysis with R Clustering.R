#Sequence of shopping carts in-depth analysis with R - Clustering
#http://analyzecore.com/2014/12/27/sequence-carts-in-depth-analysis-with-r-clustering/

# CLUSTERING
library(cluster)
df.om <- seqdist(df.seq, method='OM', indel=1, sm='TRATE', with.missing=TRUE) # computing the optimal matching distances
clusterward <- agnes(df.om, diss=TRUE, method="ward") # building a Ward hierarchical clustering
df.cl4 <- cutree(clusterward, k=4) # cut the tree for creating 4 clusters
cl4.lab <- factor(df.cl4, labels=paste("Cluster", 1:4)) # creating label with the number of cluster for each customer

# distribution chart
seqdplot(df.seq, group=cl4.lab, border=NA)
# frequence chart
seqfplot(df.seq, group=cl4.lab, pbarw=T, border=NA)
# mean time plot
seqmtplot(df.seq, group=cl4.lab, border=NA)

