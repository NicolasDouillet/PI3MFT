function [V, T] = sierpinski_solid_icosahedron(a,nb_it)
%
% Author : nicolas.douillet (at) free.fr, 2021-2024.


% Summits of the first tetrahedron with edge length = 1
phi_n = 0.5*(1+sqrt(5));
centre_angle = 2*asin(1/sqrt(phi_n*sqrt(5)));

Rmz = @(theta)[cos(theta) -sin(theta) 0;...
               sin(theta)  cos(theta) 0;...
               0          0           1];

V1 = [0 0 1];
V2 = [sin(centre_angle) 0 cos(centre_angle)];
V3 = (Rmz(0.4*pi)*V2')';
V4 = [0 0 0];

[V,T] = sierpinski_solid_tetrahedron(nb_it,V1,V2,V3,V4);

n = cross(V3-V2,V4-V2,2);
n = n / sqrt(sum(n.^2,2));

% Symetry matrix
S = eye(3) - 2*(n'*n);

Vi1 = (S*V')';
Ti1 = T + size(V,1);
V = cat(1,V,Vi1);
T = cat(1,T,Ti1);

Vi2 = -V;
Ti2 = T + size(V,1);
V = cat(1,V,Vi2);
T = cat(1,T,Ti2);

Vr1 = (Rmz(0.4*pi)*V')';
Vr2 = (Rmz(0.8*pi)*V')';
Vr3 = (Rmz(1.2*pi)*V')';
Vr4 = (Rmz(1.6*pi)*V')';

Tr1 = T + size(V,1);
Tr2 = T + 2*size(V,1);
Tr3 = T + 3*size(V,1);
Tr4 = T + 4*size(V,1);

V = a*[V; Vr1; Vr2; Vr3; Vr4];
T = [T; Tr1; Tr2; Tr3; Tr4];


% % Remove duplicated vertices
% [V,T] = remove_duplicated_vertices(V,T);
% 
% % Remove duplicated triangles
% T = unique(sort(T,2),'rows','stable');


end