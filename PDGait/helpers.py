import os
from joint_indexes import *
import pandas as pd
import numpy as np


#get feature limb length for training or testing (Deprecated)
def getLimbLengths(data_list) -> dict:
    preprocessed_data_folder = './preprocessed_data/'
    global data_list_lines
    data_list_lines = []
    labeled_data = {}
    for data_path in data_list:
        data_comps = data_path.split(' ')
        if data_comps[1] not in labeled_data:
            labeled_data[data_comps[1]] = []
        with open(preprocessed_data_folder + data_comps[0], 'r') as data_file:
            current_file = []
            frames = data_file.readlines()
            frames.pop(0)
            for frame in frames:
                frame = frame.split('\t')
                frame = frame[:-1]

                #region HEAD SECTION
                neck_values = frame[NECK_INDEX].split(',')
                nose_values = frame[NOSE_INDEX].split(',')
                #endregion

                #region HIP SECTION
                mid_hip_values = frame[MIDHIP_INDEX].split(',')
                l_hip_values = frame[LHIP_INDEX].split(',')
                r_hip_values = frame[RHIP_INDEX].split(',')
                #endregion

                #region SHOULDER SECTION
                rshoulder_values = frame[RSHOULDER_INDEX].split(',')
                lshoulder_values = frame[LSHOULDER_INDEX].split(',')
                #endregion

                #region ELBOW SECTION
                relbow_values = frame[RELBOW_INDEX].split(',')
                lelbow_values = frame[LELBOW_INDEX].split(',')
                #endregion

                #region WRIST SECTION
                rwrist_values = frame[RWRIST_INDEX].split(',')
                lwrist_values = frame[LWRIST_INDEX].split(',')
                #endregion

                #region KNEE SECTION
                rknee_values = frame[RKNEE_INDEX].split(',')
                lknee_values = frame[LKNEE_INDEX].split(',')
                #endregion

                #region ANKLE SECTION
                lankle_values = frame[LANKLE_INDEX].split(',')
                rankle_values = frame[RANKLE_INDEX].split(',')
                #endregion

                #region DISTANCES
                nose_neck_distance = calculate_distance(nose_values, neck_values)
                
                neck_midhip_distance = calculate_distance(neck_values, mid_hip_values)
                
                lhip_midhip_distance = calculate_distance(l_hip_values, mid_hip_values)
                rhip_midhip_distance = calculate_distance(r_hip_values, mid_hip_values)
                
                rhip_rknee_distance = calculate_distance(r_hip_values, rknee_values)
                lhip_lknee_distance = calculate_distance(l_hip_values, lknee_values)

                rknee_rankle_distance = calculate_distance(rknee_values, rankle_values)
                lknee_lankle_distance = calculate_distance(lknee_values, lankle_values)

                rshoulder_neck_distance = calculate_distance(rshoulder_values, neck_values)
                lshoulder_neck_distance = calculate_distance(lshoulder_values, neck_values)

                rshoulder_relbow_distance = calculate_distance(rshoulder_values, relbow_values)
                lshoulder_lelbow_distance = calculate_distance(lshoulder_values, lelbow_values)

                relbow_rwrist_distance = calculate_distance(relbow_values, rwrist_values)
                lelbow_lwrist_distance = calculate_distance(lelbow_values, lwrist_values)

                frame_values = [
                    float(frame[0]), nose_neck_distance, neck_midhip_distance, 
                    lhip_midhip_distance, rhip_midhip_distance, rhip_rknee_distance, 
                    lhip_lknee_distance, rknee_rankle_distance, lknee_lankle_distance,
                    rshoulder_neck_distance, lshoulder_neck_distance, rshoulder_relbow_distance,
                    lshoulder_lelbow_distance, relbow_rwrist_distance, lelbow_lwrist_distance
                ]
                #endregion

                current_file.append(frame_values)
            
            labeled_data[data_comps[1]].append(current_file)
    return labeled_data

def getDistanceArray(data: pd.DataFrame, bp1: str, bp2: str):
    return np.sqrt(
        ((data[f'{bp1}_x'] - data[f'{bp2}_x']) ** 2) +
        ((data[f'{bp1}_y'] - data[f'{bp2}_y']) ** 2) +
        ((data[f'{bp1}_z'] - data[f'{bp2}_z']) ** 2)
    )


        


def create_confidence_graph(file):
    pass

def calculate_distance(joint1, joint2):
    x1, y1, z1 = int(float(joint1[0])), int(float(joint1[1])), int(float(joint1[2]))
    x2, y2, z2 = int(float(joint2[0])), int(float(joint2[1])), int(float(joint2[2]))
    
    return int(( (x2 - x1)**2 + (y2 - y1)**2 + (z2 - z1)**2 )**(1/2))