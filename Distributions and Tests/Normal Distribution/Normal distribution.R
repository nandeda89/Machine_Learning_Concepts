#Normal Distribution

# Basic Properties of the Standard Normal Curve:
# Property 1: The total area under the standard normal curve is 1.
# Property 2: The standard normal curve extends indefinitely in both directions,
# approaching, but never touching, the horizontal axis as it does so.
# Property 3: The standard normal curve is symmetric about 0.
# Property 4: Almost all the area under the standard normal curve lies between -3 and 3.

#10 draws from 100-200 dist.
rnorm(n = 10, mean = 100, sd = 20)

#10 drwas from standard Normal distribution
rnorm10 <- rnorm(10)
rnorm10

#dnorm gives the density
dnorm(rnorm10)
dnorm(c(-1, 0, 1))

#3000 drwas from standard Normal distribution
randNorm <- rnorm(3000)

#Density
randDensity <- dnorm(randNorm)

require(ggplot2)
ggplot(data.frame(x = randNorm, y = randDensity), aes(x = x, y = y)) +
  geom_point() +
  labs(x = "Random Normal variables", y = "Density")

#Distribution of the normal distribution - cumulative prob.
pnorm(rnorm10)
pnorm(c(1, 0, 3))

pnorm(-1)

pnorm(1) - pnorm(0)
pnorm(1) - pnorm(-1)

p <- ggplot(data.frame(x = randNorm, y = randDensity), aes(x = x, y = y)) +
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

#OR
qnorm(
  p = 0.90,
  mean = 1000,
  sd = 100,
  lower.tail = TRUE
)
#1128

#An Area Between
#Find a positive number z so that the area under the standard normal curve 
#between ???z and z is 0.95.
#Area between -z and z = 0.95, Remaining area = 0.5, i.e. 0.25 on both sides
qnorm(c(1- 0.975, 0.975),mean=0,sd=1)
#1.959964

# Find Area(Probability) Between z=0 and z=0.78
pnorm(q= 0,
      mean = 0,
      sd = 1,
      lower.tail = FALSE) - pnorm(q= 0.78,
                                  mean = 0,
                                  sd = 1,
                                  lower.tail = FALSE)


#Find z value from probalility- q norm
#find Area (probablilty) from z value - p norm

# between z = -0.56 and z = 0
pnorm(
  q = 0,
  mean = 0,
  sd = ,
  lower.tail = TRUE) - pnorm(q = -0.56,
  mean = 0,
  sd = ,
  lower.tail = TRUE
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


#to the right of z = -1.33.
pnorm(
  q = -1.33,
  mean = 0,
  sd = 1,
  lower.tail = FALSE
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


# (b) P(Z < -2.15)
# This is the same as asking "What is the area to the left of ???2.15 under the
#standard normal curve?"
pnorm(
  q = -2.15,
  mean = 0,
  sd = 1,
  lower.tail = TRUE
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

#It was found that the mean length of 100 parts produced by a lathe was 20.05 mm
#with a standard deviation of 0.02 mm. Find the probability that a part selected
#at random would have a length

# (a) between 20.03 mm and 20.08 mm
pnorm(q=20.03, mean = 20.05, sd =0.02, lower.tail = FALSE) - pnorm(q=20.08, mean = 20.05, sd =0.02, lower.tail = FALSE)

# (b) between 20.06 mm and 20.07 mm
pnorm(q=20.06, mean = 20.05, sd =0.02, lower.tail = FALSE) - pnorm(q=20.07, mean = 20.05, sd =0.02, lower.tail = FALSE)

# (c) less than 20.01 mm
pnorm(q=20.01, mean = 20.05, sd =0.02, lower.tail = TRUE)

# (d) greater than 20.09 mm.
pnorm(q=20.09, mean = 20.05, sd =0.02, lower.tail = FALSE)

# A company pays its employees an average wage of $3.25 an hour with a 
# standard deviation of 60 cents. If the wages are a pproximately normally 
# distributed, determine

# a.the proportion of the workers getting wages between $2.75 and $3.69 an hour
pnorm(q=2.75, mean = 3.25, sd =0.6, lower.tail = FALSE) - pnorm(q=3.69, mean = 3.25, sd =0.6, lower.tail = FALSE)
#56.6%

# b.The minimum wage of the highest 5%.
qnorm(p=0.05, mean = 3.25, sd =0.6, lower.tail = FALSE)
#$4.24

# The average life of a certain type of motor is 10 years, with a standard deviation 
# of 2 years. If the manufacturer is willing to replace only 3% of the motors that 
# fail, how long a guarantee should he offer? Assume that the lives of the motors 
# follow a normal distribution.
qnorm(p=0.03, mean = 10, sd =2, lower.tail = TRUE)
#6.24 Years

#if the manufacturer offers 6.24 years of warranty then how many motors he has to replace
pnorm(q=6.238413, mean = 10, sd =2, lower.tail = TRUE)
#3%

# Find More Practice questions here
# https://cims.nyu.edu/~kiryl/Elementary%20Statistics/Chapter_9.pdf