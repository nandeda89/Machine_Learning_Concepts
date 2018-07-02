data(business)
names(business)
business.new <- subset(business, select = c(NACE1,NACE2))
treegraph(iris, index=c("Species", "Petal.Width"), show.labels=TRUE)

treegraph(business, index=c("NACE1", "NACE2", "NACE3", "NACE4"), show.labels=FALSE)
treegraph(business[business$NACE1=="F - Construction",],
          index=c("NACE2", "NACE3", "NACE4"), show.labels=TRUE, truncate.labels=c(2,4,6))
treegraph(business[business$NACE1=="F - Construction",],
          index=c("NACE2", "NACE3", "NACE4"), show.labels=TRUE, truncate.labels=c(2,4,6),
          vertex.layout="fruchterman.reingold")


library(igraph)
g <- graph.tree(20, 2)
plot(g, layout = layout.reingold.tilford(g, root=1))

library(Rcmdr)
data(iris)
