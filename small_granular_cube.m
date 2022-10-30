function [V, T] = small_granular_cube(nb_it, option_display)
%
% Author & support : nicolas.douillet (at) free.fr, 2022.


% TODO : + interior 3x3x3 cube ?

% Body
% Summits of original cube (living in the unit sphere R(O,1))
a = sqrt(3)/3;
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
        
    new_C_array = repmat(C, [1 1 48]);
    
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
            
            new_C_array(:,:,48*(j-1) + m) = new_cube;
            
        end                
        
    end
       
    C = new_C_array;            
    p = p+1;
    
end
    

% Squares to triangles conversion
[V,T] = squares2triangles(C);

ball_option = false;

if ball_option        
    
    % - (1) Déterminer le vecteur normal du plan du cube le plus proche
    % de chaque point M (table)
   
    f = abs(V) == max(abs(V),[],2); 
    n = a * sign(V) .* f;        
    
    % - (2) Calculer I, le point d'intersection entre le vecteur OM et ce plan (besoin algos line-plane intersection
    % distance) ; même point du plan pris que vecteur normal
      
    M = n;
    u = V ./ sqrt(sum(V.^2,2));        
    
    I = V + u .* (dot(n,M,2) - dot(n,V,2)) ./ dot(n,u,2);     
        
    % - (3) Calculer le ratio de distances k = OI / r (r, le rayon de la sphère circonscrite; a ici)
    % - (4) Multiplier OM par r.
    
    k = a .* sqrt(sum(I.^2,2));
    V = k .* V;        
    
end


% Remove duplicated vertices
[V,T] = remove_duplicated_vertices(V,T);

% Remove duplicated triangles
T = unique(sort(T,2),'rows','stable');


% Display
if option_display          
    
    disp_small_granular_cube(V,T);
    
end


end % small_granular_cube


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
    
         2 3 9 8; % Top layer top edge right cube (+1)
         38 39 45 44;
         2 8 44 38;
         3 2 38 39;
         9 3 39 45;
         8 9 45 44;...                  
    
         4 5 11 10; % Top layer top edge left cube (+1)
         40 41 47 46;
         4 10 46 40;
         5 4 40 41;
         11 5 41 47;
         10 11 47 46;...                      
    
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
                           
         26 27 33 32; % Top layer bottom edge right cube (+1)
         62 63 69 68;
         26 32 68 62;
         27 26 62 63;
         33 27 63 69;
         32 33 69 68;...
                  
         28 29 35 34; % Top layer bottom edge left cube (+1)
         64 65 71 70;
         28 34 70 64;
         29 28 64 65;
         35 29 65 71;
         34 35 71 70;...    
         
         14 15 21 20; % Top layer middle column 2nd cube
         50 51 57 56;
         14 20 56 50;
         15 14 50 51;
         21 15 51 57
         20 21 57 56;...                  
         
         16 17 23 22; % Top layer middle column 4th cube
         52 53 59 58;
         16 22 58 52;
         17 16 52 53;
         23 17 53 59;
         22 23 59 58;...
         
         9 10 16 15; % Top layer 2nd row middle cube (+6)
         45 46 52 51;
         9 15 51 45;
         10 9 45 46;
         16 10 46 52;
         15 16 52 51;...
                        
         21 22 28 27; % Top layer 4th row middle cube (+12)
         57 58 64 63;
         21 27 63 57;
         22 21 57 58;
         28 22 58 64;
         27 28 64 63;...
         
         
         % Layer #2 (4 cubes)
         
         39 40 46 45; % layer #2 top edge middle cube / back face centre cube
         75 76 82 81;
         39 45 81 75;
         40 39 75 76;
         46 40 76 82;
         45 46 82 81;...
                  
         49 50 56 55; % layer #2 right edge middle cube / right face centre cube
         85 86 92 91;
         49 55 91 85;
         50 49 85 86;
         56 50 86 92;
         55 56 92 91;...
                           
         53 54 60 59; % layer #2 left edge middle cube / left face centre cube
         89 90 96 95;
         53 59 95 89;
         54 53 89 90;
         60 54 90 96;
         59 60 96 95;...
                  
         63 64 70 69; % layer #2 bottom edge middle cube / front face centre cube
         99 100 106 105;
         63 69 105 99;
         64 63 99 100;
         70 64 100 106;
         69 70 106 105;...
         
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
         
         
         % Layer #3 (4 x 2 = 8 cubes)
                                                               
         
         74 75 81 80; % layer #3 top edge second cube (+1)
         110 111 117 116;
         74 80 116 110;
         75 74 110 111;
         81 75 111 117;
         80 81 117 116;...
         
         79 80 86 85; % layer #3 right edge top cube (+6)
         115 116 122 121;
         79 85 121 115;
         80 79 115 116;
         86 80 116 122;
         85 86 122 121;...                  
         
         76 77 83 82 % layer #3 last before top left corner cube (-1)
         112 113 119 118;
         76 82 118 112;
         77 76 112 113;
         83 77 113 119;
         82 83 119 118;...
         
         83 84 90 89 % layer #3 left edge top cube (+6)
         119 120 126 125;
         83 89 125 119;
         84 83 119 120;
         90 84 120 126;
         89 90 126 125;...                  
         
         98 99 105 104; % layer #3 last before bottom right corner cube (+1)
         134 135 141 140;
         98 104 140 134;
         99 98 134 135;
         105 99 135 141;
         104 105 141 140;...
         
         91 92 98 97; % layer #3 right edge bottom cube (+6)
         127 128 134 133;
         91 97 133 127;
         92 91 127 128;
         98 92 128 134;
         97 98 134 133;...                  
         
         100 101 107 106; % layer #3 last before bottom left corner cube (-1)
         136 137 143 142;
         100 106 142 136;
         101 100 136 137;
         107 101 137 143;
         106 107 143 142;...
         
         95 96 102 101; % layer #3 left edge bottom cube (+6)
         131 132 138 137;
         95 101 137 131;
         96 95 131 132;
         102 96 132 138;
         101 102 138 137;...
         
         % Layer #4 (4 cubes) (+72 / layer #2)
         
         111 112 118 117; % layer #4 top edge middle cube / back face centre cube
         147 148 154 153;
         111 117 153 147;
         112 111 147 148;
         118 112 148 154;
         117 118 154 153;...
                  
         121 122 128 127; % layer #4 right edge middle cube / right face centre cube
         157 158 164 163;
         121 127 163 157;
         122 121 157 158;
         128 122 158 164;
         127 128 164 163;...
                           
         125 126 132 131; % layer #4 left edge middle cube / left face centre cube
         161 162 168 167;
         125 131 167 161;
         126 125 161 162;
         132 126 162 168;
         131 132 168 167;...
                  
         135 136 142 141; % layer #4 bottom edge middle cube / front face centre cube
         171 172 178 177;
         135 141 177 171;
         136 135 171 172;
         142 136 172 178;
         141 142 178 177;...
         
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
         
         
         % Bottom layer (#5) (+ 144 / 1st layer; index max = 216 = 144 + 72, ok)
                  
    
         146 147 153 152; % Bottom layer top edge right cube (+1)
         182 183 189 188;
         146 152 188 182;
         147 146 182 183;
         153 147 183 189;
         152 153 189 188;...                  
    
         148 149 155 154; % Bottom layer top edge left cube (+1)
         184 185 191 190;
         148 154 190 184;
         149 148 184 185;
         155 149 185 191;
         154 155 191 190;...                     
    
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
                  
         170 171 177 176; % Bottom layer bottom edge right cube (+1)
         206 207 213 212;
         170 176 212 206;
         171 170 206 207;
         177 171 207 213;
         176 177 213 212;...                  
         
         172 173 179 178; % Bottom layer bottom edge left cube (+1)
         208 209 215 214;
         172 178 214 208;
         173 172 208 209;
         179 173 209 215;
         178 179 215 214;...    
         
         158 159 165 164; % Bottom layer middle column 2nd cube (+1)
         194 195 201 200;
         158 164 200 194;
         159 158 194 195;
         165 159 195 201;
         164 165 201 200;...                  
         
         160 161 167 166; % Bottom layer middle column 4th cube (+1)
         196 197 203 202;
         160 166 202 196;
         161 160 196 197;
         167 161 197 203;
         166 167 203 202;...
         
         153 154 160 159; % Bottom layer 2nd row middle cube (+6)
         189 190 196 195;
         153 159 195 189;
         154 153 189 190;
         160 154 190 196;
         159 160 196 195;...
                        
         165 166 172 171; % Bottom layer 4th row middle cube (+12)
         201 202 208 207;
         165 171 207 201;
         166 165 201 202;
         172 166 202 208;
         171 172 208 207;...
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
function [] = disp_small_granular_cube(V, T)
%
% Author & support : nicolas.douillet (at) free.fr, 2017-2022.

C = max(abs(V),[],2);
% C = sqrt(sum(V.^2,2));

% figure;
set(gcf,'Color',[0 0 0]), set(gca,'Color',[0 0 0]);
trisurf(T,V(:,1),V(:,2),V(:,3),C), shading interp, hold on;
colormap(flipud(1-hot));
axis square, axis equal, axis tight, axis off;
grid off;
ax = gca;
ax.Clipping = 'off';
camlight left, camlight right;
view(-45,35);
zoom(1.1);

end % disp_small_granular_cube


% Remove duplicated vertices subfunction
function [V_out, T_out] = remove_duplicated_vertices(V_in, T_in)
%
% Author & support : nicolas.douillet (at) free.fr, 2017-2022.

tol = 1e4*eps;
[V_out,~,n] = uniquetol(V_in,tol,'ByRows',true);
T_out = n(T_in);

end % remove_duplicated_vertices