function M_new = compute_new_tetra_summits(M1, M2, M3, M4, u, v, w, sample_step)
%
% Author : nicolas.douillet (at) free.fr, 2017-2024.


u_floor_shift = floor(0.5*sample_step)*u/sample_step;
u_ceil_shift  =  ceil(0.5*sample_step)*u/sample_step;
v_floor_shift = floor(0.5*sample_step)*v/sample_step;
v_ceil_shift  =  ceil(0.5*sample_step)*v/sample_step;
w_floor_shift = floor(0.5*sample_step)*w/sample_step;
w_ceil_shift  =  ceil(0.5*sample_step)*w/sample_step;

% Right floor tetra
R1 = M1;
R2 = M1 + u_ceil_shift;
R3 = M1 + v_ceil_shift;
R4 = M1 + w_ceil_shift;
R = cat(1,R1,R2,R3,R4);

% top Left tetra
L1 = M1 + u_floor_shift;
L2 = M2; % M1' + u; 
L3 = M1 + u_floor_shift + v_ceil_shift;
L4 = M1 + u_floor_shift + w_ceil_shift;
L = cat(1,L1,L2,L3,L4);

% Bottom left tetra
B1 = M1 + v_floor_shift;
B2 = M1 + v_floor_shift + u_ceil_shift;
B3 = M3; % M1' + v 
B4 = M1 + v_floor_shift + w_ceil_shift;
B = cat(1,B1,B2,B3,B4);

% Top tetra
T1 = M1 + w_floor_shift;
T2 = M1 + u_ceil_shift + w_floor_shift;
T3 = M1 + v_ceil_shift + w_floor_shift;
T4 = M4; % M1' + w;
T = cat(1,T1,T2,T3,T4);
    
M_new = cat(3,R,L,B,T);    


end