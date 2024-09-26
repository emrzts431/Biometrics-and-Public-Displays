body_parts = [
    "nose",
    "neck",
    "rshoulder",
    "relbow",
    "rwrist",
    "lshoulder",
    "lelbow",
    "lwrist",
    "midhip",
    "rhip",
    "rknee",
    "rankle",
    "lhip",
    "lknee",
    "lankle",
    "reye",
    "leye",
    "rear",
    "lear",
    "lbigtoe",
    "lsmalltoe",
    "lheel",
    "rbigtoe",
    "rsmalltoe",
    "rheel",
]

connections = [
    # Face
    ('nose', 'neck'),
    ('nose', 'reye'),
    ('nose', 'leye'),
    
    # Torso
    ('neck', 'rshoulder'),
    ('rshoulder', 'relbow'),
    ('relbow', 'rwrist'),
    ('neck', 'lshoulder'),
    ('lshoulder', 'lelbow'),
    ('lelbow', 'lwrist'),
    ('neck', 'midhip'),
    ('rshoulder', 'lshoulder'),
    ('rhip', 'rshoulder'),
    ('lhip', 'lshoulder'),
    ('rhip', 'lhip'),
    
    # Right Leg
    ('rhip', 'rknee'),
    ('rknee', 'rankle'),
    ('rankle', 'rheel'),
    #('rheel', 'right_foot_index'),
   # ('rankle', 'right_foot_index'),
    
    # Left Leg
    ('lhip', 'lknee'),
    ('lknee', 'lankle'),
    ('lankle', 'lheel'),
    #('lheel', 'left_foot_index'),
   # ('lankle', 'left_foot_index'),
    
    # Right Arm
    ('rwrist', 'relbow'),
    ('relbow', 'rshoulder'),
    
    # Left Arm
    ('lwrist', 'lelbow'),
    ('lelbow', 'lshoulder'),
    
    # Eyes to Ears
    #('reye', 'rear'),
    #('leye', 'lear'),
]