function [V, T, C] = MoebiuSierpinski(nb_it, option_display)
%
% Author & support : nicolas.douillet (at) free.fr, 2022.

addpath('C:\Users\Nicolas\Desktop\TMW_contributions\mesh_processing_toolbox\src');
addpath('C:\Users\Nicolas\Desktop\TMW_contributions\geometry_toolbox\fractals\printable_iterative_meshed_fractal_objects');


% Summits of original cube (living in the unit sphere R(O,1))
a = 1;
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
[V,T] = sierpinski_solid_tetrahedron(V1,V2,V3,V4,nb_it,false);

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
[Vin,Tin] = sierpinski_solid_tetrahedron(V2,V4,V3,V8,nb_it,false);
Tin = Tin + 4*size(Vin,1);

V = cat(1,V,Vtbr,Vbbl,Vbtr,Vin);
T = cat(1,T,Ttbr,Tbbl,Tbtr,Tin);

% Remove duplicated vertices
[V,T] = remove_duplicated_vertices(V,T);

% Remove duplicated triangles
T = unique(sort(T,2),'rows','stable');


Mrz = @(theta)[cos(theta) -sin(theta) 0;
    sin(theta)  cos(theta) 0;
    0           0          1];

C = max(abs(V(:,1:2)),[],2);
C = cat(1,C,C,C,C,C,C,C,C);
V(:,3) = 0.125*pi*(1+V(:,3));
    

for k = 1:size(V,1)
    
    V(k,:) = (Mrz(V(k,3))*V(k,:)')';
    
end


Mry = @(theta)[cos(theta) 0 -sin(theta);
               0          1  0;
               sin(theta) 0  cos(theta)];

V(:,1) = 0.125*pi + 0.5*(1+V(:,1));
V(:,2) = 0.5*V(:,2);
Z = V(:,3);

for k = 1:size(V,1)
    
    V(k,:) = (Mry(V(k,3))*cat(2,V(k,1:2),0)')';
    
end

V(:,3) = -V(:,3) - sin(Z);
V(:,1) = V(:,1) + cos(Z);

% Three other quarters creation
T = cat(1,T,T+size(V,1));
V = cat(1,V,cat(2,V(:,1),-V(:,2),-V(:,3)));
T = cat(1,T,T+size(V,1));
V = cat(1,V,(Mry(0.5*pi)*V')');
T = cat(1,T,T+size(V,1));
V = cat(1,V,(Mry(pi)*V')');


% Display
if option_display
    
    disp_MoebiuSierpinski(V,T,C);
    
end


end % MoebiuSierpinski


% Display subfunction
function [] = disp_MoebiuSierpinski(V, T, C)

    figure;        
    trisurf(T,V(:,1),V(:,2),V(:,3),C), shading interp, hold on;
    colormap(winter);
    ax = gca;
    ax.Clipping = 'off';
    set(gcf,'Color',[0 0 0]), set(ax,'Color',[0 0 0]);
    axis square, axis equal, axis tight, axis off;
    camlight(315,0);
    view(-25,15);

end % disp_MoebiuSierpinski


% Remove duplicated vertices subfunction
function [V_out, T_out] = remove_duplicated_vertices(V_in, T_in)

tol = 1e4*eps;
[V_out,~,n] = uniquetol(V_in,tol,'ByRows',true);
T_out = n(T_in);

end % remove_duplicated_vertices