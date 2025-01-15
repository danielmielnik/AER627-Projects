function  ret = save_tag_obj(lv, tag_obj)

ret  = 0;
if ~isa(tag_obj,'apriltag_obj')
    error('Invalid tag-object type. Please use apriltag_obj');
end

if tag_obj.is_origin
   if ~isempty(lv.origin_tag)
       fprintf('Reassigning origin\n');
       ret = 1;
   end
   lv.origin_tag = tag_obj;
   return;
end

%For the moment, just allow a single vehicle tag
if strcmpi(tag_obj.obj_type, 'vehicle')
    
    if ~isempty(lv.vehicle_tag)
        fprintf('Reassigning vehicle\n');
        ret = 1;
    end
    lv.vehicle_tag = tag_obj;
    return;
end

%Look for obstacles
if lv.tag_list(tag_obj.id+1) == 0
    %New tag
    lv.obstacle_tags = [lv.obstacle_tags tag_obj];
    lv.tag_list(tag_obj.id+1) = length(lv.obstacle_tags);
    
else
    %At present this will not copy any old positioning data
    lv.obstacle_tags(lv.tag_list(tag_obj.id+1)) = tag_obj;
    ret = 1;
end

