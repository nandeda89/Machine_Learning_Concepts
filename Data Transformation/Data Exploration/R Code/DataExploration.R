install.packages('psych')
library(caret)
library(ellipse)
library(psych)

dataset <- iris  ## Loading the iris dataset
head(dataset)
summary(dataset)  ## Summary of the dataset
describe(dataset)  ## Detailed summary using describe (psych package)
sapply(dataset, class)  ## Datatypes for each attribute
cbind(Frequency=table(dataset$Species), Percentage=prop.table(table(dataset$Species)) * 100)  ## Frequency and % split of the target variable values

boxplot(dataset)  ## Boxplot for each attribute
pairs(dataset[,1:4], main="Iris Scatterplot Matrix")  ## Scatterplot matrix for numeric factors
cor(dataset[,1:4])  ## Correlation matrix for the numeric attributes

hist(dataset$Petal.Length, breaks = 10, main="Petal Length")  ## Histogram for petal length
m<-mean(dataset$Sepal.Length);std<-sqrt(var(dataset$Sepal.Length))  ## Calculating mean and standard deviation for sepal length attribute
hist(dataset$Sepal.Length, breaks = 10, main="Sepal Length", prob=T, ylim = c(0,0.5) )  ## Histogram for sepal length having the Y-axis as probability
curve(dnorm(x, mean=m, sd=std), col="darkblue", lwd=2, add=TRUE)  ## Adding the normal distribution curve

featurePlot(x=dataset[,1:4], y=dataset[,5], plot='ellipse')  ## Scatterplot matrix;  Options for plot: box, strip, density, pairs or ellipse
featurePlot(x=dataset[,1:4], y=dataset[,5], plot='density')  ## Using density for the plot argument

