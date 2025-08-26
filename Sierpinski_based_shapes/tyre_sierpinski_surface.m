function [V, T] = tyre_sierpinski_surface(nb_it, type)
%
% Author : nicolas.douillet (at) free.fr, 2024.


% TODO :
%
% - Avec printable version (!)


addpath('C:\Users\Nicolas\Desktop\TMW_contributions\geometry_toolbox\fractals\Sierpinski_triangle');
addpath('..\cube_transformations\');
addpath('..\tools\');

% Rectangular basis
M1 = [1 -1 -1];
M2 = [1  1  1];
M3 = [1 -1  1];

% [V1,T1] = Sierpinski_triangle_original(nb_it,M1,M2,M3,type,false);
% [V2,T2] = Sierpinski_triangle_original(nb_it,M2,M1,[1 1 -1],type,false);

[V1,T1] = Sierpinski_phantom_triangle(nb_it,M1,M2,M3,false);
[V2,T2] = Sierpinski_phantom_triangle(nb_it,M2,M1,[1 1 -1],false);

V = cat(1,V1,V2);
T = cat(1,T1,T2+size(V1,1));


% Torus transformation
Mry = @(theta)[cos(theta) 0 -sin(theta);
               0          1  0;
               sin(theta) 0  cos(theta)];

% V(:,1) = 0.125*pi + V(:,1);
V(:,2) = 0.5*V(:,2);
V(:,3) = 0.25*pi*(1+V(:,3));
Z = V(:,3);


for k = 1:size(V,1)
    
    V(k,:) = (Mry(V(k,3))*cat(2,V(k,1:2),0)')';
    
end


V(:,3) = V(:,3) + sin(Z);
V(:,1) = V(:,1) + cos(Z);

% Three other quarters creation
T = cat(1,T,T+size(V,1));

% 0.125*pi rotate all the other cylinders from their basis
V = cat(1,V,(Mry(0.5*pi)*V')');
T = cat(1,T,T+size(V,1));
V = cat(1,V,(Mry(pi)*V')');


tol = 1e4*eps;
[V,~,n] = uniquetol(V,tol,'ByRows',true);
T = n(T);


figure;
set(gcf,'Color',[0 0 0]);
t = trisurf(T,V(:,1),V(:,2),V(:,3)); shading flat, hold on;
% t.EdgeColor = 'g';
set(gca,'Color',[0 0 0],'XColor',[1 1 1],'YColor',[1 1 1],'ZColor',[1 1 1]);
colormap([0 1 0]);
axis equal, axis tight;
camlight right;
camlight head;
% alpha(0.5);


end