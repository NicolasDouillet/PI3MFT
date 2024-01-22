function [V, C] = cylinder_transformation(V, a, type)
%
% Author : nicolas.douillet (at) free.fr, 2017-2024.


C = max(abs(V(:,1:2)),[],2);
V(:,3) = 0.125*pi*(1+V(:,3));


% - (1) Déterminer le vecteur normal du plan du cube le plus proche
% de chaque point M (table)

f = abs(V(:,1:2)) == max(abs(V(:,1:2)),[],2);
n = cat(2,a * sign(V(:,1:2)) .* f, zeros(size(V,1),1));

% - (2) Calculer I, le point d'intersection entre le vecteur OM et ce plan (besoin algos line-plane intersection
% distance) ; même point du plan pris que vecteur normal

M = n;
u = cat(2,V(:,1:2)./sqrt(sum(V(:,1:2).^2,2)),zeros(size(V,1),1));

I = V + u .* (dot(n,M,2) - dot(n,V,2)) ./ dot(n,u,2);

% - (3) Calculer le ratio de distances k = OI / r (r, le rayon de la sphère circonscrite; a ici)
% - (4) Multiplier OM par r.

if nargin < 3 || strcmpi(type,'convex')
    
    k = a ./ sqrt(sum(I(:,1:2).^2,2));
    V(:,1:2) = k .* V(:,1:2);
    
elseif nargin > 2 && strcmpi(type,'twisted')
    
    k = a ./ sqrt(sum(I(:,1:2).^2,2));
    V(:,1:2) = k .* V(:,1:2);
    
    Mrz = @(theta)[cos(theta) -sin(theta) 0;
               sin(theta)  cos(theta) 0;
               0           0          1];
    
    for k = 1:size(V,1)
        
        V(k,:) = (Mrz(V(k,3))*V(k,:)')';
        % V(k,:) = (Mrz(V(k,3))^4*V(k,:)')'; % to increase the twist rotation angle
        
    end
    
elseif nargin > 2 &&  strcmpi(type,'concave')
    
    k = a .* sqrt(sum(I(:,1:2).^2,2));
    V(:,1:2) = k .* V(:,1:2);        
    
end


end