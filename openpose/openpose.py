from typing import List
import subprocess
import os
import cv2
import numpy as np
import json
import datetime

class Person:
    def __init__(self):
        self.joint_coordinates = dict()

class Frame:
    def __init__(self, version:float, people) -> None:
        self.version = version
        self.people = people

documents_path = os.path.join(os.path.expanduser("~"), "Documents")
desktop_path = os.path.join(os.path.expanduser("~"), "Desktop")
if not os.path.exists(rf"{desktop_path}\PDLogs"):
    os.mkdir(rf"{desktop_path}\PDLogs")
body_parts = [
    "Nose",
    "Neck",
    "RShoulder",
    "RElbow",
    "RWrist",
    "LShoulder",
    "LElbow",
    "LWrist",
    "MidHip",
    "RHip",
    "RKnee",
    "RAnkle",
    "LHip",
    "LKnee",
    "LAnkle",
    "REye",
    "LEye",
    "REar",
    "LEar",
    "LBigToe",
    "LSmallToe",
    "LHeel",
    "RBigToe",
    "RSmallToe",
    "RHeel"
]

#region create important folders
openpose_program = r'bin\OpenPoseDemo.exe'

image_folder_list = os.listdir(rf"{documents_path}\CameraLogs")
image_folder_list.sort()
image_folder_name = image_folder_list[-1]
for f in image_folder_list:
    print(f)
    image_folder_name = f#str(input("Enter the image folder name: "))
    print(f"loading images from {image_folder_name}")
    image_folder = rf'{documents_path}\CameraLogs\{image_folder_name}'
    logs_write_folder = rf'{desktop_path}\PDLogs'
    num_folders = len(os.listdir(logs_write_folder))
    openpose_path = rf'{logs_write_folder}\{0 if num_folders == 0 else num_folders}\openpose'
    if not os.path.exists(rf'{logs_write_folder}\{0 if num_folders == 0 else num_folders}'):
        os.mkdir( rf'{logs_write_folder}\{0 if num_folders == 0 else num_folders}')
        os.mkdir(rf'{logs_write_folder}\{0 if num_folders == 0 else num_folders}\openpose')
        os.mkdir(rf'{logs_write_folder}\{0 if num_folders == 0 else num_folders}\openpose\json')
        os.mkdir(rf'{logs_write_folder}\{0 if num_folders == 0 else num_folders}\openpose\image')

subprocess.run([openpose_program, '--image_dir', rf'{image_folder}\color', '--net_resolution', '-1x128', '--write_json' , rf'{openpose_path}\json']) #'--write_images', rf'{openpose_path}\image'])
#endregion
logfile = rf'{logs_write_folder}\{0 if num_folders == 0 else num_folders}\logs.tsv'
with open(logfile, 'w') as f:
    #TODO: Seperate the x, y, z of the joints
    f.write('timestamp\tperson_id\tnose_x\tnose_y\tnose_z\tnose_c\tneck_x\tneck_y\tneck_z\tneck_c\trshoulder_x\trshoulder_y\trshoulder_z\trshoulder_c\trelbow_x\trelbow_y\trelbow_z\trelbow_c\trwrist_x\trwrist_y\trwrist_z\trwrist_c\tlshoulder_x\tlshoulder_y\tlshoulder_z\tlshoulder_c\tlelbow_x\tlelbow_y\tlelbow_z\tlelbow_c\tlwrist_x\tlwrist_y\tlwrist_z\tlwrist_c\tmidhip_x\tmidhip_y\tmidhip_z\tmidhip_C\trhip_x\trhip_y\trhip_z\trhip_c\trknee_x\trknee_y\trknee_z\trknee_c\trankle_x\trankle_y\trankle_z\trankle_c\tlhip_x\tlhip_y\tlhip_z\tlhip_c\tlknee_x\tlknee_y\tlknee_z\tlknee_c\tlankle_x\tlankle_y\tlankle_z\tlankle_c\treye_x\treye_y\treye_z\treye_c\tleye_x\tleye_y\tleye_z\tleye_c\trear_x\trear_y\trear_z\trear_c\tlear_x\tlear_y\tlear_z\tlear_c\tlbigtoe_x\tlbigtoe_y\tlbigtoe_z\tlbigtoe_c\tlsmalltoe_x\tlsmalltoe_y\tlsmalltoe_z\tlsmalltoe_c\tlheel_x\tlheel_y\tlheel_z\tlheel_c\trbigtoe_x\trbigtoe_y\trbigtoe_z\trbigtoe_c\trsmalltoe_x\trmsalltoe_y\trsmalltoe_z\trsmalltoe_c\trheel_x\trheel_y\trheel_z\trheel_c\n')


    frames = os.listdir(rf"{openpose_path}\json")
    frames.sort()

    for frame in frames:

        people_list = []
        #region Get people and their joint coordinates
        with open(rf"{openpose_path}\json\{frame}", 'r') as f:
            frame_content = f.readline()
            json_obj = json.loads(frame_content)
            poses = Frame(**json_obj)
            for person in poses.people: 
                p = Person()
                group_index = 0
                for i in range(0, len(person['pose_keypoints_2d']), 3):
                    p.joint_coordinates[body_parts[group_index]] = [person['pose_keypoints_2d'][i], person['pose_keypoints_2d'][i+1], person['pose_keypoints_2d'][i+2]]#example: {'Nose': [x, y, confidence]}
                    group_index+=1
                people_list.append(p)
        #endregion
                
        #region Find corresponding depth frame
        frame_components = frame.split("_")
        frame_name = frame_components[0] + "_" + frame_components[1]
        corresponding_depth_frame = np.asanyarray(cv2.imread(rf'{image_folder}\depth\{frame_name}.png'))
        #endregion

        #region Log the information
    
        with open(logfile, 'a') as f:
            person_index = 0
            for person in people_list:
                log_string = f"{frame_components[1]}\t{person_index}"
                for joint, coordinates in person.joint_coordinates.items():
                    if coordinates[0] > 480:
                        coordinates[0] = 480
                    if coordinates[1] > 640:
                        coordinates[1] = 640
                    z = max(corresponding_depth_frame[int(coordinates[1]), int(coordinates[0])])
                    log_string += '\t'+ str(coordinates[0])+'\t'+str(coordinates[1])+'\t'+str(z)+'\t'+str(coordinates[2])
                log_string += '\n'
                person_index += 1
                f.write(log_string)
        
        #endregion
    print(len(frames))


    
