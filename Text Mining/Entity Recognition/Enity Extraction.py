import nltk
from nltk.corpus import state_union
from nltk.tokenize import PunktSentenceTokenizer

train_text = state_union.raw("2005-GWBush.txt")
sample_text = state_union.raw("2006-GWBush.txt")

custom_sent_tokenizer = PunktSentenceTokenizer(train_text)

sample_text = "New York"
tokenized = custom_sent_tokenizer.tokenize(sample_text)

def process_content():
    try:
        for i in tokenized[0:]:
            words = nltk.word_tokenize(i)
            tagged = nltk.pos_tag(words)
            namedEnt = nltk.ne_chunk(tagged, binary=True)
            namedEnt.draw()
    except Exception as e:
        print(str(e))

process_content()

my_sent = "WASHINGTON -- In the wake of a string of abuses by New York police officers in the 1990s. 04/03/2017"
parse_tree = nltk.ne_chunk(nltk.tag.pos_tag(my_sent.split()), binary=True)  # POS tagging before chunking!

named_entities = []

for t in parse_tree.subtrees():
    if t.label() == 'NE':
        named_entities.append(t)
        # named_entities.append(list(t))  # if you want to save a list of tagged words instead of a tree

print(named_entities)
