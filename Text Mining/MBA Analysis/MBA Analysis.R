# Load the libraries
library(arules)
library(arulesViz)
library(datasets)

# Load the data set
data(Groceries)

# Create an item frequency plot for the top 20 items
itemFrequencyPlot(Groceries, topN = 20, type = "absolute")

#We set the minimum support to 0.001
suppt = 0.001

#We set the minimum confidence of 0.8
confidnce = 0.8

# Get the rules
rules <- apriori(Groceries, parameter = list(supp = suppt, conf = confidnce))

# Show the top 5 rules
inspect(rules[1:5])

# Show the top 5 rules, but only 2 digits
options(digits=2)
inspect(rules[1:5])

summary(rules)

#Sorting stuff out - Lets say we wanted to have the most likely rules
rules <- sort(rules, by = "confidence", decreasing = TRUE)

## Show the top 5 rules
inspect(rules[1:5])

#Sort rules by lift ratio
rules <- sort(rules, by = "lift", decreasing = TRUE)

## Show the top 5 rules
inspect(rules[1:5])

#Rule 4 is perhaps excessively long. Lets say we wanted more concise rules.
rules <- apriori(Groceries, parameter = list(supp = suppt, conf = confidnce, maxlen = 3))
rules <- sort(rules, by = "confidence", decreasing = TRUE)

## Show the top 5 rules
inspect(rules[1:5])

#Redundancies
#We can eliminate these repeated rules using the follow snippet of code:
  
subset.matrix <- is.subset(rules, rules)
head(subset.matrix)

subset.matrix[lower.tri(subset.matrix, diag=T)] <- NA

redundant <- colSums(subset.matrix, na.rm=T) >= 1
rules.pruned <- rules[!redundant]
rules<-rules.pruned

#Targeting Items
#What are customers likely to buy before buying whole milk
rules <- apriori(Groceries, parameter = list(supp = suppt, conf = confidnce),
                 appearance = list(default= "lhs", rhs = "whole milk"))

rules <- sort(rules, by = "confidence", decreasing = TRUE)
inspect(rules[1:5])
summary(rules)

rules <- apriori(Groceries, parameter = list(supp = suppt, conf = confidnce),
                 appearance = list(default= "lhs", rhs = "whole milk"),
                 control = list(verbose = F))

rules <- sort(rules, by = "confidence", decreasing = TRUE)
inspect(rules[1:5])
summary(rules)

# What are customers likely to buy if they purchase whole milk?
rules<-apriori(data=Groceries, parameter=list(supp=suppt,conf = confidnce,minlen=2), 
               appearance = list(default="rhs",lhs="whole milk"),
               control = list(verbose=F))

rules<-sort(rules, decreasing=TRUE,by="confidence")
#set of 0 rules

#set the confidence to 0.15 since we get no rules with 0.8
confidnce =0.15

rules<-apriori(data=Groceries, parameter=list(supp=suppt,conf = confidnce,minlen=2), 
               appearance = list(default="rhs",lhs="whole milk"),
               control = list(verbose=F))

rules<-sort(rules, decreasing=TRUE,by="confidence")
#set of 6 rules

inspect(rules)

#Visualization
library(arulesViz)
library(igraph)

plot(rules,method="graph",interactive=TRUE,shading=NA)
#Error: 'nicely' is not an exported object from 'namespace:igraph'