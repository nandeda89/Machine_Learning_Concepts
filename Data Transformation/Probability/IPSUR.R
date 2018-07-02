#IPSUR
#install.packages("IPSUR")
library(IPSUR)
read(IPSUR)

#quantitative continuous data
str(precip)
precip[1:5]

#Lengths of Major North American Rivers
str(rivers)

#Yearly Numbers of Important Discoveries
str(discoveries)
discoveries[1:5]

#Displaying Quantitative Data
#Strip charts (also known as Dot plots)

stripchart(precip, xlab = "rainfall")
stripchart(rivers, method = "jitter", xlab = "length")
stripchart(discoveries, method = "stack", xlab = "number")

#install.packages("RcmdrPlugin.IPSUR")
# library(RcmdrPlugin.IPSUR)
