install.packages('AppliedPredictiveModeling')
library(AppliedPredictiveModeling)
library(caret)

#################### Removing data with NAs and outlier detection ######################
str(airquality)  ## Structure of airquality dataset
airquality_clean <- airquality[complete.cases(airquality),]  ## Removing rows containing NAs using the complete.cases function; na.omit can also be used
airquality_clean <- airquality[complete.cases(airquality[,1]),]  ## Removing rows containing NAs in the first column (Ozone)

boxplot(airquality_clean)  ## Boxplot
airquality_outliers <- apply(airquality_clean,2, function(x) boxplot.stats(x)$out)  ## Getting the list of outliers for all columns based on the boxplot
airquality_wo_outliers <- apply(airquality_clean,2, function(x) x[!x %in% boxplot.stats(x)$out])  ## Getting list of columns without outliers

###################### Creating Dummy Variables #####################
data(schedulingData)
str(schedulingData)
head(schedulingData)

dummies <- dummyVars(Class ~ ., data = schedulingData, fullRank = T)  ## Converting every categorical variable to numerical using dummy variables, fullRank=T ensures (n-1) columns for n levels of the categorical variables
schedulingData_Transformed <- data.frame(predict(dummies, newdata = schedulingData), schedulingData$Class)
str(schedulingData_Transformed)  ## Checking the structure of transformed data

##################### Removing zero and near zero variance predictors ##################
data(mdrr)
head(mdrrDescr)  ## Viewing first 5 rows for mdrrDescr dataset
nzv <- nearZeroVar(mdrrDescr, saveMetrics= TRUE)  ## Finding zero and near zero variance predictors, which are factors taking only one value or only a handful of unique values that occur with very low frequencies
nzv[nzv$nzv,][1:10,]  ## Viewing 10 factors with near zero variance
data.frame(table(mdrrDescr$nTB)) ## Viewing frequency distribution for one of the nzv predictors

dim(mdrrDescr)  ## Dimensions before removal of nzv predictors
nzv <- nearZeroVar(mdrrDescr)  ## Without the saveMetrics argument, the indices of the near zero var predictors are returned
filteredDescr <- mdrrDescr[, -nzv]  ## Removing the nzv predictors
dim(filteredDescr)  ## 342-297=45 predictors (columns) removed

##################### Identifying correlated predictors ##################
descrCor <- cor(filteredDescr)  ## Correlation matrix
summary(descrCor[upper.tri(descrCor)])  ## Quantile distribution for the correlation ranges

highlyCorDescr <- findCorrelation(descrCor, cutoff = .75)  ## Finding indices of variables, which if removed, will remove all correlation values above the cutoff (0.75 here)
filteredDescr <- filteredDescr[,-highlyCorDescr]  ## Filtering out the list found above
descrCor2 <- cor(filteredDescr)
summary(descrCor2[upper.tri(descrCor2)])  ## Quantile distribution for new correlation ranges (not exceeding an absolute maximum value of 0.75)

##################### Centering and scaling ##################
set.seed(7)
inTrain <- sample(seq(along = mdrrClass), length(mdrrClass)/2)
training <- filteredDescr[inTrain,]  ## Dividing the data set into equal training and test sets
test <- filteredDescr[-inTrain,]

preProcValues <- preProcess(training, method = c("knnImpute","center", "scale", "pca"))  ## Standardize the data set by centering each of the columns around their mean, and scaling based on standard deviation, PCA is used to get uncorrelated attributes; knnImpute is used to replace NA values by average of that attribute; Other common options for method include range, BoxCox, YeoJohnson and ICA
trainTransformed <- predict(preProcValues, training)  ## The data is preprocessed here using the predict function; The Preprocess function creates a method but doesn't apply it on the data
testTransformed <- predict(preProcValues, test)
summary(trainTransformed)

set.seed(7)
control <- rfeControl(functions=rfFuncs, method="cv", number=10) ## Define the control using a random forest selection function
results <- rfe(filteredDescr, mdrrClass, rfeControl=control)  ## Run the RFE algorithm
print(results) ## Summarize the results
predictors(results)  ## List the chosen features
plot(results, type=c("g", "o"))  ## Plot the results


