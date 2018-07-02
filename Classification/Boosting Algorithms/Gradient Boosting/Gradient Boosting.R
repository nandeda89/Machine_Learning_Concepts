#install.packages("gbm")
#install.packages("cvAUC")
path <-
    "datasets/"
setwd(path)
getwd()

library(gbm)
library(cvAUC)

# Load 2-class HIGGS dataset
train <- read.csv("higgs_train_10k.csv")
test <- read.csv("higgs_test_5k.csv")

class(train$response)
train$response <- as.factor(train$response)
test$response <- as.factor(test$response)

set.seed(1)
gbm.model <- gbm(
    formula = response ~ .,
    distribution = "bernoulli",
    data = train,
    n.trees = 700,
    interaction.depth = 5,
    shrinkage = 0.3,
    bag.fraction = 0.5,
    train.fraction = 1.0,
    cv.folds = 5,
    n.cores = NULL
)  #will use all cores by default
print(gbm.model)

best.iter = gbm.perf(gbm.model, method = "cv")
best.iter

summary(gbm.model)
plot.gbm(gbm.model, 1, best.iter)
plot.gbm(gbm.model, 2, best.iter)
plot.gbm(gbm.model, 3, best.iter)

library(caret)
set.seed(123)
fitControl = trainControl(method = "cv",
                          number = 5,
                          returnResamp = "all")
tuneGrid <-
    data.frame(
        .n.trees = best.iter,
        .shrinkage = 0.01,
        .interaction.depth = 1,
        .n.minobsinnode = 1
    )

model2 = train(
    response ~ .,
    data = train,
    method = "gbm",
    distribution = "bernoulli",
    trControl = fitControl,
    verbose = F,
    tuneGrid = tuneGrid
)

model2
confusionMatrix(model2)

#Predict
mPred = predict(model2, test[,-1], na.action = na.pass)
postResample(mPred, test$response)

confusionMatrix(mPred,test$response)
getTrainPerf(model2)

mResults = predict(model2, test[,-1], na.action = na.pass, type = "prob")
mResults$obs = test$response
head(mResults)

mnLogLoss(mResults, lev = levels(mResults$obs))
mResults$pred = predict(model2, test[,-1], na.action = na.pass)
multiClassSummary(mResults, lev = levels(mResults$obs))

evalResults <- data.frame(Class = test$response)
evalResults$GBM <- predict(model2, test[,-1], na.action = na.pass, type = "prob")[,"neg"]

head(evalResults)

trellis.par.set(caretTheme())
liftData <- lift(Class ~ GBM, data = evalResults)
plot(liftData, values = 60, auto.key = list(columns = 1,
                                            lines = TRUE,
                                            points = FALSE))

