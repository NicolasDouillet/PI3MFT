function [V, T] = Sierpinski_solid_triangle(nb_it) % nb_it, M1, M2, M3, option_display
%
% Author : nicolas.douillet (at) free.fr, 2024.


% Principe : construire par agencements, plutôt que creuser des trous
%            -> par décalage / translations du pattern de base


addpath('..\tools\');


% % I Basis pattern
% % Body
% nb_it = 1; % 0 impossible µ calcul auto en fonction du nb d'itérations (!)
% sample_step = 5;
% 
% M1 = [1 0 0];
% M2 = [-0.5  0.5*sqrt(3) 0];
% M3 = [-0.5 -0.5*sqrt(3) 0];
% 
% [V,T] = sample_triangle(M1',M2',M3',sample_step); % create a meshed triangle
% 
% 
% % Indice qui doit fonctionner quel que soit l'ordre des sommets du triangle
% % M1M2M3
% T(idx,:) = []; % idx = 17


M1 = [1 0 0];
M2 = [-0.5  0.5*sqrt(3) 0];
M3 = [-0.5 -0.5*sqrt(3) 0];

nb_it = 1;
option_display = true;
    

if nargin < 1
        
    nb_it = 1;
    option_display = true;
    
end


% Body
summit_array = cat(1,M1,M2,M3);
p = 0;
sample_step = 5; % for iteration #1 / basis

for k = 2:nb_it
    sample_step = 2*sample_step - 1;
end


% nb_it iterations / loops over tetrahedron split function
while p ~= nb_it
    
    % tetrahedric base
    u = summit_array(2,:,1) - summit_array(1,:,1);
    v = summit_array(3,:,1) - summit_array(1,:,1);
    
    new_summit_array = zeros(3,3,3^p);
    
    for k = 1:size(summit_array,3)
        
        new_summit_array(:,:,1+3*(k-1):3*k) = compute_new_triangle_summits(summit_array(1,:,k),summit_array(2,:,k),summit_array(3,:,k),u,v,sample_step); % vecteur de sample_step ?
        
    end
    
    sample_step = ceil(0.5*sample_step);
    summit_array = new_summit_array;
    p = p+1;
    
end

V = zeros(0,3);
T = zeros(0,3);


for k = 1:size(summit_array,3)        
    
    [V_sub,T_sub] = sample_triangle(summit_array(:,1,k),summit_array(:,2,k),summit_array(:,3,k),sample_step);
            
    if k > 1
        
        T_sub = T_sub + size(V,1);
        
    end
    
    V = cat(1,V,V_sub);
    T = cat(1,T,T_sub);
    
end


% Remove duplicated vertices
[V,T] = remove_duplicated_vertices(V,T);

% % Remove duplicated triangles
% T = unique(sort(T,2),'rows','stable');


if option_display
    
    figure;
    set(gcf,'Color',[0 0 0]);
    t = trisurf(T,V(:,1),V(:,2),V(:,3)); shading flat, hold on;
    t.EdgeColor = 'g';
    set(gca,'Color',[0 0 0],'XColor',[1 1 1],'YColor',[1 1 1],'ZColor',[1 1 1]);
    colormap([0 1 0]);
    axis equal, axis tight;
    camlight right;
    camlight head;
    alpha(0.5);
    
end




end


% compute_new_tetra_summits subfunction
function M_new = compute_new_triangle_summits(M1, M2, M3, u, v, sample_step)


u_floor_shift = floor(0.5*sample_step)*u/sample_step;
u_ceil_shift  =  ceil(0.5*sample_step)*u/sample_step;
v_floor_shift = floor(0.5*sample_step)*v/sample_step;
v_ceil_shift  =  ceil(0.5*sample_step)*v/sample_step;

% Right floor triangle
R1 = M1;
R2 = M1 + u_ceil_shift;
R3 = M1 + v_ceil_shift;
R = cat(1,R1,R2,R3);

% top Left triangle
L1 = M1 + u_floor_shift;
L2 = M2; % M1' + u; 
L3 = M1 + u_floor_shift + v_ceil_shift;
L = cat(1,L1,L2,L3);

% Bottom left triangle
B1 = M1 + v_floor_shift;
B2 = M1 + v_floor_shift + u_ceil_shift;
B3 = M3; % M1' + v 
B = cat(1,B1,B2,B3);
    
M_new = cat(3,R,L,B);    


end % compute_new_triangle_summits