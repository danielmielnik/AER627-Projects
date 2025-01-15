function T_inv = ht_inv(T)
%Find inverse homogeneous transform

% T_inv = zeros(4);
T_inv = T; %We're going to over-write everything, but this ensures that T_inv is symbolic if T is.

C = T(1:3,1:3).';
rho = T(1:3,4);

T_inv(1:3,1:3) = C;
T_inv(1:3,4) = -C*rho;
T_inv(4,4) = 1;

