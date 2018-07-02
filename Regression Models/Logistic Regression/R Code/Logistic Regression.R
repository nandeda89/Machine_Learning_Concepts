#rm(list = ls())
getwd()
setwd("F:/Data Analytics/Statistical Models/Logistic Regression/")

mydata <- read.csv("http://www.ats.ucla.edu/stat/data/binary.csv")
write.csv(mydata,"Datafile.csv", row.names = FALSE)

## view structure and  the first few rows of the data
nrow(mydata)
ncol(mydata)
str(mydata)
class(mydata)

head(mydata)
tail(mydata)

Column_Names <- names(mydata)
Column_Names

mydata$admit <- as.factor(mydata$admit)
mydata$rank <- as.factor(mydata$rank)

sapply(mydata,function(x) sum(is.na(x)))

sapply(mydata, function(x) length(unique(x)))

str(mydata)

#Summary of Data
summary(mydata)

#Check Variance in data
sapply(mydata[,2:3], sd)

## two-way contingency table of categorical outcome and predictors we want
xtabs(~admit + rank, data = mydata)

#Using the logit model
mylogit <- glm(admit ~ gre + gpa + rank, data = mydata, family = "binomial")
summary(mylogit)

mydata$rankP<- NULL
mydata$rankP <- predict(mylogit, newdata = mydata, type = "response")
mydata$rankP <- ifelse(mydata$rankP>0.5,1,0)

conf.mat <- table(mydata$rankP, mydata$admit)
conf.mat

accuracy <- sum(diag(conf.mat))/nrow(mydata)
accuracy

summary(mylogit)
