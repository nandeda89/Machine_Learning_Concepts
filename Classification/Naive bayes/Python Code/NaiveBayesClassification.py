
import pandas as pd
from sklearn.svm import *
from sklearn.feature_extraction.text import *
from sklearn.externals import joblib
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
from sklearn.metrics import confusion_matrix

test_corpus = []
test_classes = []

# training file is expected in csv format with comma as delimiter
# <document string>,<class>
path = "Python_Data.csv"
df = pd.read_csv(path)
train, test = train_test_split(df, test_size = 0.25)
test.to_csv(".//Dataset//TestDataset.csv")

# print(list(train))
# print(list(test))
#print(train.head())

train_corpus = train['Text']
train_classes = train['Speaker'].tolist()

test_corpus = test['Text']
test_classes = test['Speaker'].tolist()

#print(type(train_corpus))
# print(type(train_classes))

# print(train_classes)

# Transfer text into vector
vectorizer = TfidfVectorizer(lowercase=False, ngram_range=(1, 3), encoding='utf-8') # From Sklearn sklearn.feature_extraction.text.TfidfVectorizer
vectorizer.fit(train_corpus.values.astype('U')) # train model

train_corpus_matrix = vectorizer.transform(train_corpus.values.astype('U')) # sparce matrix of training documents
test_corpus_matrix = vectorizer.transform(test_corpus.values.astype('U')) # sparce matrix of test documents

model = LinearSVC()
model.fit(train_corpus_matrix, train_classes) # train model

# end of training

# persist the models
joblib.dump(model, './/Model Files//LinearSVC_model_2_Utter_2.pkl')
joblib.dump(vectorizer, './/Model Files//TfidfVectorizer_model_2.pkl')

## Load Models
model = joblib.load(".//Model Files//LinearSVC_model_2_Utter_2.pkl") # LinearSVC model
vectorizer = joblib.load(".//Model Files//TfidfVectorizer_model_2.pkl") # TfidfVectorizer model

# Test/Validation
pred = model.predict(test_corpus_matrix)
decision = model.decision_function(test_corpus_matrix)
classes = model.classes_
outstring = str(pred) + '|*|' + str(decision) + '|*|' + str(classes)
#print type(pred), type(decision), type(classes)
# print(outstring)
# print(pred)
print(len(pred))
cnf_matrix = confusion_matrix(test_classes, pred)

print(cnf_matrix)
print(accuracy_score(test_classes, pred))

print(type(test_corpus))
test["Prediction"] = pred

print(test.head())
print(type(test))
test.to_csv("LinearSVC.csv")