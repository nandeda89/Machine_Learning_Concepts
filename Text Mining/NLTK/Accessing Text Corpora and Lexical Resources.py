
#Accessing Text Corpora
import nltk
from nltk.book import *
from nltk.corpus import gutenberg
from nltk.corpus import webtext
from nltk.corpus import nps_chat
from nltk.corpus import brown
from nltk.corpus import reuters
from nltk.corpus import PlaintextCorpusReader

#Gutenberg Corpus
'''
fileids = gutenberg.fileids()
print(fileids)

emma = gutenberg.words("austen-emma.txt")
print(len(emma))

emma = Text(emma)
emma.concordance("surprize")

for fileid in fileids:
    num_chars = len(gutenberg.raw(fileid))
    num_words = len(gutenberg.words(fileid))
    num_sents = len(gutenberg.sents(fileid))
    num_vocab = len(set([w.lower() for w in gutenberg.words(fileid)]))
    print(int(num_chars/num_words),int(num_words/num_sents),int(num_words/num_vocab),fileid)

macbeth_sentences = gutenberg.sents('shakespeare-macbeth.txt')
print(macbeth_sentences)

print(macbeth_sentences[1037])

longest_len = max([len(s) for s in macbeth_sentences])
print([s for s in macbeth_sentences if len(s) == longest_len])

'''

#Web and Chat Text
'''
for fileid in webtext.fileids():
    print(fileid, webtext.raw(fileid)[:65])

#corpus of instant messaging chat sessions
chatroom = nps_chat.posts('10-19-20s_706posts.xml')
print(chatroom[123])
'''

#Brown Corpus
'''
#Table 2-1. Example document for each section of the Brown Corpus
# ID File Genre Description
# A16 ca16 news Chicago Tribune: Society Reportage
# B02 cb02 editorial Christian Science Monitor: Editorials
# C17 cc17 reviews Time Magazine: Reviews
# D12 cd12 religion Underwood: Probing the Ethics of Realtors
# E36 ce36 hobbies Norling: Renting a Car in Europe
# F25 cf25 lore Boroff: Jewish Teenage Culture
# G22 cg22 belles_lettres Reiner: Coping with Runaway Technology
# H15 ch15 government US Office of Civil and Defence Mobilization: The Family Fallout Shelter
# J17 cj19 learned Mosteller: Probability with Statistical Applications
# K04 ck04 fiction W.E.B. Du Bois: Worlds of Color
# L13 cl13 mystery Hitchens: Footsteps in the Night
# M01 cm01 science_fiction Heinlein: Stranger in a Strange Land
# N14 cn15 adventure Field: Rattlesnake Ridge
# P12 cp12 romance Callaghan: A Passion in Rome
# R06 cr06 humor Thurber: The Future, If Any, of Comedy

print(brown.categories())
print(brown.words(categories='news'))
print(brown.words(fileids=['cg22']))
print(brown.sents(categories=['news', 'editorial', 'reviews']))

news_text = brown.words(categories='news')
fdist = nltk.FreqDist([w.lower() for w in news_text])
modals = ['can', 'could', 'may', 'might', 'must', 'will']
for m in modals:
    print (m + ':', fdist[m],)

wh_words = ["what", "when", "where", "who", "why"]
news_text = brown.words(categories='reviews')
fdist = nltk.FreqDist([w.lower() for w in news_text])
for m in wh_words:
    print (m + ':', fdist[m],)

cfd = nltk.ConditionalFreqDist(
    (genre, word)
    for genre in brown.categories()
    for word in brown.words(categories=genre))

genres = ['news', 'religion', 'hobbies', 'science_fiction', 'romance', 'humor']
modals = ['can', 'could', 'may', 'might', 'must', 'will']

cfd_tabulate = cfd.tabulate(conditions=genres, samples=modals)
print(cfd_tabulate)
'''

#Reuters Corpus
'''
print(reuters.categories())
print(reuters.fileids())

#Categories
print(reuters.categories('training/9865'))
print(reuters.categories(['training/9865', 'training/9880']))

#Fileids
print(reuters.fileids('barley'))
print(reuters.fileids(['barley', 'corn']))
print("\n")
#Words
print(reuters.words('training/9865')[:14])
print("\n")

print(reuters.words(['training/9865', 'training/9880']))
print("\n")

print(reuters.words(categories='barley'))
print("\n")

print(reuters.words(categories=['barley', 'corn']))

'''

#Inaugural Address Corpus
'''

'''
#Annotated Text Corpora
'''

'''

#Corpora in Other Languages
'''

'''

#Text Corpus Structure
'''
# Table 2-3. Basic corpus functionality defined in NLTK: More documentation can be found using
# help(nltk.corpus.reader) and by reading the online Corpus HOWTO at http://www.nltk.org/howto.
# Example Description
# fileids() The files of the corpus
# fileids([categories]) The files of the corpus corresponding to these categories
# categories() The categories of the corpus
# categories([fileids]) The categories of the corpus corresponding to these files
# raw() The raw content of the corpus
# raw(fileids=[f1,f2,f3]) The raw content of the specified files
# raw(categories=[c1,c2]) The raw content of the specified categories
# words() The words of the whole corpus
# words(fileids=[f1,f2,f3]) The words of the specified fileids
# words(categories=[c1,c2]) The words of the specified categories
# sents() The sentences of the specified categories
# sents(fileids=[f1,f2,f3]) The sentences of the specified fileids
# sents(categories=[c1,c2]) The sentences of the specified categories
# abspath(fileid) The location of the given file on disk
# encoding(fileid) The encoding of the file (if known)
# open(fileid) Open a stream for reading the given corpus file
# root() The path to the root of locally installed corpus
# readme() The contents of the README file of the corpus
'''

#Loading Your Own Corpus

