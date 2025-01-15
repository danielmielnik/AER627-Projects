function fhandle = draw_box(ato, fhandle)
%Draw a box representing the object. Sides will be aligned to
%the axis directions.

%  (c) 2021 John Enright
%
% This work is licensed under the Creative Commons Attribution 3.0 Unported License.
% To view a copy of this license, visit http://creativecommons.org/licenses/by/3.0/
% or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.


if ~ato.is_visible
    return
end

if isempty(ato.obj_size)
    return
end
if nargin < 2 || isempty(fhandle)
    fhandle = gcf;
end

%principal axes (ignoring z)
x_dir = ato.T_0T(1:2,1);
x_dir = x_dir/norm(x_dir);

y_dir = ato.T_0T(1:2,2);
y_dir = y_dir/norm(y_dir);

obj_pos = ato.T_0T(1:2,4);
%assumes +X is forward and +Y is to the left

fl = obj_pos + ato.obj_size(2)*x_dir+ato.obj_size(4)*y_dir;
fr = obj_pos + ato.obj_size(2)*x_dir+ato.obj_size(3)*y_dir;
rl = obj_pos + ato.obj_size(1)*x_dir+ato.obj_size(4)*y_dir;
rr = obj_pos + ato.obj_size(1)*x_dir+ato.obj_size(3)*y_dir;
obj_box = [fl';fr';rr';rl';fl'];

patch('XData',obj_box(:,1), 'YData', obj_box(:,2),'EdgeColor',ato.map_color(1,:),'FaceColor',ato.map_color(2,:));

end
