## Categorical data only:
install.packages("mlbench")
install.packages("e1071")
library(e1071)

data(HouseVotes84, package = "mlbench")
head(HouseVotes84)
model <- naiveBayes(Class ~ ., data = HouseVotes84)
model

predict(model, HouseVotes84[1:10,])
predict(model, HouseVotes84[1:10,], type = "raw")

pred <- predict(model, HouseVotes84)
conf.mat <- table(pred, HouseVotes84$Class)
conf.mat 

accuracy <- sum(diag(conf.mat ))/nrow(HouseVotes84)
accuracy

## using laplace smoothing:
model <- naiveBayes(Class ~ ., data = HouseVotes84, laplace = 3)
model

pred <- predict(model, HouseVotes84[,-1])

conf.mat <- table(pred, HouseVotes84$Class)
conf.mat 

accuracy <- sum(diag(conf.mat ))/nrow(HouseVotes84)
accuracy


## Example of using a contingency table:
data(Titanic)
Titanic <- as.data.frame(Titanic)

head(Titanic)

m <- naiveBayes(Survived ~ ., data = Titanic)
m

pred<- predict(m, Titanic)

conf.mat <- table(pred, Titanic$Survived)
conf.mat 

accuracy <- sum(diag(conf.mat ))/nrow(Titanic)
accuracy

## Example of using a contingency table:
data(Titanic)
class(Titanic)

m <- naiveBayes(Survived ~ ., data = Titanic)
m

pred<- predict(m, as.data.frame(Titanic))

conf.mat <- table(pred, as.data.frame(Titanic)$Survived)
conf.mat 

accuracy <- sum(diag(conf.mat ))/nrow(as.data.frame(Titanic))
accuracy

## Example with metric predictors:
data(iris)
str(iris)
# iris <- as.data.frame(iris)

m <- naiveBayes(Species ~ ., data = iris)

## alternatively:
m <- naiveBayes(iris[,-5], iris[,5])
m

conf.mat <- table(predict(m, iris), iris[,5])
conf.mat 

accuracy <- sum(diag(conf.mat))/nrow(iris)
accuracy

