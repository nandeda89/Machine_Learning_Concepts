install.packages('e1071', dependencies = TRUE)
library(class) 
library(e1071)

pairs(iris[1:4], main = "Iris Data (red=setosa,green=versicolor,blue=virginica)",
      pch = 21, bg = c("red", "green3", "blue")[unclass(iris$Species)])

classifier<-naiveBayes(iris[,1:4], iris[,5]) 
table(predict(classifier, iris[,-5]), iris[,5])

conf.mat <- table(predict(classifier, iris[,-5]), iris[,5])
conf.mat

accuracy <- sum(diag(conf.mat))/nrow(iris)
accuracy

