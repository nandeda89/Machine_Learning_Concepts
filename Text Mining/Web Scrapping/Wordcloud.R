library(tm) 
library(class)
library(SnowballC)
library(wordcloud)

df <- read.csv("ConsumComplaints_v1.csv", sep =",", header = TRUE)

docs <- Corpus(df$Comments)
#Error: inherits(x, "Source") is not TRUE

#VectorSource -it can create a corpus from character vectors,
docs <- Corpus(VectorSource(df$Comments))

# Clean the corpus

#Content transformers, modify the content of an R object
docs <- tm_map(docs, content_transformer(tolower))

#Remove numbers from a text document
docs <- tm_map(docs, removeNumbers)

#Remove words from a text document
#list of smart stopwords - http://jmlr.csail.mit.edu/papers/volume5/lewis04a/a11-smart-stop-list/english.stop
docs <- tm_map(docs, removeWords, stopwords("smart"))

#Remove punctuation marks from a text document
docs <- tm_map(docs, removePunctuation)

#Strip extra whitespace from a text document.   Multiple whitespace characters 
#are collapsed to a single blank
docs <- tm_map(docs, stripWhitespace)

#Stem words in a text document using Porter's stemming algorithm
docs <- tm_map(docs, stemDocument, language = "english")

#new Stop words
myStopwords <- c("verizon")
docs <- tm_map(docs, removeWords, myStopwords)

# Create TermDocumentMatrix
TDM <- TermDocumentMatrix(docs, control = list(minWordLength = 1))

# Builing WordCloud which shows the importance of words.
m <- as.matrix(TDM) # calculate the frequency of words 
v <- sort(rowSums(m), decreasing=TRUE) 
myNames <- names(v) 
d <- data.frame(word=myNames, freq=v) 
head(d,30)
wordcloud(d$word, d$freq, min.freq=30,colors = brewer.pal(8, "Dark2"), random.order = FALSE)

---------
  
library(tm)
library(RWeka)    

#Tokenizer for n-grams and passed on to the term-document matrix constructor
BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
txtTdmBi<-TermDocumentMatrix(docs, control = list(tokenize = BigramTokenizer))

dim(txtTdmBi)
sparse.01 <- removeSparseTerms(txtTdmBi, 0.999)
dim(sparse.01)
tdm.matrix.01 <- as.matrix(sparse.01)
#tdm.matrix.01[tdm.matrix.01>1] <- 1

#Bigram wordcloud
m.01 <- as.matrix(sparse.01) # calculate the frequency of words 
v.01 <- sort(rowSums(m.01), decreasing=TRUE) 
myNames.01 <- names(v.01) 

d <- data.frame(word=myNames.01, freq=v.01) 
head(d,75)

wordcloud(d$word, d$freq, max.words=20,min.freq=5, random.order = FALSE,
          colors = brewer.pal(8, "Dark2"))
