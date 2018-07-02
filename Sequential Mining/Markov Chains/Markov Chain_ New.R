
##################################################################################################################################
##################################################################################################################################

#Set Working Directory
setwd("Markov Chains")

##################################################################################################################################
##################################################################################################################################

################################################
#Dataset - User-recommendations

data<-read.csv("final-user-recommendations.csv",stringsAsFactors = FALSE,header=TRUE)
# install.packages("markovchain")
library(markovchain)

data.usr_removed <- (data[,!(names(data) %in% c("user"))])

mModelmle <- markovchainFit(data = data.usr_removed, method = "mle",name = "Model MLE")
GetAccuracy(data, mModelmle)

mModelmle <- markovchainFit(data = data.usr_removed, method = "bootstrap",name = "Model bootstrap")
GetAccuracy(data, mModelmle)

mModelmle <- markovchainFit(data = data.usr_removed, method = "laplace", laplacian = 0.01,name = "Model laplace")
GetAccuracy(data, mModelmle, 1, 50)

################################################
#Dataset - holson

data(holson)
singleMc<-markovchainFit(data=holson[,2:12],name="holson")
GetAccuracy(holson, singleMc, 2, 6)

mcListFit<-markovchainListFit(data=holson[,2:6],name="holson")


###################################################################################################################################
###################################################################################################################################

#User Defined Functions

GetAccuracy <- function(data, mModelmle, startindex, endindex)
{

  predict.neighbours <- matrix(NA, nrow=nrow(data),ncol=1)
  for(i in 1:nrow(data)) 
  {
    predict.neighbours[i,] <- as.vector(predict(object = mModelmle$estimate, newdata =as.character(data[i,startindex:endindex]) ,n.ahead =1))
  }
  
  accuracy<-cbind(data[endindex+1],predict.neighbours)
  accuracy$Match <- 0
  
  accuracy$Match[accuracy$V50==accuracy$predict.neighbours] <-1
  
  print(table(accuracy$Match))
}

###################################################################################################################################
###################################################################################################################################

# write.csv(accuracy,"accuracy.csv")
# mModelmle
# 
# modelDf <- as(mModelmle$estimate, "data.frame")
# 
# ModelmcNew <- as(modelDf, "markovchain")
# ModelmcNew

predict.neighbours <- matrix(NA, nrow=nrow(data),ncol=1)
for(i in 1:nrow(data)) 
{
  predict.neighbours[i,] <- as.vector(predict(object = mModelmle$estimate, newdata =as.character(data[i,startindex:endindex]) ,n.ahead =1))
}

accuracy<-cbind(data[endindex+1],predict.neighbours)
accuracy$Match <- 0

accuracy$Match[accuracy$V50==accuracy$predict.neighbours] <-1

print(table(accuracy$Match))