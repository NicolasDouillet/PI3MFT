function [V, T] = iterate_over_jerusalem_cube(a, nb_it, pattern_id, subcube_nb)
%
% Author : nicolas.douillet (at) free.fr, 2017-2024.


edglength = 2*a;

V1 = [a a a];
V2 = [-a a a];
V3 = [-a -a a];
V4 = [a -a a];
V5 = -V3;
V6 = -V4;
V7 = -V1;
V8 = -V2;

C = cube(V1, V2, V3, V4, V5, V6, V7, V8);

h = sqrt(2) - 1; % homothetic ratio
p = 0;

while p ~= nb_it+2        
    
    if p == 1
        
        new_C_array = repmat(C, [1 1 subcube_nb]);
        
        for j = 1 : size(C,3)
            
            C_current = C(:,:,j);                                    
            [V_new, F_new] = split_jerusalem_cube(C_current,h,pattern_id);
            
            for m = 1:size(F_new,1)/6 %  = 20 = 120 / 6
                
                new_cube = cube(V_new(F_new(6*(m-1)+1,1),:),...
                                V_new(F_new(6*(m-1)+1,2),:),...
                                V_new(F_new(6*(m-1)+1,3),:),...
                                V_new(F_new(6*(m-1)+1,4),:),...
                                V_new(F_new(6*(m-1)+2,1),:),...
                                V_new(F_new(6*(m-1)+2,2),:),...
                                V_new(F_new(6*(m-1)+2,3),:),...
                                V_new(F_new(6*(m-1)+2,4),:)); % first two lines vertices in this order
                
                new_C_array(:,:,subcube_nb*(j-1) + m) = new_cube;
                
            end
            
        end
        
        C = new_C_array;
        
    elseif p > 1
        
        new_C_array = C;
        cube_idx_to_suppr = [];
        
        for j = 1 : size(C,3)
            
            C_current = C(:,:,j);
            
            if (max(C_current.vertex(:,1)) - min(C_current.vertex(:,1))) > edglength*h^(p-1)
                
                cube_idx_to_suppr = cat(2,cube_idx_to_suppr,j);
                [V_new, F_new] = split_jerusalem_cube(C_current,h,pattern_id);
                
                for m = 1:size(F_new,1)/6 %  = 20 = 120 / 6
                    
                    new_cube = cube(V_new(F_new(6*(m-1)+1,1),:),...
                                    V_new(F_new(6*(m-1)+1,2),:),...
                                    V_new(F_new(6*(m-1)+1,3),:),...
                                    V_new(F_new(6*(m-1)+1,4),:),...
                                    V_new(F_new(6*(m-1)+2,1),:),...
                                    V_new(F_new(6*(m-1)+2,2),:),...
                                    V_new(F_new(6*(m-1)+2,3),:),...
                                    V_new(F_new(6*(m-1)+2,4),:)); % first two lines vertices in this order
                    
                    new_C_array = cat(3,new_C_array,new_cube);
                    
                end
                
            end
            
        end
        
        new_C_array(:,:,cube_idx_to_suppr) = [];
        C = new_C_array;
        
    end
        
    p = p+1;
    
end

[V,T] = squares2triangles(C);
clear C;


end