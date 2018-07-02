#Cosine Similarity

getwd()
setwd("\Cosine Similarity")

#install.packages("lsa")
library(lsa)

#R Example
d1 <- c(1, -2)
d2 <- c(1, 1)

cosine(d1, d2)
# -0.3162278

#Example
d1 <- 1:10
d2 <- 11:20

cosine(d1, d2)
#0.9559123

#R Example
S1 <- "Julie loves me more than Linda loves me"
S2 <- "Jane likes me more than Julie loves me"

#Document term Matrix
# me   2   2
# Jane   0   1
# Julie   1   1
# Linda   1   0
# likes   0   1
# loves   2   1
# more   1   1
# than   1   1

#Vectors
v1 <- c(2, 1, 0, 2, 0, 1, 1, 1)
v2 <- c(2, 1, 1, 1, 1, 0, 1, 1)

cosine(v1, v2)
#0.8215838

#Text Similarity

#install.packages("tm")
#update.packages("tm")
library(tm)

#######################           Data Import      ##############################

#Read txt articles from directory
FilePath <- system.file("texts", "txt", package = "tm")

##that means we will get the files(text files) in txt folder
#which is subfolder of texts and texts are in package tm.

(TextFiles <- Corpus(
    DirSource(FilePath),
    readerControl = list(
        reader = readPlain,
        language = "en",
        load = TRUE
    )
))

#In the code above us, we got the text files all in the TextFiles
#readerControl is a function which is used for define attributes of texts
#files such as define language, which type does the text files have etc.
#So the texts files are hold by TextFiles

#getReaders()  - All Available Readers in tm package

#Read files from current working directory
#dir()
#DirSource()

#Read only text files
# Files <- dir()
# Files <- Files[grep('\\.txt$', Files)]

#######################           Data Export      ##############################
writeCorpus(TextFiles)

#######################     Inspecting Corpora     ##############################

# print ()
# summary ()
# inspect ()

print(TextFiles)
print(TextFiles[1])

summary(TextFiles)
summary(TextFiles[1])

inspect(TextFiles)
inspect(TextFiles[1])

TextFiles[[1]]$content
as.character(TextFiles[[1]])
lapply(TextFiles[1:2], as.character)

#######################     Transformations     ##############################

#Replace all non letters with space
#/[^a-zA-Z]+/g

toSpace <-
    content_transformer(function(x, pattern)
        gsub(pattern = pattern, " ", x))

TextFiles <- tm_map(x = TextFiles, FUN = toSpace, "[^a-zA-Z]+")
lapply(TextFiles[1:2], as.character)

#Remove Numbers
#TextFiles <- tm_map(TextFiles, removeNumbers)

#Remove Punctuation
#TextFiles <- tm_map(TextFiles, removePunctuation)

#Convert to Lower
TextFiles <- tm_map(TextFiles, content_transformer(tolower)) 
lapply(TextFiles[1:2], as.character)

#stemDocument - root words
TextFiles <- tm_map(TextFiles, stemDocument)

#Remove Stopwords- english
TextFiles <- tm_map(TextFiles, removeWords, stopwords("english"))

#Remove Stopwords- smart
TextFiles <- tm_map(TextFiles, removeWords, stopwords("SMART"))

# remove Whitespace in the texts
TextFiles <- tm_map(TextFiles, stripWhitespace) 
lapply(TextFiles[1:2], as.character)

#New Stop Words
newStopwords <- c("Hello", "Hi", "Jessica", "Cosine", "Similarity",
                  "Vector", "etc.")

#Remove New Stop Words
TextFiles <- tm_map(TextFiles, removeWords, newStopwords)

#Plain Text Document
TextFiles <- tm_map(TextFiles, PlainTextDocument)
lapply(TextFiles[1:2], as.character)

#Replace words
ConverttoString <- content_transformer(function(x, from, to) gsub(from, to,x))

TextFiles <- tm_map(TextFiles, ConverttoString, "pass", "transfer")
TextFiles <- tm_map(TextFiles, ConverttoString, "xfer", "tra")

#######################     Evaluations (Methods)     ##############################

tdm <-
    TermDocumentMatrix(
        TextFiles,
        control = list(
            removePunctuation = TRUE,
            weighting = weightTf,
            stopwords = TRUE
        )
    )

#Computing correlations between terms. function findAssocs() which computes all 
#associations for a given term and corlimit, that is the minimal correlation for 
#being identified as valid associations.

findAssocs(tdm, "pecud", 0.8)

# find those terms that occur at least five times, then we can use the findFreqTerms() 
#function:

findFreqTerms(tdm, 5)

#Cosine Similarity
library(lsa)
tdm_matrix <- as.matrix(tdm)
colnames(tdm_matrix) <- paste("TextDoc", 1:ncol(tdm_matrix), sep = "")

cosine(tdm_matrix[,"TextDoc1"], tdm_matrix[,"TextDoc2"])
# #0.201016

cosine(tdm_matrix[,"TextDoc1"], tdm_matrix[,"TextDoc3"])
# #0.1351571

tdm_Cosine <- cosine(tdm_matrix)
tdm_Cosine

tdm_Cosine <- round(tdm_Cosine, 2)

tdm_Cosine[upper.tri(tdm_Cosine)] <- 0
tdm_Cosine

