function raw_img = get_img(lv)
%Trigger an image
start(lv.vid);
raw_img = getdata(lv.vid);
stop(lv.vid);
% stoppreview(lv.vid);
end