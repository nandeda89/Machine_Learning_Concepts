## Not run: 
data(iris)
head(iris)
model <- darch(Species ~ ., iris)
print(model)
predictions <- predict(model, newdata = iris, type = "class")
cat(paste("Incorrect classifications:", sum(predictions != iris[,5])))

conf.mat <- table(iris$Species, predictions)
conf.mat

accuracy <- sum(diag(conf.mat))/nrow(iris)
accuracy



## End(Not run)

#
# More examples can be found at
# https://github.com/maddin79/darch/tree/v0.12.0/examples