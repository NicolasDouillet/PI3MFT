function [V, T] = sierpinski_solid_tetraki_hexahedron(a,nb_it)
%
% Author : nicolas.douillet (at) free.fr, 2017-2024.


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
V9 = C(4,:);
V11 = [0 0 1.5*sqrt(3)/3]; % top of the top pyramid of height 0.5*cube_edge

% Create root / mother meshed tetrahedron
[V,T] = sierpinski_solid_tetrahedron(nb_it,V1,V2,V3,V4);

% Top bottom right tetra
Vtbr = cat(2,-V(:,1),-V(:,2),V(:,3));
Ttbr = T + size(V,1);

Rmx = @(theta)[1 0           0;
               0 cos(theta) -sin(theta);
               0 sin(theta)  cos(theta)];

Rmy = @(theta)[cos(theta) 0 -sin(theta);
               0          1  0;
               sin(theta) 0  cos(theta)];


Rmz = @(theta)[cos(theta) -sin(theta) 0;
               sin(theta)  cos(theta) 0;
               0           0          1];

% Bottom bottom left tetra
Vbbl = cat(2,V(:,1),-V(:,2),-V(:,3));
Tbbl = T + 2*size(V,1);

% Bottom top right tetra
Vbtr = cat(2,-V(:,1),V(:,2),-V(:,3));
Tbtr = T + 3*size(V,1);

% Intern tetra (to be solid)
[Vin,Tin] = sierpinski_solid_tetrahedron(nb_it,V2,V4,V3,V8);
Tin = Tin + 4*size(Vin,1);

% Hexahedron face pyramids

% top pyramid
[Vtlp,Ttlp] = sierpinski_solid_tetrahedron(nb_it,V1,V2,V4,V11); % top left
Ttlp = Ttlp + 5*size(Vin,1);

[Vtrp,Ttrp] = sierpinski_solid_tetrahedron(nb_it,V2,V4,V9,V11); % top right
Ttrp = Ttrp +6*size(Vin,1);

Vtp = cat(1,Vtlp,Vtrp);
Ttp = cat(1,Ttlp,Ttrp);

Vbp = -(Rmz(0.5*pi)*Vtp')';
Tbp = Ttp + size(Vtp,1);

% Top bottom together
Vtbp = cat(1,Vtp,Vbp);
Ttbp = cat(1,Ttp,Tbp);

% Sides
Vsy = (Rmy(0.5*pi)*Rmx(0.5*pi)*Vtbp')';
Tsy = Ttbp + 4*size(Vin,1);

Vsx = (Rmx(0.5*pi)*Rmy(0.5*pi)*Vtbp')';
Tsx = Tsy + 4*size(Vin,1);

V = cat(1,V,Vtbr,Vbbl,Vbtr,Vin,Vtbp,Vsy,Vsx);
T = cat(1,T,Ttbr,Tbbl,Tbtr,Tin,Ttbp,Tsy,Tsx);


% % Remove duplicated vertices
% [V,T] = remove_duplicated_vertices(V,T);
% 
% % Remove duplicated triangles
% T = unique(sort(T,2),'rows','stable');


end