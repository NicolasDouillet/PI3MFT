function [V_new, F_new] = split_jerusalem_cube(C, h, pattern_id)
%
% Author : nicolas.douillet (at) free.fr, 2017-2024.


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


valxyz = cat(2,cat(1,val1x,val2x,val3x,val4x,val5x,val6x),...
               cat(1,val1y,val2y,val3y,val4y,val5y,val6y),...
               cat(1,val1z,val2z,val3z,val4z,val5z,val6z));

           
V_new = cube_5x5x5_coord(valxyz);
F_new = cube_5x5x5_face_indices(pattern_id);


end