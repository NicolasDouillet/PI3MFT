function [V_new, F_new] = split_3x3x3_cube(C, pattern_id)
%
% Author : nicolas.douillet (at) free.fr, 2017-2024.


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


valxyz = cat(2,cat(1,val1x,val2x,val3x,val4x),...
               cat(1,val1y,val2y,val3y,val4y),...
               cat(1,val1z,val2z,val3z,val4z));

           
V_new = cube_3x3x3_coord(valxyz,pattern_id);
F_new = cube_3x3x3_face_indices(pattern_id);


end