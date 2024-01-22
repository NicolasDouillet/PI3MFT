function [V, T] = sierpinski_solid_cube(a, nb_it)
%
% Author : nicolas.douillet (at) free.fr, 2021-2024.


% Summits of original cube (living in the unit sphere R(O,a))
C = a*[ 1  1  1;...
       -1  1  1;...
       -1 -1  1;...
        1 -1  1;...
        1  1 -1;...
       -1  1 -1;...
       -1 -1 -1;...
        1 -1 -1];   

% Summits of one corner tetrahedron (living in the unit sphere R(O,1))
V1 = C(2,:);
V2 = C(1,:);
V3 = C(6,:);
V4 = C(3,:);
V8 = C(8,:);

% Create root / mother meshed tetrahedron
[V,T] = sierpinski_solid_tetrahedron(nb_it,V1,V2,V3,V4);

% Top bottom right tetra
Vtbr = cat(2,-V(:,1),-V(:,2),V(:,3));
Ttbr = T + size(V,1);

% Bottom bottom left tetra
Vbbl = cat(2,V(:,1),-V(:,2),-V(:,3));
Tbbl = T + 2*size(V,1);

% Bottom top right tetra
Vbtr = cat(2,-V(:,1),V(:,2),-V(:,3));
Tbtr = T + 3*size(V,1);

% Intern tetra
[Vin,Tin] = sierpinski_solid_tetrahedron(nb_it,V2,V4,V3,V8);
Tin = Tin + 4*size(Vin,1);

V = cat(1,V,Vtbr,Vbbl,Vbtr,Vin);
T = cat(1,T,Ttbr,Tbbl,Tbtr,Tin);


% % Remove duplicated vertices
% [V,T] = remove_duplicated_vertices(V,T);

% % Remove duplicated triangles
% T = unique(sort(T,2),'rows','stable');


end