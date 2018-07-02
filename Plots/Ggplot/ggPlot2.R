
#---------------------------------------------------------------------------------#
                                    
                                    # ggplot2

#---------------------------------------------------------------------------------#

#Install below package before you Start

#install.packages('ggplot2')
#install.packages('car')
#install.packages('gridExtra')

#Load Packages
library(ggplot2)
library(lattice)
library(car)
library(gridExtra)

#Example
ggplot(data=mtcars, aes(x=wt,y=mpg)) +
  geom_point() +
  labs(title="Automobile Data", x="Weight", y="Miles Per Gallon")

#Example
ggplot(data=mtcars, aes(x=wt,y=mpg)) +
  geom_point(pch=15, color="blue", size=2) +
  labs(title="Automobile Data", x="Weight", y="Miles Per Gallon")

#Example
p<- ggplot(data=mtcars, aes(x=wt,y=mpg)) +
  labs(title="Automobile Data", x="Weight", y="Miles Per Gallon")

#Basic
p + geom_point()

# Add aesthetic mappings
p + geom_point(aes(colour=qsec))
p + geom_point(aes(alpha=qsec))
p + geom_point(aes(colour= factor(cyl)))
p + geom_point(aes(shape= factor(cyl)))
p + geom_point(aes(size= qsec))
