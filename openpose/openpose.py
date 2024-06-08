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
    "RHeel",
    "Background"
]

#region important files
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

    subprocess.run([openpose_program, '--image_dir', rf'{image_folder}\color', '--net_resolution', '-1x128', '--write_json' , rf'{openpose_path}\json', '--write_images', rf'{openpose_path}\image'])
    #endregion
    logfile = rf'{logs_write_folder}\{0 if num_folders == 0 else num_folders}\logs.tsv'
    with open(logfile, 'w') as f:
        f.write('timestamp\tperson_id\tnose\tneck\trshoulder\trelbow\trwrist\tlshoulder\tlelbow\tlwrist\tmidhip\trhip\trknee\trankle\tlhip\tlknee\tlankle\treye\tleye\trear\tlear\tlbigtoe\tlsmalltoe\tlheel\trbigtoe\trsmalltoe\trheel\tbackground\n')


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
                    log_string += '\t'+ str(coordinates[0])+','+str(coordinates[1])+','+str(z)+','+str(coordinates[2])
                log_string += '\n'
                person_index += 1
                f.write(log_string)
        
        #endregion
    print(len(frames))


    
