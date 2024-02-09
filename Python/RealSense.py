# First import the library
import pyrealsense2 as rs
import numpy as np
import cv2
import datetime
import os
import asyncio



array_list = []



# Configure depth and color streams
now = datetime.datetime.now().__str__().replace(' ', '').replace(':', "_").replace('.','_').replace('-', '_')
camerafilename = rf"C:\Users\erme4\Documents\CameraLogs\{now}\frame"
cameradoc =  rf"C:\Users\erme4\Documents\CameraLogs\{now}"


"""Idea Storing depth frames

Step-1: Create a temporary store file and save every 500 frames on it. 
Step-2: after the number of files reaches 500, read these files, compress them and dump them into the original folder
"""


if not os.path.exists(cameradoc):
    os.mkdir(cameradoc)

pipeline = rs.pipeline()
config = rs.config()

async def save_image(depth_array, color_array, lock):
    async with lock:
        print("started corotuine")
        array_list.append(depth_array)
        array_list.append(color_array)
        print("added images to array")
        if len(array_list) == 1000:
            print("Dumping arrays...")
            np.savez_compressed(camerafilename + f'_{str(datetime.datetime.now().timestamp())}.npz', *array_list)
            array_list.clear()
        
# Get device product line for setting a supporting resolution
pipeline_wrapper = rs.pipeline_wrapper(pipeline)
pipeline_profile = config.resolve(pipeline_wrapper)
device = pipeline_profile.get_device()
device_product_line = str(device.get_info(rs.camera_info.product_line))

found_rgb = False
for s in device.sensors:
    if s.get_info(rs.camera_info.name) == 'RGB Camera':
        found_rgb = True
        break
if not found_rgb:
    print("The demo requires Depth camera with Color sensor")
    exit(0)

config.enable_stream(rs.stream.depth, 640, 480, rs.format.z16, 30)

if device_product_line == 'L500':
    config.enable_stream(rs.stream.color, 960, 540, rs.format.bgr8, 30)
else:
    config.enable_stream(rs.stream.color, 640, 480, rs.format.bgr8, 30)

# Start streaming
pipeline.start(config)
try:
    i = 0
    while True:

        # Wait for a coherent pair of frames: depth and color
        frames = pipeline.wait_for_frames()
        depth_frame = frames.get_depth_frame()
        color_frame = frames.get_color_frame()
        if not depth_frame or not color_frame:
            continue

        # Convert images to numpy arrays
        depth_image = np.asanyarray(depth_frame.get_data())#2D matrix
        color_image = np.asanyarray(color_frame.get_data())

        #task = asyncio.create_task(save_image(depth_image, color_image, lock))
        now = datetime.datetime.now().timestamp()
        #np.savez_compressed(camerafilename + f'_{str(now)}', depth=depth_image, color=color_image)
       
        cv2.imwrite(camerafilename + f'_{str(now)}.png', depth_image, [cv2.IMWRITE_PNG_COMPRESSION, 9] )
        cv2.imwrite(camerafilename + f'_{str(now)}.jpg',color_image, [cv2.IMWRITE_JPEG_QUALITY, 90] )
        # Apply colormap on depth image (image must be converted to 8-bit per pixel first)
        depth_colormap = cv2.applyColorMap(cv2.convertScaleAbs(depth_image, alpha=0.03), cv2.COLORMAP_JET)

        depth_colormap_dim = depth_colormap.shape
        color_colormap_dim = color_image.shape

        # If depth and color resolutions are different, resize color image to match depth image for display
        if depth_colormap_dim != color_colormap_dim:
            resized_color_image = cv2.resize(color_image, dsize=(depth_colormap_dim[1], depth_colormap_dim[0]), interpolation=cv2.INTER_AREA)
            images = np.hstack((resized_color_image, depth_colormap))
        else:
            images = np.hstack((color_image, depth_colormap))

        # Show images
        cv2.namedWindow('RealSense', cv2.WINDOW_AUTOSIZE)
        cv2.imshow('RealSense', images)
        cv2.waitKey(1)

finally:
    #await 
    # Stop streaming
    pipeline.stop()