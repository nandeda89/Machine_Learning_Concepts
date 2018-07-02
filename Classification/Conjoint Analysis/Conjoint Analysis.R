## Conjoint Analysis

setwd("Conjoint Analysis")

#Step 1: Design the profile of the product under consideration. 
#Since we just need 21 parameters, we use fractional factorial method with 
#21 cards

#install.packages("conjoint")

library(conjoint)
attribute<-list(
    Origin=c("European","Canadian","Japanese"),
    Price=c("6.19","5.49","4.79"),
    Body=c("Rich full bodied","Regular","Crisp and clear"),
    Aftertaste=c("strong","mild", "very mild"),
    Calories=c("full", "regular", "low"),
    Packaging=c("Six 12Oz Large", "Six 12Oz Small",   "Four 16Oz"),
    Glass=c("Green Label",    "Brown Label",  "Brown Painted")
)

#?expand.grid

profiles<-expand.grid(attribute)

?caFactorialDesign
design<-caFactorialDesign(data=profiles,type="fractional", cards=21)

print(design)

nrow(design)

#Step 2: Load the file with levels (or design a matrix with level names). 
#Load the file with preferences as received from the survey.

KrinLev <- read.csv("KrinLev.csv", header=F)
KrinPref <- read.csv("KrinPref.csv")

#Step 3: Execute the conjoint function as:
#Conjoint(Matrix of Preferences, matrix of design, matrix of levels names)
    
Conjoint(KrinPref, design, KrinLev)

#Step 4: To get the importance of each of seven attributes, we can use:
#caImportance(matrix of preferences, design of the profile)

caImportance(KrinPref, design)
        
#Step 5: Here we'll get the part utilities of each of 317 respondents with intercept on first place
uslall <- caPartUtilities(KrinPref, design, KrinLev)
uslall

caTotalUtilities(y=KrinPref, x=design)

#Step 6: We can also segment the respondents as per their ratings. For detail segmentation, 
#one can use K-Means algorithm. Here clusters are formed based on matrix of preferences and 
#matrix of profiles. Here, we chose 5 clusters (c=5)
    
sgment <- caSegmentation(KrinPref, design, c=3)
sgment

#Step 7: We can also plot the clusters by plotcluster() function used for K-Means cluster plotting

library(cluster)
#install.packages("fpc")
library(fpc)
plotcluster(KrinPref, sgment$cluster)
