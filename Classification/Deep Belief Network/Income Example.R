source("http://scg.sdsu.edu/wp-content/uploads/2013/09/dataprep.r")
names(data$train)

head(data$train)

fit1 <-glm(income~., family = binomial(logit), data = data$train)
summary(fit1)

predicted <- predict(fit1, newdata = data$val, type = "response")
predicted<- ifelse(predicted>0.5,1,0)

conf.mat <- table(predicted, data$val$income)
conf.mat

accuracy <- sum(diag(conf.mat))/nrow(data$val)
accuracy

## Not run: 
model <- darch(income~., data = data$train)
print(model)

predictions <- predict(model, newdata = data$train, type = "class")
cat(paste("Incorrect classifications:", sum(predictions != data$train$income)))

conf.mat1 <- table(data$train$income, predictions)
conf.mat1

accuracy1 <- sum(diag(conf.mat1))/nrow(data$train)
accuracy1