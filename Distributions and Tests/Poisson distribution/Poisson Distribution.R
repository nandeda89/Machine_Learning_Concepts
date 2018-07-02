#Poisson Distribution
#The Poisson distribution can be used to calculate the probabilities of various
#numbers of "successes" based on the mean number of successes. In order to apply
#the Poisson distribution, the various events must be independent. Keep in mind
#that the term "success" does not really mean success in the traditional positive
#sense. It just means that the outcome in question occurs.

#Example
#The mean number of calls to a fire station on a weekday is 8. What is the
#probability that on a given weekday there would be 11 calls?

dpois(x = 11, lambda = 8)
#0.07219021

#xample 2 - If there are twelve cars crossing a bridge per minute on average, find
# the probability of having seventeen or more cars crossing the bridge in a
# particular minute.

#16 or less
ppois(q = 16,
      lambda = 12,
      lower.tail = TRUE)

ppois(q = 16,
      lambda = 12,
      lower.tail = FALSE)
#0.101


# The mean number of defective products produced in a factory in one day is 21.
# What is the probability that in a given day there are exactly 12 defective
# products?

dpois(x = 12, lambda = 21)
#0.01164422

#Births in a hospital occur randomly at an average rate of 1.8 births per hour.
#What is the probability of observing 4 births in a given hour at the hospital?

dpois(x = 4, lambda = 1.8)
#0.07230173

#What about the probability of observing more than or equal to 2 births in a given
#hour at the hospital? Average =1.8

ppois(q = 1,
      lambda = 1.8,
      lower.tail = FALSE)
#0.5371631

#What about the probability of observing less than or equal to 1 births in a given
#hour at the hospital? Average =1.8
ppois(q = 1,
      lambda = 1.8,
      lower.tail = TRUE)
#0.4628369

#Changing the size of the interval
#Suppose we know that births in a hospital occur randomly at an average rate of
#1.8 births per hour.
#What is the probability that we observe 5 births in a given 2 hour interval?

# if births occur randomly at a rate of 1.8 births per 1 hour interval
# Then births occur randomly at a rate of 3.6 births per 2 hour interval

dpois(x = 5, lambda = 3.6)
#0.1376801

#Now suppose we know that in hospital A births occur randomly at an average rate
#of 2.3 births per hour and in hospital B births occur randomly at an average rate
#of 3.1 births per hour.
#What is the probability that we observe 7 births in total from the two hospitals
#in a given 1 hour period?
#Lambda = 2.3 + 3.1 = 5.4

dpois(x = 7, lambda = 5.4)
#0.1199874

#A manufacturer of television set known that on an average 5% of their product is 
#defective. They sells television sets in consignment of 100 and guarantees that 
#not more than 2 set will be defective. What is the probability that the TV set 
#will fail to meet the guaranteed quality? 

#lambda = np = 100*0.05 = 5
ppois(q=2, lambda = 5, lower.tail = FALSE)
# 0.875348

# A life insurance salesman sells on the average 3 life insurance policies per week.
# Use Poisson's law to calculate the probability that in a given week he will sell

# a. Some policies
# Some means 1 or More

ppois(q=0, lambda = 3, lower.tail = FALSE)
# 0.9502129
 
# b. 2 or more policies but less than 5 policies.
ppois(q=1, lambda = 3, lower.tail = FALSE)- ppois(q=4, lambda = 3, lower.tail = FALSE)
# 0.616115

# c. Assuming that there are 5 working days per week, what is the probability 
# that in a given day he will sell one policy?

#Average number of policies sold per day: 3/5 = 0.6
dpois(x = 1, lambda = 0.6)
#0.329287
