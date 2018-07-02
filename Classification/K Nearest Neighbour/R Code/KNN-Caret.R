library(caret)

set.seed(3033)
intrain <- createDataPartition(y = iris$Species, p= 0.7, list = FALSE)
training <- iris[intrain,]
testing <- iris[-intrain,]

dim(training); dim(testing);
anyNA(iris)

summary(iris)

trctrl <- trainControl(method = "repeatedcv", number = 10, repeats = 3)
set.seed(3333)
knn_fit <- train(Species ~., data = training, method = "knn",
                 trControl=trctrl,
                 preProcess = c("center", "scale"),
                 tuneLength = 10)
knn_fit

test_pred <- predict(knn_fit, newdata = testing)
test_pred

confusionMatrix(test_pred, testing$Species )
