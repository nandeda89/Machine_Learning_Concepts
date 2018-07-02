from __future__ import division
import nltk
from nltk.book import *
from nltk import bigrams

# #Conditionals
# print(sent7)
#
# print([w for w in sent7 if len(w) < 4])
#
# print([w for w in sent7 if len(w) <= 4])
#
# print([w for w in sent7 if len(w) == 4])
#
# print([w for w in sent7 if len(w) != 4])

# ## Function           Meaning
# # sent7.startswith("t")     #Test if s starts with t
# # sent7.endswith("t")      ##Test if s ends with t
# # #t in s              ##Test if t is contained inside s
# # sent7.islower()         #Test if all cased characters in s are lowercase
# # sent7.isupper()         #Test if all cased characters in s are uppercase
# # sent7.isalpha()         #Test if all characters in s are alphabetic
# # sent7.isalnum()         #Test if all characters in s are alphanumeric
# # sent7.isdigit()         #Test if all characters in s are digits
# # sent7.istitle()         #Test if s is titlecased (all words in s have initial capitals)
#
# print(sorted([w for w in set(text1) if w.endswith('ableness')]))
# print(sorted([term for term in set(text4) if 'gnt' in term]))
# print(sorted([item for item in set(text6) if item.istitle()]))
# print(sorted([item for item in set(sent7) if item.isdigit()]))
# print("\n\n")
# print(sorted([w for w in set(text7) if '-' in w and 'index' in w]))
# print(sorted([wd for wd in set(text3) if wd.istitle() and len(wd) > 10]))
# print(sorted([w for w in set(sent7) if not w.islower()]))
# print(sorted([t for t in set(text2) if 'cie' in t or 'cei' in t]))

# #Operating on Every Element
# length = [len(w) for w in text1]
# print(length)
#
# upper_1 = [w.upper() for w in text1]
# print(upper_1)

# print(len(text1))
# print(len(set(text1)))
# print(len(set([word.lower() for word in text1])))
# print(len(set([word.lower() for word in text1 if word.isalpha()])))

# #Nested Code Blocks
# word = 'cat'
# if len(word) < 5:
#     print('word length is less than 5')
#
# for word in ['Call', 'me', 'Ishmael', '.']:
#     print(word)

# #Looping with Conditions
# sent1 = ['Call', 'me', 'Ishmael', '.']
#
# for xyzzy in sent1:
#     if xyzzy.endswith('l'):
#         print (xyzzy)
#
# for token in sent1:
#     if token.islower():
#         print(token, 'is a lowercase word')
#     elif token.istitle():
#         print(token, 'is a titlecase word')
#     else:
#         print(token, 'is punctuation')

tricky = sorted([w for w in set(text2) if "cei"in w or "cie" in w])
for word in tricky:
    print(word,)