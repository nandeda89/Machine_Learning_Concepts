Data <- read.csv("Order Status.csv", stringsAsFactors = FALSE)
library(reshape)
names(Data)

library(reshape2)
dataset1 <- dcast(data = Data, ORDER_NUMBER ~ STATUS, value.var='STATUS', length)

write.csv(dataset1, "Data.csv", row.names = FALSE)
