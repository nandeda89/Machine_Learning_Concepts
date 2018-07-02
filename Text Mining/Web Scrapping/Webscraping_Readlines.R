require(RCurl)
require(XML)
library(stringr)

Url <- "https://www.consumeraffairs.com/internet/verizon_fios.html?page="
df <- data.frame()

for (i in 1:6) {
  WebUrl <- paste(Url,i, sep = "")
  webpage <- readLines(WebUrl)
  pagetree <- htmlTreeParse(webpage, error=function(...){}, useInternalNodes = TRUE)
  Review <- xpathSApply(pagetree,"//div[@class = 'review']", xmlValue)
  df <- rbind(df, as.data.frame(Review))
}

write.csv(df, file.choose(), row.names = FALSE)
head(df)

New_df <- data.frame()

for (i in 1: nrow(df)) {

  # i <-1
    str <- as.character(df[i,])
    # str
    
  pos0 <- regexpr(' of',str)
  pos <- regexpr(',',str)
  pos1 <- regexpr(' on',str)
  pos2 <- regexpr('Rating',str)
  pos3 <- regexpr('adsbygoogle',str)
  
  Name <- ifelse(pos0!=-1,substr(str, 1, pos0-1), "")
  
  City <- ifelse(pos0!=-1 & pos!=-1,substr(str, pos0+4, pos-1), "")
  
  State <- ifelse(pos!=-1 & pos1!=-1,substr(str, pos+1, pos1-1), "")
  
  Date <- ifelse(pos!=-1 & pos1!=-1 & pos2!=-1,substr(str, pos1+3, pos2-14), "")
  
  Comments <- ifelse(pos3==-1,substr(str,pos2+6, nchar(str) -13),
                                      substr(str,pos2+6,pos3-7))
  
  New_df[i,"Name"] <- str_trim(Name)
  New_df[i,"City"] <- str_trim(City)
  New_df[i,"State"] <- str_trim(State)
  New_df[i,"Date"] <- str_trim(Date)
  New_df[i,"Comments"] <- str_trim(Comments)
  New_df[i,"str"] <- str_trim(str)
}

write.csv(New_df, file.choose(), row.names = FALSE)
