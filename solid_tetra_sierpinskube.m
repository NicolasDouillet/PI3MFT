function [V, T] = solid_tetra_sierpinskube(nb_it, option_display)


addpath('C:\Users\Nicolas\Desktop\TMW_contributions\mesh_processing_toolbox\src');

% Body
% Summits of original cube (living in the unit sphere R(O,1))
C = (sqrt(3)/3)*[ 1  1  1;...
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
[V,T] = sierpinski_solid_tetrahedron(V1,V2,V3,V4,nb_it,false);

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
[Vin,Tin] = sierpinski_solid_tetrahedron(V2,V4,V3,V8,nb_it,false);
Tin = Tin + 4*size(Vin,1);

% Hexahedron face pyramids

% top pyramid
[Vtlp,Ttlp] = sierpinski_solid_tetrahedron(V1,V2,V4,V11,nb_it,false); % top left
Ttlp = Ttlp + 5*size(Vin,1);

[Vtrp,Ttrp] = sierpinski_solid_tetrahedron(V2,V4,V9,V11,nb_it,false); % top right
Ttrp = Ttrp +6*size(Vin,1);

Vtp = cat(1,Vtlp,Vtrp);
Ttp = cat(1,Ttlp,Ttrp);

Vbp = -(Rmz(0.5*pi)*Vtp')';
Tbp = Ttp + size(Vtp,1);

% Top bottom together
Vtbp = cat(1,Vtp,Vbp);
Ttbp = cat(1,Ttp,Tbp);

% Sides
% TODO : check no crossing triangle patterns for 3D printing solidity
Vsy = (Rmy(0.5*pi)*Rmx(0.5*pi)*Vtbp')';
Tsy = Ttbp + 4*size(Vin,1);

Vsx = (Rmx(0.5*pi)*Rmy(0.5*pi)*Vtbp')';
Tsx = Tsy + 4*size(Vin,1);

V = cat(1,V,Vtbr,Vbbl,Vbtr,Vin,Vtbp,Vsy,Vsx);
T = cat(1,T,Ttbr,Tbbl,Tbtr,Tin,Ttbp,Tsy,Tsx);

% Remove duplicated vertices
[V,T] = remove_duplicated_vertices(V,T);

% Remove duplicated triangles
T = unique(sort(T,2),'rows','stable');


if option_display        
    display_fractal_octahedron(V,T);    
end


end % solid_tetra_sierpinskube.m


% remove_duplicated_vertices subfunction
function [V_out, T_out] = remove_duplicated_vertices(V_in, T_in)

tol = 1e4*eps;
[V_out,~,n] = uniquetol(V_in,tol,'ByRows',true);
T_out = n(T_in);

end % remove_duplicated_vertices


% display_fractal_tetra subfunction
function [] = display_fractal_octahedron(V, T)


figure;
set(gcf,'Color',[0 0 0]);
C = sqrt(sum(V.^2,2));
trisurf(T,V(:,1),V(:,2),V(:,3),C); colormap(flipud('hot'));
shading interp;

set(gca,'Color',[0 0 0],'XColor',[1 1 1],'YColor',[1 1 1],'ZColor',[1 1 1]);
ax = gca;
ax.Clipping = 'off';
axis equal, axis tight, axis off;
camlight right;
camlight left;
camlight head;
view(-33,21);


end % display_fractal_tetra