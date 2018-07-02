require(graphics)

## The CO2 data

Dataset <- read.csv("Monthly Data.csv", stringsAsFactors = FALSE)

## time series object.
q = ts(Dataset[[1]],start=c(2013,1),frequency=12)

## Generate the seasonal subseries plot.
par(mfrow=c(1,1))
monthplot(q,phase=cycle(q), base=mean, ylab="Cancel Rate",
          main="Seasonal Subseries Plot ",
          xlab="Month",
          labels=c("Jan","Feb","Mar","Apr","May","Jun",
                   "Jul","Aug","Sep","Oct","Nov","Dec"),
          ylim=c(0.05,.17))

#Another Seasonal graphh

fit <- stl(q , s.window = 20, t.window = 20)
plot(fit)

op <- par(mfrow = c(2,2))
monthplot(co2, ylab = "data", cex.axis = 0.8)
monthplot(fit, choice = "seasonal", cex.axis = 0.8)
monthplot(fit, choice = "trend", cex.axis = 0.8)
monthplot(fit, choice = "remainder", type = "h", cex.axis = 0.8)
par(op)




