function task_info = generate_robot_task
fmax = 10;
mmax = 5;

task_info.L1 = .5 + rand(1);

task_info.fx = randi(2*fmax+1) - fmax;
task_info.fy = randi(2*fmax+1) - fmax;
task_info.mz = randi(2*mmax+1) - mmax;

task_info.phi1 = rand(1)*pi;
task_info.phi2 = rand(1)*pi-pi/2;
task_info.d3 = .5*rand(1)+1;