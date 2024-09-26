import matplotlib.cm
import matplotlib.font_manager
import pandas as pd
from glob import glob
import os
import numpy as np
import matplotlib.pyplot as plt
import matplotlib
import matplotlib
import seaborn as sns
from sklearn.neighbors import KNeighborsClassifier
from sklearn.ensemble import RandomForestClassifier
import random
from body_parts import body_parts, connections

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
    
    def find3dDistance(self, df: pd.DataFrame, body_part1:str, body_part2:str) -> pd.DataFrame:
        return ((df[f'{body_part1}_x']-df[f'{body_part2}_x'])**2 + (df[f'{body_part1}_y'] - df[f'{body_part2}_y'])**2 + (df[f'{body_part1}_z'] - df[f'{body_part2}_z'])**2) ** (1/2)

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
            frames_with_ankles['shoulder_width'] = self.find3dDistance(frames_with_ankles, 'lshoulder', 'rshoulder')
            frames_with_ankles['neck_rshoulder'] = self.find3dDistance(frames_with_ankles, 'neck', 'rshoulder')
            frames_with_ankles['neck_lshoulder'] = self.find3dDistance(frames_with_ankles, 'neck', 'lshoulder')
            frames_with_ankles['neck_rwrist'] = self.find3dDistance(frames_with_ankles, 'neck', 'rwrist')
            frames_with_ankles['neck_lwrist'] = self.find3dDistance(frames_with_ankles, 'neck', 'lwrist')
            frames_with_ankles['neck_relbow'] = self.find3dDistance(frames_with_ankles, 'neck', 'relbow')
            frames_with_ankles['neck_lelbow'] = self.find3dDistance(frames_with_ankles, 'neck', 'lelbow')
            frames_with_ankles['neck_rhip'] = self.find3dDistance(frames_with_ankles, 'neck', 'rhip')
            frames_with_ankles['neck_lhip'] = self.find3dDistance(frames_with_ankles, 'neck', 'lhip')
            frames_with_ankles['neck_midhip'] = self.find3dDistance(frames_with_ankles, 'neck', 'midhip')
            frames_with_ankles['neck_lknee'] = self.find3dDistance(frames_with_ankles, 'neck', 'lknee')
            frames_with_ankles['neck_rknee'] = self.find3dDistance(frames_with_ankles, 'neck', 'rknee')

            self.global_dataframe = pd.concat([self.global_dataframe, frames_with_ankles], axis = 0)
        #print(self.global_dataframe['shoulder_width'])

    def plotOpenPoseAverageConfidence(self):
        confidence_matrix = self.global_dataframe.filter(regex='_c$')
        avg_confidence = confidence_matrix.mean()

        # cmap = matplotlib.cm.get_cmap('tab20')
        # colors = cmap(np.linspace(0,1, len(body_parts)))

        plt.figure(figsize=(6,4))
        plt.bar([x[:-2] for x in avg_confidence.index], avg_confidence.values)
        #plt.xticks([x for x in range(len(avg_confidence.index))])
        plt.xticks(rotation=80)
        plt.title('Openpose Average Confidence per Bodypart')
        plt.xlabel('Body parts')
        plt.ylabel('Confidence')
        plt.show()

    def setTestingAndTrainingSetManuallyForSingleSessionApproach(self, train_list: list, session_id: int = 1) -> pd.DataFrame:
        print(f'setting up training for list: {train_list}')
        sessionData = self.global_dataframe[(self.global_dataframe['session_id'] == session_id)]
        sessionData['set'] = 'test'
        for x in train_list:
            sessionData.loc[sessionData['rep_id'] == x, 'set'] = 'train'
        return sessionData
    
    def setTestingAndTrainingSetManuallyForMultiSessionApproach(self, train_list: list) -> pd.DataFrame:
        data = self.global_dataframe
        data['set'] = 'test'
        for x in train_list:
            data.loc[(data['set'] == x), 'set'] = 'train'
        return data

    def setTrainingAndTestingForSingleSessionApproach(self, session_id: int, randomize: bool = False) -> pd.DataFrame:
        sessionData = self.global_dataframe[(self.global_dataframe['session_id'] == session_id)]
        sessionData['set'] = 'test'
        
        if not randomize:
            sessionData.loc[sessionData['rep_id'] <= 12, 'set'] = 'train'
        else:
            train_id_list = random.sample([x for x in range(1, 16)], 12) #randomly select 12 samples as training data
            print(train_id_list)
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
            print(train_id_list)
            for x in train_id_list:
                data.loc[data['rep_id'] == x, 'set'] = 'train'
            
        return data
    

    def plotNumberOfFramesForEachSession(self):
        num_frames_session_1 = len(self.global_dataframe[self.global_dataframe['session_id'] == 1])
        nunm_frames_session_2 = len(self.global_dataframe[self.global_dataframe['session_id'] == 2])
        num_frames_session3 = len(self.global_dataframe[self.global_dataframe['session_id'] == 3])
        len_frames = [num_frames_session_1, nunm_frames_session_2, num_frames_session3]
        print(len_frames)
        plt.figure(figsize=(5,4))
        plt.plot(['Session 1', 'Session 2', 'Session 3'], len_frames, marker='o')
        plt.xlabel('Session')
        plt.ylabel('Number of frames')
        plt.title('Number of total frames in each session')
        plt.show()

    def plot_confusion_matrix(self, labels_true, labels_pred):
        from sklearn.metrics import confusion_matrix, accuracy_score, recall_score, f1_score, precision_score, precision_recall_curve

        cm = confusion_matrix(labels_true, labels_pred)
        accuracy = accuracy_score(labels_true, labels_pred)
        precision = precision_score(labels_true, labels_pred, average='weighted')
        recall = recall_score(labels_true, labels_pred, average='weighted')
        f1 = f1_score(labels_true, labels_pred, average='weighted')
        

        plt.figure(figsize=(7, 7))
        sns.heatmap(cm, annot=True, fmt='d', cmap='Blues', cbar=False)
        plt.xlabel('Predicted label')
        plt.ylabel('True label')
        plt.title('Confusion Matrix')
        plt.text(0.5, -0.1, f'Accuracy: {accuracy:.2f} Precision: {precision:.2f} Recall: {recall:.2f} F1-Score: {f1:.2f}', size=8, ha='center', transform=plt.gca().transAxes)
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
        plt.figure(figsize=4.9)
        
        plt.bar(average_values.keys(), average_values.values())
        plt.title('PD-Biometrics frame-based average confidence on predicting users')
        plt.xlabel('Users')
        plt.ylabel('Confidence')
        plt.show()
    
    def setUpXMatrix(self, data: pd.DataFrame, set_name: str, data_idx, columns_to_exclude: list = []) -> pd.DataFrame:
        return data.loc[data.set == set_name].iloc[:, data_idx:].drop(columns=data.columns[(data.columns.str.endswith('_c')) | (data.columns.str.endswith('_C'))]).drop(columns=sum([['set', 'rep_id', 'session_id'], columns_to_exclude], []))

    def setUpYVector(self, data: pd.DataFrame, set_name: str) -> pd.DataFrame:
        return data.loc[data.set == set_name]['person_id']

    def plotFeatureImportance(self, feature_importance_list_coordinates: list, feature_importance_list_extra: list):
        x_values = feature_importance_list_coordinates[::3]
        y_values = feature_importance_list_coordinates[1::3]
        z_values = feature_importance_list_coordinates[2::3]


        x_axis = np.arange(len(x_values))
        width = 0.2
        # font = {'family': 'normal', 'size': 19}
        # matplotlib.rc('font', **font)
        #plot the data in a grouped manner
        plt.figure(figsize=(7,5))
        plt.bar(x_axis-0.2, x_values, width=width, color='cyan')
        plt.bar(x_axis, y_values, width=width, color='orange')
        plt.bar(x_axis+0.2, z_values, width=width, color='green')
        plt.xticks(x_axis, [x.split('_')[0] for x in body_parts[:len(x_values)]], rotation=80)
        plt.xlabel('Features')
        plt.ylabel('Mean Decrease in Impurity (MDI) Score')
        plt.title('Feature Importance Body Part Coordinates')
        plt.legend(['x', 'y', 'z'])
        plt.show()

        plt.figure(figsize=(6,4))
        plt.bar(['shoulder_width', 'neck_rshoulder', 'neck_lshoulder', 'neck_rwrist', 'neck_lwrist', 'neck_relbow', 'neck_lelbow', 'neck_rhip', 'neck_lhip', 'neck_midhip', 'neck_lknee', 'neck_rknee'], feature_importance_list_extra)
        plt.xlabel('Features')
        plt.ylabel('Mean Decrease in Impurity (MDI) Score')
        plt.title('Feature Importance Extra Features')
        plt.xticks(rotation=80)
        plt.show()

   

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


    def trainAndTestMulticlassRandomForest(self, approach: str, session_id: int = 1, randomize: bool = False, train_list: list = None):
        if train_list != None:
            if approach == 'single':
                data = self.setTestingAndTrainingSetManuallyForSingleSessionApproach(train_list=train_list, session_id=session_id)
            else:
                data = self.setTestingAndTrainingSetManuallyForMultiSessionApproach(train_list=train_list)
        else:
            if approach == 'single':
                data = self.setTrainingAndTestingForSingleSessionApproach(session_id, randomize)
            else:
                data = self.setTrainingAndTestingForMultiSessionApproach(randomize)

        
        model = RandomForestClassifier()

         
        x_train = self.setUpXMatrix(data, 'train', 2)

        
        y_train = self.setUpYVector(data, 'train')

        model.fit(x_train, y_train)

        x_test = self.setUpXMatrix(data, 'test', 2)
        y_test = self.setUpYVector(data, 'test')

        feature_importances = model.feature_importances_
        
        importances = []
        for i, importance in enumerate(feature_importances):
            importances.append(importance)
       
        self.plotFeatureImportance(importances[:-12], importances[-12:])

        pred = model.predict(x_test)
        self.plot_confusion_matrix(y_test, pred)



        
    
    

