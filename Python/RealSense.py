# First import the library
import pyrealsense2 as rs
import numpy as np
import cv2
import datetime
import os
import msvcrt
import sys
import imageio

#documents_path = os.path.join(os.path.expanduser("~"), "Documents")
documents_path = r'D:\\Emre'
if not os.path.exists(rf"{documents_path}\CameraLogs"):
    os.mkdir(rf"{documents_path}\CameraLogs")

camerafilename_depth = None
camerafilename_color = None

#region Configure depth and color streams
pipeline = rs.pipeline()
config = rs.config()
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

pause = True
stop = False
restart = False
#endregion

#region Create necesarry folders
def create_folders():
    now = datetime.datetime.now().__str__().replace(' ', '').replace(':', "_").replace('.','_').replace('-', '_')
    global camerafilename_depth
    camerafilename_depth = rf"{documents_path}\CameraLogs\{now}\depth\frame"
    global camerafilename_color
    camerafilename_color = rf"{documents_path}\CameraLogs\{now}\color\frame"
    cameradoc =  rf"{documents_path}\CameraLogs\{now}"

    if not os.path.exists(cameradoc):
        os.mkdir(cameradoc)
        os.mkdir(rf"{cameradoc}\depth")
        os.mkdir(rf"{cameradoc}\color")

#endregion

#region Main Loop
def start_record():
    global stop
    global restart
    global pause
    global pipeline
    create_folders()
    try:
        profile = pipeline.start(config)
        depth_sensor = profile.get_device().first_depth_sensor()
        depth_sensor.set_option(
            rs.option.visual_preset, 3
        )  # Set high accuracy for depth sensor
        depth_scale = depth_sensor.get_depth_scale()
        align_to = rs.stream.color
        align = rs.align(align_to)
        print("Depth Scale is: " , depth_scale)
        i = 0
        print("Hasn't started recording...")
        while True:
            if msvcrt.kbhit():
                key = msvcrt.getch()
                if key == b'p':
                    pause = not pause
                    if pause:
                        print("Stopped recording ||")
                    else:
                        print("Resumed recording >")
                elif key == b'x':
                    stop = True
                    print("Shutting down program...")
                elif key == b'r':
                    restart = True

            if not stop and not restart:
                # Wait for a coherent pair of frames: depth and color
                frames = pipeline.wait_for_frames()
                aligned_frames = align.process(frames)
                #aligned_depth_frame = aligned_frames.get_depth_frame()
                depth_frame = aligned_frames.get_depth_frame()#depth_frame = frames.get_depth_frame()#
                color_frame = aligned_frames.get_color_frame()#color_frame = frames.get_color_frame()#
                if not depth_frame or not color_frame:
                    continue

                # Convert images to numpy arrays
                depth_image = np.asanyarray(depth_frame.get_data())#2D matrix
                color_image = np.asanyarray(color_frame.get_data())

               
                now_frame = datetime.datetime.now().timestamp()
                
                if not pause:
                    cv2.imwrite(camerafilename_color + f'_{str(now_frame)}.jpg',color_image)
                    cv2.imwrite(camerafilename_depth + f'_{str(now_frame)}.png', depth_image)
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
            else:
                break
    finally:
        # Stop streaming
        pipeline.stop()
#endregion
        
while True:
    if not stop:
        if restart:
            restart = False
            pause = True
        start_record()
    else:
        break
