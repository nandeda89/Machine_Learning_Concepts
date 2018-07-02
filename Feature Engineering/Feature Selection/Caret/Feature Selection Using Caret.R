
################################ Feature Selection ################################

# Feature selection algorithms: wrappers, filters and embedded methods

# Select Features
# 
# Feature selection is a process where you automatically select those features in your data that contribute 
# most to the prediction variable or output in which you are interested.
#
# Having too many irrelevant features in your data can decrease the accuracy of the models. 
# Three benefits of performing feature selection before modeling your data are:

# Reduces Overfitting: Less redundant data means less opportunity to make decisions based on noise.
# Improves Accuracy: Less misleading data means modeling accuracy improves.
# Reduces Training Time: Less data means that algorithms train faster.


##################################################################################

#Feature Selection with the Caret R Package

# ensure the results are repeatable
set.seed(7)

# load the library
library(mlbench)
library(caret)
library(corrplot)
library(dplyr)

# load the data
data(PimaIndiansDiabetes)

### Summary of data
glimpse(PimaIndiansDiabetes)

##################################################################################

# Remove variables having high missing percentage (50%)
PimaIndiansDiabetes <- PimaIndiansDiabetes[, colMeans(is.na(PimaIndiansDiabetes)) <= .5]
dim(PimaIndiansDiabetes)

##################################################################################

#Pre- processing 

### #Remove Zero and Near Zero-Variance Predictors
### #Remove highly Correlated Predictors

#################################################

#Remove Zero and Near Zero-Variance Predictors
nzv <- nearZeroVar(PimaIndiansDiabetes)
nzvcol <- colnames(PimaIndiansDiabetes)[nzv]

if (length(nzvcol)) {
  # Remove highly correlated variables and create a new dataset
  PimaIndiansDiabetes <- PimaIndiansDiabetes[, -which(colnames(PimaIndiansDiabetes) %in% nzvcol)]
}
dim(PimaIndiansDiabetes)

rm(nzv, nzvcol)

#################################################

#Remove highly Correlated Predictors

# Identifying numeric variables
numericData <- PimaIndiansDiabetes[sapply(PimaIndiansDiabetes, is.numeric)]

# Calculate correlation matrix
descrCor <- cor(numericData)

# Print correlation matrix and look at max correlation
print(descrCor)
summary(descrCor[upper.tri(descrCor)])

# Check Correlation Plot
corrplot(descrCor, order = "FPC", method = "color", type = "lower", tl.cex = 0.7, tl.col = rgb(0, 0, 0))

# find attributes that are highly corrected
highlyCorrelated <- findCorrelation(descrCor, cutoff=0.75)

# print indexes of highly correlated attributes
print(highlyCorrelated)

# Indentifying Variable Names of Highly Correlated Variables
highlyCorCol <- colnames(numericData)[highlyCorrelated]

# Print highly correlated attributes
highlyCorCol

# Remove highly correlated variables and create a new dataset
if (length(highlyCorCol)) {
  # Remove highly correlated variables and create a new dataset
  PimaIndiansDiabetes <- PimaIndiansDiabetes[, -which(colnames(PimaIndiansDiabetes) %in% highlyCorCol)]
}
dim(PimaIndiansDiabetes)

rm(descrCor, numericData, highlyCorCol, highlyCorrelated)

##################################################################################

############################## Filter Method   ################################
### #Univariate filters

# Selection by filter -- SBF
## Basic Syntax

# sbf(predictors, outcome, sbfControl = sbfControl(), ...)
# ## or
# sbf(formula, data, sbfControl = sbfControl(), ...)

data(mdrr)

## sbfcontrol
#  Functions included in the package: caretSBF, lmSBF, rfSBF, treebagSBF, ldaSBF and nbSBF.
filterCtrl <- sbfControl(functions = nbSBF,
                         method = "repeatedcv", repeats = 5)

mdrrDescr <- mdrrDescr[,-nearZeroVar(mdrrDescr)]
mdrrDescr <- mdrrDescr[, -findCorrelation(cor(mdrrDescr), .8)]

set.seed(1)
filteredNB <- sbf(mdrrDescr, mdrrClass,
                  sbfControl = filterCtrl)

confusionMatrix(filteredNB)
filteredNB

filteredNB$variables

filteredNB <- filteredNB$fit
filteredNB$varnames

## End(Not run)

##################################################################################
##################################################################################

#### Models with Built-In Feature Selection

#These models are thought to have built-in feature selection: 
# ada, bagEarth, bagFDA, bstLs, bstSm, C5.0, C5.0Cost, C5.0Rules, C5.0Tree, cforest, 
# ctree, ctree2, cubist, earth, enet, evtree, extraTrees, fda, gamboost, gbm, gcvEarth, 
# glmnet, glmStepAIC, J48, JRip, lars, lars2, lasso, LMT, LogitBoost, M5, M5Rules, nodeHarvest, 
# oblique.tree, OneR, ORFlog, ORFpls, ORFridge, ORFsvm, pam, parRF, PART, penalized, PenalizedLDA, 
# qrf, relaxo, rf, rFerns, rpart, rpart2, rpartCost, RRF, RRFglobal, smda, sparseLDA.

## Rank Features By Importance

# ensure results are repeatable
set.seed(7)

# load the library
# library(mlbench)
# library(caret)

# prepare training scheme
control <- trainControl(method="repeatedcv", number=10, repeats=3)

# train the model
#http://topepo.github.io/caret/modelList.html
model <- train(diabetes~., data=PimaIndiansDiabetes, method="rf", preProcess="scale", trControl=control)

# estimate variable importance
importance <- varImp(model, scale=FALSE)

# summarize importance
print(importance)

# plot importance
plot(importance)

##################################################################################

############################## Wrapper Methods   ################################

# Backwards selection (a.k.a. recursive feature elimination).
# Genetic algorithms, and 
# Simulated annealing.

#################################################

## Feature Selection using Recursive Feature Elimination or RFE

# ensure the results are repeatable
set.seed(7)

# load the library
# library(mlbench)
# library(caret)

# load the data
# data(PimaIndiansDiabetes)

# There are a number of pre-defined sets of functions for several models, including: 
# linear regression (in the object lmFuncs), 
# random forests (rfFuncs), 
# naive Bayes (nbFuncs), 
# bagged trees (treebagFuncs) 
# and functions that can be used with caret's train function (caretFuncs).

# define the control using a random forest selection function
control <- rfeControl(functions=rfFuncs, method="repeatedcv", number=10)

# run the RFE algorithm
results <- rfe(PimaIndiansDiabetes[,1:8], PimaIndiansDiabetes[,9], sizes=c(1:8), rfeControl=control)

# summarize the results
print(results)

# list the chosen features
predictors(results)

# plot the results
plot(results, type=c("g", "o"))

#################################################

#Genetic Algorithms

################################################

##################################################################################
