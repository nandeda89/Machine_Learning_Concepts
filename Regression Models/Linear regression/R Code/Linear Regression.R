############################################## Linear Regression   ##############################################

#################################

#### Simple Linear Regression
library(lattice)

### Sample Data
alligator = data.frame(
    lnLength = c(3.87, 3.61, 4.33, 3.43, 3.81, 3.83, 3.46, 3.76,
                 3.50, 3.58, 4.19, 3.78, 3.71, 3.73, 3.78),
    lnWeight = c(4.87, 3.93, 6.46, 3.33, 4.38, 4.70, 3.50, 4.50,
                 3.58, 3.64, 5.90, 4.43, 4.38, 4.42, 4.25)
)

## Visualize the Data
xyplot(lnWeight ~ lnLength, data = alligator,
       xlab = "Snout vent length (inches) on log scale",
       ylab = "Weight (pounds) on log scale",
       main = "Alligators in Central Florida"
)

# Simple linear Model
alli.mod1 = lm(lnWeight ~ lnLength, data = alligator)

## Model Summary
summary(alli.mod1)

## Plot Residual Plots
plot(alli.mod1)

####################################################
## Model diagnosis

################ P value
# P Value of Model -- p-value: 1.495e-12
# P Value of predictor -- 1.49e-12 
# P value less than 0.05 - it is significant

#########################
## R Squared
# Multiple R-squared: 0.9808,     
# Adjusted R-squared: 0.9794 

# R Squared is close to one.. which is good
#########################
## Plot the results
plot(alli.mod1)

# 1. Residuals vs. Fitted
xyplot(resid(alli.mod1) ~ fitted(alli.mod1),
       xlab = "Fitted Values",
       ylab = "Residuals",
       main = "Residual Diagnostic Plot",
       panel = function(x, y, ...)
       {
           panel.grid(h = -1, v = -1)
           panel.abline(h = 0)
           panel.xyplot(x, y, ...)
       }
)
## Residual vs. Fitted should not follow Linearity

# 2. Normal Q-Q
qqnorm(resid(alli.mod1)); 
qqline(resid(alli.mod1), col = 2)
## if theoritical and Residuals are on straight line, then we can say that Residuals are following normal distibution

# 3. Scale - Location
xyplot(sqrt(abs((scale((resid(alli.mod1)))))) ~ fitted(alli.mod1),
       xlab = "Fitted Values",
       ylab = "Square root of Standardized Residuals",
       main = "Scale Location Plot",
       panel = function(x, y, ...)
       {
           panel.grid(h = -1, v = -1)
           panel.abline(h = 0)
           panel.xyplot(x, y, ...)
       }
)

# 4. Residuals vs. Leverage


# 1. 

#################################

















################################################################################################################