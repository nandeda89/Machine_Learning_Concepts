library(rpart) #Popular decision tree algorithm
library(rattle) #Fancy tree plot, nice graphical interface
library(rpart.plot) #Enhanced tree plots
library(RColorBrewer) #Color selection for fancy tree plot
library(party) #Alternative decision tree algorithm
library(partykit) #Convert rpart object to BinaryTree
library(RWeka) #Weka decision tree J48
library(evtree) #Evolutionary Algorithm, builds the tree from the bottom up
library(randomForest)
library(doParallel)
library(CHAID) #Chi-squared automatic interaction detection tree
library(tree)
library(caret)

#Data Preperation
data(weather)
names(weather)

dsname <- "weather"
target <- "RainTomorrow"
risk <- "RISK_MM"

ds <- get(dsname)
vars <- colnames(ds)
(ignore <- vars[c(1, 2, if (exists("risk")) which(risk==vars))])
#names(ds)[1]==''Date''
#names(ds)[2]==''Location''

vars <- setdiff(vars, ignore)
(inputs <- setdiff(vars, target))
(nobs <- nrow(ds))
dim(ds[vars])

(form <- formula(paste(target, "~ .")))
set.seed(1426)
length(train <- sample(nobs, 0.7*nobs))
length(test <- setdiff(seq_len(nobs), train))

#rPart Tree
model <- rpart(formula=form, data=ds[train, vars])
print(model)
summary(model)

printcp(model) #printcp for rpart objects
plotcp(model)

plot(model)
text(model)

fancyRpartPlot(model)

prp(model)
prp(model, type=2, extra=104, nn=TRUE, fallen.leaves=TRUE,
    faclen=0, varlen=0, shadow.col="grey", branch.lty=3)

#Prediction
pred <- predict(model, newdata=ds[test, vars], type="class")
pred.prob <- predict(model, newdata=ds[test, vars], type="prob")

model$variable.importance
model$ordered

#Pruning

