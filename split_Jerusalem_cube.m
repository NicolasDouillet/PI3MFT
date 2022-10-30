function [V_new, F_new] = split_Jerusalem_cube(C, h)
% Input
%
% C : cube structure
%
%
% Outputs
%
% V_new : the newly created vertices -coordinates-
% F_new : the newly created facets line indices


h1 = 1 - 2*h;

% Six possible values for each coordinate, X, Y, or Z
val1x = min(C.vertex(:,1));
val6x = max(C.vertex(:,1));
val2x = val1x + h1 * (val6x - val1x);
val3x = val1x + h *  (val6x - val1x);
val4x = val6x - h *  (val6x - val1x);
val5x = val6x - h1 * (val6x - val1x);

val1y = min(C.vertex(:,2));
val6y = max(C.vertex(:,2));
val2y = val1y + h1 * (val6y - val1y);
val3y = val1y + h *  (val6y - val1y);
val4y = val6y - h *  (val6y - val1y);
val5y = val6y - h1 * (val6y - val1y);

val1z = min(C.vertex(:,3));
val6z = max(C.vertex(:,3));
val2z = val1z + h1 * (val6z - val1z);
val3z = val1z + h *  (val6z - val1z);
val4z = val6z - h *  (val6z - val1z);
val5z = val6z - h1 * (val6z - val1z);


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

F_new = [1 3 15 13; % Top layer top right corner cube
         73 75 87 85;
         1 13 85 73;
         3 1 73 75;
         15 3 75 87;
         13 15 87 85;...
    
         3 4 10 9; % Top layer top cross cube
         39 40 46 45;
         3 9 45 39;
         4 3 39 40;
         10 4 40 46;
         9 10 46 45;...
    
         4 6 18 16; % Top layer top left corner cube
         76 78 90 88;
         4 16 88 76;
         6 4 76 78;
         18 6 78 90;
         16 18 90 88;...
    
         13 14 20 19; % Top layer right cross cube
         49 50 56 55;
         13 19 55 49;
         14 13 49 50;
         20 14 50 56;
         19 20 56 55;...
    
         17 18 24 23; % Top layer left cross cube
         53 54 60 59;
         17 23 59 53;
         18 17 53 54;
         24 18 54 60;
         23 24 60 59;...
    
         19 21 33 31 ; % Top layer bottom right corner cube
         91 93 105 103;
         19 31 103 91;
         21 19 91 93;
         33 21 93 105;
         31 33 105 103;...
    
         27 28 34 33; % Top layer bottom cross cube
         63 64 70 69;
         27 33 69 63;
         28 27 63 64;
         34 28 64 70;
         33 34 70 69;...
    
         22 24 36 34; % Top layer bottom left corner cube
         94 96 108 106;
         22 34 106 94;
         24 22 94 96;
         36 24 96 108;
         34 36 108 106;...            
    
         73 74 80 79; % Middle layer top right small cube
         109 110 116 115;
         73 79 115 109;
         74 73 109 110;
         80 74 110 116;
         79 80 116 115;...
    
         77 78 84 83; % Middle layer top left small cube
         113 114 120 119;
         77 83 119 113;
         78 77 113 114;
         84 78 114 120;
         83 84 120 119;...
    
         97 98 104 103; % Middle layer bottom right small cube
         133 134 140 139;
         97 103 139 133;
         98 97 133 134;
         104 98 134 140;
         103 104 140 139;...
    
         101 102 108 107; % Middle layer bottom left small cube
         137 138 144 143;
         101 107 143 137;
         102 101 137 138;
         108 102 138 144;
         107 108 144 143;...          
    
         109 111 123 121; % Bottom layer top right corner cube
         181 183 195 193;
         109 121 193 181;
         111 109 181 183;
         123 111 183 195;
         121 123 195 193;...
    
         147 148 154 153; % Bottom layer top cross cube
         183 184 190 189;
         147 153 189 183;
         148 147 183 184;
         154 148 184 190;
         153 154 190 189;...
    
         112 114 126 124; % Bottom layer top left corner cube
         184 186 198 196;
         112 124 196 184;
         114 112 184 186;
         126 114 186 198;
         124 126 198 196;...
    
         157 158 164 163; % Bottom layer right cross cube
         193 194 200 199;
         157 163 199 193;
         158 157 193 194;
         164 158 194 200;
         163 164 200 199;...
    
         161 162 168 167; % Bottom layer left cross cube
         197 198 204 203;
         161 167 203 197;
         162 161 197 198;
         168 162 198 204;
         167 168 204 203;...
    
         127 129 141 139 ; % Bottom layer bottom right corner cube
         199 201 213 211;
         127 139 211 199;
         129 127 199 201;
         141 129 201 213;
         139 141 213 211;...
    
         171 172 178 177; % Bottom layer bottom cross cube
         207 208 214 213;
         171 177 213 207;
         172 171 207 208;
         178 172 208 214;
         177 178 214 213;...
    
         130 132 144 142; % Bottom layer bottom left corner cube
         202 204 216 214;
         130 142 214 202;
         132 130 202 204;
         144 132 204 216;
         142 144 216 214;...
    ];

end % split_Jerusalem_cube