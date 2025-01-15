img = imread('sample/apriltag_sample.jpg');
load sample/camera_calibration 

img2 = rgb2gray(img); 

h = 112;

K = cameraParams.IntrinsicMatrix'; 

tags = apriltags(img2, h, K);