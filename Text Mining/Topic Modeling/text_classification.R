rm(list=ls())


#install.packages("tm")
#install.packages("RTextTools")

library(tm)
library(RTextTools)

setwd("D:\\Transcripts")
getwd()
data = read.csv("Book1.csv",  # File path
                sep = ',',                               # Delimiter
                stringsAsFactors = F,                     # String as text
                quote = "",                               # disable quoting altogether
                header = F) 

#data$sentiment <- 1
colnames(data) = c('sentiment','text')                    # Rename variables
head(data)                                                # View few rows

set.seed(2604)                          # To fix the sample 
samp_id = sample(1:nrow(data),
                 round(nrow(data)*.70),     # 70% records will be used for training
                 replace = F)
train = data[samp_id,]                      # 70% of training data set
test = data[-samp_id,]                      # remaining 30% of training data set

dim(test) ; dim(train)



train.data = rbind(train,test)              # join two data sets
train.data$text = tolower(train.data$text)  # Convert to lower case

text = train.data$text                      
text = removePunctuation(text)              # remove punctuation marks
text = removeNumbers(text)                  # remove numbers
text = stripWhitespace(text)                # remove blank space
cor = Corpus(VectorSource(text))            # Create text corpus
inspect(cor[1:5])
####################################################################################################################
#stop word removal
words_list<-read.table("remove_dict.txt",header = FALSE)
colnames(words_list)<-"Words"
rm_words_list<-as.vector(words_list$Words)
cor1 = tm_map(cor,removeWords,c(rm_words_list))
cor1= tm_map(cor1,stripWhitespace)
cor= tm_map(cor, PlainTextDocument)
inspect(cor1[1:5])

#************************************************************************************************************************


dtm = DocumentTermMatrix(cor, control = list(weighting =             # Create DTM
                                               function(x)
                                                 weightTfIdf(x, normalize = T)))
dtm1 = DocumentTermMatrix(cor1)

str(dtm1)
str(dtm)
??slam

inspect(dtm1[1:10,1:10])
term_tfidf <- tapply(dtm1$v/slam::row_sums(dtm1)[dtm1$i], dtm1$j, mean) * log2(tm::nDocs(dtm1)/slam::col_sums(dtm1 > 0))
term_tfidf1 <- tapply(dtm$v/slam::row_sums(dtm)[dtm1$i], dtm1$j, mean) * log2(tm::nDocs(dtm)/slam::col_sums(dtm > 0))

summary(term_tfidf)

## Keeping the rows with tfidf >= to the 0.2480
llisreduced.dtm <- dtm1[,term_tfidf >= 0.2480]
summary(slam::col_sums(llisreduced.dtm))

#Find the sum of words in each Document
rowTotals <- apply(llisreduced.dtm , 1, sum)
head(rowTotals)
llisreduced1.dtm   <- llisreduced.dtm[rowTotals> 0, ]
inspect(llisreduced1.dtm[1:5])

trainmodel <-LDA(llisreduced1.dtm, 3, method = "Gibbs", control = list(iter=2000, seed = 0622))
llis.terms <- as.data.frame(topicmodels::terms(trainmodel, 10), stringsAsFactors = FALSE)
head
##############################################################################################################################
install.packages("topicmodels")
library(topicmodels)

#Apply LDA
burnin <- 4000
iter <- 1000
thin <- 500
seed <-list(2003,5,63,100001,765)
nstart <- 5
best <- TRUE

#Number of topics
k <- 3


#Run LDA using Gibbs sampling
trainmodel <-LDA(llisreduced.dtm,k, method="Gibbs", control=list(nstart=nstart, seed = seed, best=best, burnin = burnin, iter = iter, thin=thin, weighting=weightTfIdf(normalize = T)))

training_codes = train.data$sentiment       # Coded labels
dim(dtm)

#Algorithm Selection

container <- create_container(dtm,t(training_codes),trainSize=1:nrow(train), testSize=(nrow(train)+1):nrow(train.data),virgin=FALSE)
#write.csv(as.matrix(container),file="container.csv")
# Run all algorithms and create analytics

models <- train_models(container, algorithms=c("MAXENT","SVM","TREE","RF")) #"MAXENT","SVM","GLMNET","SLDA","TREE","BAGGING","BOOSTING","RF"

results <- classify_models(container, models)

##########################################
# VIEW THE RESULTS BY CREATING ANALYTICS #
##########################################
analytics <- create_analytics(container, results)

# RESULTS WILL BE REPORTED BACK IN THE analytics VARIABLE.
# analytics@algorithm_summary: SUMMARY OF PRECISION, RECALL, F-SCORES, AND ACCURACY SORTED BY TOPIC CODE FOR EACH ALGORITHM
# analytics@label_summary: SUMMARY OF LABEL (e.g. TOPIC) ACCURACY
# analytics@document_summary: RAW SUMMARY OF ALL DATA AND SCORING
# analytics@ensemble_summary: SUMMARY OF ENSEMBLE PRECISION/COVERAGE. USES THE n VARIABLE PASSED INTO create_analytics()

head(analytics@algorithm_summary)


# Just check the accuracy of each algorithm
#tree algorithm -> 71.54%
models <- train_models(container, algorithms=c("TREE")) #"MAXENT","SVM","GLMNET","SLDA","TREE","BAGGING","BOOSTING","RF"
results <- classify_models(container, models)
head(results)

out = data.frame(model_sentiment = results$TREE_LABEL,
                 model_prob = results$TREE_PROB,
                 actual_sentiment = train.data$sentiment[(nrow(train)+1):nrow(train.data)])

(z = as.matrix(table(out[,1],out[,3])))

(pct = round(((z[1,1]+z[2,2])/sum(z))*100,2))

#Maxent algorithm -> 75.61%
models <- train_models(container, algorithms=c("MAXENT")) #"MAXENT","SVM","GLMNET","SLDA","TREE","BAGGING","BOOSTING","RF"
results <- classify_models(container, models)
head(results)

out = data.frame(model_sentiment = results$MAXENTROPY_LABEL,
                 model_prob = results$MAXENTROPY_PROB,
                 actual_sentiment = train.data$sentiment[(nrow(train)+1):nrow(train.data)])

(z = as.matrix(table(out[,1],out[,3])))

(pct = round(((z[1,1]+z[2,2])/sum(z))*100,2))

#SVM algorithm -> 75.61%
models <- train_models(container, algorithms=c("SVM")) #"MAXENT","SVM","GLMNET","SLDA","TREE","BAGGING","BOOSTING","RF"
results <- classify_models(container, models)
head(results)

out = data.frame(model_sentiment = results$SVM_LABEL,
                 model_prob = results$SVM_PROB,
                 actual_sentiment = train.data$sentiment[(nrow(train)+1):nrow(train.data)])

(z = as.matrix(table(out[,1],out[,3])))


(pct = round(((z[1,1]+z[2,2])/sum(z))*100,2))

#RF algorithm -> 75.61%
models <- train_models(container, algorithms=c("RF")) #"MAXENT","SVM","GLMNET","SLDA","TREE","BAGGING","BOOSTING","RF"
results <- classify_models(container, models)
head(results)

out = data.frame(model_sentiment = results$FORESTS_LABEL,
                 model_prob = results$FORESTS_PROB,
                 actual_sentiment = train.data$sentiment[(nrow(train)+1):nrow(train.data)])

(z = as.matrix(table(out[,1],out[,3])))


(pct = round(((z[1,1]+z[2,2])/sum(z))*100,2))


#check the testing dataset

data.test = read.csv("Book2.csv",  # File path
                sep = ',',                               # Delimiter
                stringsAsFactors = F,                     # String as text
                quote = "",                               # disable quoting altogether
                header = F)
colnames(data.test) = 'text'
data.test1 = data.test

text = data.test1$text
text = removePunctuation(text)
text = removeNumbers(text)
text = stripWhitespace(text)
cor = Corpus(VectorSource(text))
dtm.test = DocumentTermMatrix(cor, control = list(weighting = 
                                                    function(x)
                                                      weightTfIdf(x, normalize =
                                                                    F)))

row.names(dtm.test) = (nrow(dtm)+1):(nrow(dtm)+nrow(dtm.test))
dtm.f = c(dtm,dtm.test)
training_codes.f = c(training_codes,rep(NA,length(data.test1)))

container.f = create_container(dtm.f,t(training_codes.f),trainSize=1:nrow(dtm), testSize = (nrow(dtm)+1):(nrow(dtm)+nrow(dtm.test)), virgin = F)
model.f = train_models(container.f, algorithms=c("SVM")) 
predicted <- classify_models(container.f, model.f)

out = data.frame(model_sentiment = predicted$SVM_LABEL,
                 model_prob = predicted$SVM_PROB,
                 text = data.test1)

head(out,20)

(z = as.matrix(table(out$model_sentiment,out$text)))

write.csv(z,file="final.csv")

(pct = round(((z[1,1]+z[2,2])/sum(z))*100,2))
