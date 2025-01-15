function scene_rec = get_scene(lv, img)
%Collect the necessary information about the image scene. This processes
%all the relative transforms between objects.

% This work is licensed under the Creative Commons Attribution 3.0 Unported License.
% To view a copy of this license, visit http://creativecommons.org/licenses/by/3.0/
% or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.


if isempty(lv.origin_tag)
    warning('No origin defined. Using default scaling');
    h = 80;
else
    h = lv.origin_tag.tag_size;
    origin_id = lv.origin_tag.id;
    
end

if isempty(lv.calib)
    error('Missing camera calibration')
end

K = lv.calib.IntrinsicMatrix';

scene_rec = apriltags(img, h, K, lv.quad_decimate);
num_tags = length(scene_rec);

if num_tags == 0
    error('No AprilTags found')
end

tag_ids = [scene_rec.id];

%first, find the origin
origin_idx = find(origin_id == tag_ids);
if isempty(origin_idx)
    warning('Warning unable to find origin, Aborting')
    return;
end

if length(origin_idx) > 1
    warning('Multiple origins detected. Aborting');
end

%C-0 transform
% If R is C_TC
% T_0C = [scene_rec(origin_idx).R scene_rec(origin_idx).p;0 0 0 1];
% lv.origin_tag.T_CT = ht_inv(T_0C);

%If R is C_CT
lv.origin_tag.is_visible = true;
lv.origin_tag.T_CT = [scene_rec(origin_idx).R scene_rec(origin_idx).p;0 0 0 1];
T_0C = ht_inv(lv.origin_tag.T_CT);


% reset visibility
lv.vehicle_tag.is_visible = false;
for k = 1:length(lv.obstacle_tags)
    lv.obstacle_tags(k).is_visible = false;
end

% Loop over remaining tags
for k = 1:num_tags
    tmp_id = tag_ids(k);
    if tag_ids(k) ~= origin_id
        %Update the record
        %Defn 1
%         T_TC = [scene_rec(k).R scene_rec(k).p;0 0 0 1];
%         T_CT = dh_inv(T_TC);
        %Defn 2
        T_CT = [scene_rec(k).R scene_rec(k).p;0 0 0 1];
        T_TC = dh_inv(T_CT);
        
        T_0T = T_0C*T_CT;
        
        if tmp_id == lv.vehicle_tag.id
            %Update vehicle information
            lv.vehicle_tag.T_CT =T_CT;
            lv.vehicle_tag.T_0T = T_0T;
            lv.vehicle_tag.is_visible = true;
        else
            %Look in the obstacle list
            tmp_obstacle_idx  = lv.tag_list(tmp_id+ 1);
            if  tmp_obstacle_idx == 0
                error('Tag %d not recognized', tmp_id);
            else
                
                lv.obstacle_tags(tmp_obstacle_idx).T_CT = T_CT;
                lv.obstacle_tags(tmp_obstacle_idx).T_0T = T_0T;
                lv.obstacle_tags(tmp_obstacle_idx).is_visible = true;
            end
        end
    end
end


    function Tinv = dh_inv(T)
        C = T(1:3,1:3);
        p = T(1:3,4);
        
        Tinv = eye(4);
        Tinv(1:3,1:3) = C.';
        Tinv(1:3,4) = -C.'*p;
        
    end

end

