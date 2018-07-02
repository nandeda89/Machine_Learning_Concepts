import pandas as pd
from sklearn.svm import *
from sklearn.feature_extraction.text import *
from sklearn.externals import joblib

train_corpus = []
train_classes = []

# training file is expected in csv format with comma as delimiter
# <document string>,<class>
path = "TrainingDataset.csv"
train = pd.read_csv(path)
train.to_csv(".//Dataset//TrainingDataset.csv")

# print(train.head())

train_corpus = train['Text']
train_classes = train['Speaker'].tolist()

# print(type(train_corpus))
# print(type(train_classes))

# Transfer text into vector
vectorizer = TfidfVectorizer(lowercase=False, ngram_range=(1, 3), encoding='utf-8') # From Sklearn sklearn.feature_extraction.text.TfidfVectorizer
vectorizer.fit(train_corpus.values.astype('U')) # train model

train_corpus_matrix = vectorizer.transform(train_corpus.values.astype('U')) # sparce matrix of training documents

model = LinearSVC()
model.fit(train_corpus_matrix, train_classes) # train model

# end of training

# persist the models
joblib.dump(model, './/Model Files//LinearSVC_model.pkl')
joblib.dump(vectorizer, './/Model Files//TfidfVectorizer_model.pkl')
