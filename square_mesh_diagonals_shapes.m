function [V, T] = square_mesh_diagonals_shapes(nb_it, option_display)
%
% Author & support : nicolas.douillet (at) free.fr, 2023.


% Body
% Summits of original cube (living in the unit sphere R(O,1))
a = 1;
% edglength = 2*a;

V1 = [a a a];
V2 = [-a a a];
V3 = [-a -a a];
V4 = [a -a a];
V5 = -V3;
V6 = -V4;
V7 = -V1;
V8 = -V2;

C = cube(V1, V2, V3, V4, V5, V6, V7, V8);


p = 0;

while p ~= nb_it
        
    new_C_array = repmat(C, [1 1 22]);
    
    for j = 1 : size(C,3)
        
        C_current = C(:,:,j);
        [V_new, F_new] = split_cube(C_current);
        
        for m = 1:size(F_new,1)/6
            
            new_cube = cube(V_new(F_new(6*(m-1)+1,1),:),...
                            V_new(F_new(6*(m-1)+1,2),:),...
                            V_new(F_new(6*(m-1)+1,3),:),...
                            V_new(F_new(6*(m-1)+1,4),:),...
                            V_new(F_new(6*(m-1)+2,1),:),...
                            V_new(F_new(6*(m-1)+2,2),:),...
                            V_new(F_new(6*(m-1)+2,3),:),...
                            V_new(F_new(6*(m-1)+2,4),:));
            
            new_C_array(:,:,22*(j-1) + m) = new_cube;
            
        end                
        
    end
       
    C = new_C_array;            
    p = p+1;
    
end
    

% Squares to triangles conversion
[V,T] = squares2triangles(C);


twisted_cube_option = false;
twisted_cylinder_option = false;
cylinder_option = false;
torus_option = false;
ball_option = true;


if ball_option        
    
    [V,C] = ball_transformation(V,a);
    
end


Mrz = @(theta)[cos(theta) -sin(theta) 0;
               sin(theta)  cos(theta) 0;
               0           0          1];
               

if twisted_cube_option       
   
    [V, C] = twisted_cube_transformation(V, Mrz);           
    
end


if cylinder_option || torus_option
    
    C = max(abs(V(:,1:2)),[],2);    
    V(:,3) = 0.125*pi*(1+V(:,3));        
        
end

if torus_option
    
    C = cat(1,C,C,C,C,C,C,C,C);
    
end


if cylinder_option || torus_option        
    
    % - (1) Déterminer le vecteur normal du plan du cube le plus proche
    % de chaque point M (table)
    
    f = abs(V(:,1:2)) == max(abs(V(:,1:2)),[],2);
    n = cat(2,a * sign(V(:,1:2)) .* f, zeros(size(V,1),1));
    
    % - (2) Calculer I, le point d'intersection entre le vecteur OM et ce plan (besoin algos line-plane intersection
    % distance) ; même point du plan pris que vecteur normal
    
    M = n;
    u = cat(2,V(:,1:2)./sqrt(sum(V(:,1:2).^2,2)),zeros(size(V,1),1));
    
    I = V + u .* (dot(n,M,2) - dot(n,V,2)) ./ dot(n,u,2);
    
    % - (3) Calculer le ratio de distances k = OI / r (r, le rayon de la sphère circonscrite; a ici)
    % - (4) Multiplier OM par r.
    
    k = a ./ sqrt(sum(I(:,1:2).^2,2));
    V(:,1:2) = k .* V(:,1:2);
    
    if twisted_cylinder_option
        
        for k = 1:size(V,1)
            
            V(k,:) = (Mrz(V(k,3))*V(k,:)')';
            
        end
        
    end
    
end


if torus_option        
    
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
    
    % 0.125*pi rotate all the other cylinders from their basis
    V = cat(1,V,(Mry(0.25*pi)*V')');
    T = cat(1,T,T+size(V,1));
    V = cat(1,V,(Mry(0.5*pi)*V')');
    T = cat(1,T,T+size(V,1));
    V = cat(1,V,(Mry(pi)*V')');
            
end


% Display
if option_display          
    
    disp_square_mesh_diagonals_shapes(V,T,C);
    
end


end % square_mesh_diagonals_shapes_shapes


% Split cube subfunction
function [V_new, F_new] = split_cube(C)
% Input
%
% C : cube structure
%
%
% Outputs
%
% V_new : the newly created vertices -coordinates-
% F_new : the newly created facets line indices


% Six possible values for each coordinate, X, Y, or Z
val1x = min(C.vertex(:,1));
val6x = max(C.vertex(:,1));
val2x = val1x +  0.2 * (val6x - val1x);
val3x = val1x +  0.4 * (val6x - val1x);
val4x = val1x +  0.6 * (val6x - val1x);
val5x = val1x +  0.8 * (val6x - val1x);

val1y = min(C.vertex(:,2));
val6y = max(C.vertex(:,2));
val2y = val1y +  0.2 * (val6y - val1y);
val3y = val1y +  0.4 * (val6y - val1y);
val4y = val1y +  0.6 * (val6y - val1y);
val5y = val1y +  0.8 * (val6y - val1y);

val1z = min(C.vertex(:,3));
val6z = max(C.vertex(:,3));
val2z = val1z + 0.2 * (val6z - val1z);
val3z = val1z + 0.4 * (val6z - val1z);
val4z = val1z + 0.6 * (val6z - val1z);
val5z = val1z + 0.8 * (val6z - val1z);


V_new = [val6x val6y val6z; % Top first layer
    val5x val6y val6z;
    val4x val6y val6z;
    val3x val6y val6z;
    val2x val6y val6z;
    val1x val6y val6z;
    
    val6x val5y val6z;
    val5x val5y val6z;
    val4x val5y val6z;
    val3x val5y val6z;
    val2x val5y val6z;
    val1x val5y val6z;
    
    val6x val4y val6z;
    val5x val4y val6z;
    val4x val4y val6z;
    val3x val4y val6z;
    val2x val4y val6z;
    val1x val4y val6z;
    
    val6x val3y val6z;
    val5x val3y val6z;
    val4x val3y val6z;
    val3x val3y val6z;
    val2x val3y val6z;
    val1x val3y val6z;
    
    val6x val2y val6z;
    val5x val2y val6z;
    val4x val2y val6z;
    val3x val2y val6z;
    val2x val2y val6z;
    val1x val2y val6z;
    
    val6x val1y val6z;
    val5x val1y val6z;
    val4x val1y val6z;
    val3x val1y val6z;
    val2x val1y val6z;
    val1x val1y val6z;...
    
    
    val6x val6y val5z; % Top second layer
    val5x val6y val5z;
    val4x val6y val5z;
    val3x val6y val5z;
    val2x val6y val5z;
    val1x val6y val5z;
    
    val6x val5y val5z;
    val5x val5y val5z;
    val4x val5y val5z;
    val3x val5y val5z;
    val2x val5y val5z;
    val1x val5y val5z;
    
    val6x val4y val5z;
    val5x val4y val5z;
    val4x val4y val5z;
    val3x val4y val5z;
    val2x val4y val5z;
    val1x val4y val5z;
    
    val6x val3y val5z;
    val5x val3y val5z;
    val4x val3y val5z;
    val3x val3y val5z;
    val2x val3y val5z;
    val1x val3y val5z;
    
    val6x val2y val5z;
    val5x val2y val5z;
    val4x val2y val5z;
    val3x val2y val5z;
    val2x val2y val5z;
    val1x val2y val5z;
    
    val6x val1y val5z;
    val5x val1y val5z;
    val4x val1y val5z;
    val3x val1y val5z;
    val2x val1y val5z;
    val1x val1y val5z;...
    
    
    val6x val6y val4z; % Top third layer
    val5x val6y val4z;
    val4x val6y val4z;
    val3x val6y val4z;
    val2x val6y val4z;
    val1x val6y val4z;
    
    val6x val5y val4z;
    val5x val5y val4z;
    val4x val5y val4z;
    val3x val5y val4z;
    val2x val5y val4z;
    val1x val5y val4z;
    
    val6x val4y val4z;
    val5x val4y val4z;
    val4x val4y val4z;
    val3x val4y val4z;
    val2x val4y val4z;
    val1x val4y val4z;
    
    val6x val3y val4z;
    val5x val3y val4z;
    val4x val3y val4z;
    val3x val3y val4z;
    val2x val3y val4z;
    val1x val3y val4z;
    
    val6x val2y val4z;
    val5x val2y val4z;
    val4x val2y val4z;
    val3x val2y val4z;
    val2x val2y val4z;
    val1x val2y val4z;
    
    val6x val1y val4z;
    val5x val1y val4z;
    val4x val1y val4z;
    val3x val1y val4z;
    val2x val1y val4z;
    val1x val1y val4z;...
    
    
    val6x val6y val3z; % Bottom third layer
    val5x val6y val3z;
    val4x val6y val3z;
    val3x val6y val3z;
    val2x val6y val3z;
    val1x val6y val3z;
    
    val6x val5y val3z;
    val5x val5y val3z;
    val4x val5y val3z;
    val3x val5y val3z;
    val2x val5y val3z;
    val1x val5y val3z;
    
    val6x val4y val3z;
    val5x val4y val3z;
    val4x val4y val3z;
    val3x val4y val3z;
    val2x val4y val3z;
    val1x val4y val3z;
    
    val6x val3y val3z;
    val5x val3y val3z;
    val4x val3y val3z;
    val3x val3y val3z;
    val2x val3y val3z;
    val1x val3y val3z;
    
    val6x val2y val3z;
    val5x val2y val3z;
    val4x val2y val3z;
    val3x val2y val3z;
    val2x val2y val3z;
    val1x val2y val3z;
    
    val6x val1y val3z;
    val5x val1y val3z;
    val4x val1y val3z;
    val3x val1y val3z;
    val2x val1y val3z;
    val1x val1y val3z;...
    
    
    val6x val6y val2z; % Bottom second layer
    val5x val6y val2z;
    val4x val6y val2z;
    val3x val6y val2z;
    val2x val6y val2z;
    val1x val6y val2z;
    
    val6x val5y val2z;
    val5x val5y val2z;
    val4x val5y val2z;
    val3x val5y val2z;
    val2x val5y val2z;
    val1x val5y val2z;
    
    val6x val4y val2z;
    val5x val4y val2z;
    val4x val4y val2z;
    val3x val4y val2z;
    val2x val4y val2z;
    val1x val4y val2z;
    
    val6x val3y val2z;
    val5x val3y val2z;
    val4x val3y val2z;
    val3x val3y val2z;
    val2x val3y val2z;
    val1x val3y val2z;
    
    val6x val2y val2z;
    val5x val2y val2z;
    val4x val2y val2z;
    val3x val2y val2z;
    val2x val2y val2z;
    val1x val2y val2z;
    
    val6x val1y val2z;
    val5x val1y val2z;
    val4x val1y val2z;
    val3x val1y val2z;
    val2x val1y val2z;
    val1x val1y val2z;...
    
    
    val6x val6y val1z; % Bottom first layer
    val5x val6y val1z;
    val4x val6y val1z;
    val3x val6y val1z;
    val2x val6y val1z;
    val1x val6y val1z;
    
    val6x val5y val1z;
    val5x val5y val1z;
    val4x val5y val1z;
    val3x val5y val1z;
    val2x val5y val1z;
    val1x val5y val1z;
    
    val6x val4y val1z;
    val5x val4y val1z;
    val4x val4y val1z;
    val3x val4y val1z;
    val2x val4y val1z;
    val1x val4y val1z;
    
    val6x val3y val1z;
    val5x val3y val1z;
    val4x val3y val1z;
    val3x val3y val1z;
    val2x val3y val1z;
    val1x val3y val1z;
    
    val6x val2y val1z;
    val5x val2y val1z;
    val4x val2y val1z;
    val3x val2y val1z;
    val2x val2y val1z;
    val1x val2y val1z;
    
    val6x val1y val1z;
    val5x val1y val1z;
    val4x val1y val1z;
    val3x val1y val1z;
    val2x val1y val1z;
    val1x val1y val1z;...
    ];


F_new = [
         % Top layer
        
         1 2 8 7; % Top layer top right corner cube
         37 38 44 43;
         1 7 43 37;
         2 1 37 38;
         8 2 38 44;
         7 8 44 43;...
    
         8 9 15 14; % Top layer first right-left diagonal cube (+7)
         44 45 51 50;
         8 14 50 44;
         9 8 44 45;
         15 9 45 51;
         14 15 51 50;...         
         
         15 16 22 21; % Top layer centre cube
         51 52 58 57;
         15 21 57 51;
         16 15 51 52;
         22 16 52 58;
         21 22 58 57;...
         
         22 23 29 28; % Top layer third right-left diagonal cube (+7)
         58 59 65 64;
         22 28 64 58;
         23 22 58 59;
         29 23 59 65;
         28 29 65 64;...
         
         29 30 36 35; % Top layer bottom left corner cube
         65 66 72 71;
         29 35 71 65;
         30 29 65 66;
         36 30 66 72;
         35 36 72 71;...
         
        
         % Layer #2
         
         38 39 45 44; % 2nd layer back face top right cube (+37)
         74 75 81 80;
         38 44 80 74;
         39 38 74 75;
         45 39 75 81;
         44 45 81 80;...                  
         
         43 44 50 49; % 2nd layer right face top right cube (+5)
         79 80 86 85;
         43 49 85 79;
         44 43 79 80;
         50 44 80 86;
         49 50 86 85;...         
         
         59 60 66 65; % 2nd layer left face top right cube (+12)
         95 96 102 101;
         59 65 101 95;
         60 59 95 96;
         66 60 96 102;
         65 66 102 101;...         
                  
         64 65 71 70; % 2nd layer back face top left cube (+24)
         100 101 107 106;
         64 70 106 100;
         65 64 100 101;
         71 65 101 107;
         70 71 107 106;...
                  
         % Layer #3 / middle layer 
         
         75 76 82 81; % layer #3 top edge middle cube
         111 112 118 117;
         75 81 117 111;
         75 75 111 112;
         82 76 112 118;
         81 82 118 117;...
                  
         85 86 92 91; % layer #3 right edge middle cube
         121 122 128 127;
         85 91 127 121;
         86 85 121 122;
         92 86 122 128;
         91 92 128 127;...
                           
         89 90 96 95; % layer #3 left edge middle cube
         125 126 132 131;
         89 95 131 125;
         90 89 125 126;
         96 90 126 132;
         95 96 132 131;...
                  
         99 100 106 105; % layer #3 bottom edge middle cube
         135 136 142 141;
         99 105 141 135;
         100 99 135 136;
         106 100 136 142;
         105 106 142 141;...
         
         
         % Layer #4 (= layer #2 + 72)         
                  
         112 113 119 118; % 4th layer back face top left cube 
         148 149 155 154;
         112 118 154 148;
         113 112 148 149;
         119 113 149 155;
         118 119 155 154;...         
         
         119 120 126 125; % 4th layer left face top left cube 
         155 156 162 161;
         119 125 161 155;
         120 119 155 156;
         126 120 156 162;
         125 126 162 161;...
         
         127 128 134 133; % 4th layer right face top left cube
         163 164 170 169;
         127 133 169 163;
         128 127 163 164;
         134 128 164 170;
         133 134 170 169;...
         
         134 135 141 140; % 4th layer front face top right cube
         170 171 177 176;
         134 140 176 170;
         135 134 170 171;
         141 135 171 177;
         140 141 177 176;...
                  
                          
         % Bottom layer (+ 4 x 36 = 144)         
         
         159 160 166 165; % Bottom layer centre cube (+7)
         195 196 202 201;
         159 165 201 195;
         160 159 195 196;
         166 160 196 202;
         165 166 202 201;...         
         
         % 2nd diagonal
         
         149 150 156 155; % Bottom layer top left corner cube (+1)
         185 186 192 191;
         149 155 191 185;
         150 149 185 186;
         156 150 186 192;
         155 156 192 191;...
         
         154 155 161 160; % Bottom layer first left-right diagonal cube (+5)
         190 191 197 196;
         154 160 196 190;
         155 154 190 191;
         161 155 191 197;
         160 161 197 196;...
         
         164 165 171 170; % Bottom layer third left-right diagonal cube (+10)
         200 201 207 206;
         164 170 206 200;
         165 164 200 201;
         171 165 201 207;
         170 171 207 206;...         
         
         169 170 176 175; % Bottom layer bottom right corner cube
         205 206 212 211;
         169 175 211 205;
         170 169 205 206;
         176 170 206 212;
         175 176 212 211;...                                      
    ];

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
% Author & support : nicolas.douillet (at) free.fr, 2017-2021.
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
function [] = disp_square_mesh_diagonals_shapes(V, T, C)
%
% Author & support : nicolas.douillet (at) free.fr, 2017-2022.

% C = max(abs(V),2);
C = sqrt(sum(V.^2,2));

figure;
set(gcf,'Color',[0 0 0]), set(gca,'Color',[0 0 0]);
trisurf(T,V(:,1),V(:,2),V(:,3),C), shading interp, hold on;
colormap(1-jet.^0.5);
axis square, axis equal, axis tight, axis off;
grid off;
ax = gca;
ax.Clipping = 'off';
camlight left;
view(-35,28.7080); % view(-45,35);
zoom(1.1);

end % disp_square_mesh_diagonals_shapes


% Remove duplicated vertices subfunction
function [V_out, T_out] = remove_duplicated_vertices(V_in, T_in)
%
% Author & support : nicolas.douillet (at) free.fr, 2017-2022.

tol = 1e4*eps;
[V_out,~,n] = uniquetol(V_in,tol,'ByRows',true);
T_out = n(T_in);

end % remove_duplicated_vertices