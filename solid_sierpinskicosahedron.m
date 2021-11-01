function [V, T] = solid_sierpinskicosahedron(nb_it, option_display)


addpath('C:\Users\Nicolas\Desktop\TMW_contributions\mesh_processing_toolbox\src');


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

[V,T] = sierpinski_solid_tetrahedron(V1,V2,V3,V4,nb_it,false);

Rmz = @(theta)[cos(theta) -sin(theta) 0;...
               sin(theta)  cos(theta) 0;...
               0           0          1];

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

V = [V; Vr1; Vr2; Vr3; Vr4];
T = [T; Tr1; Tr2; Tr3; Tr4];

% Remove duplicated vertices
[V,T] = remove_duplicated_vertices(V,T);

% Remove duplicated triangles
T = unique(sort(T,2),'rows','stable');

% Remove internal faces (triangles which have > 6 neighbors)
C = cell2mat(cellfun(@(t) numel(find(sum(bitor(bitor(T==T(t,1),T==T(t,2)),T==T(t,3)),2)==2)),num2cell((1:size(T,1))'),'un',0));
tgl_idx_2_remove = find(C > 5);
T = remove_triangles(tgl_idx_2_remove,T,'indices');

% Display
if option_display
    
    display_solid_sierpinskicosahedron(V,T);
    
end

end % solid_sierpinskicosahedron


% remove_duplicated_vertices subfunction
function [V_out, T_out] = remove_duplicated_vertices(V_in, T_in)

tol = 1e4*eps;
[V_out,~,n] = uniquetol(V_in,tol,'ByRows',true);
T_out = n(T_in);

end % remove_duplicated_vertices


% display_solid_sierpinskicosahedron subfunction
function [] = display_solid_sierpinskicosahedron(V, T)


figure;
set(gcf,'Color',[0 0 0]);
C = sqrt(sum(V.^2,2));
trisurf(T,V(:,1),V(:,2),V(:,3),C), shading interp;
colormap('hsv');

set(gca,'Color',[0 0 0],'XColor',[1 1 1],'YColor',[1 1 1],'ZColor',[1 1 1]);
ax = gca;
ax.Clipping = 'off';
axis equal, axis tight, axis off;
camlight right;
camlight head;
view(-17.64,16.95);


end % display_solid_sierpinskicosahedron