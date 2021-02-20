function [V, T] = solid_spherpinski(nb_it, option_display)


% Basis vectors
I = [1 0 0];
J = [0 1 0];
K = [0 0 1];
O = [0 0 0];

% Create root / mother meshed tetrahedron
[V,T] = sierpinski_solid_tetrahedron(I,J,K,O,nb_it,false);

% Project it into the unit ball
sphere_coord_mat = zeros(size(V,1),4); % (r, theta, phi, coeff)
sphere_coord_mat(:,1) = abs(sqrt(sum(V.^2,2))); % r
sphere_coord_mat(:,2) = abs(acos(V(:,3)./sphere_coord_mat(:,1))); % theta
sphere_coord_mat(:,3) = abs(acos(V(:,1)./(sphere_coord_mat(:,1).*sin(sphere_coord_mat(:,2))))); % phi
sphere_coord_mat(:,4) = abs(sin(sphere_coord_mat(:,2))) .* (abs(cos(sphere_coord_mat(:,3))) + abs(sin(sphere_coord_mat(:,3)))) + abs(cos(sphere_coord_mat(:,2))); % multiplying coeff

idx = isnan(sphere_coord_mat(:,4));
sphere_coord_mat(idx,4) = 1;
V = V .* repmat(sphere_coord_mat(:,4),[1 3]);

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

% % Remove duplicated vertices
% [V,T] = remove_duplicated_vertices(V,T);

% Remove duplicated triangles
T = unique(sort(T,2),'rows','stable');


if option_display        
    display_fractal_sphere(V,T);    
end


end % solid_spherpinski


% % remove_duplicated_vertices subfunction
% function [V_out, T_out] = remove_duplicated_vertices(V_in, T_in)
% 
% tol = 1e4*eps;
% [V_out,~,n] = uniquetol(V_in,tol,'ByRows',true);
% T_out = n(T_in);
% 
% end % remove_duplicated_vertices


% display_fractal_sphere subfunction
function [] = display_fractal_sphere(V, T)


figure;
set(gcf,'Color',[0 0 0]);
C = sqrt(sum(V.^2,2));
trisurf(T,V(:,1),V(:,2),V(:,3),C);
c = colormap('hsv');
colormap(1-c);
shading interp;

set(gca,'Color',[0 0 0],'XColor',[1 1 1],'YColor',[1 1 1],'ZColor',[1 1 1]);
ax = gca;
ax.Clipping = 'off';
axis equal, axis tight, axis off;
camlight right;
camlight head;
view(-17.64,16.95);


end % display_fractal_sphere