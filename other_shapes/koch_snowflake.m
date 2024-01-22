function [V, T] = koch_snowflake(a, nb_it)
%
% Author : nicolas.douillet (at) free.fr, 2017-2024.


% Summits of original tetrahedron (living in S(O,1))
V1 = a*[2*sqrt(2)/3  0         -1/3]; % right vertex
V2 = a*[-sqrt(2)/3  sqrt(6)/3  -1/3]; % top left vertex
V3 = a*[-sqrt(2)/3 -sqrt(6)/3  -1/3]; % bottom left vertex
V4 = a*[ 0          0           1  ]; % top vertex

Tetra = tetra(V1,V2,V3,V4);
Tetra_array = Tetra;

Triangle = triangle(V1,V2,V3);
Triangle_array = Triangle;

new_Triangle_array = repmat(Triangle_array,[1 1 6]);

% Build stellated octahedron and split into triangles -24 in total- and return the triangles structure array
T_current = Tetra_array;

[V_new,F_new] = split_tetra(T_current);

% Create new tetrahedrons
for m = 1:size(F_new,1)
    
    new_triangle = triangle(V_new(F_new(m,1),:),V_new(F_new(m,2),:),V_new(F_new(m,3),:));    
    new_Triangle_array(:,:,m) = new_triangle;
    
end

Triangle_array = new_Triangle_array; % 33 = 3 x 11 triangles

% Loop on nb_it
p = 0;

while p ~= nb_it
    
    new_Triangle_array = repmat(Triangle_array,[1 1 11]);       
    
    for j = 1:size(Triangle_array,3)
        
        T_current = Triangle_array(:,:,j);        
        [V_new,F_new] = split_triangle(T_current);
        
        for m = 1:size(F_new,1)
            
            new_triangle = triangle(V_new(F_new(m,1),:),V_new(F_new(m,2),:),V_new(F_new(m,3),:));            
            new_Triangle_array(:,:,11*(j-1)+m) = new_triangle;
            
        end                
        
    end
    
    Triangle_array = new_Triangle_array;        
    p = p+1;
    
end

% Triangles set concatenation
[V,T] = catriangles(Triangle_array);


end


function T = triangle(V1, V2, V3)
%
% Author : nicolas.douillet (at) free.fr, 2017-2024.


% V1, V2, V3 : line vectors of triangle three vertices coordinates
%
% Vn = [Vxn Vyn Vzn]
%
% G = [Gx Gy Gz]

F = [1 2 3]; % summit / top first, then trigonometric order 

% triangle barycentre
G = mean([V1; V2; V3], 1);

T = struct('vertex', [V1; V2; V3], ...
           'centre', G, ...
           'facet', F);
       
end


function T = tetra(V1, V2, V3, V4)
%
% Author : nicolas.douillet (at) free.fr, 2017-2024.


% V1, V2, V3, V4 : line vectors of tetrahedron four vertices coordinates
%
% Vn = [Vxn Vyn Vzn]
%
% G = [Gx Gy Gz]

F1 = [1 2 3];
F2 = [1 3 4];
F3 = [1 4 2];
F4 = [2 4 3];

% tetrahedron barycentre
G = mean([V1; V2; V3; V4], 1);

T = struct('vertex', [V1; V2; V3; V4], ...
           'centre', G, ...
           'facet', [F1; F2; F3; F4]);
       
end


function [V_new, F_new] = split_triangle(T)
%
% Author : nicolas.douillet (at) free.fr, 2017-2024.


% Input
%
% T : triangle
%
% Outputs
%
% V_new : The 11 vertices -coordinates- (8 new + 3 old)
% F_new : 11 indices line triplets of the 11 newly created facets


one_third = 1/3;
two_third = 2/3;

% Compute middles coordinates
P_121 = two_third * T.vertex(1,:) + one_third * T.vertex(2,:);
P_122 = one_third * T.vertex(1,:) + two_third * T.vertex(2,:);
P_131 = two_third * T.vertex(1,:) + one_third * T.vertex(3,:);
P_132 = one_third * T.vertex(1,:) + two_third * T.vertex(3,:);
P_231 = two_third * T.vertex(2,:) + one_third * T.vertex(3,:);
P_232 = one_third * T.vertex(2,:) + two_third * T.vertex(3,:);
P_123 = one_third * (T.vertex(1,:) + T.vertex(2,:) + T.vertex(3,:));

New_summit = compute_new_triangle_summit_coordinates(P_121, P_123, P_131);

V_new = [T.vertex(1,:); T.vertex(2,:); T.vertex(3,:); % already existing vertices
         P_121; P_122; P_131; P_132; P_231; P_232; P_123; New_summit]; % new vertices

% 11 = 9 - 1 + 3 new facets
% Sorted by top vertex first

F_new = [1 4 6;
         5 10 4;
         7 6 10;
         5 2 8;
         7 9 3;
         10 8 9;
         8 10 5;
         9 7 10;
         11 4 10;
         11 10 6;
         11 6 4];
 
% triangle / facet subdivision diagram
% New_summit is not visible here
% New_summit if the top of the tetrahedron which base is : [121 123 131]
%     
%                  1
%                /   \
%               /     \
%              /       \
%           121 _______ 131
%            /  \     /  \
%           /    \   /    \
%          /      \ /      \
%       122  ____ 123 _____ 132
%        / \      / \      / \
%       /   \    /   \    /   \
%      /     \  /     \  /     \
%     2 ____ 231 ____ 232 _____ 3

end


function [V_new, F_new] = split_tetra(T)
%
% Author : nicolas.douillet (at) free.fr, 2017-2024.


% Input
%
% T : tetrahedron structure
%
% Outputs
%
% N : The six newly created vertices -coordinates-
% I : Four index line triplets of the four newly created facets
% P : The four previous vertices -coordinates-


% Compute middles coordinates
M_12 = 0.5 * (T.vertex(1,:) + T.vertex(2,:));
M_13 = 0.5 * (T.vertex(1,:) + T.vertex(3,:));
M_14 = 0.5 * (T.vertex(1,:) + T.vertex(4,:));
M_23 = 0.5 * (T.vertex(2,:) + T.vertex(3,:));
M_24 = 0.5 * (T.vertex(2,:) + T.vertex(4,:));
M_34 = 0.5 * (T.vertex(3,:) + T.vertex(4,:));

S_586 =  compute_new_triangle_summit_coordinates(M_12, M_23, M_13);
S_579 =  compute_new_triangle_summit_coordinates(M_12, M_14, M_24);
S_6107 = compute_new_triangle_summit_coordinates(M_13, M_34, M_14);
S_8910 = compute_new_triangle_summit_coordinates(M_23, M_24, M_34);

V_new = [T.vertex(1,:); T.vertex(2,:); T.vertex(3,:); T.vertex(4,:); % already existing vertices
         M_12; M_13; M_14; M_23; M_24; M_34; % new vertices
         S_586; S_579; S_6107; S_8910]; % new summits

% 12 = 4x3 new facets
% Sorted by trigo order per line

F_new = [11 5 8;
         11 8 6;
         11 6 5;...
         
         12 5 7;
         12 7 9;
         12 9 5;...
         
         13 6 10;
         13 10 7;
         13 7 6;...
         
         14 8 9;
         14 9 10;
         14 10 8;...
         
         1 5 6;
         1 6 7;
         1 7 5;...
         
         2 5 9;
         2 9 8;
         2 8 5;...
         
         3 6 8;
         3 8 10;
         3 10 6;...
                          
         4 7 10;
         4 10 9;
         4 9 7];
      
     
end


function S = compute_new_triangle_summit_coordinates(M, N, P)
%
% Author : nicolas.douillet (at) free.fr, 2017-2024.


% Input
%
% M = [Mx My Mz]
% N = [Nx Ny Nz]
% P = [Px Py Pz]
%
% in trigonometric / counter clockwise order
%
% Output
%
% S = [Sx Sy Sz] : new tetrahedron summit


a = norm(N-M);   % edge length
h = a*sqrt(2/3); % tetrahedron height

cross_prod = cross(P-N, M-N);
norm_cross_prod = cross_prod / norm(cross_prod);

S = mean([M; N; P], 1) - h * norm_cross_prod;


end


function [V_array, T_array] = catriangles(Triangle_array)
%
% Author : nicolas.douillet (at) free.fr, 2017-2024.


S = size(Triangle_array,3);
V_array = zeros(3*S,3);
T_array = zeros(S,3);

for k = 1:S
    
    for i = 1:size(Triangle_array(:,:,k).vertex,1)
        
        V_array(3*(k-1)+i,:) = Triangle_array(:,:,k).vertex(i,:);
        
    end
    
    a = Triangle_array(:,:,k).facet(1,1) + 3*(k-1);
    b = Triangle_array(:,:,k).facet(1,2) + 3*(k-1);
    c = Triangle_array(:,:,k).facet(1,3) + 3*(k-1);
    
    T = [a b c];
    
    T_array(k,:) = T;
    
end


end