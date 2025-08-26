function C = cube(V1, V2, V3, V4, V5, V6, V7, V8)
%
% Author : nicolas.douillet (at) free.fr, 2017-2024.


% V1, V2, V3, V4, V5, V6, V7, V8 : line vectors of cube eight vertices coordinates
%
% Vn = [Vxn Vyn Vzn]


F1 = [1 2 3 4];
F2 = [5 8 7 6];
F3 = [1 4 8 5];
F4 = [2 1 5 6];
F5 = [2 6 7 3];
F6 = [3 7 8 4];

C = struct('vertex', [V1; V2; V3; V4; V5; V6; V7; V8], ...
           'facet', [F1; F2; F3; F4; F5; F6]);

       
end