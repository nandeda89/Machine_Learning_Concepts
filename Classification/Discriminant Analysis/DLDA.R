require(MASS)

# Load data
data(iris)

head(iris, 3)
r <- lda(formula = Species ~ ., 
         data = iris, 
         prior = c(1,1,1)/3)

plda = predict(object = r, # predictions
               newdata = iris)

plda$class

iris$Predicted <- plda$class

conf.mat <- table(iris$Species, iris$Predicted)
conf.mat

accuracy <- sum(diag(conf.mat))/nrow(iris)
accuracy
