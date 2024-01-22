function [V, T] = sierpinski_solid_tetrahedron(nb_it, M1, M2, M3, M4)
%
% Author : nicolas.douillet (at) free.fr, 2017-2024.


if nargin < 2
    M1 = [2*sqrt(2)/3  0         -1/3]; % right vertex
    M2 = [-sqrt(2)/3  sqrt(6)/3  -1/3]; % top left vertex
    M3 = [-sqrt(2)/3 -sqrt(6)/3  -1/3]; % bottom left vertex
    M4 = [ 0          0           1  ]; % top vertex
end

summit_array = cat(1,M1,M2,M3,M4);
p = 0;
sample_step = 4*2^(nb_it-1) + 1;

% nb_it iterations / loops over tetrahedron split function
while p ~= nb_it  
    
    % tetrahedric base
    u = summit_array(2,:,1) - summit_array(1,:,1);
    v = summit_array(3,:,1) - summit_array(1,:,1);
    w = summit_array(4,:,1) - summit_array(1,:,1);
    
    new_summit_array = zeros(4,3,4^p);
    
    for k = 1:size(summit_array,3)        
        new_summit_array(:,:,1+4*(k-1):4*k) = compute_new_tetra_summits(summit_array(1,:,k),summit_array(2,:,k),...
                                                                        summit_array(3,:,k),summit_array(4,:,k),...
                                                                        u,v,w,sample_step);        
    end
    
    sample_step = ceil(0.5*sample_step);
    summit_array = new_summit_array;
    p = p+1;    
end

V = zeros(0,3);
T = zeros(0,3);

for k = 1:size(summit_array,3)            
    [V_sub,T_sub] = mesh_tetrahedron(summit_array(:,:,k),sample_step);
            
    if k > 1        
        T_sub = T_sub + size(V,1);        
    end
    
    V = cat(1,V,V_sub);
    T = cat(1,T,T_sub);    
end

% % Remove duplicated triangles
% T = unique(sort(T,2),'rows','stable');

end