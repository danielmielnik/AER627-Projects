function fhandle = draw_2d_axes(ato, axis_scale, fhandle, label_axes)
% Draw X and Y axes at the tag location (world coordinates)
% specify axis_scale (mm) to change the size of the axis lines.
%  (c) 2021 John Enright
%
% This work is licensed under the Creative Commons Attribution 3.0 Unported License.
% To view a copy of this license, visit http://creativecommons.org/licenses/by/3.0/
% or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.

if ~ato.is_visible
    return
end

if nargin < 2 || isempty(axis_scale)
    axis_scale = 50;
end
if nargin < 3 || isempty(fhandle)
    fhandle = gcf;
end

if nargin < 4 || isempty(label_axes)
   label_axes = false; 
end

%Draw axes (ignoring z)
x_dir = ato.T_0T(1:2,1);
x_dir = x_dir/norm(x_dir);

y_dir = ato.T_0T(1:2,2);
y_dir = y_dir/norm(y_dir);

label_offset = 0.05*axis_scale;

line(ato.T_0T(1,4) + [0 axis_scale*x_dir(1)], ato.T_0T(2,4) + [0 axis_scale*x_dir(2)],'color','[0 1 1]');
line(ato.T_0T(1,4) + [0 axis_scale*y_dir(1)], ato.T_0T(2,4) + [0 axis_scale*y_dir(2)],'color','[1 0 1]');
if label_axes
    
text(ato.T_0T(1,4) + axis_scale*x_dir(1) + label_offset, ato.T_0T(2,4) + axis_scale*x_dir(2),'X');
text(ato.T_0T(1,4) + axis_scale*y_dir(1), ato.T_0T(2,4) + axis_scale*y_dir(2) + label_offset,'Y');
end