import pandas as pd
import numpy as np
from sklearn.feature_extraction.text import *
from sklearn.externals import joblib
from sklearn.naive_bayes import MultinomialNB
from sklearn.naive_bayes import GaussianNB
from sklearn.naive_bayes import BernoulliNB
from sklearn import svm
from sklearn.svm import NuSVC
from sklearn.svm import LinearSVC

from sklearn.svm import SVR
from sklearn.svm import LinearSVR
from sklearn.svm import NuSVR

from sklearn.neighbors import KNeighborsClassifier
from sklearn.neighbors import RadiusNeighborsClassifier


##########################################################################################################
############### Read Data ###################
##########################################################################################################

# training file is expected in csv format with comma as delimiter
# <document string>,<class>
path = "\\TrainingDataset.csv"
train = pd.read_csv(path)

# print(train.head())

##########################################################################################################
############### Text Corpus ###################
##########################################################################################################

#Intialize Corpus Vector
train_corpus = []
train_classes = []

train_corpus = train['Text']
train_classes = train['Speaker'].tolist()

# print(type(train_corpus))
# print(type(train_classes))
##########################################################################################################
############### Transfer text into vector ###################
##########################################################################################################

# Transfer text into vector
vectorizer = TfidfVectorizer(lowercase=False, ngram_range=(1, 3), encoding='utf-8') # From Sklearn sklearn.feature_extraction.text.TfidfVectorizer
vectorizer.fit(train_corpus.values.astype('U')) # train model

train_corpus_matrix = vectorizer.transform(train_corpus.values.astype('U')) # sparce matrix of training documents

# Save TfidVectorizer
joblib.dump(vectorizer, './/Model Files//TfidfVectorizer_model.pkl')
#
# ##########################################################################################################
############# Support Vector Machine ###################

############### SVC ###################

model = svm.SVC()
model.fit(train_corpus_matrix, train_classes) # train model

# persist the models
joblib.dump(model, './/Model Files//SVM_SVC_model.pkl')

############### Linear SVC Model ###################

# Linear SVC Model

model = LinearSVC()
model.fit(train_corpus_matrix, train_classes) # train model

# persist the models
joblib.dump(model, './/Model Files//SVM_LinearSVC_model.pkl')

############### NuSVC Model ###################

# NuSVC Model

model = NuSVC()
model.fit(train_corpus_matrix, train_classes) # train model

# persist the models
joblib.dump(model, './/Model Files//SVM_NuSVC_model.pkl')

##########################################################################################################
############### Naive Bayes ###################

############### Multinomial Naive Bayes ###################

model = MultinomialNB()
model.fit(train_corpus_matrix, train_classes) # train model

# persist the models
joblib.dump(model, './/Model Files//NaiveBayes_Multinomial_model.pkl')

############### Bernoulli Naive Bayes ###################

model = BernoulliNB()
model.fit(train_corpus_matrix, train_classes) # train model

# persist the models
joblib.dump(model, './/Model Files//NaiveBayes_Bernoulli_model.pkl')
##########################################################################################################
# ############### K Nearest Neighbors ###################

############### weights='distance' ###################
model = KNeighborsClassifier(n_neighbors=1, weights='distance')
model.fit(train_corpus_matrix, train_classes) # train model

# persist the models
joblib.dump(model, './/Model Files//KNeighborsClassifier_Distance_model.pkl')

############### weights='Uniform' - Algorithm - Auto ###################
model = KNeighborsClassifier(n_neighbors=1, weights='uniform', algorithm='auto')
model.fit(train_corpus_matrix, train_classes) # train model

# persist the models
joblib.dump(model, './/Model Files//KNeighborsClassifier_Uniform_Auto_model.pkl')

############### weights='Uniform' - Algorithm - ball_tree ###################
model = KNeighborsClassifier(n_neighbors=1, weights='uniform', algorithm='ball_tree')
model.fit(train_corpus_matrix, train_classes) # train model

# persist the models
joblib.dump(model, './/Model Files//KNeighborsClassifier_Uniform_ball_tree_model.pkl')

############### weights='Uniform' - Algorithm - kd_tree ###################
model = KNeighborsClassifier(n_neighbors=1, weights='uniform', algorithm='kd_tree')
model.fit(train_corpus_matrix, train_classes) # train model

# persist the models
joblib.dump(model, './/Model Files//KNeighborsClassifier_Uniform_kd_tree_model.pkl')

############### weights='Uniform' - Algorithm - brute ###################
model = KNeighborsClassifier(n_neighbors=1, weights='uniform', algorithm='brute')
model.fit(train_corpus_matrix, train_classes) # train model

# persist the models
joblib.dump(model, './/Model Files//KNeighborsClassifier_Uniform_brute_model.pkl')

# ############### RadiusNeighborsClassifier ###################
############### weights='distance' ###################
model = KNeighborsClassifier(radius=1.0, weights='distance')
model.fit(train_corpus_matrix, train_classes) # train model

# persist the models
joblib.dump(model, './/Model Files//RadiusNeighborsClassifier_Distance_model.pkl')

############### weights='Uniform' - Algorithm - Auto ###################
model = KNeighborsClassifier(radius=1.0, weights='uniform', algorithm='auto')
model.fit(train_corpus_matrix, train_classes) # train model

# persist the models
joblib.dump(model, './/Model Files//RadiusNeighborsClassifier_Uniform_Auto_model.pkl')

############### weights='Uniform' - Algorithm - ball_tree ###################
model = KNeighborsClassifier(radius=1.0, weights='uniform', algorithm='ball_tree')
model.fit(train_corpus_matrix, train_classes) # train model

# persist the models
joblib.dump(model, './/Model Files//RadiusNeighborsClassifier_Uniform_ball_tree_model.pkl')

############### weights='Uniform' - Algorithm - kd_tree ###################
model = KNeighborsClassifier(radius=1.0, weights='uniform', algorithm='kd_tree')
model.fit(train_corpus_matrix, train_classes) # train model

# persist the models
joblib.dump(model, './/Model Files//RadiusNeighborsClassifier_Uniform_kd_tree_model.pkl')

############### weights='Uniform' - Algorithm - brute ###################
model = KNeighborsClassifier(radius=1.0, weights='uniform', algorithm='brute')
model.fit(train_corpus_matrix, train_classes) # train model

# persist the models
joblib.dump(model, './/Model Files//RadiusNeighborsClassifier_Uniform_brute_model.pkl')

##########################################################################################################
##########################################################################################################
# end of training
