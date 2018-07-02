library(cba)

data(Votes)
names(Votes)
str(Votes)
x <- as.dummy(Votes[-17])
rc <- rockCluster(x, n=2, theta=0.73)

print(rc)
rf <- fitted(rc)

table(Votes$Class, rf$cl)
Votes$cl<- rf$cl

