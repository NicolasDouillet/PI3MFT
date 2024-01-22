function [V, T] = sierpinski_solid_octahedron(a,nb_it)
%
% Author : nicolas.douillet (at) free.fr, 2017-2024.


% Basis vectors
I = a*[1 0 0];
J = a*[0 1 0];
K = a*[0 0 1];
O =   [0 0 0];

% Create root / mother meshed tetrahedron
[V,T] = sierpinski_solid_tetrahedron(nb_it,I,J,K,O);

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

% % Remove duplicated triangles
% T = unique(sort(T,2),'rows','stable');


end