function img = draw_box_bitmap(ato, img, x, y )
%Similar to draw_box, this method draws a bitmap box representing the
%object. User must supply an image of appropriate size (img) as well
%vectors representing the dimensions of the image in both row (x) and
%column (y) directions

%  (c) 2021 John Enright
%
% This work is licensed under the Creative Commons Attribution 3.0 Unported License.
% To view a copy of this license, visit http://creativecommons.org/licenses/by/3.0/
% or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.


N_row = length(x);
N_col = length(y);
sz = size(img);

if (sz(1) ~= N_row) || (sz(2) ~= N_col)
    error('Image size must match x/y vectors');
end

%% Define coord to index mappings
Lx = [(x(end)-x(1)) (N_row*x(1)- x(end))]/(N_row - 1);     
Ly = [(y(end)-y(1)) (N_col*x(1)- y(end))]/(N_col - 1);



%% Geometry of rectangle

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

corners = [rr';fr';fl';rl'];
%lowest point
[min_col, mci]  = min(corners(:,2));

idx = circshift(1:4, -(mci-1));
%This fixes the geometry 
new_corners = corners(idx,:);
lo_col = (new_corners(1,2));
hi_col = (new_corners(3,2));

%Scale result
lo_col = round((lo_col-Ly(2))/Ly(1));
hi_col = round((hi_col-Ly(2))/Ly(1));

lo_col = max(lo_col,1);
hi_col = min(hi_col, N_col);

%Bounding lines
LA = bnd_line(new_corners(1, :), new_corners(2,:));
LB = bnd_line(new_corners(2, :), new_corners(3,:));
LC = bnd_line(new_corners(3, :), new_corners(4,:));
LD = bnd_line(new_corners(4, :), new_corners(1,:));

%intersections 
Yright = (LB(1)*LA(2)-LA(1)*LB(2))/(LB(1)-LA(1));
Yleft = (LD(1)*LC(2)-LC(1)*LD(2))/(LD(1)-LC(1));
% rescale intersections
Yright = (Yright-Ly(2))/Ly(1);
Yleft = (Yleft-Ly(2))/Ly(1);


if isnan(Yright)
    Yright = lo_col;
end

if isnan(Yleft)
    Yleft = hi_col;
end

for k = lo_col:hi_col
   if k <= Yleft
       l_bnd = LD;
   else
       l_bnd = LC;
   end
   
   if k < Yright
       r_bnd = LA;
   else
       r_bnd = LB;
   end
    
   y_tmp = Ly(1)*k+Ly(2);
   x_l = (y_tmp-l_bnd(2))/l_bnd(1);
   lo_row = round((x_l-Lx(2))/Lx(1));
   x_r = (y_tmp-r_bnd(2))/r_bnd(1);
   hi_row = round((x_r-Lx(2))/Lx(1));
   
   if isinf(l_bnd(1))
       lo_row = new_corners(1,1);
       hi_row = new_corners(2,1);
   end
   
   lo_row = max(lo_row, 1);
   hi_row = min(hi_row, N_row);
   
   img(lo_row:hi_row, k) = 1;
    
end

    function L = bnd_line(p1, p2)
        L = [(p2(2)-p1(2))/(p2(1)-p1(1)) (p1(2)-(p1(1)*(p2(2)-p1(2))/(p2(1)-p1(1))))];
    end

end

