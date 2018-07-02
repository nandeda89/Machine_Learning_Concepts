library(cluster)
library(MASS)
data(iris)
ir= iris[,1:4]
ir
species=as.numeric(iris[,5])
ir.mds=cmdscale(dist(ir))
eqscplot(ir.mds,pch=species)

#####partioning cluster ####

ir.pam =pam(ir,k=2)
??pam

plot(ir.pam)

for (i in 2: 6)
{
  ir.pam = pam(ir,k=i)
  cat(i,"AVG :",round(ir.pam$silinfo$avg.width,2))
  cat(" clus :",round(ir.pam$silinfo$clus.avg.widths,2),"\n")
  
}


ir.pam=pam(ir,k=3)
eqscplot(ir.mds,pch=ir.pam$clustering)

summary(iris) 