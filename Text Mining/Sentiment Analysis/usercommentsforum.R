getwd()
setwd("H:\\")
#Import user comments file
usercomments<- read.csv("usercommentsforum.csv", header=TRUE, stringsAsFactors=FALSE)

head(usercomments)
dim(usercomments)
usercomments$COMMENTS[1]



# #split lines 
# usercomments.splitLines <- strsplit(usercomments$COMMENTS, "\n")
# typeof(usercomments.splitLines)
# unlist(usercomments.splitLines)
# usercomments_needed <- unlist(usercomments.splitLines)

library(tm)
# #Clean text
# usercomments_needed = gsub("[[:punct:]]", "", usercomments_needed)
# usercomments_needed = gsub("[[:digit:]]", "", usercomments_needed)
# usercomments_needed = gsub("http\\w+", "", usercomments_needed)
# usercomments_needed = gsub("[ \t]{2,}", "", usercomments_needed)
# usercomments_needed = gsub("^\\s+|\\s+$", "", usercomments_needed)
# usercomments_needed <- tm_map(usercomments_needed, removeWords, stopwords("english"))
# usercomments_needed <- tm_map(usercomments_needed, removeWords, stopwords("smart"))

#Prepare Corpus

usercorpus<-Corpus(VectorSource(usercomments$COMMENTS))
usercorpus <- tm_map(usercorpus, content_transformer(tolower))
#remove punctuation
usercorpus <- tm_map(usercorpus, removePunctuation)
# remove numbers
usercorpus <- tm_map(usercorpus, removeNumbers)
# remove stopwords from corpus
usercorpus <- tm_map(usercorpus, removeWords, stopwords("english"))
usercorpus <- tm_map(usercorpus, removeWords, stopwords("smart"))
# keep a copy of corpus to use later as a dictionary for stem completion
usercorpusCopy <- usercorpus
# stem words
usercorpus <- tm_map(usercorpus, stemDocument)
usercorpus <- tm_map(usercorpus, stripWhitespace)


#Term document matrix

utdm<-TermDocumentMatrix(usercorpus) 

utdm

inspect(utdm)[1:5]
#TDM


td.mat <- as.matrix(utdm)
dist.mat <- dist(t(as.matrix(td.mat)))
dist.mat  # check distance matrix

#Frequency  and density Calculation
#freq calculation
utdm.common = removeSparseTerms(utdm, 0.90)
(ufreq.terms <- findFreqTerms(utdm.common, lowfreq = 100))

uterm.freq <- rowSums(as.matrix(utdm))
uterm.freq <- subset(uterm.freq, uterm.freq >= 100)
df <- data.frame(term = names(uterm.freq), freq = uterm.freq)

library(ggplot2)
ggplot(df, aes(x = term, y = freq)) + geom_bar(stat = "identity") +
  xlab("Terms") + ylab("Count") + coord_flip()

#Density calculation
utdm.common = removeSparseTerms(utdm, 0.90)
library(slam)
utdm.dense<-as.matrix(utdm.common)
head(utdm.dense)
# shape to plot 
library(reshape2)
utdm.dense = melt(utdm.dense, value.name = "count")
head(utdm.dense)

#plot#frequencyplot
library(ggplot2)
ggplot(utdm.dense, aes(x = Docs, y = Terms, fill = log10(count))) +
  geom_tile(colour = "white") +
  scale_fill_gradient(high="#FF0000" , low="#FFFFFF")+
  ylab("") +
  theme(panel.background = element_blank()) +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank())


#correlation plot
library(graph)
library(Rgraphviz)
plot(utdm, term = ufreq.terms, corThreshold = 0.41, weighting = T)

#wordcloud
library(wordcloud)
#wordcloud wiyth freq 10
wordcloud(usercorpus,min.freq = 100)

m <- as.matrix(utdm)
# calculate the frequency of words and sort it by frequency
word.freq <- sort(rowSums(m), decreasing = T)

#length(word.freq)
word.freq[3:length(word.freq)]

#wordcloud(words = names(word.freq), freq = word.freq, min.freq = 3,
#random.order = F)

wordcloud(words = names(word.freq[3:length(word.freq)]), freq = word.freq[3:length(word.freq)], min.freq = 3,
          random.order = F)
#Bigram

library(RWeka)    

#Tokenizer for n-grams and passed on to the term-document matrix constructor
BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
utdm<-TermDocumentMatrix(user_corpus, control = list(tokenize = BigramTokenizer))
utdm.common <- removeSparseTerms(utdm.common, 0.999)

m.01<-as.matrix(utdm.common)
v.01<-sort(row_sums(m.01),decreasing = TRUE)
cnames.01<-names(v.01)
ud<-data.frame(word=cnames.01,freq=v.01)
wordcloud(ud$word, ud$freq, max.words=20,min.freq=20,colors = brewer.pal(8, "Dark2"))

library(memoise)


getAssocMatrix <- memoise(function(assocTerm) {
  
  
  findAssocs(utdm.common, assocTerm, 0.1)
  
  
})


#sentiment

#calculate sentiment scores
library(RSentiment)
#convert corpus to text
user_comments_text<-convert.tm.to.character(usercorpus)

user_comments_text<-as.character(usercorpus)
user_sentiment_score<-calculate_score(user_comments_text)
user_sentiment<-calculate_sentiment(user_comments_text)

head(user_sentiment_score)

usersentiment<-df(usercomments$Name,user_sentiment_score,user_sentiment$sentiment)

#Sentiment
#Sentiment ANalysis
getwd()
setwd("H:\\")

library(RTextTools)
library(e1071)
library(kernlab)
library(wordcloud)
library(caret)
library(SnowballC)
library(party)
library(FSelector)
library(rminer)


tickets <- read.csv("sentiment.csv", header=TRUE, stringsAsFactors=FALSE)




pos_tweets =  rbind(
  c('I love this car', 'positive'),
  c('This view is amazing', 'positive'),
  c('I feel great this morning', 'positive'),
  c('I am so excited about the concert', 'positive'),
  c('He is my best friend', 'positive')
)

neg_tweets = rbind(
  c('I do not like this car', 'negative'),
  c('This view is horrible', 'negative'),
  c('I feel tired this morning', 'negative'),
  c('I am not looking ford to the concert', 'negative'),
  c('He is my enemy', 'negative')
)

test_tweets = rbind(
  c('feel happy this morning', 'positive'),
  c('larry friend', 'positive'),
  c('not like that man', 'negative'),
  c('house not great', 'negative'),
  c('your song annoying', 'negative')
)

tweets = rbind(pos_tweets, neg_tweets, test_tweets)

tweets[,1]

# build dtm
matrix= create_matrix(tweets[,1], language="english", 
              removeStopwords=FALSE, removeNumbers=TRUE, 
              stemWords=FALSE) 

mat = as.matrix(matrix)
classifier = naiveBayes(mat[1:10,], as.factor(tweets[1:10,2]) )


# test the validity
predicted = predict(classifier, mat[11:15,]); predicted
table(tweets[11:15, 2], predicted)
recall_accuracy(tweets[11:15, 2], predicted)



# build the data to specify response variable, training set, testing set.
container = create_container(matrix, as.numeric(as.factor(tweets[,2])),
                             trainSize=1:10, testSize=11:15,virgin=FALSE)
#to train the model with multiple machine learning algorithms:
models = train_models(container, algorithms=c("MAXENT" , "SVM", "RF", "BAGGING", "TREE"))

results = classify_models(container, models)


# accuracy table
table(as.numeric(as.factor(tweets[11:15, 2])), results[,"FORESTS_LABEL"])
table(as.numeric(as.factor(tweets[11:15, 2])), results[,"MAXENTROPY_LABEL"])

# recall accuracy
recall_accuracy(as.numeric(as.factor(tweets[11:15, 2])), results[,"FORESTS_LABEL"])
recall_accuracy(as.numeric(as.factor(tweets[11:15, 2])), results[,"MAXENTROPY_LABEL"])
recall_accuracy(as.numeric(as.factor(tweets[11:15, 2])), results[,"TREE_LABEL"])
recall_accuracy(as.numeric(as.factor(tweets[11:15, 2])), results[,"BAGGING_LABEL"])
recall_accuracy(as.numeric(as.factor(tweets[11:15, 2])), results[,"SVM_LABEL"])


#to summarize the results (especially the validity) in a formal way:
  # model summary
analytics = create_analytics(container, results)
summary(analytics)
head(analytics@document_summary)
analytics@ensemble_summary

#To cross validate the results:
N=4
set.seed(2014)
cross_validate(container,N,"MAXENT")
cross_validate(container,N,"TREE")
cross_validate(container,N,"SVM")
cross_validate(container,N,"RF")



###################
"load data"
###################
setwd("H:\\")
happy = readLines("./happy.txt")
sad = readLines("./sad.txt")
happy_test = readLines("./happy_test.txt")
sad_test = readLines("./sad_test.txt")

tweet = c(happy, sad)
tweet_test= c(happy_test, sad_test)

head(tweet)
str(tweet)
head(tweet_test)
str(tweet_test)
tweet_all = c(tweet, tweet_test)

head(tweet_all)
str(tweet_all)

sentiment = c(rep("happy", length(happy) ), 
              rep("sad", length(sad)))

sentiment
sentiment_test = c(rep("happy", length(happy_test) ), 
                   rep("sad", length(sad_test)))
sentiment_test
sentiment_all = as.factor(c(sentiment, sentiment_test))



library(RTextTools)

#First, try naive Bayes.
# naive bayes
mat= create_matrix(tweet_all, language="english", 
                   removeStopwords=FALSE, removeNumbers=TRUE, 
                   stemWords=FALSE, tm::weightTfIdf)

mat = as.matrix(mat)

classifier = naiveBayes(mat[1:160,], as.factor(sentiment_all[1:160]))
predicted = predict(classifier, mat[161:180,]); predicted

table(sentiment_test, predicted)
recall_accuracy(sentiment_test, predicted)
#Then, try the other methods:
  # the other methods
  mat= create_matrix(tweet_all, language="english", 
                     removeStopwords=FALSE, removeNumbers=TRUE, 
                     stemWords=FALSE, tm::weightTfIdf)

container = create_container(mat, as.numeric(sentiment_all),
                             trainSize=1:160, testSize=161:180,virgin=FALSE) 

models = train_models(container, algorithms=c("MAXENT",
                                              "SVM",
                                              #"GLMNET", "BOOSTING", 
                                              "SLDA","BAGGING", 
                                              "RF", # "NNET", 
                                              "TREE" 
))

# test the model
results = classify_models(container, models)

table(as.numeric(as.numeric(sentiment_all[161:180])), results[,"FORESTS_LABEL"])
recall_accuracy(as.numeric(as.numeric(sentiment_all[161:180])), results[,"FORESTS_LABEL"])

# Here we also want to get the formal test results, including:
#   analytics@algorithm_summary: Summary of precision, recall, f-scores, and accuracy sorted by topic code for each algorithm
# analytics@label_summary: Summary of label (e.g. Topic) accuracy
# analytics@document_summary: Raw summary of all data and scoring
# analytics@ensemble_summary: Summary of ensemble precision/coverage. Uses the n variable passed into create_analytics()
# Now let's see the results:

# formal tests
analytics = create_analytics(container, results)
summary(analytics)

head(analytics@algorithm_summary)
head(analytics@label_summary)
head(analytics@document_summary)
analytics@ensemble_summary # Ensemble Agreement

# Cross Validation
N=3
cross_SVM = cross_validate(container,N,"SVM")
cross_GLMNET = cross_validate(container,N,"GLMNET")
cross_MAXENT = cross_validate(container,N,"MAXENT")




############TRying to categorise the data

setwd("H:\\")

wresult <- read.csv("Wireless_categorisation.csv", header=TRUE, stringsAsFactors=FALSE)

dim(wresult)
head(wresult)
wresult[c(4,5)]<-list(NULL)
head(wresult)
wresult$Result<-factor(wresult$Result)
wresult$Result
head(wresult[,3])


# build dtm
matrix= create_matrix(wresult[,3], language="english", 
                      removeStopwords=FALSE, removeNumbers=TRUE, 
                      stemWords=FALSE) 

inspect(matrix)

mat = as.matrix(matrix)
classifier = naiveBayes(mat[1:150,], as.factor(wresult[1:150,2]) )


# test the validity
predicted = predict(classifier, mat[151:198,]); predicted
table(wresult[151:198, 2], predicted)
recall_accuracy(wresult[151:198, 2], predicted)


# build the data to specify response variable, training set, testing set.
container = create_container(matrix, as.numeric(as.factor(wresult[,2])),
                             trainSize=1:150, testSize=151:198,virgin=FALSE)
#to train the model with multiple machine learning algorithms:
models = train_models(container, algorithms=c("BAGGING"))

results = classify_models(container, models)


# accuracy table
table(as.numeric(as.factor(tweets[151:198, 2])), results[,"BAGGING"])
table(as.numeric(as.factor(tweets[151:198, 2])), results[,"MAXENTROPY_LABEL"])

# recall accuracy
recall_accuracy(as.numeric(as.factor(tweets[151:198, 2])), results[,"BAGGING"])
recall_accuracy(as.numeric(as.factor(tweets[151:198, 2])), results[,"MAXENTROPY_LABEL"])
recall_accuracy(as.numeric(as.factor(tweets[151:198, 2])), results[,"TREE_LABEL"])
recall_accuracy(as.numeric(as.factor(tweets[151:198, 2])), results[,"BAGGING_LABEL"])
recall_accuracy(as.numeric(as.factor(tweets[151:198, 2])), results[,"SVM_LABEL"])




#######sentiment
#Sentiment ANalysis with LDA
getwd()
setwd("H:\\")

# library(help=randomforest)
# install.packages("rattle", repos="http://rattle.togaware.com", type="source")
# install.packages("wsrf", repos="http://rattle.togaware.com", type="source")
# install.packages("wsrpart", repos="http://rattle.togaware.com", type="source")
# install.packages("wskm", repos="http://rattle.togaware.com", type="source")


library(e1071)
library(kernlab)
library(wordcloud)
library(caret)
library(SnowballC)
library(party)
library(FSelector)
library(rminer)

library(lda)
library(RTextTools)
library(reshape2)
data(cora.documents)
inspect(cora.documents)
head(cora.vocab)
theme_set(theme_bw())
set.seed(8675309)
K <- 10 ## Num clusters
result <- lda.collapsed.gibbs.sampler(cora.documents,
                                      K, ## Num clusters
                                      cora.vocab,
                                      25, ## Num iterations
                                      0.1,
                                      0.1,
                                      compute.log.likelihood=TRUE)

top.words <- top.topic.words(result$topics, 5, by.score=TRUE)
top.words
N <- 10
topic.proportions <- t(result$document_sums) / colSums(result$document_sums)
topic.proportions <-
  topic.proportions[sample(1:dim(topic.proportions)[1], N),]
## Error in eval(expr, envir, enclos): object 'topic.proportions' not found
topic.proportions[is.na(topic.proportions)] <- 1 / K
## Error in topic.proportions[is.na(topic.proportions)] <- 1/K: object 'topic.proportions'not found
colnames(topic.proportions) <- apply(top.words, 2, paste, collapse=" ")
## Error in apply(top.words, 2, paste, collapse = " "): object 'top.words' not found
topic.proportions.df <- melt(cbind(data.frame(topic.proportions),
                                   document=factor(1:N)),
                             variable.name="topic",
                             id.vars = "document")
## Error in data.frame(topic.proportions): object 'topic.proportions' not found
ggplot(topic.proportions.df, aes(x=topic, y=value, fill=topic)) +
  geom_bar(stat="identity") +
  theme(axis.text.x = element_text(angle=45, hjust=1, size=7),
        legend.position="none") +
  coord_flip() +
  facet_wrap(~ document, ncol=5)




#intrain<-createDataPartition(y=usercomments_needed,p=0.50,list=FALSE)
#train<-usercomments_needed[intrain]
#testdata<-usercomments_needed[-intrain]

#intest<-createDataPartition(y=testdata,p=0.50,list=FALSE)

setwd("H:\\")
topics <- read.csv("topic_sentiment.csv", header=TRUE, stringsAsFactors=FALSE)

dim(topics)
head(topics)
str(topics)

#prepare corpus

library(tm)
topic_corpus<-Corpus(VectorSource(topics$comments))
rm(tm_corpus)

inspect(topic_corpus)

#clean corpus
topics_corpus<-tm_map(topic_corpus,Token_Tokenizer())
topic_corpus <- tm_map(topic_corpus, content_transformer(tolower))
#remove punctuation
topic_corpus <- tm_map(topic_corpus, removePunctuation)
# remove numbers
topic_corpus <- tm_map(topic_corpus, removeNumbers)
# remove stopwords from corpus
topic_corpus <- tm_map(topic_corpus, removeWords, stopwords("english"))
topic_corpus <- tm_map(topic_corpus, removeWords, stopwords("smart"))
# keep a copy of corpus to use later as a dictionary for stem completion
topic_corpusCopy <- topic_corpus
# stem words
topic_corpus <- tm_map(topic_corpus, stemDocument)
topic_corpus <- tm_map(topic_corpus, stripWhitespace)

# #TDM
# 
# tdm<-TermDocumentMatrix(topic_corpus)
# 
# inspect(tdm)
# 
# 
# #Remove sparse Terms
# topic.common<-removeSparseTerms(tdm,0.91)
# 
# inspect(topic.common)
# 
# tmatrix<-as.matrix(topic.common)



# # Convert the corpus to a data frame for mallet processing
# # Prepare for mallet

library(qdap)
documents <- as.data.frame(topic_corpus)
colnames(documents) <- c("id", "text")
dim(documents)
head(documents)

library(mallet)
mallet.instances <- mallet.import(documents$id, documents$text, "data/stoplist.csv", FALSE, token.regexp="[\\p{L}']+")

## Create a topic trainer object.
topic.model <- MalletLDA(num.topics=10)
topic.model$loadDocuments(mallet.instances)

vocabulary <- topic.model$getVocabulary()

#topics<-topic.model$

# examine some of the vocabulary
vocabulary

topic.model
?MalletLDA
word.freqs <- mallet.word.freqs(topic.model)
# examine some of the word frequencies:
head(word.freqs)
str(word.freqs)
word.freqs

topic.model$setAlphaOptimization(40,80)
topic.model$train(200)


topic.words.m <- mallet.topic.words(topic.model, smoothed=TRUE, normalized=TRUE)

# how big is the resulting matrix?
dim(topic.words.m)
head(topic.words.m)

# set the column names to make the matrix easier to read:
colnames(topic.words.m) <- vocabulary

str(vocabulary)
# examine a specific topic
topic.num <- 10 # the topic id you wish to examine
num.top.words<-5 # the number of top words in the topic you want to examine

mallet.top.words(topic.model, topic.words.m[topic.num,], num.top.words)

# Visualize topics as word clouds
# be sure you have installed the wordcloud package
library(wordcloud)
topic.num <- 5
num.top.words<-8
topic.top.words <- mallet.top.words(topic.model, topic.words.m[1,], 10)
wordcloud(topic.top.words$words, topic.top.words$weights, c(4,.8), rot.per=0, random.order=F)

num.topics<-10
num.top.words<-10
for(i in 1:num.topics){
  topic.top.words <- mallet.top.words(topic.model, topic.words.m[i,], num.top.words)
  wordcloud(topic.top.words$words, topic.top.words$weights, c(4,.8), rot.per=0, random.order=F)
}

# Great clouds, but can I save them to a single file?
# Yes. . . same loop as above, but open a graphic device first and use "print" to enclose calls to the wordcloud function. . . like this

pdf(file="my.clouds.pdf")
num.topics<-10
num.top.words<-25
for(i in 1:num.topics){
  topic.top.words <- mallet.top.words(topic.model, topic.words.m[i,], num.top.words)
  print(wordcloud(topic.top.words$words, topic.top.words$weights, c(4,.8), rot.per=0, random.order=F))
}
dev.off()


# Let's look at the mixture of topics in a single book. . . 
# call mallet.doc.topics to create a matrix
topics.by.document<-mallet.doc.topics(topic.model, normalized=TRUE, smoothed=TRUE)
# how big is the matrix
dim(topics.by.document)
str(topics.by.document)
# set the labels for the rows using the doc ids
rownames(topics.by.document)<-documents$id
# set the colnames to the topic id number
colnames(topics.by.document)<-1:10
# pick a document that you are interested in
my.doc<-"10"
# sort and plot the topics in "my.doc" by their decreasing weight
barplot(sort(topics.by.document[my.doc,], decreasing=T))

########
############
######



########TOpic Modelling





############################################################
# Word Frequency
############################################################
setwd("H:\\\\data")
# First with Moby Dick
text.v <- scan("melville.txt", what="character", sep = "\n")
str(text.v)

start.v<-408
end.v<-18576

# start.metadata.v <- text.v[1:start.v -1]
# end.metadata.v <- text.v[(end.v+1):length(text.v)]
# metadata.v <- c(start.metadata.v, end.metadata.v)
novel.lines.v <-  text.v[start.v:end.v]
length(novel.lines.v)

novel.v <- paste(novel.lines.v, collapse=" ")
novel.lower.v <- tolower(novel.v)
moby.words.l <- strsplit(novel.lower.v, "\\W")

moby.word.v <- unlist(moby.words.l)
not.blanks.v  <-  which(moby.word.v!="")
moby.word.v <-  moby.word.v[not.blanks.v]
moby.freqs.t <- table(moby.word.v)

moby.freqs.t
sorted.moby.freqs.t <- sort(moby.freqs.t , decreasing=TRUE)
sorted.moby.rel.freqs.t <- 100*(sorted.moby.freqs.t/sum(sorted.moby.freqs.t))
plot(sorted.moby.rel.freqs.t[1:10], 
     main="Moby Dick", 
     type="b", 
     xlab="Top Ten Words", 
     ylab="Percentage",
     xaxt = "n")
axis(1,1:10, labels=names(sorted.moby.rel.freqs.t[1:10]))

############################################################
# Accessing and Comparing Word Frequency Data
############################################################

# Now with Jane Austen
text.v <- scan("austen.txt", what="character", sep="\n")
start.v <- which(text.v == "CHAPTER 1")
end.v <- which(text.v == "THE END")
novel.lines.v <-  text.v[start.v:end.v]
novel.v <- paste(novel.lines.v, collapse=" ")
novel.lower.v <- tolower(novel.v)
sense.words.l <- strsplit(novel.lower.v, "\\W")
sense.word.v <- unlist(sense.words.l)
not.blanks.v  <-  which(sense.word.v!="")
sense.word.v <-  sense.word.v[not.blanks.v]
sense.freqs.t <- table(sense.word.v)
sorted.sense.freqs.t <- sort(sense.freqs.t , decreasing=T)
sorted.sense.rel.freqs.t <- 100* (sorted.sense.freqs.t/sum(sorted.sense.freqs.t))
plot(sorted.sense.rel.freqs.t[1:10], 
     main="Sense and Sensibility", type="b", 
     xlab="Top Ten Words", ylab="Percentage",xaxt = "n")
axis(1,1:10, labels=names(sorted.sense.rel.freqs.t[1:10]))

############################################################
# And now some Comparison
############################################################

unique(c(names(sorted.moby.rel.freqs.t[1:10]), names(sorted.sense.rel.freqs.t[1:10])))

names(sorted.sense.rel.freqs.t[which(names(sorted.sense.rel.freqs.t[1:10]) %in% names(sorted.moby.rel.freqs.t[1:10]))])

presentSense <- which(names(sorted.sense.rel.freqs.t[1:10]) %in% names(sorted.moby.rel.freqs.t[1:10]))

names(sorted.sense.rel.freqs.t[1:10])[-presentSense]

presentMoby <- which(names(sorted.moby.rel.freqs.t[1:10]) %in% names(sorted.sense.rel.freqs.t[1:10]))

names(sorted.moby.rel.freqs.t[1:10])[-presentMoby]

############################################################
# Token Distribution Analysis and Dispersion Plots
############################################################
str(moby.word.v)

n.time.v <- seq(1:length(moby.word.v))

whales.v <- which(moby.word.v == "whale") 
whales.v
w.count.v <- rep(NA,length(n.time.v))
w.count.v
w.count.v[whales.v] <- 1

plot(w.count.v, main="Dispersion Plot of `whale' in Moby Dick", xlab="Novel Time", ylab="whale", type="h", ylim=c(0,1), yaxt='n')

ahabs.v <- which(moby.word.v == "ahab") # find `ahab'
a.count.v <- rep(NA,length(n.time.v)) 
# change prefix `w' to `a' to keep whales and ahabs in separate variables
a.count.v[ahabs.v] <- 1 # mark the occurrences with a 1
plot(a.count.v, main="Dispersion Plot of 'ahab' in Moby Dick", xlab="Novel Time", ylab="ahab", type="h", ylim=c(0,1), yaxt='n')

############################################################
# Token Distribution Analysis and Dispersion Plots 
# (Using Grep to find Chapter Breaks)
############################################################
text.v <- scan("melville.txt", what="character", sep="\n")
start.v <- which(text.v == "CHAPTER 1. Loomings.")
end.v <- which(text.v == "orphan.")
novel.lines.v <-  text.v[start.v:end.v]
chap.positions.v <- grep("^CHAPTER \\d", novel.lines.v)
novel.lines.v <- c(novel.lines.v, "END")
last.position.v <-  length(novel.lines.v)
chap.positions.v  <-  c(chap.positions.v , last.position.v)

# Two empty lists
chapter.raws.l <- list()
chapter.freqs.l <- list()

# A for loop
for(i in 1:length(chap.positions.v)){
  if(i != length(chap.positions.v)){
    chapter.title <- novel.lines.v[chap.positions.v[i]]
    start <- chap.positions.v[i]+1
    end <- chap.positions.v[i+1]-1
    chapter.lines.v <- novel.lines.v[start:end]
    chapter.words.v <- tolower(paste(chapter.lines.v, collapse=" "))
    chapter.words.l <- strsplit(chapter.words.v, "\\W")
    chapter.word.v <- unlist(chapter.words.l)
    chapter.word.v <- chapter.word.v[which(chapter.word.v!="")] 
    chapter.freqs.t <- table(chapter.word.v)
    chapter.raws.l[[chapter.title]] <-  chapter.freqs.t
    chapter.freqs.t.rel <- 100*(chapter.freqs.t/sum(chapter.freqs.t))
    chapter.freqs.l[[chapter.title]] <- chapter.freqs.t.rel
  }
}

whale.l <- lapply(chapter.freqs.l, '[', 'whale')
whales.m <- do.call(rbind, whale.l)

ahab.l <- lapply(chapter.freqs.l, '[', 'ahab')
ahabs.m <- do.call(rbind, ahab.l)

whales.v <- whales.m[,1]
ahabs.v <- ahabs.m[,1]

whales.ahabs.m <- cbind(whales.v, ahabs.v)
dim(whales.ahabs.m)

colnames(whales.ahabs.m) <- c("whale", "ahab")

barplot(whales.ahabs.m, beside=T, col="grey")
############################################################
############################################################
setwd("H:\\")
# Prelims
inputDir <- "data"
files.v <- dir(path=inputDir, pattern="*\\.txt")
chunk.size <- 1000 # number of words per chunk

# Text Chunking Function
makeFlexTextChunks <- function(inputDir, file.name, chunk.size=1000){
  text.file.path<-file.path(inputDir, file.name)
  text.lines.v <- scan(text.file.path, what="character", sep="\n")
  novel.v <- paste(text.lines.v, collapse=" ")
  novel.lower.v <- tolower(novel.v)
  novel.lower.l <- strsplit(novel.lower.v, "\\W")
  novel.word.v <- unlist(novel.lower.l)
  not.blanks.v  <-  which(novel.word.v!="")
  novel.word.v <-  novel.word.v[not.blanks.v]
  x <- seq_along(novel.word.v)
  chunks.l <- split(novel.word.v, ceiling(x/chunk.size))
  # deal with small chunks at the end
  if(length(chunks.l[[length(chunks.l)]]) <= chunk.size/2){
    chunks.l[[length(chunks.l)-1]] <- c(chunks.l[[length(chunks.l)-1]], 
                                        chunks.l[[length(chunks.l)]])
    chunks.l[[length(chunks.l)]] <- NULL
  }
  chunks.l <- lapply(chunks.l, paste, collapse=" ")
  chunks.df <- do.call(rbind, chunks.l)
  return(chunks.df)
}

# Loop for chunking each text in the corpus directory
topic.l <- NULL
for(i in 1:length(files.v)){
  chunk.m <- makeFlexTextChunks(inputDir, files.v[i], chunk.size)
  textname <- gsub("\\..*","", files.v[i])
  segments.m <- cbind(paste(textname, segment=1:nrow(chunk.m), sep="_"), chunk.m)
  topic.l[[textname]] <- segments.m
}
topic.m <- do.call(rbind, topic.l)

dim(topic.m)

# Convert the matrix to a data frame for mallet processing
# Prepare for mallet
documents <- as.data.frame(topic.m, stringsAsFactors=F)
colnames(documents) <- c("id", "text")
dim(documents)

# Load and run Mallet
library(mallet)
mallet.instances <- mallet.import(documents$id, documents$text, "data/stoplist.csv", FALSE, token.regexp="[\\p{L}']+")

## Create a topic trainer object.
topic.model <- MalletLDA(num.topics=43)
topic.model$loadDocuments(mallet.instances)
vocabulary <- topic.model$getVocabulary()

# examine some of the vocabulary
vocabulary[1:50]

word.freqs <- mallet.word.freqs(topic.model)
# examine some of the word frequencies:
head(word.freqs)

topic.model$setAlphaOptimization(40, 80)
topic.model$train(400)

topic.words.m <- mallet.topic.words(topic.model, smoothed=TRUE, normalized=TRUE)

# how big is the resulting matrix?
dim(topic.words.m)

# set the column names to make the matrix easier to read:
colnames(topic.words.m) <- vocabulary

# examine a specific topic
topic.num <- 1 # the topic id you wish to examine
num.top.words<-10 # the number of top words in the topic you want to examine

mallet.top.words(topic.model, topic.words.m[topic.num,], num.top.words)

# Visualize topics as word clouds
# be sure you have installed the wordcloud package
library(wordcloud)
topic.num <- 1
num.top.words<-100
topic.top.words <- mallet.top.words(topic.model, topic.words.m[1,], 100)
wordcloud(topic.top.words$words, topic.top.words$weights, c(4,.8), rot.per=0, random.order=F)

num.topics<-43
num.top.words<-25
for(i in 1:num.topics){
  topic.top.words <- mallet.top.words(topic.model, topic.words.m[i,], num.top.words)
  wordcloud(topic.top.words$words, topic.top.words$weights, c(4,.8), rot.per=0, random.order=F)
}

# Great clouds, but can I save them to a single file?
# Yes. . . same loop as above, but open a graphic device first and use "print" to enclose calls to the wordcloud function. . . like this

pdf(file="my.clouds.pdf")
num.topics<-43
num.top.words<-25
for(i in 1:num.topics){
  topic.top.words <- mallet.top.words(topic.model, topic.words.m[i,], num.top.words)
  print(wordcloud(topic.top.words$words, topic.top.words$weights, c(4,.8), rot.per=0, random.order=F))
}
dev.off()


# Let's look at the mixture of topics in a single book. . . 
# call mallet.doc.topics to create a matrix
topics.by.document<-mallet.doc.topics(topic.model, normalized=TRUE, smoothed=TRUE)
# how big is the matrix
dim(topics.by.document)
# set the labels for the rows using the doc ids
rownames(topics.by.document)<-documents$id
# set the colnames to the topic id number
colnames(topics.by.document)<-1:43
# pick a document that you are interested in
my.doc<-"1008_1"
# sort and plot the topics in "my.doc" by their decreasing weight
barplot(sort(topics.by.document[my.doc,], decreasing=T))





#########Annotations


setwd("H:/")
bio <- readLines("entity_id.txt")
print(bio)
library(magrittr)
library(tm)
library(NLP)
library(openNLP)
library(openNLPmodels.en)
options(java.parameters = "-Xmx1g" )

# making in string
bio<-as.String(bio)


#creating annotations and sentences
# we need to create annotators for words and sentences
# Annotators are created by functions which load the underlying Java libraries.
# These functions then mark the places in the string where words and sentences start and end.
# The annotation functions are themselves created by functions.

word_ann <- Maxent_Word_Token_Annotator()
sent_ann <- Maxent_Sent_Token_Annotator()

# These annotators form a "pipeline" for annotating the text in our bio variable.
# First we have to determine where the sentences are,
# then we can determine where the words are.
# We can apply these annotator functions to our data using the annotate() function.
bio_annotations <- annotate(bio,list(sent_ann,word_ann))
class(bio_annotations)
head(bio_annotations)
# We can combine the biography and the annotations to create what the NLP package calls an AnnotatedPlainTextDocument. If we wishd we could also associate metadata with the object using the meta = argument.
bio_doc <- AnnotatedPlainTextDocument(bio, bio_annotations)
#Now we can extract information from our document using accessor functions like sents() to get the sentences and words() to get the words. We could get just the plain text with as.character(bio_doc).
sents(bio_doc) %>% head(2)
words(bio_doc) %>% head(10)
# Annotating people and places
#Creating Entities
library(openNLPmodels.en)
person_ann <- Maxent_Entity_Annotator(kind = "person")
location_ann <- Maxent_Entity_Annotator(kind = "location")
organization_ann <- Maxent_Entity_Annotator(kind = "organization")
# date_ann<-Maxent_Entity_Annotator(kind = "year")
# time_ann<-Maxent_Entity_Annotator(kind = "time")
# money_ann<-Maxent_Entity_Annotator(kind = "money")
# distance_ann<-Maxent_Entity_Annotator(kind = "distance")
# speed_ann<-Maxent_Entity_Annotator(kind = "speed")
# age_ann<-Maxent_Entity_Annotator(kind = "age")
# weight_ann<-Maxent_Entity_Annotator(kind = "weight")
# rivers_ann<-Maxent_Entity_Annotator(kind = "river")
# we earlier passed a list of annotator functions to the annotate() function to indicate which kinds of annotations we wanted to make. We will create a new pipeline list to hold our annotators in the order we want to apply them, then apply it to the bio variable. Then, as before, we can create an AnnotatedPlainTextDocument.
pipeline <- list(sent_ann,
                 word_ann,
                 person_ann,
                 location_ann,
                 organization_ann)
#apply on bio
bio_annotations <- annotate(bio, pipeline)
bio_doc <- AnnotatedPlainTextDocument(bio, bio_annotations)
# Extract entities from an AnnotatedPlainTextDocument
#we could extract words and sentences using the getter methods words() and sents(). 
entities <- function(doc, kind) {
  s <- doc$content
  a <- annotations(doc)[[1]]
  if(hasArg(kind)) {
    k <- sapply(a$features, `[[`, "kind")
    s[a[k == kind]]
  } else {
    s[a[a$type == "entity"]]
  }
}
??annotations
#Now we can extract all of the named entities using entities(bio_doc), and specific kinds of entities using the kind = argument. Let's get all the people, places, and organizations.
entities(bio_doc, kind = "person")
entities(bio_doc, kind = "location")


## Lexical,Semantic parsing
s <- paste(c("Pierre Vinken, 61 years old, will join the board as a ",
             "nonexecutive director Nov. 29.\n",
             "Mr. Vinken is chairman of Elsevier N.V., ",
             "the Dutch publishing group."),
           collapse = "")
s <- as.String(s)

## Need sentence and word token annotations.
sent_token_annotator <- Maxent_Sent_Token_Annotator()
word_token_annotator <- Maxent_Word_Token_Annotator()
a2 <- annotate(s, list(sent_token_annotator, word_token_annotator))
parse_annotator <- Parse_Annotator()
## Compute the parse annotations only.
p <- parse_annotator(s, a2)
## Extract the formatted parse trees.
ptexts <- sapply(p$features, `[[`, "parse")
ptexts
## Read into NLP Tree objects.
ptrees <- lapply(ptexts, Tree_parse)
ptrees

str(ptexts)


??Tree_parse

a1 <- annotate(s, sent_token_annotator)
word_token_annotator <- Maxent_Word_Token_Annotator()
word_token_annotator
a2 <- annotate(s, word_token_annotator, a1)
a2
## Variant with word token probabilities as features.
head(annotate(s, Maxent_Word_Token_Annotator(probs = TRUE), a1))
## Can also perform sentence and word token annotations in a pipeline:
a <- annotate(s, list(sent_token_annotator, word_token_annotator))
head(a)



#POS TAG ANNOTATOR

pos_tag_annotator <- Maxent_POS_Tag_Annotator()
pos_tag_annotator
a3 <- annotate(s, pos_tag_annotator, a2)
a3
## Variant with POS tag probabilities as (additional) features.
head(annotate(s, Maxent_POS_Tag_Annotator(probs = TRUE), a2))



## Determine the distribution of POS tags for word tokens.
a3w <- subset(a3, type == "word")
tags <- sapply(a3w$features, `[[`, "POS")
tags
table(tags)
## Extract token/POS pairs (all of them): easy.
sprintf("%s/%s", s[a3w], tags)
## Extract pairs of word tokens and POS tags for second sentence:
a3ws2 <- annotations_in_spans(subset(a3, type == "word"),
                              subset(a3, type == "sentence")[2L])[[1L]]
sprintf("%s/%s", s[a3ws2], sapply(a3ws2$features, `[[`, "POS"))

typeof(ptrees)


library(plyr)
library(class)
??parse_annotator

head(p)

head(ptrees)


x <- Tree(1, list(2, Tree(3, list(4)), 5))
format(x)
x$value
x$children

p <- Tree("VP",
          list(Tree("V",
                    list("saw")),
               Tree("NP",
                    list("him"))))
p <- Tree("S",
          list(Tree("NP",
                    list("I")),
               p))
p
## Force nested indented bracketting:
print(p, width = 10)

s <- "(S (NP I) (VP (V saw) (NP him)))"
p <- Tree_parse(s)
p

## Extract the leaves by recursively traversing the children and
## recording the non-tree ones:
Tree_leaf_gatherer <-
  function()
  {
    v <- list()
    list(update =
           function(e) if(!inherits(e, "Tree")) v <<- c(v, list(e)),
         value = function() v,
         reset = function() { v <<- list() })
  }
g <- Tree_leaf_gatherer()
y <- Tree_apply(p, g$update, recursive = TRUE)
g$value()




















