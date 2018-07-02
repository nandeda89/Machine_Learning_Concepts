#Bayes' Theorem
#install.packages("prob")
library(prob)

S <- rolldie(times = 3,
             nsides = 6,
             makespace = FALSE)
head(S)

S <- rolldie(times = 3,
             nsides = 6,
             makespace = TRUE)
head(S)

S <- addrv(S, sum, name = "Y")
head(S)

S <- addrv(S, Z = X3 - X2)
head(S)

S <- addrv(S, mean, name = "Mean")
head(S)

#cards - A Standard Set of Playing Cards
cards(jokers = FALSE, makespace = FALSE)
cards()

cards(jokers = FALSE, makespace = TRUE)

#prob Probability and Conditional Probability

S <- rolldie(times = 3, makespace = TRUE )
Prob(S, X1+X2 > 9 )
Prob(S, X1+X2 > 9, given = X1+X2+X3 > 7 )

