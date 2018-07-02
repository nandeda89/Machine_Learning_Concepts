
#Scikit-Learn

import nltk
import random
from nltk.corpus import movie_reviews
from nltk.classify.scikitlearn import SklearnClassifier
import pickle

from sklearn.naive_bayes import MultinomialNB, GaussianNB, BernoulliNB
from sklearn.linear_model import LogisticRegression, SGDClassifier
from sklearn.svm import SVC, LinearSVC, NuSVC

from nltk.classify import ClassifierI
from statistics import mode

class VoteClassifier(ClassifierI):
    def __init__(self, *classifiers):
        self.classifiers = classifiers

    def classify(self, features):
        votes =[]
        for c in self.classifiers:
            v = c.classify(features)
            votes.append(v)
            return mode(votes)

    def confidence(self, features):
        votes =[]
        for c in self.classifiers:
            v= c.classify(features)
            votes.append(v)

        choice_votes = votes.count(mode(votes))
        conf = choice_votes/len(votes)
        return conf


documents = [(list(movie_reviews.words(fileid)), category)
             for category in movie_reviews.categories()
             for fileid in movie_reviews.fileids(category)]

random.shuffle(documents)

all_words =[]
for w in movie_reviews.words():
    all_words.append(w.lower())

all_words = nltk.FreqDist(all_words)

word_features = list(all_words.keys())[:3000]

def find_features(document):
    words = set(document)
    features = {}
    for w in word_features:
        features[w] = (w in words)

    return features

#print(find_features(movie_reviews.words('neg/cv000_29416.txt')))
featuresets = [(find_features(rev), category) for (rev, category) in documents]

training_set = featuresets[:1900]
testing_set = featuresets[1900:]

#Posterior = prior occurences x likelihood/evidence
#Read Classifier
classifier_f = open("naivebayes.pickle","rb")
classifier = pickle.load(classifier_f)
classifier_f.close()

print("Original Naive Bayes algo Accuracy, ", (nltk.classify.accuracy(classifier, testing_set))*100)
# classifier.show_most_informative_features(15)

#MultinomialNB
MNB_classifier = SklearnClassifier(MultinomialNB())
MNB_classifier.train(training_set)
print("MNB_classifier algo Accuracy, ", (nltk.classify.accuracy(MNB_classifier, testing_set))*100)

#GaussianNB
# GaussianNB_classifier = SklearnClassifier(GaussianNB())
# GaussianNB_classifier.train(training_set)
# print("GaussianNB_classifier algo Accuracy, ", (nltk.classify.accuracy(GaussianNB_classifier, testing_set))*100)

#BernoulliNB
BernoulliNB_classifier = SklearnClassifier(BernoulliNB())
BernoulliNB_classifier.train(training_set)
print("BernoulliNB_classifier algo Accuracy, ", (nltk.classify.accuracy(BernoulliNB_classifier, testing_set))*100)

#LogisticRegression
LogisticRegression_classifier = SklearnClassifier(LogisticRegression())
LogisticRegression_classifier.train(training_set)
print("LogisticRegression_classifier algo Accuracy, ", (nltk.classify.accuracy(LogisticRegression_classifier, testing_set))*100)

#SGDClassifier
SGDClassifier_classifier = SklearnClassifier(SGDClassifier())
SGDClassifier_classifier.train(training_set)
print("SGDClassifier_classifier algo Accuracy, ", (nltk.classify.accuracy(SGDClassifier_classifier, testing_set))*100)

#SVC
SVC_classifier = SklearnClassifier(SVC())
SVC_classifier.train(training_set)
print("SVC_classifier algo Accuracy, ", (nltk.classify.accuracy(SVC_classifier, testing_set))*100)

#LinearSVC
LinearSVC = SklearnClassifier(LinearSVC())
LinearSVC.train(training_set)
print("LinearSVC algo Accuracy, ", (nltk.classify.accuracy(LinearSVC, testing_set))*100)

#NuSVC
NuSVC_classifier = SklearnClassifier(NuSVC())
NuSVC_classifier.train(training_set)
print("NuSVC_classifier algo Accuracy, ", (nltk.classify.accuracy(NuSVC_classifier, testing_set))*100)

vote_classifier = VoteClassifier(classifier,
                                 MNB_classifier,
                                 BernoulliNB_classifier,
                                 LogisticRegression_classifier,
                                 SGDClassifier_classifier,
                                 SVC_classifier,
                                 LinearSVC,
                                 NuSVC_classifier)
print("vote_classifier algo Accuracy, ", (nltk.classify.accuracy(vote_classifier, testing_set))*100)

print("Classification:", vote_classifier.classify(testing_set[0][0]),
      "Confidence %:", vote_classifier.confidence(testing_set[0][0])*100)

print("Classification:", vote_classifier.classify(testing_set[1][0]),
      "Confidence %:", vote_classifier.confidence(testing_set[1][0])*100)

print("Classification:", vote_classifier.classify(testing_set[2][0]),
      "Confidence %:", vote_classifier.confidence(testing_set[2][0])*100)

print("Classification:", vote_classifier.classify(testing_set[3][0]),
      "Confidence %:", vote_classifier.confidence(testing_set[3][0])*100)

print("Classification:", vote_classifier.classify(testing_set[4][0]),
      "Confidence %:", vote_classifier.confidence(testing_set[4][0])*100)

print("Classification:", vote_classifier.classify(testing_set[5][0]),
      "Confidence %:", vote_classifier.confidence(testing_set[5][0])*100)