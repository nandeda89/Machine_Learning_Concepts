
#Wordnet - With WordNet we can do things like look up words and their meaning according to their parts of speech, we can
#  find synonyms, antonyms, and even examples of the word in use.

from nltk.corpus import wordnet
syns = wordnet.synsets("program")

#Synset
print(syns[0])

#Synset
print(syns[0].name())

#Just the word
print(syns[0].lemmas()[0].name())

#definition
print(syns[0].definition())

#examples
print(syns[0].examples())

#Synonyms #Antonyms
synonyms =[]
antonyms = []

for syn in wordnet.synsets("good"):
    for l in syn.lemmas():
        # print("l:", l)
        synonyms.append(l.name())
        if l.antonyms():
            antonyms.append(l.antonyms()[0].name())

print(set(synonyms))
print(set(antonyms))

#Semantic similarity
w1 = wordnet.synset("ship.n.01")
w2 = wordnet.synset("boat.n.01")
print(w1.wup_similarity(w2))

w1 = wordnet.synset("ship.n.01")
w2 = wordnet.synset("car.n.01")
print(w1.wup_similarity(w2))

w1 = wordnet.synset("ship.n.01")
w2 = wordnet.synset("cat.n.01")
print(w1.wup_similarity(w2))

w1 = wordnet.synset("ship.n.01")
w2 = wordnet.synset("cactus.n.01")
print(w1.wup_similarity(w2))

