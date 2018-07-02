#install.packages("clusterSim")
library(clusterSim)
data(data_ratio)
z1 <- data.Normalization(data_ratio, type = "n1", normalization = "column")
z2 <- data.Normalization(data_ratio, type = "n10", normalization = "row")

# Arguments
# n0 - without normalization
#
# n1 - standardization ((x-mean)/sd)
#
# n2 - positional standardization ((x-median)/mad)
#
# n3 - unitization ((x-mean)/range)
#
# n3a - positional unitization ((x-median)/range)
#
# n4 - unitization with zero minimum ((x-min)/range)
#
# n5 - normalization in range <-1,1> ((x-mean)/max(abs(x-mean)))
#
# n5a - positional normalization in range <-1,1> ((x-median)/max(abs(x-median)))
#
# n6 - quotient transformation (x/sd)
#
# n6a - positional quotient transformation (x/mad)
#
# n7 - quotient transformation (x/range)
#
# n8 - quotient transformation (x/max)
#
# n9 - quotient transformation (x/mean)
#
# n9a - positional quotient transformation (x/median)
#
# n10 - quotient transformation (x/sum)
#
# n11 - quotient transformation (x/sqrt(SSQ))
#
# n12 - normalization ((x-mean)/sqrt(sum((x-mean)^2)))
#
# n12a - positional normalization ((x-median)/sqrt(sum((x-median)^2)))
#
# n13 - normalization with zero being the central point ((x-midrange)/(range/2))
