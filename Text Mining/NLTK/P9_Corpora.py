
#Corpora - corpora is just a body of texts. Generally, corpora are grouped by some sort of defining characteristic
from nltk.corpus import gutenberg
from  nltk.tokenize import sent_tokenize

sample = gutenberg.raw("bible-kjv.txt")
token = sent_tokenize(sample)

print(token[5:15])

