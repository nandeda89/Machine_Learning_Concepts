#Import modules
import pandas as pd
from sklearn.svm import *
from sklearn.feature_extraction.text import *
from sklearn.externals import joblib
import numpy as np
import matplotlib.pyplot as plt

#Initialize arrays
corpus = []
classes = []

# training file is expected in csv format with comma as delimiter
# <document string>,<class>

# Read csv
df = pd.read_csv(".\\Datasets\\Categories_train_Combined.csv", encoding='cp1252')
corpus = df["Text"].values.T.tolist()
classes = df["Category"].values.T.tolist()

# Transfer text into vector
vectorizer = TfidfVectorizer(lowercase=False, ngram_range=(1, 3)) # From Sklearn sklearn.feature_extraction.text.TfidfVectorizer
vectorizer.fit(corpus) # train model

corpus_matrix = vectorizer.transform(corpus) # sparse matrix of training documents

model = LinearSVC()
model.fit(corpus_matrix, classes) # train model

# end of training

# persist the models
joblib.dump(model, '.\\Model_Files\\LinearSVC_model.pkl')
joblib.dump(vectorizer, '.\\Model_Files\\TfidfVectorizer_model.pkl')

df = pd.read_csv(".\\Datasets\\Categories_train_Combined_Retrain.csv", encoding='cp1252')
corpus = df["Text"].values.T.tolist()
classes = df["Category"].values.T.tolist()

model = joblib.load(".\\Model_Files\\LinearSVC_model.pkl") # LinearSVC model
vectorizer = joblib.load(".\\Model_Files\\TfidfVectorizer_model.pkl") # TfidfVectorizer model

corpus_matrix = vectorizer.transform(corpus) # sparse matrix of training documents
model.fit(corpus_matrix, classes) # train model

# persist the models
joblib.dump(model, '.\\Model_Files\\LinearSVC_model_1.pkl')
joblib.dump(vectorizer, '.\\Model_Files\\TfidfVectorizer_model_1.pkl')