%Setup Script for Apriltag recognition.
%Note: This is included for example purposes *ONLY*. You will need to have
%a look at the apriltag_obj and labvision class definitions to understand
%what these classes can do for you.

vid_rec.vid_type = 'winvideo';
vid_rec.src_num = 3;
vid_rec.img_format =  'RGB24_1920x1080';

calib = load('sample/camera_calibration.mat');
cam_calib = calib.cameraParams;

lv = labvision(vid_rec, cam_calib);

%% Define tag records
at_origin = apriltag_obj(50,'origin',[],80);
at_vehicle = apriltag_obj(51, 'vehicle',[-20 20 -10 10], 80);
at_obstacle1 = apriltag_obj(52, 'obstacle',[-60 60 -60 60], 80);
at_obstacle2 = apriltag_obj(53, 'obstacle',[-100 100 -50 50], 80);

lv.save_tag_obj(at_origin);
lv.save_tag_obj(at_vehicle);
lv.save_tag_obj(at_obstacle1);
lv.save_tag_obj(at_obstacle2);

%% Capture and plot scene
lv.capture_scene;
