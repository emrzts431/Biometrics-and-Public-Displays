import pandas as pd
from glob import glob
import os
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.neighbors import KNeighborsClassifier
from sklearn.ensemble import RandomForestClassifier
import random

POSE_DATA_FOLDER = '/Users/emreoztas/Desktop/DUE/Biometrics and Public Displays/PublicDisplayOpenposeData'


class PDBiometrics:
    def __init__(self) -> None:
        self.global_dataframe = pd.DataFrame()
        self.setGlobalDataframe()

    def get_data_label_and_set(self, log_file):
        file_name_split = log_file.split(os.sep)
        pid = int(file_name_split[-4].split('_')[-1])
        session_id = int(file_name_split[-3].split('_')[-1])
        rep_id = int(file_name_split[-2].split('_')[-1])
        
        return pid, session_id, rep_id
    
    def setGlobalDataframe(self):
        for log_file in sorted(glob(rf"{POSE_DATA_FOLDER}/**/**/**/logs.tsv")):
            person_id, session, repitition = self.get_data_label_and_set(log_file)
            df = pd.read_csv(log_file, sep='\t')
            df = df[1:]#First frame is somehow always problematic. TODO: !CHECK!
            
            frames_with_ankles = df[(df['lankle_c'] != 0 ) & (df['rankle_c'] != 0)]#remove frames where ankles are not visible
            frames_with_ankles = frames_with_ankles.fillna(0)
            frames_with_ankles = frames_with_ankles.interpolate('linear')
            frames_with_ankles['person_id'] = person_id
            frames_with_ankles['session_id'] = int(session)
            frames_with_ankles['rep_id'] = repitition
            self.global_dataframe = pd.concat([self.global_dataframe, frames_with_ankles], axis = 0)

    def plotOpenPoseAverageConfidence(self):
        confidence_matrix = self.global_dataframe.filter(regex='_c$')
        avg_confidence = confidence_matrix.mean()

        print(avg_confidence.head())

        plt.bar([x[:-2] for x in avg_confidence.index], avg_confidence.values)
        plt.title('Openpose Average Confidence per Bodypart')
        plt.xlabel('Body parts')
        plt.ylabel('Confidence')
        plt.show()

    def setTrainingAndTestingForSingleSessionApproach(self, session_id: int, randomize: bool = False) -> pd.DataFrame:
        sessionData = self.global_dataframe[(self.global_dataframe['session_id'] == session_id)]
        sessionData['set'] = 'test'
        
        if not randomize:
            sessionData.loc[sessionData['rep_id'] <= 12, 'set'] = 'train'
        else:
            train_id_list = random.sample([x for x in range(1, 16)], 12) #randomly select 12 samples as training data
            for x in train_id_list:
                sessionData.loc[sessionData['rep_id'] == x, 'set'] = 'train'
            pass
        return sessionData

    def setTrainingAndTestingForMultiSessionApproach(self, randomize: bool = False) -> pd.DataFrame:
        data = self.global_dataframe
        data['set'] = 'test'
        if not randomize:
            data.loc[data['rep_id'] <= 12, 'set'] = 'train'
        else:
            train_id_list = random.sample([x for x in range(1, 16)], 12) #randomly select 12 samples as training data
            for x in train_id_list:
                data.loc[data['rep_id'] == x, 'set'] = 'train'
            
        return data
    



    def plot_confusion_matrix(self, labels_true, labels_pred):
        from sklearn.metrics import confusion_matrix, accuracy_score, recall_score, f1_score

        cm = confusion_matrix(labels_true, labels_pred)
        accuracy = accuracy_score(labels_true, labels_pred)
        recall = recall_score(labels_true, labels_pred, average='weighted')
        f1 = f1_score(labels_true, labels_pred, average='weighted')


        plt.figure(figsize=(10, 8))
        sns.heatmap(cm, annot=True, fmt='d', cmap='Blues', cbar=False)
        plt.xlabel('Predicted label')
        plt.ylabel('True label')
        plt.title('Confusion Matrix')
        plt.text(0.5, -0.1, f'Accuracy: {accuracy:.2f}\nRecall: {recall:.2f}\nF1-Score: {f1:.2f}', size=8, ha='center', transform=plt.gca().transAxes)
        plt.show()

    def plot_pdbiometrics_average_confidence(self, pred, pred_proba):
        label_count = {}
        label_pred_prob_sum = {}
        average_values = {}
        cur_row = 0
        for i in pred:
            if i not in label_count:
                label_count[i] = 1
            else:
                label_count[i] += 1
         
            predicted_value = pred_proba[cur_row, i - 1]
            
            if i not in label_pred_prob_sum:
                label_pred_prob_sum[i] = predicted_value
            else:
                label_pred_prob_sum[i] += predicted_value
            cur_row += 1
        
        for i in range(1, len(label_pred_prob_sum) + 1):
            average_values[i] = label_pred_prob_sum[i] / label_count[i]

        print(average_values)
        plt.bar(average_values.keys(), average_values.values())
        plt.title('PD-Biometrics frame-based average confidence on predicting users')
        plt.xlabel('Users')
        plt.ylabel('Confidence')
        plt.show()
    
    def setUpXMatrix(self, data: pd.DataFrame, set_name: str, data_idx, columns_to_exclude: list = []) -> pd.DataFrame:
        return data.loc[data.set == set_name].iloc[:, data_idx:].drop(columns=data.columns[data.columns.str.endswith('_c')]).drop(columns=sum([['set', 'rep_id', 'session_id'], columns_to_exclude], []))

    def setUpYVector(self, data: pd.DataFrame, set_name: str) -> pd.DataFrame:
        return data.loc[data.set == set_name]['person_id']


    def trainAndTestKNeighboursClassifier(self, approach: str, session_id: int = 1) -> KNeighborsClassifier:
        
        #data = None
        if approach == 'single':
            data = self.setTrainingAndTestingForSingleSessionApproach(session_id=session_id)
        else:
            data = self.setTrainingAndTestingForMultiSessionApproach()
        model = KNeighborsClassifier(n_neighbors=3, weights="distance")
        
        x_train = self.setUpXMatrix(data, 'train', 2, ['rear_x', 'rear_y', 'rear_z', 
                                                       'lear_x', 'lear_y', 'lear_z', 
                                                       'lbigtoe_x', 'lbigtoe_y', 'lbigtoe_z', 
                                                       'rbigtoe_x', 'rbigtoe_y', 'rbigtoe_z', 
                                                       'lsmalltoe_x', 'lsmalltoe_y', 'lsmalltoe_z',
                                                       'rsmalltoe_x', 'rmsalltoe_y', 'rsmalltoe_z', 
                                                       'lheel_x', 'lheel_y', 'lheel_z',
                                                       'rheel_x', 'rheel_y', 'rheel_z'])
        y_train = self.setUpYVector(data, 'train')

        model.fit(x_train, y_train)

        x_test = self.setUpXMatrix(data, 'test', 2, ['rear_x', 'rear_y', 'rear_z', 
                                                       'lear_x', 'lear_y', 'lear_z', 
                                                       'lbigtoe_x', 'lbigtoe_y', 'lbigtoe_z', 
                                                       'rbigtoe_x', 'rbigtoe_y', 'rbigtoe_z', 
                                                       'lsmalltoe_x', 'lsmalltoe_y', 'lsmalltoe_z',
                                                       'rsmalltoe_x', 'rmsalltoe_y', 'rsmalltoe_z', 
                                                       'lheel_x', 'lheel_y', 'lheel_z',
                                                       'rheel_x', 'rheel_y', 'rheel_z'])
        y_test = self.setUpYVector(data, 'test')

        pred = model.predict(x_test)
        pred_proba = model.predict_proba(x_test)

        self.plot_confusion_matrix(y_test, pred)


    def trainAndTestMulticlassRandomForest(self, approach: str, session_id: int = 1, randomize: bool = False):
        if approach == 'single':
            data = self.setTrainingAndTestingForSingleSessionApproach(session_id, randomize)
        else:
            data = self.setTrainingAndTestingForMultiSessionApproach(randomize)

        
        model = RandomForestClassifier()

         
        x_train = self.setUpXMatrix(data, 'train', 2, ['rear_x', 'rear_y', 'rear_z', 
                                                       'lear_x', 'lear_y', 'lear_z', 
                                                       'lbigtoe_x', 'lbigtoe_y', 'lbigtoe_z', 
                                                       'rbigtoe_x', 'rbigtoe_y', 'rbigtoe_z', 
                                                       'lsmalltoe_x', 'lsmalltoe_y', 'lsmalltoe_z',
                                                       'rsmalltoe_x', 'rmsalltoe_y', 'rsmalltoe_z', 
                                                       'lheel_x', 'lheel_y', 'lheel_z',
                                                       'rheel_x', 'rheel_y', 'rheel_z'])
        y_train = self.setUpYVector(data, 'train')

        model.fit(x_train, y_train)

        x_test = self.setUpXMatrix(data, 'test', 2, ['rear_x', 'rear_y', 'rear_z', 
                                                       'lear_x', 'lear_y', 'lear_z', 
                                                       'lbigtoe_x', 'lbigtoe_y', 'lbigtoe_z', 
                                                       'rbigtoe_x', 'rbigtoe_y', 'rbigtoe_z', 
                                                       'lsmalltoe_x', 'lsmalltoe_y', 'lsmalltoe_z',
                                                       'rsmalltoe_x', 'rmsalltoe_y', 'rsmalltoe_z', 
                                                       'lheel_x', 'lheel_y', 'lheel_z',
                                                       'rheel_x', 'rheel_y', 'rheel_z'])
        y_test = self.setUpYVector(data, 'test')

        feature_importances = model.feature_importances_

        print("Feature importances: ")
        for i, importance in enumerate(feature_importances):
            print(f"Feature {i}: {importance:.3f}")


        pred = model.predict(x_test)
        model.feature_importances_
        self.plot_confusion_matrix(y_test, pred)



        
    
    

