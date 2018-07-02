############################ Using Holt Winters Method ########################
library("forecast")
library("tseries")
  plot(AirPassengers)  ## Plotting the inbuilt timeseries dataset AirPassengers, containing monthly totals of airpassengers from 1950 to 1960; an additive time series model cannot be developed as the variance seems to increase with time
plot(log(AirPassengers))  ## Plotting the log values; Additive model can be applied
logAirPassengers <- log(AirPassengers)
AirPassengersComponents <- decompose(logAirPassengers)  ## Decomposing the dataset into the trend, seasonal and random components
plot(AirPassengersComponents)  ## Plotting the 3 components along with the original time series
AirPassengersForecast <- HoltWinters(logAirPassengers)  ## HoltWinters time series model is used to make predictions from 1950 to 1960
AirPassengersForecast
plot(AirPassengersForecast)  ## Plotting the predictions against the originals
AirPassengersForecast2 <- forecast.HoltWinters(AirPassengersForecast, h=24)  ## Forecasting the next 24 month numbers using forecast.HoltWinters function
AirPassengersForecast2
plot(AirPassengersForecast2)  ## Plotting the forecast with surrounding 80 and 95% prediction intervals
exp(AirPassengersForecast2$mean)  ## The forecast numbers for Jan 1961-Dec 1962


############################### Using ARIMA Model ##############################
adf.test(diff(log(AirPassengers)), alternative="stationary", k=0)  ## Dickey fuller test to check for stationarity

## To find the values of p,d,q for an ARIMA model, we get the ACF and PACF plots
acf(diff(log(AirPassengers)))
pacf(diff(log(AirPassengers)))

fit <- arima(log(AirPassengers), c(0, 1, 1),seasonal = list(order = c(0, 1, 1), period = 12)) ## Using ARIMA with the parameters obtained by observing the ACF and PACF plots
pred <- predict(fit, n.ahead = 2*12)  ## Forecast for the next two years
ts.plot(AirPassengers,exp(pred$pred), log = "y", lty = c(1,3))  ## Plotting 2 time series using ts.plot