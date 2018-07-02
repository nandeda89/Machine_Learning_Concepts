#Bayes' Theorem
#install.packages("IPSUR")
#library(IPSUR)

#Tests detect things that don't exist (false positive), 
#and miss things that do exist (false negative)

#Example - A desk lamp produced by The Luminar Company was found to be defective (D).
#There are three factories (A, B, C) where such desk lamps are manufactured. A 
#Quality Control Manager (QCM) is responsible for investigating the source of found 
#defects. This is what the QCM knows about the company's desk lamp production and 
#the possible source of defects:

# Factory       % of total production        Probability of defective lamps
# A                0.35 = P(A)                   0.015 = P(D | A)
# B                0.35 = P(B)                   0.010 = P(D | B)
# C                0.30 = P(C)                   0.020 = P(D | C)

prior <- c(0.35,0.35,0.30)
like <- c(0.015, 0.010, 0.020)
post <- prior * like
post/(sum(post))
# 0.3559322  0.2372881  0.4067797

#Calculated posterior probabilities should make intuitive sense, as they do here. 
#For example, the probability that the randomly selected desk lamp was manufactured 
#in Factory C has increased, that is, P(C | D) > P(C), because Factory C generates 
#the greatest proportion of defective lamps (P(D | C) = 0.02). And, the probability
#that the randomly selected desk lamp was manufactured in Factory B has decreased,
#that is, P(B | D) < P(B), because Factory B generates the smallest proportion of 
#defective lamps (P(D | B) = 0.01). It is, of course, always a good practice to make 
#sure that your calculated answers make sense.

#Example 2
# p(cancer) = 0.01, p(-Cancer) = 0.99
# p(pos|c) = 0.9, p(neg|c) = 0.1
# p(neg|-c) = 0.9, p(pos|-c) = 0.1

#find p(c|pos) = ?, p(-c|pos) = ?
prior <- c(0.01,0.99)
like <- c(0.9, 0.1)
post <- prior * like
post/(sum(post))
#0.08333333 0.91666667

#find p(c|neg) = ?, p(-c|neg) = ?
prior <- c(0.01,0.99)
like <- c(0.1, 0.9)
post <- prior * like
post/(sum(post))
#0.001121076 0.998878924

#Example 3
# p(Red) = 0.5, p(Green) = 0.5
# p(See R| At R) = 0.8, p(See G| At R) = 0.2
# p(See G| At G) = 0.8,  p(See R| At G) = 0.2

#What is the probability that the robot is at R, when he sees Red
#find p(At R|Sees R) = ?, p(At G|Sees R) = ?
prior <- c(0.5,0.5)
like <- c(0.8, 0.2)
post <- prior * like
post/(sum(post))
#0.8   0.2

#Drug testing
#Suppose a drug test is 99% sensitive and 99% specific. That is, the test will 
#produce 99% true positive results for drug users and 99% true negative results for 
#non-drug users. Suppose that 0.5% of people are users of the drug. If a randomly 
#selected individual tests positive, what is the probability he or she is a user?

prior <- c(0.005,0.995)
like <- c(0.99, 0.01)
post <- prior * like
post/(sum(post))
#0.3322148 0.6677852

#now if 99.5% specific and 99% sensitive then
prior <- c(0.005,0.995)
like <- c(0.99, 0.005)
post <- prior * like
post/(sum(post))
#0.4987406 0.5012594

#The entire output of a factory is produced on three machines. The three machines 
#account for 20%, 30%, and 50% of the output, respectively. The fraction of defective
#items produced is this: for the first machine, 5%; for the second machine, 3%; for 
#the third machine, 1%. If an item is chosen at random from the total output and is 
#found to be defective, what is the probability that it was produced by the third
#machine?

prior <- c(0.2,0.3,0.5)
like <- c(0.05, 0.030, 0.010)
post <- prior * like
post/(sum(post))
# 0.4166667 0.3750000 0.2083333
#probability that it was produced by the third machine = 0.20




