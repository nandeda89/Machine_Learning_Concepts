from __future__ import division
import nltk
# nltk.download()

from nltk.book import *
from nltk import bigrams

#Searching Text
# print()
# text1.concordance("monstrous")

# print()
# text2.concordance("affection")
#
# print()
# text3.concordance("lived")
#
# print()
# text4.concordance("nation")
#
# print()
# text5.concordance("lol")

#words appear in a similar range of contexts
# print()
# text1.similar("monstrous")

# print()
# text2.similar("monstrous")
#
# #common_contexts allows us to examine just the contexts that are shared by two or more words,
# print()
#text2.common_contexts(["monstrous", "very"])
#
# #dispersion plot.
# print()
# text4.dispersion_plot(["citizens","democracy", "freedom", "duties", "America"])
#
# #length of Text
# print(len(text3))
#
# #Sorted distinct words
# print(sorted(set(text3)))
#
# # Length of distinct words
# print(len(set(text3)))
#
# #lexical richness of the text

# length = len(text3)/len(set(text3))
# print(length)
# # #16.050
#
# #count how often a word occurs in a text
# text3.concordance("smote")
# print(text3.count("smote"))
#
# #percentage of the text is taken up by a specific word
# print(100* text3.count("a")/len(text3))

# #How many times does the word lol appear in text5?
# text5.count("lol")
# 100* text5.count("lol")/len(text5)
#
# #two new functions, lexical_diversity() and percentage() -- to do the above task
# def lexical_diversity(text):
#     return len(text)/len(set(text))
#
# def percentage(count, total):
#     return 100 * count/total
#
# lexical_diversity(text3)
# lexical_diversity(text5)
#
# percentage(4, 5)
# percentage(text4.count("a"), len(text4))
#
# #how we represent text in Python
#
#
# lexical_diversity(sent_1)
#
# #predifined sentences
# sent2
# sent9
#
# len(sent1)
# len(set(sent1))
# lexical_diversity(sent1)
# percentage(sent1.count("a"), len(sent1))
# sorted(set(sent1))
#
# #Python’s addition operator on lists -concatenation;
# newlist = ['Monty', 'Python'] + ['and', 'the', 'Holy', 'Grail']
# print(newlist)
#
# sent9 + sent1
#
# #add a single item to a list? This is known as appending
#
# #item’s index
# print(text4[173])

#
# #find the index of when it first occurs
# print(text4.index("awaken"))
#
# #extracting manageable pieces of language from large texts, a technique known as slicing.
# print(text5[16715:16735])
# print(text6[1600:1625])
#
# sent = ['word1', 'word2', 'word3', 'word4', 'word5',
#          'word6', 'word7', 'word8', 'word9', 'word10']
#
# # print(sent[0])
# # #'word1'
# #
# # print(sent[9])
# # #'word10'
# #
#
# print(sent)
# sent.append("word11")
# print(sent)
#
# print(sent[0:9])
# print(sent[:3])
# print(sent[2:])
#
# sent[0]= "first"
# print(sent)
#
# sent[9]= "Last"
# print(sent)
#
# sent[1:]= ["SECOND", "THIRD"]
# print(sent)

# print(sent[9])  #Error

#Variables
# my_sent = ['Bravely', 'bold', 'Sir', 'Robin', ',', 'rode',
#            'forth', 'from', 'Camelot', '.']
# print(my_sent)
#
# noun_phrase = my_sent[1:4]
# print(noun_phrase)
#
# wOrDs = sorted(noun_phrase)
# print(wOrDs)
#
# name = 'Monty'
# print(name)
#
# print(name[0])
#
# print(name[:4])
#
# #Multiplication
# print(name * 2)
#
# #Addition
# print(name + '!')
#
# #Join
# name = name.join(['Monty', 'Python'])
# print(name)
#
# #Split
# name = name.split()
# print(name)

# saying = ['After', 'all', 'is', 'said', 'and', 'done',
#          'more', 'is', 'said', 'than', 'done']
#
# print(saying)
#
# tokens = set(saying)
# print(tokens)
#
# tokens = sorted(tokens)
# print(tokens)
#
# print(tokens[-2:])
# print(tokens[:-2])

#Frequency Distribution
# fdist1 = FreqDist(text1)
# print(fdist1)
#
# vocabulary1 = list(fdist1.keys())
# print(fdist1.most_common(3))
#
# print(fdist1['is'])
#
# fdist1.plot(50, cumulative=True)
# print(fdist1.hapaxes())

##Fine-Grained Selection of Words
# V = set(text1)
# long_words = [w for w in V if len(w) > 15]
# long_words= sorted(long_words)
# print(long_words)

# #Words longer than 7 chars and occure more than 7 times
# fdist5 = FreqDist(text5)
# sorted_words = sorted([w for w in set(text5) if len(w) > 7 and fdist5[w] > 7])
# print(sorted_words)

# #Collocations and Bigrams
# bigram_text = list(bigrams(['more', 'is', 'said', 'than', 'done']))
# print(bigram_text)

# #Collocations
# colloc = text4.collocations()
# print(colloc)
#
# colloc = text8.collocations()
# print(colloc)

#Counting Other Things
print([len(w) for w in text1])

fdist = FreqDist([len(w) for w in text1])
print(fdist)
print(fdist.keys())

print(fdist.items())
print(fdist.most_common(3))

print(fdist.max())
print(fdist[3])

print(fdist.freq(3))

fdist.N() #Total number of samples
fdist.keys() #The samples sorted in order of decreasing frequency
for sample in fdist: #Iterate over the samples, in order of decreasing frequency
    print(sample)
fdist.max() #Sample with the greatest count
fdist.tabulate() #Tabulate the frequency distribution
fdist.plot() #Graphical plot of the frequency distribution
fdist.plot(cumulative=True) #Cumulative plot of the frequency distribution
#fdist1 < fdist2
