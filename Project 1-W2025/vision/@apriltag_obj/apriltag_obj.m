%Class definition for Apriltag record objects.
%This is a simple helper class for recording the position of identified
%tags and plotting their location
%Tags can be of three different types obstacles, origin markers, and
%vehicles.
%%The origin marker must be unique. When processing a scene and plotting
%%output, the object poses are calculated relative to the origin marker.
% Vehicles are drawn in separate colours.
% Any number of obstacle records are allowed.

%  (c) 2021 John Enright
%
% This work is licensed under the Creative Commons Attribution 3.0 Unported License.
% To view a copy of this license, visit http://creativecommons.org/licenses/by/3.0/
% or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.

classdef apriltag_obj
    properties
        id = 0;
        obj_type = [];
        obj_size = [];
        T_0T = eye(4);
        T_CT = eye(4);
        map_color = [];
        is_origin = false;
        tag_size = 80;
        is_visible = true;
    end
    
    methods
        function ato = apriltag_obj(id, obj_type, obj_size, tag_size, tag_color)
            %id is the tag-id number
            % obj type can be 'origin', 'obstacle', or 'vehicle'
            % obj size is a rectangular bounding box drawn at [X_min, X_max,
            % Y_min, Y_max] in world coordinates (usually mm);
            % The first row of the colour specification is the edge colour,
            % and the second row is the face colour
            
            if nargin < 5
                default_colour = true;
            else
                default_colour = false;
            end
            
            ato.id = id;
            
            %Record the object type
            if strcmpi(obj_type,'origin')
                ato.obj_type = 'origin';
                ato.is_origin = true;
            elseif strcmpi(obj_type, 'obstacle')
                ato.obj_type = 'obstacle';
                if default_colour
                    ato.map_color = [0 0 0;.9 .9 .9];
                else
                    ato.map_color = tag_color;
                end
            elseif strcmpi(obj_type, 'vehicle')
                ato.obj_type = 'vehicle';
                if default_colour
                    ato.map_color = [0 0 1;.9 .9 1];
                else
                    ato.map_color = tag_color;
                end
            else
                error('Unknown object type');
            end
            
            %Record the obstacle size
            if isnumeric(obj_size) && length(obj_size) == 4
                ato.obj_size = obj_size;
            elseif ~ato.is_origin && ~isempty(obj_size)
                warning('Unrecognized size specification')
            end
            
            if nargin < 4 || isempty(tag_size)
                ato.tag_size = 80;
            else
                ato.tag_size = tag_size;
            end
        end
        
      fhandle = draw_2d_axes(ato, axis_scale, fhandle, label_axes);
      fhandle = draw_box(ato, fhandle);
      img = draw_box_bitmap(ato, img, x, y );
      
      
        function fhandle = draw_3d_axes(ato, fhandle)
            %Draw 3-d axes. Not yet implemented.
        end
                
        function ato = set_visible(ato, is_visible)
            ato.is_visible = is_visible;
        end
        
        function T = get_pose(ato, is_world_pose)
            if nargin < 2 || is_world_pose
                T = ato.T_0T;
            else
                T = ato.T_CT;
            end
        end
        function ato = set_pose(ato, T_CT, T_0T)
            ato.T_CT = T_CT;
            ato.T_0T = T_0T;
        end
        
    end
end