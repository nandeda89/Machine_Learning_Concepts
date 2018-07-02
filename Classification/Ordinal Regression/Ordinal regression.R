require(foreign)
require(ggplot2)
require(MASS)
require(Hmisc)
require(reshape2)

dat <- read.dta("http://www.ats.ucla.edu/stat/data/ologit.dta")
head(dat)

## fit ordered logit model and store results 'm'
m <- polr(apply ~ pared + public + gpa, data = dat, Hess=TRUE)

## view a summary of the model
summary(m)

## store table
(ctable <- coef(summary(m)))

## calculate and store p values
p <- pnorm(abs(ctable[, "t value"]), lower.tail = FALSE) * 2

## combined table
(ctable <- cbind(ctable, "p value" = p))

dat$rankP <- predict(m, dat, type="class")

cTab   <- xtabs(~ apply + rankP, data=dat)
addmargins(cTab)

accuracy <- sum(diag(cTab))/nrow(dat)
accuracy
