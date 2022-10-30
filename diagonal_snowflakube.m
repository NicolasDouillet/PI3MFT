function [V, T] = diagonal_snowflakube(nb_it, option_display)
%
% Author & support : nicolas.douillet (at) free.fr, 2022.


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
        
    new_C_array = repmat(C, [1 1 38]);
    
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
            
            new_C_array(:,:,38*(j-1) + m) = new_cube;
            
        end                
        
    end
       
    C = new_C_array;            
    p = p+1;
    
end
    

% Squares to triangles conversion
[V,T] = squares2triangles(C);

ball_option = true;

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
    
    disp_diagonal_snowflakube(V,T);
    
end


end % diagonal_snowflakube


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
         
         % 2nd diagonal
         
         5 6 12 11; % Top layer top left corner cube (+1)
         41 42 48 47;
         5 11 47 41;
         6 5 41 42;
         12 6 42 48;
         11 12 48 47;...
         
         10 11 17 16; % Top layer first left-right diagonal cube (+5)
         46 47 53 52;
         10 16 52 46;
         11 10 46 47;
         17 11 47 53;
         16 17 53 52;...
         
         20 21 27 26; % Top layer third left-right diagonal cube (+10)
         56 57 63 62;
         20 26 62 56;
         21 20 56 57;
         27 21 57 63;
         26 27 63 62;...         
         
         25 26 32 31; % Top layer bottom right corner cube
         61 62 68 67;
         25 31 67 61;
         26 25 61 62;
         32 26 62 68;
         31 32 68 67;...
         
         
         % Layer #2
         38 39 45 44; % 2nd layer back face top right cube (+37)
         74 75 81 80;
         38 44 80 74;
         39 38 74 75;
         45 39 75 81;
         44 45 81 80;...
                  
         40 41 47 46; % 2nd layer back face top left cube (+2)
         76 77 83 82;
         40 46 82 76;
         41 40 76 77;
         47 41 77 83;
         46 47 83 82;...
         
         43 44 50 49; % 2nd layer right face top right cube (+5)
         79 80 86 85;
         43 49 85 79;
         44 43 79 80;
         50 44 80 86;
         49 50 86 85;...
         
         47 48 54 53; % 2nd layer left face top left cube (+4)
         83 84 90 89;
         47 53 89 83;
         48 47 83 84;
         54 48 84 90;
         53 54 90 89;...
         
         55 56 62 61; % 2nd layer right face top left cube (+12)
         91 92 98 97;
         55 61 97 91;
         56 55 91 92;
         62 56 92 98;
         61 62 98 97;...
         
         59 60 66 65; % 2nd layer left face top right cube (+12)
         95 96 102 101;
         59 65 101 95;
         60 59 95 96;
         66 60 96 102;
         65 66 102 101;...
         
         62 63 69 68; % 2nd layer front face top right cube (+24)
         98 99 105 104;
         62 68 104 98;
         63 62 98 99;
         69 63 99 105;
         68 69 105 104;...
                  
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
         
         110 111 117 116; % 4th layer back face top right cube
         146 147 153 152;
         110 116 152 146;
         111 110 146 147;
         117 111 147 153;
         116 117 153 152;...
                  
         112 113 119 118; % 4th layer back face top left cube 
         148 149 155 154;
         112 118 154 148;
         113 112 148 149;
         119 113 149 155;
         118 119 155 154;...
         
         115 116 122 121; % 4th layer right face top right cube 
         151 152 158 157;
         115 121 157 151;
         116 115 151 152;
         122 116 152 158;
         121 122 158 157;...
         
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
         
         131 132 138 137; % 4th layer left face top right cube
         167 168 174 173;
         131 137 173 167;
         132 131 167 168;
         138 132 168 174;
         137 138 174 173;...
         
         134 135 141 140; % 4th layer front face top right cube
         170 171 177 176;
         134 140 176 170;
         135 134 170 171;
         141 135 171 177;
         140 141 177 176;...
                  
         136 137 143 142; % 4th layer back face top left cube
         172 173 179 178;
         136 142 178 172;
         137 136 172 173;
         143 137 173 179;
         142 143 179 178;...         
         
                  
         % Bottom layer (+ 4 x 36 = 144)
         
         145 146 152 151; % Bottom layer top right corner cube
         181 182 188 187;
         145 151 187 181;
         146 145 181 182;
         152 146 182 188;
         151 152 188 187;...
    
         152 153 159 158; % Bottom layer first right-left diagonal cube (+7)
         188 189 195 194;
         152 158 194 188;
         153 152 188 189;
         159 153 189 195;
         158 157 195 194;...         
         
         159 160 166 165; % Bottom layer centre cube (+7)
         195 196 202 201;
         159 165 201 195;
         160 159 195 196;
         166 160 196 202;
         165 166 202 201;...
         
         166 167 173 172; % Bottom layer third right-left diagonal cube (+7)
         202 203 209 208;
         166 172 208 202;
         167 166 202 203;
         173 167 203 209;
         172 173 209 208;...
         
         173 174 180 179; % Bottom layer bottom left corner cube (+1)
         209 210 216 215;
         173 179 215 209;
         174 173 209 210;
         180 174 210 216;
         179 180 216 215;       
         
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
          
          
%          % Layer #2 (-36 / layer #3)
% 
%          39 40 46 45; % layer #2 top edge middle cube / back face centre cube
%          75 76 82 81;
%          39 45 81 75;
%          40 39 75 76;
%          46 40 76 82;
%          45 46 82 81;...
%                   
%          49 50 56 55; % layer #2 right edge middle cube / right face centre cube
%          85 86 92 91;
%          49 55 91 85;
%          50 49 85 86;
%          56 50 86 92;
%          55 56 92 91;...
%                            
%          53 54 60 59; % layer #2 left edge middle cube / left face centre cube
%          89 90 96 95;
%          53 59 95 89;
%          54 53 89 90;
%          60 54 90 96;
%          59 60 96 95;...
%                   
%          63 64 70 69; % layer #2 bottom edge middle cube / front face centre cube
%          99 100 106 105;
%          63 69 105 99;
%          64 63 99 100;
%          70 64 100 106;
%          69 70 106 105;...
%          
%          
%          % Layer #3
% 
%          75 76 82 81; % layer #3 top edge middle cube / back face centre cube
%          111 112 118 117;
%          75 81 117 111;
%          75 75 111 112;
%          82 76 112 118;
%          81 82 118 117;...
%                   
%          85 86 92 91; % layer #3 right edge middle cube / right face centre cube
%          121 122 128 127;
%          85 91 127 121;
%          86 85 121 122;
%          92 86 122 128;
%          91 92 128 127;...
%                            
%          89 90 96 95; % layer #3 left edge middle cube / left face centre cube
%          125 126 132 131;
%          89 95 131 125;
%          90 89 125 126;
%          96 90 126 132;
%          95 96 132 131;...
%                   
%          99 100 106 105; % layer #3 bottom edge middle cube / front face centre cube
%          135 136 142 141;
%          99 105 141 135;
%          100 99 135 136;
%          106 100 136 142;
%          105 106 142 141;...
%          
%          73 74 80 79; % layer #3 top right corner cube
%          109 110 116 115;
%          73 79 115 109;
%          74 73 109 110;
%          80 74 110 116;
%          79 80 116 115;...
%          
%          74 75 81 80; % layer #3 top edge second cube (+1)
%          110 111 117 116;
%          74 80 116 110;
%          75 74 110 111;
%          81 75 111 117;
%          80 81 117 116;...
%          
%          79 80 86 85; % layer #3 right edge top cube (+6)
%          115 116 122 121;
%          79 85 121 115;
%          80 79 115 116;
%          86 80 116 122;
%          85 86 122 121;...
%          
%          77 78 84 83 % layer #3 top left corner cube
%          113 114 120 119;
%          77 83 119 113;
%          78 77 113 114;
%          84 78 114 120;
%          83 84 120 119;...
%          
%          76 77 83 82 % layer #3 last before top left corner cube (-1)
%          112 113 119 118;
%          76 82 118 112;
%          77 76 112 113;
%          83 77 113 119;
%          82 83 119 118;...
%          
%          83 84 90 89 % layer #3 left edge top cube (+6)
%          119 120 126 125;
%          83 89 125 119;
%          84 83 119 120;
%          90 84 120 126;
%          89 90 126 125;...
%          
%          97 98 104 103; % layer #3 bottom right corner cube
%          133 134 140 139;
%          97 103 139 133;
%          98 97 133 134;
%          104 98 134 140;
%          103 104 140 139;...
%          
%          98 99 105 104; % layer #3 last before bottom right corner cube (+1)
%          134 135 141 140;
%          98 104 140 134;
%          99 98 134 135;
%          105 99 135 141;
%          104 105 141 140;...
%          
%          91 92 98 97; % layer #3 right edge bottom cube (+6)
%          127 128 134 133;
%          91 97 133 127;
%          92 91 127 128;
%          98 92 128 134;
%          97 98 134 133;...
%          
%          101 102 108 107; % layer #3 bottom left corner cube (+4)
%          137 138 144 143;
%          101 107 143 137;
%          102 101 137 138;
%          108 102 138 144;
%          107 108 144 143;...
%          
%          100 101 107 106; % layer #3 last before bottom left corner cube (-1)
%          136 137 143 142;
%          100 106 142 136;
%          101 100 136 137;
%          107 101 137 143;
%          106 107 143 142;...
%          
%          95 96 102 101; % layer #3 left edge bottom cube (+6)
%          131 132 138 137;
%          95 101 137 131;
%          96 95 131 132;
%          102 96 132 138;
%          101 102 138 137;...
%          
% 
%          % Layer #4 (+36)
% 
%          111 112 118 117; % layer #4 top edge middle cube / back face centre cube
%          147 148 154 153;
%          111 117 153 147;
%          112 111 147 148;
%          118 112 148 154;
%          117 118 154 153;...
%                   
%          121 122 128 127; % layer #4 right edge middle cube / right face centre cube
%          157 158 164 163;
%          121 127 163 157;
%          122 121 157 158;
%          128 122 158 164;
%          127 128 164 163;...
%                            
%          125 126 132 131; % layer #4 left edge middle cube / left face centre cube
%          161 162 168 167;
%          125 131 167 161;
%          126 125 161 162;
%          132 126 162 168;
%          131 132 168 167;...
%                   
%          135 136 142 141; % layer #4 bottom edge middle cube / front face centre cube
%          171 172 178 177;
%          135 141 177 171;
%          136 135 171 172;
%          142 136 172 178;
%          141 142 178 177;...                  
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
function [] = disp_diagonal_snowflakube(V, T)
%
% Author & support : nicolas.douillet (at) free.fr, 2017-2022.

% C = max(abs(V),[],2);
C = sqrt(sum(V.^2,2));

figure;
set(gcf,'Color',[0 0 0]), set(gca,'Color',[0 0 0]);
trisurf(T,V(:,1),V(:,2),V(:,3),C), shading interp, hold on;
colormap(flipud(1-hot));
axis square, axis equal, axis tight, axis off;
grid off;
ax = gca;
ax.Clipping = 'off';
camlight left;
view(-45,35.2622);
zoom(1.1);

end % disp_diagonal_snowflakube


% Remove duplicated vertices subfunction
function [V_out, T_out] = remove_duplicated_vertices(V_in, T_in)
%
% Author & support : nicolas.douillet (at) free.fr, 2017-2022.

tol = 1e4*eps;
[V_out,~,n] = uniquetol(V_in,tol,'ByRows',true);
T_out = n(T_in);

end % remove_duplicated_vertices