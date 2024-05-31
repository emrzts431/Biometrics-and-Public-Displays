import numpy as np
from sklearn.svm import SVC
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, precision_score, recall_score
import log_filterer
from sklearn.preprocessing import StandardScaler
import pickle

def extract_features(data):
  features = []
  labels = []
  for label, person_data in data.items():
    for file_data in person_data:
      for limb_lengths in file_data:
        features.append(limb_lengths)
        labels.append(label)
  return features, labels



data_list_name = 'data_list/list.txt'
list_with_labels = []
with open(data_list_name, 'r') as f:
    lines = f.readlines()
    list_with_labels = [x.replace('\n', '') for x in lines]


features, labels = extract_features(log_filterer.getLimbLengths(data_list=list_with_labels).copy())

# features = np.array(features)
scaler = StandardScaler()
features_scaled = scaler.fit_transform(features)
# # Train-Test Split
X_train, X_test, y_train, y_test = train_test_split(features_scaled, labels, test_size=0.2)

# Define and train the SVM model
clf = SVC(kernel='linear')  # You can experiment with different kernels
clf.fit(X_train, y_train)

# Prediction on test data
y_pred = clf.predict(X_test)

# Evaluate performance (accuracy, precision, recall)
# ... (you can use metrics from scikit-learn)
print("Accuracy score: ", accuracy_score(y_test, y_pred))
print("Precision score: ", precision_score(y_test, y_pred, average='weighted'))
print("Recall score: ", recall_score(y_test, y_pred, average='weighted'))

with open('pdgait_model.pkl', 'wb') as f:
  pickle.dump(clf, f)
