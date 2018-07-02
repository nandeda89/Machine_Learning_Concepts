##### Darch - Deep Belief Network

library(darch)

data(iris)
head(iris)

#DBN
model <- darch(Species ~ ., iris)
print(model)

predictions <- predict(model, newdata = iris, type = "class")
cat(paste("Incorrect classifications:", sum(predictions != iris[,5])))

conf.mat <- table(iris$Species, predictions)
conf.mat

accuracy <- sum(diag(conf.mat))/nrow(iris)
accuracy

