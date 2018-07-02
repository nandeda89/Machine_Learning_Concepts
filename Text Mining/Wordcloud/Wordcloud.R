
getwd()
setwd("\\R\\Wordcloud")
source('http://www.sthda.com/upload/rquery_wordcloud.r')

txtdata <- readLines("data.txt")
res<-rquery.wordcloud(filePath, type ="file", lang = "english")


#http://www.sthda.com/english/wiki/word-cloud-generator-in-r-one-killer-function-to-do-everything-you-need

source('http://www.sthda.com/upload/rquery_wordcloud.r')
filePath <- "http://www.sthda.com/sthda/RDoc/example-files/martin-luther-king-i-have-a-dream-speech.txt"
res<-rquery.wordcloud(filePath, type ="file", lang = "english")

filePath <- "H:/Analytics/R/Wordcloud/data.txt"

res<-rquery.wordcloud(filePath, type ="file", lang = "english",
                      min.freq = 1,  max.words = 200)

# Reds color palette
res<-rquery.wordcloud(filePath, type ="file", lang = "english",
                      colorPalette = "Reds")

# RdBu color palette
res<-rquery.wordcloud(filePath, type ="file", lang = "english",
                      colorPalette = "RdBu")

# use unique color
res<-rquery.wordcloud(filePath, type ="file", lang = "english",
                      colorPalette = "black")
tdm <- res$tdm
freqTable <- res$freqTable

head(freqTable, 10)

# Bar plot of the frequency for the top10
barplot(freqTable[1:10,]$freq, las = 2, 
        names.arg = freqTable[1:10,]$word,
        col ="lightblue", main ="Most frequent words",
        ylab = "Word frequencies")

findFreqTerms(tdm, lowfreq = 4)
findAssocs(tdm, terms = "freedom", corlimit = 0.3)

url = "http://www.sthda.com/english/wiki/create-and-format-powerpoint-documents-from-r-software"
rquery.wordcloud(x=url, type="url")
