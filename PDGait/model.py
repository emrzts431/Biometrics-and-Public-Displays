from sklearn.svm import SVC
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, precision_score, recall_score
from sklearn.preprocessing import StandardScaler
import pickle
from preprocessing import get_feature_and_label_list

#NOTE: Ask Jonathan, how to proceed after this part
features, labels = get_feature_and_label_list()

# features = np.array(features)
# scaler = StandardScaler()
# features_scaled = scaler.fit_transform(features)
# # Train-Test Split
X_train, X_test, y_train, y_test = train_test_split(features, labels, test_size=0.2)

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
