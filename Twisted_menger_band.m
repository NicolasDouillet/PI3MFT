function [V, T, C] = Twisted_menger_band(nb_it, option_display)
%
% Author & support : nicolas.douillet (at) free.fr, 2022.

% Summits of original cube
a = 1;

V1 = [a a a];
V2 = [-a a a];
V3 = [-a -a a];
V4 = [a -a a];
V5 = -V1;
V6 = -V2;
V7 = -V3;
V8 = -V4;

C = cube(V1, V2, V3, V4, V5, V6, V7, V8);


% % Loop on nb_it
% p = 0;
% 
% while p ~= nb_it 
%     
%     new_C_array = repmat(C, [1 1 20]);
%     
%     for j = 1 : size(C,3)
%         
%         C_current = C(:,:,j);        
%         [V_new, F_new] = split_cube(C_current);
%         
%         for m = 1:size(F_new,1)/6 %  20 = 120 / 6
%             
%             new_cube = cube(V_new(F_new(6*(m-1)+1,1),:),...
%                             V_new(F_new(6*(m-1)+1,2),:),...
%                             V_new(F_new(6*(m-1)+1,3),:),...
%                             V_new(F_new(6*(m-1)+1,4),:),...
%                             V_new(F_new(6*(m-1)+2,1),:),...
%                             V_new(F_new(6*(m-1)+2,2),:),...
%                             V_new(F_new(6*(m-1)+2,3),:),...
%                             V_new(F_new(6*(m-1)+2,4),:)); % first two lines vertices in this order
%                         
%             new_C_array(:,:,20*(j-1) + m) = new_cube;
%             
%         end
%         
%     end
%     
%     C = new_C_array;        
%     p = p+1;
%     
% end


% For the MengerusaleMoebius
for k = 1:nb_it
    
    if mod(k,2) == 0
        
        C = Jerusalem_cube_main_algo(C,k);
                
    else
        
        C = Menger_cube_main_algo(C,k);
        
    end
    
end


% Squares to triangles conversion
[V,T] = squares2triangles(C);


Mrz = @(theta)[cos(theta) -sin(theta) 0;
    sin(theta)  cos(theta) 0;
    0           0          1];


C = max(abs(V(:,1:2)),[],2);
V(:,3) = 0.125*pi*(1+V(:,3));
C = cat(1,C,C,C,C,C,C,C,C);


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

V(:,3) = V(:,3) + sin(Z);
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
    
    disp_Twisted_menger_band(V,T,C);
    
end


end % Twisted_menger_band


% Split cube subfunction
function [V_new, F_new] = split_cube(C)
% Input
%
% C : cube structure
%
%
% Outputs
%
% V_new : The 8 + 4*6 + 8 = 40 (8 old + 32 new) newly created vertices -coordinates-
% F_new : 6 x 20 = 120 newly created facets line indices


one_third = 1/3;
two_third = 2/3;

% Four possible values for each coordinate, X, Y, or Z
val1x = min(C.vertex(:,1)); % min value
val4x = max(C.vertex(:,1)); % max value
val2x = val1x + one_third * (val4x - val1x);
val3x = val1x + two_third * (val4x - val1x);

val1y = min(C.vertex(:,2)); % min value
val4y = max(C.vertex(:,2)); % max value
val2y = val1y + one_third * (val4y - val1y);
val3y = val1y + two_third * (val4y - val1y);

val1z = min(C.vertex(:,3)); % min value
val4z = max(C.vertex(:,3)); % max value
val2z = val1z + one_third * (val4z - val1z);
val3z = val1z + two_third * (val4z - val1z);


% Compute  (8) + 4*6 + 8 = 40 new vertices coordinates

V_new = [val4x val4y val4z; % Top layer
         val3x val4y val4z; 
         val2x val4y val4z;
         val1x val4y val4z;
         val4x val3y val4z;
         val3x val3y val4z;
         val2x val3y val4z;
         val1x val3y val4z;
         val4x val2y val4z;
         val3x val2y val4z;
         val2x val2y val4z;
         val1x val2y val4z;
         val4x val1y val4z;
         val3x val1y val4z;
         val2x val1y val4z;
         val1x val1y val4z;...
         
         val4x val4y val3z; % Bottom first layer
         val3x val4y val3z; 
         val2x val4y val3z;
         val1x val4y val3z;
         val4x val3y val3z;
         val3x val3y val3z;
         val2x val3y val3z;
         val1x val3y val3z;
         val4x val2y val3z;
         val3x val2y val3z;
         val2x val2y val3z;
         val1x val2y val3z;
         val4x val1y val3z;
         val3x val1y val3z;
         val2x val1y val3z;
         val1x val1y val3z;...
         
         val4x val4y val2z; % Bottom second layer
         val3x val4y val2z; 
         val2x val4y val2z;
         val1x val4y val2z;
         val4x val3y val2z;
         val3x val3y val2z;
         val2x val3y val2z;
         val1x val3y val2z;
         val4x val2y val2z;
         val3x val2y val2z;
         val2x val2y val2z;
         val1x val2y val2z;
         val4x val1y val2z;
         val3x val1y val2z;
         val2x val1y val2z;
         val1x val1y val2z;...
         
         val4x val4y val1z; % Bottom face
         val3x val4y val1z; 
         val2x val4y val1z;
         val1x val4y val1z;
         val4x val3y val1z;
         val3x val3y val1z;
         val2x val3y val1z;
         val1x val3y val1z;
         val4x val2y val1z;
         val3x val2y val1z;
         val2x val2y val1z;
         val1x val2y val1z;
         val4x val1y val1z;
         val3x val1y val1z;
         val2x val1y val1z;
         val1x val1y val1z]; 

% 6 x 20 = 120 new facets
% /_!_\ Counter clockwise sorted for squares /_!_\

% General model  for a (a b c d e f g h) cube
% a b c d
% e f g h
% a d h e
% b a e f
% c b f g
% d c g h

F_new = [1 2 6 5; % Top layer top right corner cube
         17 18 22 21;
         1 5 21 17;
         2 1 17 18;
         6 2 18 22;
         5 6 22 21;...
         
         2 3 7 6; % Top layer top cross cube
         18 19 23 22;
         2 6 22 18;
         3 2 18 19;
         7 3 19 23;
         6 7 23 22;...         
         
         3 4 8 7; % Top layer top left corner cube
         19 20 24 23;
         3 7 23 19;
         4 3 19 20;
         8 4 20 24;
         7 8 24 23;...
         
         5 6 10 9; % Top layer right cross cube
         21 22 26 25;
         5 9 25 21;
         6 5 21 22;
         10 6 22 26;
         9 10 26 25;...
         
         7 8 12 11; % Top layer left cross cube
         23 24 28 27;
         7 11 27 23;
         8 7 23 24;
         12 8 24 28;
         11 12 28 27;...
         
         9 10 14 13; % Top layer bottom right corner cube
         25 26 30 29;
         9 13 29 25;
         10 9 25 26;
         14 10 26 30;
         13 14 30 29;...
         
         10 11 15 14; % Top layer bottom cross cube
         26 27 31 30;
         10 14 30 26;
         11 10 26 27;
         15 11 27 31;
         14 15 31 30;...
         
         11 12 16 15; % Top layer bottom left corner cube
         27 28 32 31;
         11 15 31 27;
         12 11 27 28;
         16 12 28 32;
         15 16 32 31;...         
         
         17 18 22 21; % Middle layer top right corner cube
         33 34 38 37;
         17 21 37 33;
         18 17 33 34;
         22 18 34 38;
         21 22 38 37;...                      
         
         19 20 24 23; % Middle layer top left corner cube
         35 36 40 39;
         19 23 39 35;
         20 19 35 36;
         24 20 36 40;
         23 24 40 39;...                                    
         
         25 26 30 29; % Middle layer bottom right corner cube
         41 42 46 45;
         25 29 45 41;
         26 25 41 42;
         30 26 42 46;
         29 30 46 45;...                  
         
         27 28 32 31; % Middle layer bottom left corner cube
         43 44 48 47;
         27 31 47 43;
         28 27 43 44;
         32 28 44 48;
         31 32 48 47;...          
         
         33 34 38 37; % Bottom layer top right corner cube
         49 50 54 53;
         33 37 53 49;
         34 33 49 50;
         38 34 50 54;
         37 38 54 53;...
         
         34 35 39 38; % Bottom layer top cross cube
         50 51 55 54;
         34 38 54 50;
         35 34 50 51;
         39 35 51 55;
         38 39 55 54;...         
         
         35 36 40 39; % Bottom layer top left corner cube
         51 52 56 55;
         35 39 56 51;
         36 35 51 52;
         40 36 52 56;
         39 40 56 55;...
         
         37 38 42 41; % Bottom layer right cross cube
         53 54 58 57;
         37 41 57 53;
         38 37 53 54;
         42 38 54 58;
         41 42 58 57;...
         
         39 40 44 43; % Bottom layer left cross cube
         55 56 60 59;
         39 43 59 55;
         40 39 55 56;
         44 40 56 60;
         43 44 60 59;...
         
         41 42 46 45; % Bottom layer bottom right corner cube
         57 58 62 61;
         41 45 61 57;
         42 41 57 58;
         46 42 58 62;
         45 46 62 61;...
         
         42 43 47 46; % Bottom layer bottom cross cube
         58 59 63 62;
         42 46 62 58;
         43 42 58 59;
         47 43 59 63;
         46 47 63 62;...
         
         43 44 48 47; % Bottom layer bottom left corner cube
         59 60 64 63;
         43 47 63 59;
         44 43 59 60;
         48 44 60 64;
         47 48 64 63];

end % split_cube


% Build cube structure subfunction
function [C] = cube(V1, V2, V3, V4, V5, V6, V7, V8)
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


% Squares to triangles conversion subfunction
function [V, T] = squares2triangles(C)
%
% Author & support : nicolas.douillet (at) free.fr, 2017-2020.
%
% Split struct array into two arrays : vertices & facets

S = size(C,3);
V = zeros(8*S,3);
T = zeros(12*S,3);

for k = 1:S
    
    for i = 1:size(C(:,:,k).vertex,1)
        
        V(8*(k-1)+i,:) = C(:,:,k).vertex(i,:);
        
    end
    
    for j = 1:size(C(:,:,k).facet,1) % 6
        
        a = C(:,:,k).facet(j,1) + 8*(k-1);
        b = C(:,:,k).facet(j,2) + 8*(k-1);
        c = C(:,:,k).facet(j,3) + 8*(k-1);
        d = C(:,:,k).facet(j,4) + 8*(k-1);
        
        T1 = sort([a b c]);
        T2 = sort([a d c]);
        
        T(12*(k-1)+2*(j-1)+1,:) = T1;
        T(12*(k-1)+2*j,:) = T2;
        
    end
    
end

% Remove duplicated triangles
T = unique(sort(T,2),'rows','stable');

end % squares2triangles


% Display subfunction
function [] = disp_Twisted_menger_band(V, T, C)

    figure;        
    trisurf(T,V(:,1),V(:,2),V(:,3),C), shading interp, hold on;
    colormap(summer);
    ax = gca;
    ax.Clipping = 'off';
    set(gcf,'Color',[0 0 0]), set(ax,'Color',[0 0 0]);
    axis square, axis equal, axis tight, axis off;
    camlight(315,0);
    view(-25,15);

end % disp_Twisted_menger_band


% Remove duplicated vertices subfunction
function [V_out, T_out] = remove_duplicated_vertices(V_in, T_in)

tol = 1e4*eps;
[V_out,~,n] = uniquetol(V_in,tol,'ByRows',true);
T_out = n(T_in);

end % remove_duplicated_vertices