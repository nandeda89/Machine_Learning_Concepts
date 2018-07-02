
# example tree & viz from http://scikit-learn.org/stable/modules/tree.html
from sklearn import datasets, tree
iris = datasets.load_iris()
clf = tree.DecisionTreeClassifier()
clf = clf.fit(iris.data, iris.target)

from sklearn_pandas import DataFrameMapper
default_mapper = DataFrameMapper([(i, None) for i in iris.feature_names + ['Species']])

import sklearn_pmml
sklearn_pmml(estimator=clf,
             mapper=default_mapper,
             pmml="C:/IrisClassificationTree.pmml")