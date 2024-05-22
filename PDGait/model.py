import numpy as np
from sklearn.svm import SVC
from sklearn.model_selection import train_test_split

# Sample data (replace with your actual data)
# Each row represents a frame with joint coordinates (normalized)
# We focus on Head, Hips, Knees, and Ankles (center points)
data = np.array([
    [0.5, 0.7, 0.6, 0.8, 0.4, 0.6],  # Head, Hip, Knee, Ankle (normalized)
    [0.45, 0.75, 0.55, 0.85, 0.35, 0.55],
    # ... more data for different frames and people
])

# Labels (replace with actual person labels)
labels = np.array([0, 0, 1, 2, 1, 0])  # Person 0, 0, 1, 2, 1, 0

# Extract features (distances and angles)
features = []
for frame in data:
    # Head-Hip distance
    head_hip_dist = np.linalg.norm(frame[:2] - frame[2:4])
    # Hip angles (assuming torso center at frame[0:2])
    hip_angle_left = np.arctan2(frame[4] - frame[0], frame[5] - frame[1])
    hip_angle_right = np.arctan2(frame[6] - frame[0], frame[7] - frame[1])
    # Knee-Ankle distance
    knee_ankle_dist_left = np.linalg.norm(frame[2:4] - frame[4:6])
    knee_ankle_dist_right = np.linalg.norm(frame[3:5] - frame[6:8])
    features.append([head_hip_dist, hip_angle_left, hip_angle_right, knee_ankle_dist_left, knee_ankle_dist_right])

features = np.array(features)

# Train-Test Split
X_train, X_test, y_train, y_test = train_test_split(features, labels, test_size=0.2)

# Define and train the SVM model
clf = SVC(kernel='linear')  # You can experiment with different kernels
clf.fit(X_train, y_train)

# Prediction on test data
y_pred = clf.predict(X_test)

# Evaluate performance (accuracy, precision, recall)
# ... (you can use metrics from scikit-learn)

print("Accuracy:", np.mean(y_pred == y_test))
