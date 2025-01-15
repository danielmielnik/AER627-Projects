function [ea_order, C_AB] = rand_euler_angle(student_no)

old_rng = rng;

if nargin <1
    do_rng = false;
    %Do nothing
else
    do_rng = true;
    rng(student_no);
end

% axis_combinations = [1,2,3;1,3,2;1,2,1;1,3,1;2,1,3;2,3,1;2,1,2;2,3,2;3,1,2;3,2,1;3,1,3;3,2,3];
%Don't allow 123 (this was covered in class)
axis_combinations = [1,3,2;1,2,1;1,3,1;2,1,3;2,3,1;2,1,2;2,3,2;3,1,2;3,2,1;3,1,3;3,2,3];

num_combinations = size(axis_combinations,1);


ea_order = axis_combinations(randi(num_combinations),:);

fcn_list = {@Rx, @Ry, @Rz};

theta = rand(3,1).*[2*pi;pi;2*pi];

C_AB =fcn_list{ea_order(1)}(theta(1))*fcn_list{ea_order(2)}(theta(2))*fcn_list{ea_order(3)}(theta(3));


if do_rng
rng(old_rng);
end