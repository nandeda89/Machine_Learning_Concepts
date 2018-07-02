from sklearn.ensemble import AdaBoostClassifier #For Classification
from sklearn.ensemble import AdaBoostRegressor #For Regression
from sklearn.tree import DecisionTreeClassifier
from sklearn import tree
from sklearn.model_selection import train_test_split
from sklearn.metrics import confusion_matrix
from sklearn.datasets import load_iris

# import Iris some data to play with
iris = load_iris()
X = iris.data
y = iris.target
class_names = iris.target_names

# Split the data into a training set and a test set
X_train, X_test, y_train, y_test = train_test_split(X, y, random_state=0)

#Decision Tree Classifier
clf = tree.DecisionTreeClassifier()
clf = clf.fit(X_train, y_train)

#Predict Test results
y_pred = clf.predict(X_test)

# Compute confusion matrix
cnf_matrix = confusion_matrix(y_test, y_pred)
print("Decision Tree Results:")
print(cnf_matrix)

# also get the accuracy easily with numpy
accuracy = (y_test == y_pred).sum() / float(len(y_test))
print(accuracy)

#Print Decision Tree
# print(iris.data)
# https://github.com/ellson/graphviz/
import pydotplus
dot_data = tree.export_graphviz(clf, out_file=None)
graph = pydotplus.graph_from_dot_data(dot_data)
graph.write_pdf("iris.pdf")

#AdaBoost
# Decision Tree Classifier
dt = DecisionTreeClassifier()
clf_ada = AdaBoostClassifier(n_estimators=1000, base_estimator=dt,learning_rate=1)
#Above I have used decision tree as a base estimator, you can use any ML learner as base estimator if it ac# cepts sample weight

#Model fitting
clf_ada = clf_ada.fit(X_train, y_train)

#Prediction
y_pred = clf_ada.predict(X_test)

# Compute confusion matrix
cnf_matrix = confusion_matrix(y_test, y_pred)

print("\n")
print("AdaBoost Results:")
print(cnf_matrix)

# also get the accuracy easily with numpy
accuracy = (y_test == y_pred).sum() / float(len(y_test))
print(accuracy)