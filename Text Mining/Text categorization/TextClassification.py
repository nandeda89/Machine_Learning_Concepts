
import pandas as pd
from sklearn.svm import *
from sklearn.feature_extraction.text import *
from sklearn.externals import joblib
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
from sklearn.metrics import confusion_matrix

##########################################################################################################
############### Read Data ###################
##########################################################################################################

# training file is expected in csv format with comma as delimiter
# <document string>,<class>
path = "\\TestDataset.csv"
test = pd.read_csv(path)

# print(train.head())

##########################################################################################################
############### Text Corpus ###################
##########################################################################################################

#Intialize Corpus Vector
test_corpus = []
test_classes = []

test_corpus = test['Text']
test_classes = test['Speaker'].tolist()

# print(type(train_corpus))
# print(type(train_classes))
##########################################################################################################
############### Transfer text into vector ###################
##########################################################################################################

# Transfer text into vector
vectorizer = joblib.load(".//Model Files//TfidfVectorizer_model.pkl") # TfidfVectorizer model
test_corpus_matrix = vectorizer.transform(test_corpus.values.astype('U')) # sparce matrix of test documents

##########################################################################################################
############### SVM Models ###################
##########################################################################################################

############### SVC ###################
## Load Models
model = joblib.load(".//Model Files//SVM_SVC_model.pkl") # LinearSVC model

# Test/Validation
pred = model.predict(test_corpus_matrix)

# decision = model.decision_function(test_corpus_matrix)
# classes = model.classes_
# outstring = str(pred) + '|*|' + str(decision) + '|*|' + str(classes)
#print type(pred), type(decision), type(classes)
# print(outstring)
# print(pred)

cnf_matrix = confusion_matrix(test_classes, pred)

print(cnf_matrix)
print("SVM_SVC : ", accuracy_score(test_classes, pred))
print("\n")

test["Prediction"] = pred
test.to_csv(".//Model Output//SVM_SVC_Output.csv")

############### Linear SVC ###################
## Load Models
model = joblib.load(".//Model Files//SVM_LinearSVC_model.pkl") # LinearSVC model

# Test/Validation
pred = model.predict(test_corpus_matrix)
cnf_matrix = confusion_matrix(test_classes, pred)

print(cnf_matrix)
print("SVM_LinearSVC : ", accuracy_score(test_classes, pred))
print("\n")

test["Prediction"] = pred
test.to_csv(".//Model Output//SVM_LinearSVC_Output.csv")

############### SVC ###################
## Load Models
model = joblib.load(".//Model Files//SVM_NuSVC_model.pkl") # LinearSVC model

# Test/Validation
pred = model.predict(test_corpus_matrix)
cnf_matrix = confusion_matrix(test_classes, pred)

print(cnf_matrix)
print("SVM_NuSVC : ", accuracy_score(test_classes, pred))
print("\n")

test["Prediction"] = pred
test.to_csv(".//Model Output//SVM_NuSVC_Output.csv")

##########################################################################################################
##########################################################################################################

##########################################################################################################
##########################################################################################################

############### Multinomial Naive Bayes ###################

## Load Models
model = joblib.load(".//Model Files//NaiveBayes_Multinomial_model.pkl") # LinearSVC model

# Test/Validation
pred = model.predict(test_corpus_matrix)

print(len(pred))
cnf_matrix = confusion_matrix(test_classes, pred)

print(cnf_matrix)
print("NaiveBayes_Multinomial : ", accuracy_score(test_classes, pred))
print("\n")

test["Prediction"] = pred
test.to_csv(".//Model Output//Multinomial_NaiveBayes_Output.csv")

############### Bernoulli Naive Bayes ###################
## Load Models
model = joblib.load(".//Model Files//NaiveBayes_Bernoulli_model.pkl") # LinearSVC model

# Test/Validation
pred = model.predict(test_corpus_matrix)

print(len(pred))
cnf_matrix = confusion_matrix(test_classes, pred)

print(cnf_matrix)
print("NaiveBayes_Bernoulli : ", accuracy_score(test_classes, pred))
print("\n")

test["Prediction"] = pred
test.to_csv(".//Model Output///Bernoulli_NaiveBayes_Output.csv")

##########################################################################################################
##########################################################################################################

##########################################################################################################
##########################################################################################################

############### K Neighbors Classifier ###################


############### weights='distance' ###################
## Load Models
model = joblib.load(".//Model Files//KNeighborsClassifier_Distance_model.pkl") # LinearSVC model

# Test/Validation
pred = model.predict(test_corpus_matrix)
cnf_matrix = confusion_matrix(test_classes, pred)

print(cnf_matrix)
print("KNeighborsClassifier_Distance : ",accuracy_score(test_classes, pred))
print("\n")

test["Prediction"] = pred
test.to_csv(".//Model Output//KNeighborsClassifier_Distance_Output.csv")

############### weights='distance' ###################
## Load Models
model = joblib.load(".//Model Files//KNeighborsClassifier_Distance_model.pkl") # LinearSVC model

# Test/Validation
pred = model.predict(test_corpus_matrix)
cnf_matrix = confusion_matrix(test_classes, pred)

print(cnf_matrix)
print("KNeighborsClassifier_Distance : ",accuracy_score(test_classes, pred))
print("\n")

test["Prediction"] = pred
test.to_csv(".//Model Output//KNeighborsClassifier_Distance_Output.csv")

############### weights='Uniform' - Algorithm - Auto ###################
## Load Models
model = joblib.load(".//Model Files//KNeighborsClassifier_Distance_model.pkl") # LinearSVC model

# Test/Validation
pred = model.predict(test_corpus_matrix)
cnf_matrix = confusion_matrix(test_classes, pred)

print(cnf_matrix)
print("KNeighborsClassifier_Distance : ",accuracy_score(test_classes, pred))
print("\n")

test["Prediction"] = pred
test.to_csv(".//Model Output//KNeighborsClassifier_Distance_Output.csv")

############### weights='Uniform' - Algorithm - ball_tree ###################
## Load Models
model = joblib.load(".//Model Files//KNeighborsClassifier_Distance_model.pkl") # LinearSVC model

# Test/Validation
pred = model.predict(test_corpus_matrix)
cnf_matrix = confusion_matrix(test_classes, pred)

print(cnf_matrix)
print("KNeighborsClassifier_Distance : ",accuracy_score(test_classes, pred))
print("\n")

test["Prediction"] = pred
test.to_csv(".//Model Output//KNeighborsClassifier_Distance_Output.csv")

############### weights='Uniform' - Algorithm - kd_tree ###################
## Load Models
model = joblib.load(".//Model Files//KNeighborsClassifier_Distance_model.pkl") # LinearSVC model

# Test/Validation
pred = model.predict(test_corpus_matrix)
cnf_matrix = confusion_matrix(test_classes, pred)

print(cnf_matrix)
print("KNeighborsClassifier_Distance : ",accuracy_score(test_classes, pred))
print("\n")

test["Prediction"] = pred
test.to_csv(".//Model Output//KNeighborsClassifier_Distance_Output.csv")

############### weights='Uniform' - Algorithm - brute ###################
## Load Models
model = joblib.load(".//Model Files//KNeighborsClassifier_Distance_model.pkl") # LinearSVC model

# Test/Validation
pred = model.predict(test_corpus_matrix)
cnf_matrix = confusion_matrix(test_classes, pred)

print(cnf_matrix)
print("KNeighborsClassifier_Distance : ",accuracy_score(test_classes, pred))
print("\n")

test["Prediction"] = pred
test.to_csv(".//Model Output//KNeighborsClassifier_Distance_Output.csv")
##########################################################################################################
##########################################################################################################