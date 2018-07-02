
#Stemming - Take the root word
#I was taking a ride in the car
#I was riding in the car

#Here the word ride and iding has the same meaning

from nltk.stem import PorterStemmer
from nltk.tokenize import word_tokenize, sent_tokenize

ps = PorterStemmer()
example_words = ["Python", "Pythoner", "Pythoning","Pythoned","Pythonly"]

for w in example_words:
    print(ps.stem(w))

new_text = "It is very imporant to be pythonly while you are pythoning with python. All Pythoners have pythoned poorly at least once"
words = word_tokenize(new_text)

for w in words:
    print(ps.stem(w))

print(sent_tokenize(new_text))