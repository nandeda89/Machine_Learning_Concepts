import nltk

# nltk.download()

#Tokenizing
    #Word Tokenizer
    #Sentence Tokenizer

#Lexicon & corporas
    #Copora - body of text ex. medical journals, presidentials speeches, English language
    #Lexicon -words and their means
        #Investor speak - regular english speak
        #invester speak "bull" -= some one who is positive about market
        #english speak "bull" = scary animal you don't want running @ you

from nltk.tokenize import sent_tokenize, word_tokenize

example_text = "Hello Mr. Smith , how are you doing today? The weather is great and Python is awesome. The sky is pinkish-blue and you " \
               "should not go out today"

print(sent_tokenize(example_text))
print(word_tokenize(example_text))

for i in word_tokenize(example_text):
    print(i)