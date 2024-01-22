function [V, T, C] = torus_transformation(V, T, C)
%
% Author : nicolas.douillet (at) free.fr, 2017-2024.


C = cat(1,C,C,C,C,C,C,C,C);

Mry = @(theta)[cos(theta) 0 -sin(theta);
               0          1  0;
               sin(theta) 0  cos(theta)];

V(:,1) = 0.125*pi + 0.5*(1+V(:,1));
V(:,2) = 0.5*V(:,2);
Z = V(:,3);


for k = 1:size(V,1)
    
    V(k,:) = (Mry(V(k,3))*cat(2,V(k,1:2),0)')';
    
end


V(:,3) = V(:,3) + sin(Z);
V(:,1) = V(:,1) + cos(Z);

% Three other quarters creation
T = cat(1,T,T+size(V,1));

% 0.125*pi rotate all the other cylinders from their basis
V = cat(1,V,(Mry(0.25*pi)*V')');
T = cat(1,T,T+size(V,1));
V = cat(1,V,(Mry(0.5*pi)*V')');
T = cat(1,T,T+size(V,1));
V = cat(1,V,(Mry(pi)*V')');


end