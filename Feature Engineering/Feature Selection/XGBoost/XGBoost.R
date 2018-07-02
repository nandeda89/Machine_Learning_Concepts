library(xgboost) 
library(caret) # for confusionMatrix 

#Set working directory
setwd("\\XGBoost")

## Read data
CarDat<-read.csv(file="Car.csv",header = T)

#See the structure of data 
print(str(CarDat)) 

#Split the iris data into training (70%) and testing(30%). 
#Pseudo Random Number Generators 
set.seed(100) 

#Split the entire data into 70% for training data, 30% for test dataset
ind = sample(nrow(CarDat),nrow(CarDat)* 0.7) 
training = CarDat[ind,] 
testing = CarDat[-ind,]

#Parameters to be used in XGBoosting
param = list("objective" = "multi:softmax", # multi class classification 
             "num_class"= 3 , # Number of classes in the dependent variable. 
             "eval_metric" = "mlogloss", # evaluation metric 
             "nthread" = 8, # number of threads to be used 
             "max_depth" = 16, # maximum depth of tree 
             "eta" = 0.3, # step size shrinkage , 0.3 is default 0 to 1
             "gamma" = 0, # minimum loss reduction
             "subsample" = 0.7, # part of data instances to grow tree 
             "colsample_bytree" = 1, # subsample ratio of columns when constructing each tree 
             "min_child_weight" = 12 # minimum sum of instance weight needed in a child 
) 
#Identify the Predictors and the dependent variable, aka label. 
predictors = colnames(training[-ncol(training)]) 

#xgboost works only if the labels are numeric. Hence, convert the labels (Make) to numeric. 
label = as.numeric(training[,ncol(training)]) 
print(table (label))

#xgboost works only if the numeric labels start from 0. Hence, subtract 1 from the label. 
label = as.numeric(training[,ncol(training)])-1 
print(table (label)) 

# Step 1: Run a Cross-Validation to identify the round with the minimum loss or error. 
# Note: xgboost expects the data in the form of a numeric matrix. 

set.seed(100) 
# Number of rounds. This can be set to a lower or higher value, if you wish, example: 150 or 250 or 300 
cv.nround = 200; 
bst.cv = xgb.cv( param=param,
                 data = as.matrix(training[,predictors]), label = label, nfold = 3, nrounds=cv.nround, prediction=T) 

#Find where the minimum logloss occurred 
min.loss.idx = which.min(bst.cv$dt[, test.mlogloss.mean]) 
cat ("Minimum logloss occurred in round : ", min.loss.idx, "\n") 

# Minimum logloss 
print(bst.cv$dt[min.loss.idx,]) 

# Step 2: Train the xgboost model using min.loss.idx found above.
# Note, we have to stop at the round where we get the minumum error. 
set.seed(100) 
bst = xgboost( param=param, data =as.matrix(training[,predictors]), label = label, nrounds=min.loss.idx) 

# Make prediction on the testing data. 
testing$prediction = predict(bst, as.matrix(testing[,predictors])) 
#Translate the prediction to the original class or make 
testing$prediction = ifelse(testing$prediction==0,"Honda",ifelse(testing$prediction==1,"Hyundai","Maruti")) 
#Compute the accuracy of predictions.
confusionMatrix( testing$prediction,testing$Make) 

#Extra: Use some other model for the same prediction. 
# (randomForest with cross-validation using the caret package) 
set.seed(100) 
train_control = trainControl(method="cv",number=10) 
model.rf = train(Make~., data=training, trControl=train_control, method="rf") 
testing$prediction.rf = predict(model.rf,testing[,predictors]) 
#Compute the accuracy of predictions. 
confusionMatrix( testing$prediction.rf,testing$Make)
write.csv(testing,"xgboostTest_demo.csv")