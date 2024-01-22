function V_new = cube_5x5x5_coord(valxyz)
%
% Author : nicolas.douillet (at) free.fr, 2021-2024.


val1x = valxyz(1,1);
val2x = valxyz(2,1);
val3x = valxyz(3,1);
val4x = valxyz(4,1);
val5x = valxyz(5,1);
val6x = valxyz(6,1);

val1y = valxyz(1,2);
val2y = valxyz(2,2);
val3y = valxyz(3,2);
val4y = valxyz(4,2);
val5y = valxyz(5,2);
val6y = valxyz(6,2);

val1z = valxyz(1,3);
val2z = valxyz(2,3);
val3z = valxyz(3,3);
val4z = valxyz(4,3);
val5z = valxyz(5,3);
val6z = valxyz(6,3);


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


end