function [C] = Menger_cube_main_algo(C,k)


epsilon = 1e4 * eps;
sup_edglength = 0;
inf_edglength = Inf;

% à optimiser, maximum dans une structure
for n = 1:size(C,3)
    
    max_X = max(C(:,:,n).vertex(:,1));
    min_X = min(C(:,:,n).vertex(:,1));
    inf_edglength = min(max_X-min_X,inf_edglength);
    sup_edglength = max(max_X-min_X,sup_edglength);

end

h = 2/3;
p = 0;

while p ~= 1 
    
    new_C_array = C;
    cube_idx_to_suppr = [];
    
    for j = 1 : size(C,3)
        
        C_current = C(:,:,j);
            
        if k > 1
        
            if (max(C_current.vertex(:,1)) - min(C_current.vertex(:,1)) < sup_edglength*h^(p-1) + epsilon  && ...
                max(C_current.vertex(:,1)) - min(C_current.vertex(:,1)) > inf_edglength*h^(p-1) - epsilon)
        
                cube_idx_to_suppr = cat(2,cube_idx_to_suppr,j);            
                [V_new, F_new] = split_Menger_cube(C_current);
        
                for m = 1:size(F_new,1)/6 %  20 = 120 / 6
            
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
        
        else
           
            cube_idx_to_suppr = cat(2,cube_idx_to_suppr,j);            
            [V_new, F_new] = split_Menger_cube(C_current);
        
            for m = 1:size(F_new,1)/6 %  20 = 120 / 6
            
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
    p = p+1;
    
end


end % Menger_cube_main_algo


function [C] = cube(V1, V2, V3, V4, V5, V6, V7, V8)
%
% Author & support : nicolas.douillet (at) free.fr, 2017-2022.
%
% V1, V2, V3, V4, V5, V6, V7, V8 : line vectors of cube eight vertices coordinates
%
% Vn = [Vxn Vyn Vzn]

F1 = [1 2 3 4];
F2 = [5 6 7 8];
F3 = [1 4 8 5];
F4 = [2 1 5 6];
F5 = [2 3 7 6];
F6 = [3 4 8 7];

C = struct('vertex', [V1; V2; V3; V4; V5; V6; V7; V8], ...
    'facet', [F1; F2; F3; F4; F5; F6]);

end % cube