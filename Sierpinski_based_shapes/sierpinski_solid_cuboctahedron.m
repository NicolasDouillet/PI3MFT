function [V, T] = sierpinski_solid_cuboctahedron(a,nb_it)
%
% Author : nicolas.douillet (at) free.fr, 2021-2024.


% Basis vectors
V1 =   [0 0 0];
V2 = a*[2*sqrt(2)/3 0 -4/3];
V3 = a*[-sqrt(2)/3 sqrt(6)/3 -4/3];
V4 = a*[-sqrt(2)/3 -sqrt(6)/3 -4/3];

% Create root / mother meshed tetrahedron
[V,T] = sierpinski_solid_tetrahedron(nb_it,V1,V2,V3,V4);

Rmy = @(theta)[cos(theta) 0 -sin(theta);
               0          1  0;
               sin(theta) 0  cos(theta)];

Rmz = @(theta)[cos(theta) -sin(theta) 0;
               sin(theta)  cos(theta) 0;
               0           0          1];

Vs = cat(2,-V(:,1),V(:,2:3));
Vr1 = (Rmy(-acos(-1/3))*Vs')';
Vr2 = (Rmz(2*pi/3)*Vr1')';
Vr3 = (Rmz(-2*pi/3)*Vr1')';

Tr1 = T + size(V,1);
Tr2 = T + 2*size(V,1);
Tr3 = T + 3*size(V,1);

V = cat(1,V,Vr1,Vr2,Vr3);
T = cat(1,T,Tr1,Tr2,Tr3);

% Top tetrahedra
V2 = -V;
T2 = T + size(V,1);
V = cat(1,V,V2);
T = cat(1,T,T2);

% Square face tetrahedra
V5 = [sqrt(2)    -sqrt(6)/3 0];
V6 = [sqrt(2)     sqrt(6)/3 0];
V7 = [sqrt(2)/3   sqrt(6)/3 4/3];
V8 = [sqrt(2)/3  -sqrt(6)/3 4/3];

% 1st tetrahedron of the cubic part 
[Vc1,Tc1] = sierpinski_solid_tetrahedron(nb_it,V5,V6,V7,V1);

% 2nd tetrahedron of the cubic part 
[Vc2,Tc2] = sierpinski_solid_tetrahedron(nb_it,V5,V7,V8,V1);
Tc2 = Tc2 + size(Vc1,1);

Vcu1 = cat(1,Vc1,Vc2);
Tcu1 = cat(1,Tc1,Tc2);

% Rotations
Vcu2 = (Rmz( 2*pi/3)*Vcu1')';
Tcu2 = Tcu1 + size(Vcu1,1);
Vcu3 = (Rmz(-2*pi/3)*Vcu1')';
Tcu3 = Tcu1 + 2*size(Vcu1,1);
Vcu = cat(1,Vcu1,Vcu2,Vcu3);
Tcu = cat(1,Tcu1,Tcu2,Tcu3);

Vcd = -Vcu;
Tcd = Tcu + size(Vcu,1);

Vc = cat(1,Vcu,Vcd);
Tc = cat(1,Tcu,Tcd);
Tc = Tc + size(V,1);

V = cat(1,V,Vc);
T = cat(1,T,Tc);


% % Remove duplicated vertices
% [V,T] = remove_duplicated_vertices(V,T);
% 
% % Remove duplicated triangles
% T = unique(sort(T,2),'rows','stable');


end