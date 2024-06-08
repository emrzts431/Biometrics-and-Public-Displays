import os
import pandas as pd
from joint_indexes import body_parts


data_path = "/Volumes/Mac External SSD/Emre Private/Uni/Biometrics/Alia/PDLogs/"
write_folder = './preprocessed_data/'


user_list = os.listdir(data_path)
tmp = []
for user in user_list:
    log_index = 0
    try:
        user_data_list = os.listdir(f'{data_path}{user}')
        for data in user_data_list:
            try:
                file_name = f"{data_path}{user}/{data}/logs.tsv"
                log_file = pd.read_csv(file_name, sep='\t')
                for bp in body_parts:
                    try:
                        log_file[[f'{bp}_x', f'{bp}_y', f'{bp}_z', f'{bp}_c']] = log_file[bp].str.split(',', expand=True)
                        log_file = log_file.drop(columns=[bp])
                    except Exception as e:
                        print(e)
                        continue
                new_log_path = f'{write_folder}{user}/{log_index}/'
                os.makedirs(new_log_path, exist_ok=True)
                log_file = log_file.drop(columns=['background', 'person_id'])
                log_file.to_csv(new_log_path + '/logs.tsv', sep='\t')
                log_index+=1
            except Exception as e:
                print(e)
                continue    
    except Exception as e:
        print(e)
        continue

