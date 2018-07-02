
import pandas as pd
import numpy as np
from sklearn.externals import joblib
from sklearn.metrics import accuracy_score

# 1) restore the models with the pkl files created by the LinearClassificationModelBuilder.py script
model = joblib.load(".\\Model_Files\\LinearSVC_model.pkl") # LinearSVC model
vectorizer = joblib.load(".\\Model_Files\\TfidfVectorizer_model.pkl") # TfidfVectorizer model

# 2) data processing
corpus = []
classes_test = []

# Read csv
df = pd.read_csv(".\\Datasets\\Categories_test.csv", encoding='cp1252')
#corpus = df["Text"].values.T.tolist()
classes_test = df["Category"].values.T.tolist()

#print(type(corpus))

corpus= np.array(["Is there any extra charges on my current bill?","why is my bill high last month?","Can I pay my bill online?","What is my Current Bill"]).tolist()
print(type(corpus))

test_matrix  = vectorizer.transform(corpus)  # sparce matrix of test document

# 3) Prediction
pred = model.predict(test_matrix)
decision = model.decision_function(test_matrix)
classes = model.classes_
outstring = str(pred) + '|*|' + str(decision) + '|*|' + str(classes)
print(outstring)
#print(pred)
print(len(pred))

#print(accuracy_score(classes_test, pred))