from nltk.corpus import wordnet as wn
print(wn.synsets('motorcar'))
print(wn.synset('car.n.01').lemma_names())

print(wn.synset('car.n.01').definition())
print(wn.synset('car.n.01').examples())

print(wn.synset('car.n.01').lemmas())
print(wn.lemma('car.n.01.automobile'))
print(wn.lemma('car.n.01.automobile').synset())
print(wn.lemma('car.n.01.automobile').name())

print("\n")
print(wn.synsets('car'))
for synset in wn.synsets('car'):
    print(synset.lemma_names())

print("\n")
print(wn.synsets('jaguar'))
print(wn.synset('jaguar.n.01').lemma_names())
print(wn.synset('jaguar.n.01').definition())