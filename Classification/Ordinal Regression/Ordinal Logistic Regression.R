#Ordinal Logistic Regression
# update.packages("foreign")
# update.packages("ggplot2")
# update.packages("MASS")
# update.packages("Hmisc")
# update.packages("reshape2")

#Packages Required
require(foreign)
require(ggplot2)
require(MASS)
require(Hmisc)
require(reshape2)

#Failed with error:  'package 'Formula' required by 'Hmisc' could not be found'
# install.packages("Hmisc")

#Example : A study looks at factors that influence the decision of whether to 
# apply to graduate school. College juniors are asked if they are unlikely, 
# somewhat likely, or very likely to apply to graduate school. Hence, our outcome 
# variable has three categories. Data on parental educational status, whether the 
# undergraduate institution is public or private, and current GPA is also collected.
# The researchers have reason to believe that the "distances" between these three 
# points are not equal. For example, the "distance" between "unlikely" and 
# "somewhat likely" may be shorter than the distance between "somewhat likely" 
# and "very likely".

dat <- read.dta("http://www.ats.ucla.edu/stat/data/ologit.dta")
head(dat)


#About data
# This hypothetical data set has a three level variable called apply, with levels 
# "unlikely", "somewhat likely", and "very likely", coded 1, 2, and 3, respectively,
# that we will use as our outcome variable.

# We also have three variables that we will use as predictors: pared, which is a 0/1 
# variable indicating whether at least one parent has a graduate degree

# public, which is a 0/1 variable where 1 indicates that the undergraduate 
# institution is public and 0 private

# gpa, which is the student's grade point average

## one at a time, table apply, pared, and public
lapply(dat[, c("apply", "pared", "public")], table) #best result

table(dat$public)

table(dat[, c("apply", "pared", "public")])
table(dat$apply, dat$pared, dat$public)

table(dat[, c("pared", "public","apply")])
table(dat$public, dat$pared, dat$apply)

lapply(dat[, c("apply", "pared", "public")], table) #best result

## $apply
## 
##        unlikely somewhat likely     very likely 
##             220             140              40 
## 
## $pared
## 
##   0   1 
## 337  63 
## 
## $public
## 
##   0   1 
## 343  57


## three way cross tabs (xtabs) and flatten the table
ftable(xtabs(~ public + apply + pared, data = dat))

summary(dat$gpa)
sd(dat$gpa)

ggplot(dat, aes(x = apply, y = gpa)) +
    geom_boxplot(size = .75) +
    geom_jitter(alpha = .5) +
    facet_grid(pared ~ public, margins = TRUE) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))

## fit ordered logit model and store results 'm'
m <- polr(apply ~ pared + public + gpa, data = dat, Hess=TRUE)

## view a summary of the model
summary(m)

# store table
(ctable <- coef(summary(m)))

## calculate and store p values
p <- pnorm(abs(ctable[, "t value"]), lower.tail = FALSE) * 2

## combined table
(ctable <- cbind(ctable, "p value" = p))

(ci <- confint(m)) # default method gives profiled CIs

confint.default(m) # CIs assuming normality

## odds ratios
exp(coef(m))

## OR and CI
exp(cbind(OR = coef(m), ci))

sf <- function(y) {
    c('Y>=1' = qlogis(mean(y >= 1)),
      'Y>=2' = qlogis(mean(y >= 2)),
      'Y>=3' = qlogis(mean(y >= 3)))
}

(s <- with(dat, summary(as.numeric(apply) ~ pared + public + gpa, fun=sf)))

glm(I(as.numeric(apply) >= 2) ~ pared, family="binomial", data = dat)

s[, 4] <- s[, 4] - s[, 3]
s[, 3] <- s[, 3] - s[, 3]
s # print

plot(s, which=1:3, pch=1:3, xlab='logit', main=' ', xlim=range(s[,3:4]))

newdat <- data.frame(
    pared = rep(0:1, 200),
    public = rep(0:1, each = 200),
    gpa = rep(seq(from = 1.9, to = 4, length.out = 100), 4))

newdat <- cbind(newdat, predict(m, newdat, type = "probs"))

##show first few rows
head(newdat)

lnewdat <- melt(newdat, id.vars = c("pared", "public", "gpa"),
                variable.name = "Level", value.name="Probability")
## view first few rows
head(lnewdat)

ggplot(lnewdat, aes(x = gpa, y = Probability, colour = Level)) +
    geom_line() +
    facet_grid(pared ~ public, scales="free")

#http://www.ats.ucla.edu/stat/r/dae/ologit.htm