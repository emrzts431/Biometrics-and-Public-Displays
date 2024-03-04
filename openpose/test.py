import os
path = r"C:\Users\erme4\Desktop\PDLogs\3\openpose\json"
frames = os.listdir(path)
frames.sort()
i = 0
for frame in frames:
    print(frame)
    i+=1
print(i)