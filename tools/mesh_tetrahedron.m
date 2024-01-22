function [V, T] = mesh_tetrahedron(tetra, nbstep)
%
% Author : nicolas.douillet (at) free.fr, 2017-2024.


M1 = tetra(1,:)';
M2 = tetra(2,:)';
M3 = tetra(3,:)';
M4 = tetra(4,:)';

[V1,T1] = sample_triangle(M1,M2,M4,nbstep);
[V2,T2] = sample_triangle(M2,M3,M4,nbstep);
[V3,T3] = sample_triangle(M3,M1,M4,nbstep);
[V4,T4] = sample_triangle(M1,M3,M2,nbstep);

T2 = T2 + size(V1,1);
T3 = T3 + size(V1,1) + size(V2,1);
T4 = T4 + size(V1,1) + size(V2,1) + size(V3,1);

V = cat(1,V1,V2,V3,V4);
T = cat(1,T1,T2,T3,T4);


end