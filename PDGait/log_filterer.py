import os

def createPreprocessedFolder():

    RANKLE_INDEX = 13
    LANKLE_INDEX = 16

    data_path = '/Volumes/Mac External SSD/Emre Private/Uni/Biometrics/Alia/PDLogs/'
    original_logs = './data_list/list.txt'


    #read the data list
    log_lines = []
    with open(original_logs, 'r') as f:
        log_lines = f.readlines()

    log_lines = [x.replace('\n', '') for x in log_lines]

    for log_line in log_lines:
        components = log_line.split(' ')
        label = components[1]
        log_path = components[0]
        folder_name = log_path.split('/')[0]
        print(folder_name)
        with open(rf'{data_path}{log_path}', 'r') as log_file:
            rows = log_file.readlines()
            if len(rows) < 100:
                continue
            else:
                new_path = f'./preprocessed_data/{folder_name}/logs.tsv'
                if not os.path.exists(f'./preprocessed_data/{folder_name}'):
                    os.mkdir(f'./preprocessed_data/{folder_name}')
                filtered_rows = []
                for row in rows:
                    inputs = row.split('\t')
                    
                    if inputs[RANKLE_INDEX] != '0,0,0,0' or inputs[LANKLE_INDEX] != '0,0,0,0':
                        filtered_rows.append(row)
                with open(new_path, 'w') as new_file:
                    new_file.writelines(filtered_rows)
                

     
