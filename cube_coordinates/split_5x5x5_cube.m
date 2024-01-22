function [V_new, F_new] = split_5x5x5_cube(C, pattern_id)
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


valxyz = cat(2,cat(1,val1x,val2x,val3x,val4x,val5x,val6x),...
               cat(1,val1y,val2y,val3y,val4y,val5y,val6y),...
               cat(1,val1z,val2z,val3z,val4z,val5z,val6z));

           
V_new = cube_5x5x5_coord(valxyz);
F_new = cube_5x5x5_face_indices(pattern_id);


end