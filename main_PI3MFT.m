function [V, T] = main_PI3MFT(pattern_id, nb_it, option_display)
%
% Author : nicolas.douillet (at) free.fr, 2024.


addpath('tools');
addpath('cube_coordinates');
addpath('cube_face_indices');
addpath('cube_transformations');
addpath('Sierpinski_based_shapes');
addpath('other_shapes');


% Logical parameters / choices for a pattern and options for a shape
logtransform            = false;
twisted_cube_shape      = false;

cylinder_shape          = false;
twisted_cylinder_shape  = false;
twisted_cylinder_shape  = cylinder_shape && twisted_cylinder_shape;

concave_cylinder_shape  = false;
concave_cylinder_shape  = cylinder_shape && concave_cylinder_shape;

ball_shape              = false;
inverted_ball_shape     = false;
inverted_ball_shape     = ball_shape && inverted_ball_shape;

torus_shape             = false;
moebius_shape           = false;

crescent_shape          = false;
infinity_shape          = false;
infinity_shape          = infinity_shape && crescent_shape; 

printable_ready         = true; % default


% %---------------------%
% | 3x3x3 cube patterns |
% %---------------------%
%
% Original Menger cube                  : pattern_id = 1;  every options available
% Cube based Koch snowflake             : pattern_id = 2;  every options available
% Interior diagonals 3x3x3 snowflake    : pattern_id = 3;  every options available
% Jerusalem original                    : pattern_id = 4;  every options available
%
% %---------------------%
% | 5x5x5 cube patterns |
% %---------------------%
%
% Hypermenger                           : pattern_id = 5;  every options available
% Octomenger                            : pattern_id = 6;  every options available
% 101_skeleton                          : pattern_id = 7;  every options available
% Jerusalem_5x5x5                       : pattern_id = 8;  every options available
% Interior diagonals / snowflake_1      : pattern_id = 9;  every options available
% Midline / snowflake 2                 : pattern_id = 10;  every options available
% Face_diagonals / snowflake 3          : pattern_id = 11; every options available
% One_sided face_diagonals              : pattern_id = 12; every options available
% Small granular pattern                : pattern_id = 13; every options available
% Large granular pattern                : pattern_id = 14; every options available
%
% %---------------------------------------%
% | Sierpinski tetrahedron based patterns |
% %---------------------------------------%
%
% Tetrahedron                           : pattern_id = 15; no option available
% Cube                                  : pattern_id = 16; every options available
% Octahedron                            : pattern_id = 17; ball shape is only option
% Icosahedron                           : pattern_id = 18; no option available
% Cuboctahedron                         : pattern_id = 19; no option available
% Tetraki hexahedron                    : pattern_id = 20; no option available
%
% %-----------------------------%
% | Others shape based patterns |
% %-----------------------------%
%
% Triangular based Koch snowflake       : pattern_id = 21; no option available


% % Maximum number of iterations
% switch pattern_id
%     case {1,2,3,15,16,17,18,19,20,21}
%         assert(nb_it < 5,'To save your computer health, number of iterations is limited to 4 for 3x3x3 cube and Sierpinski based patterns');
%     case {4,5,6,7,8,9,10,11,12,13,14}
%         assert(nb_it < 4,'To save your computer health, number of iterations is limited to 3 for 5x5x5 patterns');
%     otherwise
%         error('Non supported pattern identifier.');
% end


% Generic default parameters
a = 1;                  % size parameter
cmap = flipud(1-jet);   % color display parameter
az = -37.5;             % view display parameter 1
el = 30;                % view display parameter 2


% Shape and size parameters
switch pattern_id
    case 1        
        subcube_nb = 20;        
    case 2
        subcube_nb = 18; 
        az = -45;
        el = 35;
        cmap = flipud(1-hot);
    case 3
        subcube_nb = 9;
        az = -44.8088;
        el = 35.2622;
        cmap = flipud(1-hot);
        printable_ready = false;
    case 4
        subcube_nb = 20;   
    case 5
        subcube_nb = 44;
    case 6
        subcube_nb = 81;        
    case 7
        subcube_nb = 57;
        printable_ready = false;        
    case 8
        subcube_nb = 76;        
    case 9
        subcube_nb = 17;
        az = -44.8088;
        el = 35.2622;
        cmap = flipud(1-hot);
        printable_ready = false;
    case 10
        subcube_nb = 42;
        az = -45;
        el = 35;
        cmap = flipud(1-hot);
    case 11        
        subcube_nb = 38;
        az = -45;
        el = 35;
        printable_ready = false;
    case 12
        subcube_nb = 22;
        printable_ready = false;
    case 13
        subcube_nb = 48;
        printable_ready = false;
    case 14
        subcube_nb = 50;
        printable_ready = false;
    case 15        
        M1 = a*[2*sqrt(2)/3  0         -1/3]; % right vertex
        M2 = a*[-sqrt(2)/3  sqrt(6)/3  -1/3]; % top left vertex
        M3 = a*[-sqrt(2)/3 -sqrt(6)/3  -1/3]; % bottom left vertex
        M4 = a*[ 0          0           1  ]; % top vertex
    case {16,17,18,19}
        % nothing to do
    case 20
        a = sqrt(3)/3;
    case 21      
        az = -90;
        el = 15;
        cmap = flipud(1-hot);
    otherwise
        error('Non supported pattern identifier.');
end


% Switch for an algorithm
switch pattern_id
    case {1,2,3}
        [V,T] = iterate_over_3x3x3_cube(a,nb_it,pattern_id,subcube_nb);
    case 4
        [V,T] = iterate_over_jerusalem_cube(a,nb_it,pattern_id,subcube_nb);
    case {5,6,7,8,9,10,11,12,13,14}
        [V,T] = iterate_over_5x5x5_cube(a,nb_it,pattern_id,subcube_nb);
    case 15
        [V,T] = sierpinski_solid_tetrahedron(nb_it,M1,M2,M3,M4);
    case 16
        [V,T] = sierpinski_solid_cube(a,nb_it);
    case 17
        [V,T] = sierpinski_solid_octahedron(a,nb_it);
    case 18
        [V,T] = sierpinski_solid_icosahedron(a,nb_it);
    case 19
        [V,T] = sierpinski_solid_cuboctahedron(a,nb_it);
    case 20
        [V,T] = sierpinski_solid_tetraki_hexahedron(a,nb_it);
    case 21
        [V,T] = koch_snowflake(a,nb_it);
    otherwise
        error('Non supported pattern identifier.');
end


[V,T] = remove_duplicated_vertices(V,T);


% Color computation
switch pattern_id
    case {1,4,5,6,7,8,11,12,13,14}
        C = max(abs(V(:,1:2)),[],2); % cube basic shape max(X,Y) colormap
    case {2,3,9,10,15,16,17,18,19,20,21}
        C = vecnorm(V',2)';       % radial colormap
    otherwise
        error('Non supported pattern identifier.');
end


if logtransform
    V = cube_logtransformation(V);
    C = ones(size(V,1),1);
end


if twisted_cube_shape          
    [V,C] = twisted_cube_transformation(V);
    az = -30;
    el = 15;
end


if cylinder_shape || torus_shape    
    if twisted_cylinder_shape == false && concave_cylinder_shape == false        
        [V,C] = cylinder_transformation(V,a,'convex');        
    elseif twisted_cylinder_shape == true        
        [V,C] = cylinder_transformation(V,a,'twisted');        
    elseif concave_cylinder_shape == true        
        [V,C] = cylinder_transformation(V,a,'concave');        
    end    
end


if ball_shape
    if inverted_ball_shape == false
        [V,C] = ball_transformation(V,a,'convex');
    elseif inverted_ball_shape == true
        [V,C] = ball_transformation(V,a,'concave');
    end
end


if torus_shape   
    [V,T,C] = torus_transformation(V,T,C);
    az = 0;
    el = -60;    
end


if moebius_shape    
    [V,T,C] = moebius_3D_ring_transformation(V,T);
    az = 0;
    el = -45;    
end


if crescent_shape || infinity_shape
   [V,T,C] = crescent_transformation(V,T,a); 
end


if infinity_shape
    [V,T,C] = infinity_sign_transformation(V,T,C);
    az = 135;
    el = 180;
end


if ~printable_ready    
    [V,T,C] = remove_duplicated_colored_vertices(V,T,C);        
    T = unique(sort(T,2),'rows','stable'); % remove duplicated triangles
end


if option_display                 
    display_meshed_fractal(V,T,C,az,el,cmap);
end


end