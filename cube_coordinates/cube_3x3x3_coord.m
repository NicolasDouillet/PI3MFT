function V_new = cube_3x3x3_coord(valxyz, pattern_id)
%
% Author : nicolas.douillet (at) free.fr, 2017-2024.


val1x = valxyz(1,1);
val2x = valxyz(2,1);
val3x = valxyz(3,1);
val4x = valxyz(4,1);

val1y = valxyz(1,2);
val2y = valxyz(2,2);
val3y = valxyz(3,2);
val4y = valxyz(4,2);

val1z = valxyz(1,3);
val2z = valxyz(2,3);
val3z = valxyz(3,3);
val4z = valxyz(4,3);


switch pattern_id % TODO : factorize to merge
    
    case {1, 3}
        
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
        
    case 2
        
   V_new = [val3x val4y val4z; % Top face
            val2x val4y val4z;
            val4x val3y val4z;
            val3x val3y val4z;
            val2x val3y val4z;
            val1x val3y val4z;
            val4x val2y val4z;
            val3x val2y val4z;
            val2x val2y val4z;
            val1x val2y val4z;
            val3x val1y val4z;
            val2x val1y val4z;...
            
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
            
            val3x val4y val1z; % Bottom face
            val2x val4y val1z;
            val4x val3y val1z;
            val3x val3y val1z;
            val2x val3y val1z;
            val1x val3y val1z;
            val4x val2y val1z;
            val3x val2y val1z;
            val2x val2y val1z;
            val1x val2y val1z;
            val3x val1y val1z;
            val2x val1y val1z];
        
end