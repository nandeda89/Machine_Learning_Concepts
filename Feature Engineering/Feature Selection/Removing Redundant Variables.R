#Removing Redundant Variables
# rm(list=ls())

# load required libraries
library(caret)
library(corrplot)
library(plyr)

# load required dataset
New_data <- Data

# Set seed
set.seed(227)

# Remove variables having high missing percentage (50%)
New_data <- New_data[, colMeans(is.na(New_data)) <= .5]
dim(New_data)

#Remove Zero and Near Zero-Variance Predictors
nzv <- nearZeroVar(New_data)
colnames(New_data)[nzv]

# 
# dat2 <- New_data[, -nzv]
# dim(dat2)

dat2 <- New_data

# Identifying numeric variables
numericData <- dat2[sapply(dat2, is.numeric)]

# Calculate correlation matrix
descrCor <- cor(numericData)

# Print correlation matrix and look at max correlation
print(descrCor)
summary(descrCor[upper.tri(descrCor)])

# Check Correlation Plot
corrplot(descrCor, order = "FPC", method = "color", type = "lower", tl.cex = 0.7, tl.col = rgb(0, 0, 0))

# find attributes that are highly corrected
highlyCorrelated <- findCorrelation(descrCor, cutoff=0.7)

# print indexes of highly correlated attributes
print(highlyCorrelated)

# Indentifying Variable Names of Highly Correlated Variables
highlyCorCol <- colnames(numericData)[highlyCorrelated]

# Print highly correlated attributes
highlyCorCol

# Remove highly correlated variables and create a new dataset
dat3 <- dat2[, -which(colnames(dat2) %in% highlyCorCol)]
dim(dat3)

#Feature Selection with Random Forest
library(randomForest)
str(dat3)
dat3[sapply(dat3, is.character)] <- 
  lapply(dat3[sapply(dat3, is.character)], as.factor)

smp_size <- floor(nrow(dat3))
train_ind <- sample(seq_len(nrow(dat3)), size = smp_size)
dat4 <- dat3[train_ind, ]


#Train Random Forest
rf <-randomForest(CANCEL_IND~.,data=dat4, importance=TRUE,ntree=10)

#Evaluate variable importance
imp = importance(rf, type=1)
imp <- data.frame(predictors=rownames(imp),imp)

# Order the predictor levels by importance
imp.sort <- arrange(imp,desc(MeanDecreaseAccuracy))
write.csv(imp.sort,"imp_sort.csv", row.names = FALSE)

imp.sort$predictors <- factor(imp.sort$predictors,levels=imp.sort$predictors)

# Select the top 20 predictors
maxlength <- round(nrow(imp.sort)*0.7)
imp.maxlength<- imp.sort[1:maxlength,]
print(imp.maxlength)

# Plot Important Variables
varImpPlot(rf, type=1)

# Subset data with 20 independent and 1 dependent variables
dat5 = cbind(CANCEL_IND = dat4$CANCEL_IND, dat4[,c(imp.maxlength$predictors)])

# names(numericData)

#######################################################################
#Boruta Package

set.seed(123)
boruta.train <- Boruta(CANCEL_IND~.-Order.Type, data = Data, doTrace = 2)
print(boruta.train)
