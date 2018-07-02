import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import accuracy_score
from sklearn import tree
from sklearn.datasets import load_iris
import pydotplus

# save load_iris() sklearn dataset to iris
# if you'd like to check dataset type use: type(load_iris())
# if you'd like to view list of attributes use: dir(load_iris())
iris = load_iris()

# np.c_ is the numpy concatenate function
# which is used to concat iris['data'] and iris['target'] arrays
# for pandas column argument: concat iris['feature_names'] list
# and string list (in this case one string); you can make this anything you'd like..
# the original dataset would probably call this ['Species']
df = pd.DataFrame(data= np.c_[iris['data'], iris['target']],
                     columns= iris['feature_names'] + ['target'])
# print(df.head())
# print(df.tail())
# print("* iris types:", df["target"].unique(), sep="\n")


#Data Slicing
X = df.values[:, 0:3]
Y = df.values[:,4]

X_train, X_test, y_train, y_test = train_test_split( X, Y, test_size = 0.3, random_state = 100)
# print(pd.DataFrame(X_train).head())

#Decision Tree Classifier with criterion gini index

clf_gini = DecisionTreeClassifier(criterion = "gini", random_state = 100,
                               max_depth=3, min_samples_leaf=5)
clf_gini.fit(X_train, y_train)

dot_data = tree.export_graphviz(clf_gini, out_file=None,
                         feature_names=iris.feature_names,
                         class_names=iris.target_names,
                         filled=True, rounded=True,
                         special_characters=True)
graph = pydotplus.graph_from_dot_data(dot_data)
graph.write_pdf(".//Tree//clf_gini_iris.pdf")

#Decision Tree Classifier with criterion information gain
clf_entropy = DecisionTreeClassifier(criterion = "entropy", random_state = 100,
 max_depth=3, min_samples_leaf=5)
clf_entropy.fit(X_train, y_train)

dot_data = tree.export_graphviz(clf_entropy, out_file=None,
                         feature_names=iris.feature_names,
                         class_names=iris.target_names,
                         filled=True, rounded=True,
                         special_characters=True)
graph = pydotplus.graph_from_dot_data(dot_data)
graph.write_pdf(".//Tree//clf_entropy_iris.pdf")

#Prediction for Decision Tree classifier with criterion as gini index
y_pred_gini = clf_gini.predict(X_test)
# print(y_pred_gini)

#Prediction for Decision Tree classifier with criterion as Entropy
y_pred_entropy = clf_entropy.predict(X_test)
# print(y_pred_entropy)

print ("Accuracy using Gini Index is: ", accuracy_score(y_test,y_pred_gini)*100)
print ("Accuracy using Entropy is: ", accuracy_score(y_test,y_pred_entropy)*100)

#Produce psuedo-code for decision tree.
def get_code(tree, feature_names, target_names,
             spacer_base="    "):
    """Produce psuedo-code for decision tree.

    Args
    ----
    tree -- scikit-leant DescisionTree.
    feature_names -- list of feature names.
    target_names -- list of target (class) names.
    spacer_base -- used for spacing code (default: "    ").

    Notes
    -----
    """
    left      = tree.tree_.children_left
    right     = tree.tree_.children_right
    threshold = tree.tree_.threshold
    features  = [feature_names[i] for i in tree.tree_.feature]
    value = tree.tree_.value

    def recurse(left, right, threshold, features, node, depth):
        spacer = spacer_base * depth
        if (threshold[node] != -2):
            print(spacer + "if ( " + features[node] + " <= " + \
                  str(threshold[node]) + " ) {")
            if left[node] != -1:
                    recurse(left, right, threshold, features,
                            left[node], depth+1)
            print(spacer + "}\n" + spacer +"else {")
            if right[node] != -1:
                    recurse(left, right, threshold, features,
                            right[node], depth+1)
            print(spacer + "}")
        else:
            target = value[node]
            for i, v in zip(np.nonzero(target)[1],
                            target[np.nonzero(target)]):
                target_name = target_names[i]
                target_count = int(v)
                print(spacer + "return " + str(target_name) + \
                      " ( " + str(target_count) + " examples )")

    recurse(left, right, threshold, features, 0, 0)

# Get psuedo-code for Decision tree built using gini index
print("\n", "Rules for Tree using Gini Index")
get_code(clf_gini, iris['feature_names'], ["setosa", "versicolor", "virginica"])

print("\n", "Rules for Tree using Gini Index")
get_code(clf_entropy, iris['feature_names'], ["setosa", "versicolor", "virginica"])