
#  Sample JSON

# install.packages("jsonlite")
library(jsonlite)
document <- fromJSON(txt="C:/CTI_log_2.json")
write.csv(document, "C:/Cti_logs.csv", row.names = FALSE)

library(rjson)
document1 <- rjson::fromJSON(file="C:/CTI_log_2.json", method='C')
document1 <- data.frame(document)
write.csv(document1, "Cti_logs.csv", row.names = FALSE)




