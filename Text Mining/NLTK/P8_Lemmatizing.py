
#Lemmatizing
#Similar to Stemming - but the end result might be the synonyms of the actual word

from nltk.stem import WordNetLemmatizer
lemmatizer = WordNetLemmatizer()

# print(lemmatizer.lemmatize("cats"))
# print(lemmatizer.lemmatize("cacti"))
# print(lemmatizer.lemmatize("geese"))
# print(lemmatizer.lemmatize("rocks"))
# print(lemmatizer.lemmatize("python"))
# print(lemmatizer.lemmatize("hellos"))

print(lemmatizer.lemmatize("better"))
print(lemmatizer.lemmatize("better", pos="a"))

print(lemmatizer.lemmatize("best", pos="a"))

print(lemmatizer.lemmatize("run", pos="a"))
print(lemmatizer.lemmatize("run"))
print(lemmatizer.lemmatize("run", pos="v"))
