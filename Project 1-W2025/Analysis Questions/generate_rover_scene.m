function [rover_info, scene_info] = generate_rover_scene(seed)
% Generate rover and scene information 
% All dimensions are in cm, and angles in radians

if nargin <1
    %Do nothing
else
    rng(seed);
end

%% Generate rover
%Rover dimensions
rover_info.length = 150 + randi(40);
rover_info.width = 120 + randi(40);
rover_info.height = 60 + randi(40);

%Rover orientation
scene_info.rover_heading = 2*pi*rand(1);
scene_info.rover_pitch = (-10 + randi(20))*pi/180;
scene_info.rover_roll = (-10 + randi(20))*pi/180;

arm_halfwidth = 10;
rover_info.arm_pos =  arm_halfwidth + [(-rover_info.length*.5+randi((rover_info.length - 2*arm_halfwidth)));...
    (-rover_info.width*.5+randi(rover_info.width - 2*arm_halfwidth))];

drone_diam = 40;

min_dist = sqrt(rover_info.width^2 + rover_info.length^2) + drone_diam;

%% Scene information
scene_dim = 2000; %40m
height_variation = 50;

min_pos = round(.1*scene_dim);
max_pos = round(.9*scene_dim);


scene_info.rover_pos = [min_pos + (max_pos-min_pos)*rand(2,1);height_variation*(-.5 + rand(1))];

%Not efficient, but let's just try a few times to make sure we're far
%enough away.

while(1)
    tmp_pos = [min_pos + (max_pos-min_pos)*rand(2,1);height_variation*(-.5 + rand(1))];
    if sum((tmp_pos(1:2) - scene_info.rover_pos(1:2)).^2) > min_dist^2
        break;
    end
end
scene_info.drone_pos = tmp_pos;
scene_info.drone_heading = 2*pi*rand(1);


%% Plot object
rover_ato = apriltag_obj(1,'vehicle',[rover_info.length*[-.5 .5], rover_info.width*[-0.5, 0.5]]);
drone_ato = apriltag_obj(2,'obstacle',[drone_diam*[-.5 .5], .2*drone_diam*[-0.5, 0.5]]);



T_0T_rover = eye(4);
T_0T_rover(1:3,4) = scene_info.rover_pos;
T_0T_drone = eye(4);
T_0T_drone(1:3,4) = scene_info.drone_pos;
T_0T_drone(1:3,1:3) = Rz(scene_info.drone_heading);
T_0T_rover(1:3,1:3) = Rz(scene_info.rover_heading);



% Plot rover
arm_text_offset = 5;
figure
clf;
hold on;
rover_ato.set_pose(eye(4), eye(4));
title('Robot (Top View)')


rover_ato.draw_box;
rover_ato.draw_2d_axes;

plot(rover_info.arm_pos(1), rover_info.arm_pos(2), 'ro', 'markersize',2,'markerfacecolor',[1 0 0]);
text(rover_info.arm_pos(1)+ arm_text_offset, rover_info.arm_pos(2),'Arm');


%Plot larger scene
rover_ato = rover_ato.set_pose(eye(4), T_0T_rover);
drone_ato = drone_ato.set_pose(eye(4), T_0T_drone);
figure
clf;
hold on;
rover_ato.draw_box;
rover_ato.draw_2d_axes(200,[],1);
drone_ato.draw_box;
drone_ato.draw_2d_axes(200,[],1);
grid on;
axis equal;
axis([0 scene_dim, 0, scene_dim]);
title('Rover Scene Layout')
text(scene_info.drone_pos(1), scene_info.drone_pos(2),'Drone');
text(scene_info.rover_pos(1), scene_info.rover_pos(2),'Rover');
xlabel('X-position (cm)');
ylabel('Y-Position (cm)');

