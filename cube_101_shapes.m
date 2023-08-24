function [V, T] = cube_101_shapes(nb_it, option_display)
%
% Author & support : nicolas.douillet (at) free.fr, 2017-2022.


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
        
    new_C_array = repmat(C, [1 1 57]);
    
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
            
            new_C_array(:,:,57*(j-1) + m) = new_cube;
            
        end                
        
    end
       
    C = new_C_array;            
    p = p+1;
    
end
    

% Squares to triangles conversion
[V,T] = squares2triangles(C);


twisted_cube_option = true;
twisted_cylinder_option = false;
cylinder_option = false;
torus_option = false;
ball_option = false;


Mrz = @(theta)[cos(theta) -sin(theta) 0;
               sin(theta)  cos(theta) 0;
               0           0          1];
               

if twisted_cube_option       
   
    [V, C] = twisted_cube_transformation(V, Mrz);           
    
end


if ball_option        
    
    [V,C] = ball_transformation(V,a);
    
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
    
    disp_cube_101_shapes(V,T,C);
    
end


end % cube_101_shapes


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
    
         2 3 9 8; % Top layer top edge right cube (+1)
         38 39 45 44;
         2 8 44 38;
         3 2 38 39;
         9 3 39 45;
         8 9 45 44;...
         
         3 4 10 9; % Top layer top edge middle cube (+1)
         39 40 46 45;
         3 9 45 39;
         4 3 39 40;
         10 4 40 46;
         9 10 46 45;...
    
         4 5 11 10; % Top layer top edge left cube (+1)
         40 41 47 46;
         4 10 46 40;
         5 4 40 41;
         11 5 41 47;
         10 11 47 46;...
             
         5 6 12 11; % Top layer top left corner cube (+1)
         41 42 48 47;
         5 11 47 41;
         6 5 41 42;
         12 6 42 48;
         11 12 48 47;...
    
         7 8 14 13; % Top layer right edge top cube
         43 44 50 49;
         7 13 49 43;
         8 7 43 44;
         14 8 44 50;
         13 14 50 49;...
         
         11 12 18 17; % Top layer left edge top cube
         47 48 54 53;
         11 17 53 47;
         12 11 47 48;
         18 12 48 54;
         17 18 54 53;...
         
         13 14 20 19; % Top layer right edge middle cube
         49 50 56 55;
         13 19 55 49;
         14 13 49 50;
         20 14 50 56;
         19 20 56 55;...
             
         15 16 22 21; % Top layer centre cube
         51 52 58 57;
         15 21 57 51;
         16 15 51 52;
         22 16 52 58;
         21 22 58 57;...
         
         17 18 24 23; % Top layer left edge middle cube
         53 54 60 59;
         17 23 59 53;
         18 17 53 54;
         24 18 54 60;
         23 24 60 59;...
         
         19 20 26 25; % Top layer right edge bottom cube
         55 56 62 61;
         19 25 51 55;
         20 19 55 56;
         26 20 56 62;
         25 26 62 51;...
         
         23 24 30 29; % Top layer left edge bottom cube
         59 60 66 65;
         23 29 65 59;
         24 23 59 60;
         30 24 60 66;
         29 30 66 65;...
         
         25 26 32 31; % Top layer bottom right corner cube
         61 62 68 67;
         25 31 67 61;
         26 25 61 62;
         32 26 62 68;
         31 32 68 67;...
                  
         26 27 33 32; % Top layer bottom edge right cube (+1)
         62 63 69 68;
         26 32 68 62;
         27 26 62 63;
         33 27 63 69;
         32 33 69 68;...
         
         27 28 34 33; % Top layer bottom edge middle cube (+1)
         63 64 70 69;
         27 33 69 63;
         28 27 63 64;
         34 28 64 70;
         33 34 70 69;...
         
         28 29 35 34; % Top layer bottom edge left cube (+1)
         64 65 71 70;
         28 34 70 64;
         29 28 64 65;
         35 29 65 71;
         34 35 71 70;...         
         
         29 30 36 35; % Top layer bottom left corner cube (+1)
         65 66 72 71;
         29 35 71 65;
         30 29 65 66;
         36 30 66 72;
         35 36 72 71;...
         
         
         % Layer #2 (5 cubes)
         
         37 38 44 43; % layer #2 top right corner cube
         73 74 80 79;
         37 43 79 73;
         38 37 73 74;
         44 38 74 80;
         43 44 80 79;...
         
         41 42 48 47; % layer #2 top left corner cube (+4)
         77 78 84 83;
         41 47 83 77;
         42 41 77 78;
         48 42 78 84;
         47 48 84 83;...
         
         61 62 68 67; % layer #2 bottom right corner cube
         97 98 104 103;
         61 67 103 97;
         62 61 97 98;
         68 62 98 104;
         67 68 104 103;...
         
         65 66 72 71; % layer #2 bottom left corner cube (+4)
         101 102 108 107;
         65 71 107 101;
         66 65 101 102;
         72 66 102 108;
         71 72 108 107;...
         
         51 52 58 57; % layer #2 centre cube
         87 88 94 93;
         51 57 93 87;
         52 51 87 88;
         58 52 88 94;
         57 58 94 93;...
         
         
         % Layer #3 (5 + 4 + 4 = 13 cubes)
         
         73 74 80 79; % layer #3 top right corner cube
         109 110 116 115;
         73 79 115 109;
         74 73 109 110;
         80 74 110 116;
         79 80 116 115;...
         
         77 78 84 83 % layer #3 top left corner cube (+4)
         113 114 120 119;
         77 83 119 113;
         78 77 113 114;
         84 78 114 120;
         83 84 120 119;...
         
         97 98 104 103; % layer #3 bottom right corner cube
         133 134 140 139;
         97 103 139 133;
         98 97 133 134;
         104 98 134 140;
         103 104 140 139;...
         
         101 102 108 107; % layer #3 bottom left corner cube (+4)
         137 138 144 143;
         101 107 143 137;
         102 101 137 138;
         108 102 138 144;
         107 108 144 143;...
         
         87 88 94 93; % layer #3 centre cube
         123 124 130 129;
         87 93 129 123;
         88 87 123 124;
         94 88 124 130;
         93 94 130 129;...
                           
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
                  
         81 82 88 87; % layer #3 centre cross top cube
         117 118 124 123;
         81 87 123 117;
         82 81 117 118;
         88 82 118 124;
         87 88 124 123;...
                  
         86 87 93 92; % layer #3 centre cross right cube
         122 123 129 128;
         86 92 128 122;
         87 86 122 123;
         93 87 123 129;
         92 93 129 128;...
                  
         88 89 95 94; % layer #3 centre cross left cube
         124 125 131 130;
         88 94 130 124;
         89 88 124 125;
         95 89 125 131;
         94 95 131 130;...
                  
         93 94 100 99; % layer #3 centre cross bottom cube
         129 130 136 135;
         93 99 135 129;
         94 93 129 130;
         100 94 130 136;
         99 100 136 135;...
         
         % Layer #4 (5 cubes) (+72 / layer #2)
         
         109 110 116 115; % layer #4 top right corner cube
         145 146 152 151;
         109 115 151 145;
         110 109 145 146;
         116 110 146 152;
         115 116 152 151;...
         
         113 114 120 119; % layer #4 top left corner cube (+4)
         149 150 156 155;
         113 119 155 149;
         114 113 149 150;
         120 114 150 156;
         119 120 156 155;...
         
         133 134 140 139; % layer #4 bottom right corner cube
         169 170 176 175;
         133 139 175 169;
         134 133 169 170;
         140 134 170 176;
         139 140 176 175;...
         
         137 138 144 143; % layer #4 bottom left corner cube (+4)
         173 174 180 179;
         137 143 179 173;
         138 137 173 174;
         144 138 174 180;
         143 144 180 179;...
         
         123 124 130 129; % layer #4 centre cube
         159 160 166 165;
         123 129 165 159;
         124 123 159 160;
         130 124 160 166;
         129 130 166 165;...
         
         
         % Bottom layer (#5) (+ 144 / 1st layer; index max = 216 = 144 + 72, ok)
         
         145 146 152 151; % Bottom layer top right corner cube
         181 182 188 187;
         145 151 187 181;
         146 145 181 182;
         152 146 182 188;
         151 152 188 187;...
    
         146 147 153 152; % Bottom layer top edge right cube (+1)
         182 183 189 188;
         146 152 188 182;
         147 146 182 183;
         153 147 183 189;
         152 153 189 188;...
         
         147 148 154 153; % Bottom layer top edge middle cube (+1)
         183 184 190 189;
         147 153 189 183;
         148 147 183 184;
         154 148 184 190;
         153 154 190 189;...
    
         148 149 155 154; % Bottom layer top edge left cube (+1)
         184 185 191 190;
         148 154 190 184;
         149 148 184 185;
         155 149 185 191;
         154 155 191 190;...
             
         149 150 156 155; % Bottom layer top left corner cube (+1)
         185 186 192 191;
         149 155 191 185;
         150 149 185 186;
         156 150 186 192;
         155 156 192 191;...
    
         151 152 158 157; % Bottom layer right edge top cube
         187 188 194 193;
         151 157 193 187;
         152 151 187 188;
         158 152 188 194;
         157 158 194 193;...
         
         155 156 162 161; % Bottom layer left edge top cube
         191 192 198 197;
         155 161 197 191;
         156 155 191 192;
         162 156 192 198;
         161 162 198 197;...
         
         157 158 164 163; % Bottom layer right edge middle cube
         193 194 200 199;
         157 163 199 193;
         158 157 193 194;
         164 158 194 200;
         163 164 200 199;...
             
         159 160 166 165; % Bottom layer centre cube
         195 196 202 201;
         159 165 201 195;
         160 159 195 196;
         166 160 196 202;
         165 166 202 201;...
         
         161 162 168 167; % Bottom layer left edge middle cube
         197 198 204 203;
         161 167 203 197;
         162 161 197 198;
         168 162 198 204;
         167 168 204 203;...
         
         163 164 170 169; % Bottom layer right edge bottom cube
         199 200 206 205;
         163 169 205 199;
         164 163 199 200;
         170 164 200 206;
         169 170 206 205;...
         
         167 168 174 173; % Bottom layer left edge bottom cube
         203 204 210 209;
         167 173 209 203;
         168 167 203 204;
         174 168 204 210;
         173 174 210 209;...
         
         169 170 176 175; % Bottom layer bottom right corner cube
         205 206 212 211;
         169 175 211 205;
         170 169 205 206;
         176 170 206 212;
         175 176 212 211;...
                  
         170 171 177 176; % Bottom layer bottom edge right cube (+1)
         206 207 213 212;
         170 176 212 206;
         171 170 206 207;
         177 171 207 213;
         176 177 213 212;...
         
         171 172 178 177; % Bottom layer bottom edge middle cube (+1)
         207 208 214 213;
         171 177 213 207;
         172 171 207 208;
         178 172 208 214;
         177 178 214 213;...
         
         172 173 179 178; % Bottom layer bottom edge left cube (+1)
         208 209 215 214;
         172 178 214 208;
         173 172 208 209;
         179 173 209 215;
         178 179 215 214;...
                  
         173 174 180 179; % Bottom layer bottom left corner cube (+1)
         209 210 216 215;
         173 179 215 209;
         174 173 209 210;
         180 174 210 216;
         179 180 216 215;                  
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
function [] = disp_cube_101_shapes(V, T, C)
%
% Author & support : nicolas.douillet (at) free.fr, 2017-2022.

% C = max(abs(V(:,1:2)),[],2);

figure;
set(gcf,'Color',[0 0 0]), set(gca,'Color',[0 0 0]);
trisurf(T,V(:,1),V(:,2),V(:,3),C), shading interp, hold on;
colormap(flipud(1-hsv.^0.5));
axis square, axis equal, axis tight, axis off;
grid off;
ax = gca;
ax.Clipping = 'off';
camlight left;
view(-35,28.7080); % view(-45,35);
zoom(1.1);

end % disp_cube_101_shapes


% Remove duplicated vertices subfunction
function [V_out, T_out] = remove_duplicated_vertices(V_in, T_in)
%
% Author & support : nicolas.douillet (at) free.fr, 2017-2022.

tol = 1e4*eps;
[V_out,~,n] = uniquetol(V_in,tol,'ByRows',true);
T_out = n(T_in);

end % remove_duplicated_vertices