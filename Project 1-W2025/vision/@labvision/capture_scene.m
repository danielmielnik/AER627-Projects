function scene_map = capture_scene(lv)
%%Capture the scene and plot the output

% (c) 2020-2022 John Enright
% This work is licensed under the Creative Commons Attribution 3.0 Unported License.
% To view a copy of this license, visit http://creativecommons.org/licenses/by/3.0/
% or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.


img = lv.get_img;
scene = lv.get_scene(img);

%% Paint scene
figure(1);
clf

lv.origin_tag.draw_2d_axes;


lv.vehicle_tag.draw_box;
lv.vehicle_tag.draw_2d_axes;

for k = 1:length(lv.obstacle_tags)
    lv.obstacle_tags(k).draw_box
    lv.obstacle_tags(k).draw_2d_axes;
end

% TODO: generate bitmap from figure
scene_map = scene;

figure(2);
clf
imagesc(img);
hold on
colormap(gray);

for k = 1:length(scene)
   plot(scene(k).center(1), scene(k).center(2),'x', 'linewidth', 2) 
end