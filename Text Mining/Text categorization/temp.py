############### SVR Model ###################

# SVR Model

model = SVR(C=1.0, epsilon=0.2)
model.fit(train_corpus_matrix, train_classes) # train model

# persist the models
joblib.dump(model, './/Model Files//SVR_model.pkl')

############### LinearSVR Model ###################

# LinearSVR Model

model = LinearSVR(C=1.0, epsilon=0.2)
model.fit(train_corpus_matrix, train_classes) # train model

# persist the models
joblib.dump(model, './/Model Files//LinearSVR_model.pkl')

############### NuSVR Model ###################

# NuSVR Model

model = NuSVR(C=1.0, epsilon=0.2)
model.fit(train_corpus_matrix, train_classes) # train model

# persist the models
joblib.dump(model, './/Model Files//NuSVR_model.pkl')