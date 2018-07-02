library(tm)

docs <- c("customer want to know his repair","customer want to know his repair",
          "Transfer to repair")
class(docs)
class(dd)
dd <- Corpus(VectorSource(docs)) #Make a corpus object from a text vector
class(data)
#Clean the text
dd <- tm_map(dd, stripWhitespace)
inspect(dd[1:2])

dd <- tm_map(dd, tolower)
inspect(dd[1:2])

dd <- tm_map(dd, removePunctuation)
inspect(dd[1:2])

dd <- tm_map(dd, removeWords, stopwords("english"))
inspect(dd[1:2])

length(stopwords("smart"))
dd <- tm_map(dd, stemDocument) #removed common word endings 
inspect(dd[1:2])

dd <- tm_map(dd, removeNumbers)
inspect(dd[1:2])

#converting corpus to plaintextdocument
dd <- tm_map(dd, PlainTextDocument)
inspect(dd[1:2])

library(proxy)
tdm <- TermDocumentMatrix(dd)#, control = list(weighting = weightTfIdf))
inspect(tdm)

dim(tdm)
dtm <- DocumentTermMatrix(dd)#, control = list(weighting = weightTfIdf))
inspect(dtm)
dtm.matrix<-as.data.frame(as.matrix(tdm))

a<-dtm.matrix[,1]
a
b<-dtm.matrix[,2]
b
c<-dtm.matrix[,3]
c

#Checking similarity between 1st and 3rd comment, you can check 1st and 2nd by replacing c with b.
Numerator<-sum(b*a)
Numerator

deno1<-sqrt(sum(b*b))
deno2<-sqrt(sum(a*a))
deno<-deno1*deno2
deno
cosine<-Numerator/deno
cosine
