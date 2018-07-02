#Normal Distribution
#10 drwas from standard Normal distribution
rnorm(n = 10)

#10 draws from 100-200 dist.
rnorm(n = 10, mean = 100, sd = 20)
rnorm10 <- rnorm(10)
rnorm10

dnorm(rnorm10)
dnorm(c(-1, 0, 1))

randNorm <- rnorm(3000)
randDensity <- dnorm(randNorm)
require(ggplot2)
ggplot(data.frame(x = randNorm, y = randDensity), aes(x = x, y = y)) +
    geom_point() +
    labs(x = "Random Normal variables", y = "Density")

#Distribution of the normal distribution - cumulative prob.
pnorm(rnorm10)
pnorm(c(-3, 0, 3))

pnorm(-1)

pnorm(1) - pnorm(0)
pnorm(1) - pnorm(-1)

p <-
    ggplot(data.frame(x = randNorm, y = randDensity), aes(x = x, y = y)) +
    geom_line() + labs(x = "x", y = "Density")

negSeq1 <- seq(from = min(randNorm),
               to = -1,
               by = .1)
lessthanNeg1 <- data.frame(x = negSeq1, y = dnorm(negSeq1))
head(lessthanNeg1)

lessthanNeg1 <-
    rbind(c(min(randNorm), 0), lessthanNeg1, c(max(lessthanNeg1$x), 0))
p + geom_polygon(data = lessthanNeg1, aes(x = x, y = y))

neg1POS1Seq <- seq(from = -1, to = 1, by = .1)
neg1To1 <- data.frame(x = neg1POS1Seq, y = dnorm(neg1POS1Seq))
head(neg1To1)

neg1To1 <-
    rbind(c(min(neg1To1$x), 0), neg1To1, c(max(neg1To1$x), 0))
p + geom_polygon(data = neg1To1, aes(x = x, y = y))

randProb <- pnorm(randNorm)
ggplot(data.frame(x = randNorm, y = randProb), aes(x = x, y = y)) +
    geom_point() + labs(x = "Random Normal Variables", y = "Probility")

rnorm10
pnorm(rnorm10)
dnorm(rnorm10)
qnorm(pnorm(rnorm10))

#Examples
#Assume that the test scores of a college entrance exam fits a normal distribution.
#Furthermore, the mean test score is 72, and the standard deviation is 15.2. What
#is the percentage of students scoring 84 or more in the exam?

pnorm(
    q = 84,
    mean = 72,
    sd = 15.2,
    lower.tail = FALSE
)
#0.2149176

qnorm(
    p = 0.2149176,
    mean = 72,
    sd = 15.2,
    lower.tail = FALSE
)
#84

#install.packages("clusterSim")
library(clusterSim)
data(data_ratio)
z1 <-
    data.Normalization(data_ratio, type = "n1", normalization = "column")
z2 <-
    data.Normalization(data_ratio, type = "n10", normalization = "row")
?data.Normalization

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

qnorm(0.975, mean = 0, sd = 1)
qnorm(1 - 0.975, mean = 0, sd = 1)

#install.packages("tigerstats")
require(tigerstats)
qnorm(0.85, mean = 70, sd = 3)
pnormGC(
    73.1093,
    region = "below",
    mean = 70,
    sd = 3,
    graph = TRUE
)

#Suppose that SAT scores are normally distributed, and that the mean SAT score
#is 1000, and the standard deviation of all SAT scores is 100. How high must you
#score so that only 10% of the population scores higher than you?
#mean = 1000
#SD =100,
#p= 10%


qnorm(
    p = 0.10,
    mean = 1000,
    sd = 100,
    lower.tail = FALSE
)
#1128

qnorm(
    p = 0.90,
    mean = 1000,
    sd = 100,
    lower.tail = TRUE
)
#1128

# Find Area Between z=0 and z=0.78
#install.packages("tigerstats")
require(tigerstats)
pnorm(0,
      mean = 0,
      sd = 1,
      lower.tail = FALSE) - pnorm(0.78,
                                  mean = 0,
                                  sd = 1,
                                  lower.tail = FALSE)
pnormGC(
    c(0, 0.78),
    region = "between",
    mean = 0,
    sd = 1,
    graph = TRUE
)

#Find z value from probalility- q norm
#find Area probablilty from z value - p norm

# between z = -0.56 and z = 0
pnorm(
    q = 0,
    mean = 0,
    sd = ,
    lower.tail = TRUE
) - pnorm(
    q = -0.56,
    mean = 0,
    sd = ,
    lower.tail = TRUE
)
pnormGC(
    c(-0.56 , 0),
    region = "between",
    mean = 0,
    sd = 1,
    graph = TRUE
)

#between z = -0.43 and z = 0.78
pnorm(
    q = -0.43,
    mean = 0,
    sd = 1,
    lower.tail = FALSE
) - pnorm(
    q = 0.78,
    mean = 0,
    sd = 1,
    lower.tail = FALSE
)
pnormGC(
    c(-0.43 , 0.78),
    region = "between",
    mean = 0,
    sd = 1,
    graph = TRUE
)

#between z = 0.44 and z = 1.50
pnorm(
    q = 0.44,
    mean = 0,
    sd = 1,
    lower.tail = FALSE
) - pnorm(
    q = 1.50,
    mean = 0,
    sd = 1,
    lower.tail = FALSE
)
pnormGC(
    c(0.44 , 1.50),
    region = "between",
    mean = 0,
    sd = 1,
    graph = TRUE
)

#to the right of z = -1.33.
pnorm(
    q = -1.33,
    mean = 0,
    sd = 1,
    lower.tail = FALSE
)
pnormGC(
    -1.33,
    region = "above",
    mean = 0,
    sd = 1,
    graph = TRUE
)

# Find the following probabilities:

# (a) P(Z > 1.06)
#This is the same as asking "What is the area to the right of 1.06 under the
#standard normal curve?"
pnorm(
    q = 1.06,
    mean = 0,
    sd = 1,
    lower.tail = FALSE
)
pnormGC(
    1.06,
    region = "above",
    mean = 0,
    sd = 1,
    graph = TRUE
)

# (b) P(Z < -2.15)
# This is the same as asking "What is the area to the left of ???2.15 under the
#standard normal curve?"
pnorm(
    q = -2.15,
    mean = 0,
    sd = 1,
    lower.tail = TRUE
)

pnormGC(
    -2.15,
    region = "below",
    mean = 0,
    sd = 1,
    graph = TRUE
)

# (c) P(1.06 < Z < 4.00)
# This is the same as asking "What is the area between z=1.06 and z=4.00
#under the standard normal curve?"
pnorm(
    q = 1.06,
    mean = 0,
    sd = 1,
    lower.tail = FALSE
) - pnorm(
    q = 4.00,
    mean = 0,
    sd = 1,
    lower.tail = FALSE
)

pnormGC(
    c(1.06 , 4.00),
    region = "between",
    mean = 0,
    sd = 1,
    graph = TRUE
)

# (d) P(-1.06 < Z < 4.00)
#This is the same as asking "What is the area between z=???1.06 andz=4.00
#under the standard normal curve?"
pnorm(
    q = -1.06,
    mean = 0,
    sd = 1,
    lower.tail = FALSE
) - pnorm(
    q = 4.00,
    mean = 0,
    sd = 1,
    lower.tail = FALSE
)
pnormGC(
    c(-1.06 , 4.00),
    region = "between",
    mean = 0,
    sd = 1,
    graph = TRUE
)

#It was found that the mean length of 100 parts produced by a lathe was 20.05 mm
#with a standard deviation of 0.02 mm. Find the probability that a part selected
#at random would have a length

# (a) between 20.03 mm and 20.08 mm
pnorm(q=20.03, mean = 20.05, sd =0.02, lower.tail = FALSE) - pnorm(q=20.08, mean = 20.05, sd =0.02, lower.tail = FALSE)

z1 = round((20.03-20.05)/0.02, digits = 2)
z2 = round((20.08-20.05)/0.02, digits = 2)
pnormGC(
    c(z1 , z2),
    region = "between",
    mean = 0,
    sd = 1,
    graph = TRUE
)

# (b) between 20.06 mm and 20.07 mm
pnorm(q=20.06, mean = 20.05, sd =0.02, lower.tail = FALSE) - pnorm(q=20.07, mean = 20.05, sd =0.02, lower.tail = FALSE)

z1 = round((20.06-20.05)/0.02, digits = 2)
z2 = round((20.07-20.05)/0.02, digits = 2)
pnormGC(
    c(z1 , z2),
    region = "between",
    mean = 0,
    sd = 1,
    graph = TRUE
)

# (c) less than 20.01 mm
pnorm(q=20.01, mean = 20.05, sd =0.02, lower.tail = TRUE)

z1 = round((20.01-20.05)/0.02, digits = 2)
pnormGC(
    z1,
    region = "below",
    mean = 0,
    sd = 1,
    graph = TRUE
)

# (d) greater than 20.09 mm.
pnorm(q=20.09, mean = 20.05, sd =0.02, lower.tail = FALSE)

z1 = round((20.09-20.05)/0.02, digits = 2)
pnormGC(
    z1,
    region = "above",
    mean = 0,
    sd = 1,
    graph = TRUE
)