import os
import log_filterer

data_path = "/Volumes/Mac External SSD/Emre Private/Uni/Biometrics/Alia/PDLogs/"

alia = (0, 9)
emre = (10, 19)
jonathan = (22, 31)

labels = [0,1,2]

data_list = os.listdir(data_path)
tmp = []
for x in data_list:
    try:
        t = int(x)
        tmp.append(x)
    except:
        continue
data_list = tmp
data_list.sort(key=lambda x : int(x))
print(f"Preprocessing list: {data_list}")

if not os.path.exists('./data_list'):
    os.mkdir('data_list')

#region Create data list with labels
with open('data_list/list.txt', 'w') as f:
    for data_folder in data_list:
        if alia[0] <= int(data_folder) <= alia[1]:
            f.write(f"{data_folder}/logs.tsv {labels[0]}\n")
        elif emre[0] <= int(data_folder) <= emre[1]:
            f.write(f"{data_folder}/logs.tsv {labels[1]}\n")
        else:
            f.write(f"{data_folder}/logs.tsv {labels[2]}\n")
#endregion

#log_filterer.createPreprocessedFolder()

#TODO: Select important joints, check the confidence (should be >= 70), fine tune the z value, create a new folder named final folder and update data_list