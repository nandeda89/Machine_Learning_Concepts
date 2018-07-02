
getwd()
setwd("\\PMML File")
data("iris")

# install.packages("pmml")
# install.packages("randomForest")

# Build a simple randomForest model
library(rpart)
library(pmml)

iris.rf <- rpart(Species ~ ., data=iris)

# Convert to pmml

pmod <- pmml(iris.rf)

# Save to an external file
savePMML(pmod, "RandomForestModel.pmml")
savePMML(pmod, "RandomForestModel_XML.xml")
