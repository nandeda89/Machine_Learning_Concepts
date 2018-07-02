#Boruta package - to select important features for model building

library(ranger)
library(Boruta)

setwd("\\Boruta")
traindata <- read.csv("train_boruta.csv", header = T, stringsAsFactors = F)

str(traindata)
names(traindata) <- gsub("_", "", names(traindata))

#gsub() function is used to replace an expression with other one. In this 
#case, We've replaced the underscore(_) with blank("").

summary(traindata)
traindata[traindata == ""] <- NA

traindata <- traindata[complete.cases(traindata),]

traindata[sapply(traindata, is.character)] <- 
  lapply(traindata[sapply(traindata, is.character)], as.factor)

traindata$LoanID <- as.character(traindata$LoanID)
str(traindata)

set.seed(123)
boruta.train <- Boruta(LoanStatus~.-LoanID, data = traindata, doTrace = 2)
print(boruta.train)

plot(boruta.train, xlab = "", xaxt = "n")

lz<-lapply(1:ncol(boruta.train$ImpHistory),function(i)
boruta.train$ImpHistory[is.finite(boruta.train$ImpHistory[,i]),i])

names(lz) <- colnames(boruta.train$ImpHistory)
Labels <- sort(sapply(lz,median))

axis(side = 2,las=2,labels = names(Labels),
       at = 1:ncol(boruta.train$ImpHistory), cex.axis = 0.7)

final.boruta <- TentativeRoughFix(boruta.train)
print(final.boruta)

plot(final.boruta, xlab = "", xaxt = "n")
lz<-lapply(1:ncol(final.boruta$ImpHistory),function(i)
  final.boruta$ImpHistory[is.finite(final.boruta$ImpHistory[,i]),i])
names(lz) <- colnames(final.boruta$ImpHistory)
Labels <- sort(sapply(lz,median))
axis(side = 1,las=2,labels = names(Labels),
     at = 1:ncol(final.boruta$ImpHistory), cex.axis = 0.7)

getSelectedAttributes(final.boruta, withTentative = F)
boruta.df <- attStats(final.boruta)
class(boruta.df)
print(boruta.df)
