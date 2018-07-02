# -*- coding: utf-8 -*-

from nltk.tag import StanfordNERTagger
from nltk.tokenize import word_tokenize
from nltk.tokenize import sent_tokenize
import nltk

st = StanfordNERTagger('.\\stanford-ner-2016-10-31\\stanford-ner-2016-10-31\\classifiers\english.muc.7class.distsim.crf.ser.gz',
					   '.\\stanford-ner-2016-10-31\\stanford-ner-2016-10-31\\stanford-ner.jar',
					   encoding='utf-8')

text = 'Barack Obama was born on August 4, 1961 in Honolulu, Hawaii which was 4 days ago.'

tokenized_text = word_tokenize(text)
classified_text = st.tag(tokenized_text)

print(type(classified_text))
print(classified_text)

