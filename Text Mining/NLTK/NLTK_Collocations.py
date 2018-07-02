import nltk
from nltk.collocations import *

bigram_measures = nltk.collocations.BigramAssocMeasures()
trigram_measures = nltk.collocations.TrigramAssocMeasures()

#Get Bigrams from text
finder = BigramCollocationFinder.from_words(
    nltk.corpus.genesis.words('english-web.txt'))

#Bigrams which occure more than 3 times
finder.apply_freq_filter(3)

#Print top 10 bigrams
print(finder.nbest(bigram_measures.pmi, 10))  # doctest: +NORMALIZE_WHITESPACE

# for k, v in finder.ngram_fd.items():
#     print(k, v)

#find collocations among tagged words
finder = BigramCollocationFinder.from_words(
    nltk.corpus.brown.tagged_words('ca01', tagset='universal')
)

#Print top 10 bigrams
print(finder.nbest(bigram_measures.pmi, 10))

#find collocations among tags alone
finder = BigramCollocationFinder.from_words(t for w, t in
                                            nltk.corpus.brown.tagged_words('ca01', tagset='universal'))
#Print top 10 bigrams
print(finder.nbest(bigram_measures.pmi, 10))

#spanning intervening words
finder = BigramCollocationFinder.from_words(
    nltk.corpus.genesis.words('english-web.txt'),
    window_size = 20)

finder.apply_freq_filter(2)
ignored_words = nltk.corpus.stopwords.words('english')
finder.apply_word_filter(lambda w: len(w) < 3 or w.lower() in ignored_words)
print(finder.nbest(bigram_measures.likelihood_ratio, 10))