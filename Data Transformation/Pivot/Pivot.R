library(reshape2)
genes = paste('MMP', sprintf("%04d",1:10), sep="")
data = expand.grid(gene=genes, condition=c('copper', 'cheetos', 'beer', 'pizza'))
data$value = rnorm(40)
acast(data, gene ~ condition)
data.incomplete <- data[data$value > -1.0,]
dim(data.incomplete)
