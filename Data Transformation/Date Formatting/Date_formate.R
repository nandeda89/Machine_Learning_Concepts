#lubridate
# 
# lubridate uses an intuitive user interface inspired by the date libraries of 
# object-oriented programming languages. lubridate methods are compatible with 
# a wide-range of common date-time and time series objects. These include 
# character strings, POSIXct, POSIXlt, Date

library(lubridate)
date <- dmy("01-01-2010")
date

#Month, day and Year
month(date)
day(date)
year(date)

#Set month = 2
month(date) <- 2
date

#deduc 32 days from the date
date <- date - days(32)
date

#Change time zone
with_tz(date, "EST")
date


#Parsing date-times
#Date - 1st dec 2010
date <- mdy("12-01-2010")
date
#[1] "2010-12-01 UTC"

#Date- 12th Jan 2010
date <- dmy("12-01-2010")
date

dmy(c("31.12.2010", "21.01.2011"))

month(date)
day(date)
year(date)


# Order of elements in date-time    Parse function
# year, month, day                          ymd()
# year, day, month                          ydm()
# month, day, year                          mdy()
# day, month, year                          dmy()
# hour, minute                              hm()
# hour, minute, second                      hms()
# year, month, day, hour, minute, second    ymd_hms()

#When a ymd() function is applied to a vector of dates, lubridate will 
#assume that all of the dates have the same order and the same separators

hm("12:00")
#[1] "12H 0M 0S"

hms("12:00:55")
#[1] "12H 0M 55S"

date <- now()
date

year(date)
minute(date)
month(date)
month(date, label = TRUE)
month(date, label = TRUE, abbr = FALSE)
wday(date, label = TRUE, abbr = FALSE)
day(date) <- 5

# Date component        Accessor
# Year                  year()
# Month                 month()
# Week                  week()
# Day of year           yday()
# Day of month          mday()
# Day of week           wday()
# Hour                  hour()
# Minute                minute()
# Second                second()
# Time zone             tz()

dates <- ymd_hms("2010-01-01 01:00:00", "2010-01-01 01:30:00")
minute.dates <- mean(minute(dates))

#last day of month
day(date) <- 1
month(date) <- month(date) + 1
day(date) <- day(date) - 1
date

#update method for date-times.
update(date, year = 2010, month = 1, day = 1)

date

hour(date) <- 12
date

date <- date + hours(15)
date

#Notice that hours() (plural) is not the same function as hour() (singular). hours() creates
#a new object that can be added or subtracted to a date-time.

start_2012 <- ymd_hms("2012-01-01 12:00:00")
is.instant(364)
is.instant(start_2012)

