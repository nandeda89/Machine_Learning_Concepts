#set working directory
path <- ""
setwd(path)
getwd()

#Install Packages
# install.packages("data.table")
# install.packages("mlr")
# install.packages("stringr")
# install.packages('xgboost')

#load libraries
library(data.table)
library(mlr)
library(stringr)
library(xgboost)

#set variable names
setcol <- c(
    "age",
    "workclass",
    "fnlwgt",
    "education",
    "education-num",
    "marital-status",
    "occupation",
    "relationship",
    "race",
    "sex",
    "capital-gain",
    "capital-loss",
    "hours-per-week",
    "native-country",
    "target"
)

#load data
train <-
    read.table(
        "adult.data.txt",
        header = F,
        sep = ",",
        col.names = setcol,
        na.strings = c(" ?"),
        stringsAsFactors = F
    )
test <-
    read.table(
        "adult.test.txt",
        header = F,
        sep = ",",
        col.names = setcol,
        skip = 1,
        na.strings = c(" ?"),
        stringsAsFactors = F
    )

#convert data frame to data table
setDT(train)
setDT(test)

#check missing values
table(is.na(train))
sapply(train, function(x)
    sum(is.na(x)) / length(x)) * 100

table(is.na(test))
sapply(test, function(x)
    sum(is.na(x)) / length(x)) * 100

#quick data cleaning
#remove extra character from target variable
test[, target := substr(target, start = 1, stop = nchar(target) - 1)]
train[, target := substr(target, start = 1, stop = nchar(target) - 1)]

#remove leading whitespaces
char_col <- colnames(train)[sapply(test, is.character)]
for (i in char_col)
    set(train, j = i, value = str_trim(train[[i]], side = "left"))

for (i in char_col)
    set(test, j = i, value = str_trim(test[[i]], side = "left"))

#set all missing value as "Missing"
train[is.na(train)] <- "Missing"
test[is.na(test)] <- "Missing"

# Convert the categorical variables into numeric using one hot encoding
# For classification, if the dependent variable belongs to class factor, convert it to numeric

#using one hot encoding
labels <- train$target
ts_label <- test$target
new_tr <- model.matrix( ~ . + 0, data = train[, -c("target"), with = F])
new_ts <- model.matrix( ~ . + 0, data = test[, -c("target"), with = F])

#convert factor to numeric
labels <- as.factor(labels)
labels <- as.numeric(labels) - 1

ts_label <- as.factor(ts_label)
ts_label <- as.numeric(ts_label) - 1

#For xgboost, we'll use xgb.DMatrix to convert data table into a matrix (most recommended):
#preparing matrix

dtrain <- xgb.DMatrix(data = new_tr, label = labels)
dtest <- xgb.DMatrix(data = new_ts, label = ts_label)

#default parameters
params <- list(
    booster = "gbtree",
    objective = "binary:logistic",
    eta = 0.3,
    gamma = 0,
    max_depth = 6,
    min_child_weight = 1,
    subsample = 1,
    colsample_bytree = 1
)

#calculate the best nround
xgbcv <- xgb.cv(params = params
                ,data = dtrain
                ,nrounds = 100
                ,nfold = 5
                ,showsd = T
                ,stratified = T
                ,print_every_n = 10
                ,early_stopping_rounds = 20
                ,maximize = F
)

xgbcv$best_iteration
best_nrounds = xgbcv$best_iteration
cv_mean = xgbcv$evaluation_log$test_error_mean[best_nrounds]
cv_std = xgbcv$evaluation_log$test_error_std[best_nrounds]
cat(paste0('CV-Mean: ',cv_mean))
cat(paste0( 'CV-STD: ', cv_std))

CV_Accuracy <- 1- cv_mean
CV_Accuracy

#first default - model training
xgb1 <- xgb.train(
    params = params
    ,data = dtrain
    ,nrounds = best_nrounds
    ,watchlist = list(val=dtest,train=dtrain)
    ,print_every_n = 10
    ,early_stopping_rounds = 10
    ,maximize = F
    ,eval_metric = "error"
)

#model prediction
xgbpred <- predict(xgb1,dtest)
xgbpred <- ifelse(xgbpred > 0.5,1,0)

#confusion matrix
library(caret)
confusionMatrix(xgbpred, ts_label)
#Accuracy - 87.4%

#view variable importance plot
mat <- xgb.importance(feature_names = colnames(new_tr),model = xgb1)
xgb.plot.importance(importance_matrix = mat[1:20]) #first 20 variables

#we've achieved better accuracy than a random forest model using default parameters in xgboost
#From here on, we'll be using the MLR package for model building. A quick reminder, the MLR 
#package creates its own frame of data, learner as shown below. Also, keep in mind that task 
#functions in mlr doesn't accept character variables. Hence, we need to convert them to factors 
#before creating task:

#convert characters to factors
library(mlr)
fact_col <- colnames(train)[sapply(train,is.character)]
for(i in fact_col)
    set(train,j=i,value = factor(train[[i]]))

for(i in fact_col)
    set(test,j=i,value = factor(test[[i]]))

#create tasks
traintask <- makeClassifTask(data = train,target = "target")
testtask <- makeClassifTask(data = test,target = "target")

#do one hot encoding
traintask <- createDummyFeatures(obj = traintask)
testtask <- createDummyFeatures(obj = testtask)

#create learner
lrn <- makeLearner("classif.xgboost",predict.type = "response")
lrn$par.vals <- list(
    objective="binary:logistic",
    eval_metric="error",
    nrounds=100L,
    eta=0.1
)

#set parameter space
params <- makeParamSet(
    makeDiscreteParam("booster",values = c("gbtree","gblinear")),
    makeIntegerParam("max_depth",lower = 3L,upper = 10L),
    makeNumericParam("min_child_weight",lower = 1L,upper = 10L),
    makeNumericParam("subsample",lower = 0.5,upper = 1),
    makeNumericParam("colsample_bytree",lower = 0.5,upper = 1)
)

#set resampling strategy
rdesc <- makeResampleDesc("CV",stratify = T,iters=5L)

#With stratify=T, we'll ensure that distribution of target class is maintained in the resampled data sets. If you've noticed above, in the parameter set, I didn't consider gamma for tuning. Simply because during cross validation, we saw that train and test error are in sync with each other. Had either one of them been dragging or rushing, we could have brought this parameter into action.
#Now, we'll set the search optimization strategy. Though, xgboost is fast, instead of grid search, we'll use random search to find the best parameters. In random search, we'll build 10 models with different parameters, and choose the one with the least error. You are free to build any number of models.

#search strategy
ctrl <- makeTuneControlRandom(maxit = 10L)

#We'll also set a parallel backend to ensure faster computation. Make sure you've not opened several applications in backend. We'll use all the cores in your machine.

#set parallel backend
library(parallel)
library(parallelMap)
parallelStartSocket(cpus = detectCores())

#parameter tuning
mytune <- tuneParams(learner = lrn
,task = traintask
,resampling = rdesc
,measures = acc
,par.set = params
,control = ctrl
,show.info = T)

mytune$y # 0.8717484 

#set hyperparameters
lrn_tune <- setHyperPars(lrn,par.vals = mytune$x)

#train model

xgmodel <- mlr::train(learner = lrn_tune,task = traintask)

#predict model
xgpred <- predict(xgmodel,testtask)

#We've made our predictions on the test set. Let's check our model's accuracy.

confusionMatrix(xgpred$data$response,xgpred$data$truth)
#Accuracy : 0.8751 