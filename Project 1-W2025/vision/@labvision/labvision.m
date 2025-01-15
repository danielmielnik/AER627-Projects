classdef labvision < handle
    %This class can be used to capture, localize and visualize scenes
    %containing Apriltag fiducials. This intended to be used with the AER627 projects
    %
    %Feel free to extend the functionality of this class (if you do, its better to define an inherited class,
    %that way any bug-fixes can be iautomatically incorporated by updating
    %the parent class.
    
    % This work is licensed under the Creative Commons Attribution 4.0 International License.
    % To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/
    % or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
    properties
        
        vid=[];
        src=[];
        calib;
        %tags
        origin_tag = [];
        vehicle_tag = [];
        obstacle_tags = [];
        tag_list = zeros(1,256);
        quad_decimate = 1.0;
    end
    
    properties (Transient = true)
    end
    
    methods
        function lv = labvision(video_rec, cam_calib)
            %The constructor needs a valid camera calibration object;
            %vid_rect contains information about the desired video source
            %and format
            lv.vid = videoinput(video_rec.vid_type, video_rec.src_num, video_rec.img_format);
            lv.src = getselectedsource(lv.vid);
            lv.vid.FramesPerTrigger = 1;
            lv.vid.ReturnedColorspace = 'grayscale';
            if isa(cam_calib,'cameraParameters')
                lv.calib = cam_calib;
            else
                error('Invalid camera calibration. Please pass in a valid cameraParameters object')
            end
        end
        
        function delete(lv)
            if ~isempty(lv.vid)
                delete(lv.vid);
                lv.vid = [];
            end
        end
        
        %        reset_cam(lv);
        
        ret = save_tag_obj(lv, tag_obj)
        raw_img = get_img(lv)
        
        
        scene_rec = get_scene(lv, img)
        
        scene_map = get_image_map(lv, scene_rec);
        scene_map = capture_scene(lv);
        
        
    end
    
    
end