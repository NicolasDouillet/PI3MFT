function [V, T] = sierpinski_solid_octahedron(nb_it, option_display)


% Basis vectors
I = [1 0 0];
J = [0 1 0];
K = [0 0 1];
O = [0 0 0];

% Create root / mother meshed tetrahedron
[V,T] = sierpinski_solid_tetrahedron(I,J,K,O,nb_it,false);

% Perform one Rz 180° rotation, and one Rx 180° rotation such that the
% resulting sierpinski sphere is based on a regular octahedron
RzV = ([-1 0 0; 0 -1 0; 0 0 1]*V')';
T = cat(1,T,T+size(V,1));
V = cat(1,V,RzV);

RxV = ([1 0 0; 0 -1 0; 0 0 -1]*V')';
T = cat(1,T,T+size(V,1));
V = cat(1,V,RxV);

Rz2V = ([0 -1 0; 1 0 0; 0 0 1]*V')';
T = cat(1,T,T+size(V,1));
V = cat(1,V,Rz2V);

% Remove duplicated vertices
[V,T] = remove_duplicated_vertices(V,T);

% Remove duplicated triangles
T = unique(sort(T,2),'rows','stable');


if option_display        
    display_fractal_octahedron(V,T);    
end


end % sierpinski_solid_octahedron


% remove_duplicated_vertices subfunction
function [V_out, T_out] = remove_duplicated_vertices(V_in, T_in)

tol = 1e4*eps;
[V_out,~,n] = uniquetol(V_in,tol,'ByRows',true);
T_out = n(T_in);

end % remove_duplicated_vertices


% display_fractal_octahedron subfunction
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
camlight head;
view(-17.64,16.95);


end % display_fractal_tetra