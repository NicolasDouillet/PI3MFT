function [V, T, C] = moebius_3D_ring_transformation(V, T)
%
% Author : nicolas.douillet (at) free.fr, 2021-2024.


C = max(abs(V(:,1:2)),[],2);
C = cat(1,C,C,C,C,C,C,C,C);
V(:,3) = 0.125*pi*(1+V(:,3));

Mrz = @(theta)[cos(theta) -sin(theta) 0;
               sin(theta)  cos(theta) 0;
               0           0          1];

for k = 1:size(V,1)
    
    V(k,:) = (Mrz(V(k,3))*V(k,:)')';
    
end


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
V = cat(1,V,cat(2,V(:,1),-V(:,2),-V(:,3)));
T = cat(1,T,T+size(V,1));
V = cat(1,V,(Mry(0.5*pi)*V')');
T = cat(1,T,T+size(V,1));
V = cat(1,V,(Mry(pi)*V')');


end