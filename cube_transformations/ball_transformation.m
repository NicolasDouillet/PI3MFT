function [V, C] = ball_transformation(V, a, type)
%
% Author : nicolas.douillet (at) free.fr, 2023.


% - (1) Déterminer le vecteur normal du plan du cube le plus proche de chaque point M (table)
f = abs(V) == max(abs(V),[],2);
n = a * sign(V) .* f;

% - (2) Calculer I, le point d'intersection entre le vecteur OM et ce plan (besoin algos line-plane intersection
% distance) ; même point du plan pris que vecteur normal
M = n;
u = V ./ sqrt(sum(V.^2,2));

I = V + u .* (dot(n,M,2) - dot(n,V,2)) ./ dot(n,u,2);

% - (3) Calculer le ratio de distances k = OI / r (r, le rayon de la sphère circonscrite; a ici)
if nargin < 3 || strcmpi(type,'convex')
    k = a ./ sqrt(sum(I.^2,2));
elseif nargin > 2 && strcmpi(type,'concave')
    k = a .* sqrt(sum(I.^2,2));
end

% - (4) Multiplier OM par r.
V = k .* V;

% - (5) Radial colormap
C = sqrt(sum(V.^2,2));


end