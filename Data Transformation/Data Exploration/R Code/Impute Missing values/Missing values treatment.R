
## Missing values treatment #####

path <- "R/"
setwd(path)

#load data
data <- iris

#Get summary
summary(iris)

#Generate 10% missing values at Random 
library(missForest)
iris.mis <- prodNA(iris, noNA = 0.1)

#Check missing values introduced in the data
summary(iris.mis)

##### Continuos variables  ###

#Remove categorical variables
iris.mis <- subset(iris.mis, select = -c(Species))
summary(iris.mis)

#install MICE
library(mice)

#tabular form of missing value 
md.pattern(iris.mis)

# Create a visual to represent missing values
##install.packages("VIM")
library(VIM)
mice_plot <- aggr(iris.mis, col=c('navyblue','yellow'),
                    numbers=TRUE, sortVars=TRUE,
                    labels=names(iris.mis), cex.axis=.7,
                    gap=3, ylab=c("Missing data","Pattern"))


# impute the missing values.
imputed_Data <- mice(iris.mis, m=5, maxit = 50, method = 'pmm', seed = 500)
summary(imputed_Data)

#check imputed values
imputed_Data$imp$Sepal.Width

#Since there are 5 imputed data sets, we can select any using complete() 
#function.

#get complete data ( 2nd out of 5)
completeData <- complete(imputed_Data,2)
summary(completeData)

#Also, if we wish to build models on all 5 datasets, we can do it in one 
#go using with() command. we can also combine the result from these models 
#and obtain a consolidated output using pool() command.

#build predictive model
fit <- with(data = imputed_Data, exp = lm(Sepal.Width ~ Sepal.Length + Petal.Width)) 
summary(fit)

#combine results of all 5 models
combine <- pool(fit)
summary(combine)

#build predictive model - complete data ( 2nd out of 5)
fit <- with(data = completeData, exp = lm(Sepal.Width ~ Sepal.Length + Petal.Width)) 
summary(fit)

#build predictive model - original data
iris.new <- subset(iris, select = -c(Species))
fit <- with(data = iris.new, exp = lm(Sepal.Width ~ Sepal.Length + Petal.Width)) 
summary(fit)
