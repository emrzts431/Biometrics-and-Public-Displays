import os
import helpers
import pandas as pd
import numpy as np
from joint_indexes import *



def get_feature_and_label_list():
    data_path = './preprocessed_data/'

    user_list = os.listdir(data_path)
    feature_list = []
    label_list = []
    for user in user_list:
        try:
            user_data_list = os.listdir(f'{data_path}{user}')
            for data in user_data_list:
                try:
                    file_name = f"{data_path}{user}/{data}/logs.tsv"
                    log_file = pd.read_csv(file_name, sep='\t')
                    
                    frames_with_ankles = log_file[(log_file['lankle_c'] != 0) & (log_file['rankle_c'] != 0)]
                    frames_with_ankles.replace(0, np.nan)
                    frames_with_ankles.interpolate('linear')
                    
                    feature = pd.DataFrame()
                    #region Distance calculation    
                    feature['h_to_lwrist'] = helpers.getDistanceArray(frames_with_ankles, 'nose', 'lwrist')
                    feature['h_to_rwrist'] = helpers.getDistanceArray(frames_with_ankles, 'nose', 'rwrist')
                    feature['h_to_midhip'] = helpers.getDistanceArray(frames_with_ankles, 'nose', 'midhip')
                    feature['h_to_rhip'] = helpers.getDistanceArray(frames_with_ankles, 'nose', 'rhip')
                    feature['h_to_lhip'] = helpers.getDistanceArray(frames_with_ankles, 'nose', 'lhip')
                    feature['h_to_lankle'] = helpers.getDistanceArray(frames_with_ankles, 'nose', 'lankle')
                    feature['h_to_rankle'] = helpers.getDistanceArray(frames_with_ankles, 'nose', 'rankle')
                    feature_list.append(feature)
                    label_list.append(user.split('_')[-1])
                    #endregion
                except:
                    continue    
        except:
            continue
        
    return feature_list, label_list