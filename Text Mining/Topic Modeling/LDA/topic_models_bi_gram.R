
getwd()
setwd("H:\\LDA")

library(dplyr)
library(RWeka)  
library(wordcloud)
library(slam)
library(tm)
library(topicmodels)
library(dplyr)
library(ggplot2)
library(server)

#(k <- optimal_k(dtm.new, 40, control = control))
topicmodels2LDAvis <- function(x, ...){
  post <- topicmodels::posterior(x)
  if (ncol(post[["topics"]]) < 3) stop("The model must contain > 2 topics")
  mat <- x@wordassignments
  LDAvis::createJSON(
    phi = post[["terms"]], 
    theta = post[["topics"]],
    vocab = colnames(post[["terms"]]),
    doc.length = slam::row_sums(mat, na.rm = TRUE),
    term.frequency = slam::col_sums(mat, na.rm = TRUE)
  )
}
k<-5


#Import user comments file
usercomments<- read.csv("ChatConcepts.csv", header=TRUE, stringsAsFactors=FALSE,nrow=1000)


#Prepare Corpus

usercorpus<-Corpus(VectorSource(usercomments$Chat.Concat))
usercorpus <- tm_map(usercorpus, content_transformer(tolower))
#remove punctuation
usercorpus <- tm_map(usercorpus, removePunctuation)
# remove numbers
usercorpus <- tm_map(usercorpus, removeNumbers)
#usercorpus <- tm_map(usercorpus, removeWords, stopwords("english"))
#usercorpus <- tm_map(usercorpus, removeWords, stopwords("smart"))
# keep a copy of corpus to use later as a dictionary for stem completion
usercorpusCopy <- usercorpus
usercorpus <- tm_map(usercorpus, stemDocument)
usercorpus <- tm_map(usercorpus, stripWhitespace)
#usercorpus <- tm_map(usercorpus,removeWords,c(stop_vec))



#Tokenizer for n-grams and passed on to the term-document matrix constructor
BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))

#txtTdmBi.01<-TermDocumentMatrix(topic1_corpus, control = list(tokenize = BigramTokenizer))

#Create document-term matrix
dtm <- DocumentTermMatrix(usercorpus,control = list(tokenize = BigramTokenizer))


#Remove the docs with empty terms
rowTotals <- apply(dtm , 1, sum) #Find the sum of words in each Document
dtm.new   <- dtm[rowTotals>0, ]           #remove all docs without words

#To know what comments are having Zero Terms
dtm.new.x   <- dtm[rowTotals==0, ]           #remove all docs without words
#docs_to_be_removed<-as.data.frame(dtm.new.x)

#Remove sparse terms
dtm.common<-removeSparseTerms(dtm.new,0.99)


#Set parameters for Gibbs sampling
burnin <- 4000
iter <- 2000
thin <- 500
seed <-list(2003,5,63,100001,765)
nstart <- 5
best <- TRUE

control <- list(burnin = 500, iter = 1000, keep = 100)

#To find Number of topics

#Run LDA using Gibbs sampling
ldaOut <-LDA(dtm.new,k, method="Gibbs", control=list(nstart=nstart, seed = seed, best=best, burnin = burnin, iter = iter, thin=thin))




#View LDAVIS
ldaOut %>%
  topicmodels2LDAvis() %>%
  LDAvis::serVis()




#write out results
#docs to topics
ldaOut.topics <- as.matrix(topics(ldaOut))

##Topic to data frame
ldaOut.topics.df<-as.data.frame(ldaOut.topics)

#add row names to data frame
ldaOut.topics.df[,"Commsss"]<-rownames((ldaOut.topics.df))

#merge with Original data
usercomments_new_with_topic = merge(ldaOut.topics.df,usercomments,all.x = TRUE,by.x = "Commsss", by.y = "comments")

ldaOut.topics.df[,"Comments_real"]<-usercomments_new_with_topic$Social.Comments
write.csv(ldaOut.topics.df,file=paste("LDAGibbs",k,"DocsToTopics.csv"))


#top 10 terms in each topic
ldaOut.terms <- as.matrix(terms(ldaOut,10))
write.csv(ldaOut.terms,file=paste("LDAGibbs",k,"TopicsToTerms.csv"))


#probabilities associated with each topic assignment
topicProbabilities <- as.data.frame(ldaOut@gamma)
write.csv(topicProbabilities,file=paste("LDAGibbs",k,"TopicProbabilities.csv"))





#Tokenizer for n-grams and passed on to the term-document matrix constructor
BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 5))

txtTdmBi.01<-TermDocumentMatrix(topic1_corpus, control = list(tokenize = BigramTokenizer))
sparse.01 <- removeSparseTerms(txtTdmBi.01, 0.999)
dim(sparse.01)

tdm.matrix.01 <- as.matrix(sparse.01)
tdm.matrix.01[tdm.matrix.01>1] <- 1

#m <- as.matrix(dtmsrep) # calculate the frequency of words 
v.01 <- sort(rowSums(tdm.matrix.01), decreasing=TRUE) 
myNames.01 <- names(v.01) 
d.01 <- data.frame(word=myNames.01, freq=v.01) 

head(d.01,5)