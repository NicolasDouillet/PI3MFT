function [V, C] = twisted_cube_transformation(V)
%
% Author : nicolas.douillet (at) free.fr, 2017-2024.


V(:,3) = 0.25*pi*(1+V(:,3));
C = max(abs(V(:,1:2)),[],2);

Mrz = @(theta)[cos(theta) -sin(theta) 0;
               sin(theta)  cos(theta) 0;
               0           0          1];


for k = 1:size(V,1)
    
    V(k,:) = (Mrz(V(k,3))*V(k,:)')';
    
end

% Renormalization
V(:,2) = 0.5*(1+sqrt(5)) * V(:,2);
V(:,3) = 0.5*(1+sqrt(5))^2 * V(:,3) / pi;


end