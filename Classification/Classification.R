install.packages('LogicReg')
install.packages('ellipse')
install.packages('gbm')
library(caret)
library(LogicReg)
library(ellipse)
library(pROC)

dataset <- iris  ## Loading the iris dataset
summary(dataset)  ## Summary of the dataset

# Divide the data set into training and test in an 80-20 ratio
partition_index <- createDataPartition(dataset$Species, p=0.80, list=FALSE)
training <- dataset[partition_index,]
test <- dataset[-partition_index,]


# Run algorithms using 10-fold cross validation
control <- trainControl(method="cv", number=10)
metric <- "Accuracy"

set.seed(7)
fit.logit <- train(Species~., data=training, method="LogitBoost", metric=metric, trControl=control)  ## Boosted Logistic Regression

set.seed(7)
fit.rf <- train(Species~., data=training, method="rf", metric=metric, trControl=control)  ## Random Forest


set.seed(7)
fit.nn <- train(Species~., data=training, method="nnet", metric=metric, trControl=control)  ## Neural Network

set.seed(7)
fit.lda <- train(Species~., data=training, method="lda", metric=metric, trControl=control) ## Linear Discriminant Analysis (LDA)

set.seed(7)
fit.cart <- train(Species~., data=training, method="rpart", metric=metric, trControl=control) ## Classification and regression trees (CART)

set.seed(7)
fit.knn <- train(Species~., data=training, method="knn", metric=metric, trControl=control)  ## k-Nearest Neighbors

set.seed(7)
fit.svm <- train(Species~., data=training, method="svmRadial", metric=metric, trControl=control)  ## Support Vector Machines (SVM)

set.seed(7)
fit.gbm <- train(Species~., data=training, method="gbm", metric=metric, trControl=control)  ## Gradient boosting machine (GBM)

plot(fit.gbm)
varImp(object=fit.lda, scale = FALSE)  ## Variable importance for the LDA model
plot(varImp(object=fit.lda, scale = FALSE),main="NNET - Variable Importance")  ## Plotting the variable importance

names(getModelInfo())  ## List of methods under the CARET package for train function

results <- resamples(list(logit=fit.logit, rf=fit.rf, nn=fit.nn, lda=fit.lda, cart=fit.cart, knn=fit.knn, svm=fit.svm, gbm=fit.gbm)) 
summary(results)  ## Summarize accuracy of models
dotplot(results) ## Compare accuracy of models

predictions <- predict(fit.nn, test)  ## Predictions made for the test set for the neural network model
confusionMatrix(predictions, test$Species)  ## Confusion matrix

gc()  ## Flush memory to clear objects from R memory that are no longer required
