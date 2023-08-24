function [V, T, C] = mengerusalem_crescent(nb_it, option_display)


[V,T] = Mengerusalem_cube(nb_it);


[V,T] = remove_duplicated_vertices(V,T);

C = max(abs(V(:,1:2)),[],2);
V(:,3) = 0.125*pi*(1+V(:,3));
C = cat(1,C,C);


% - (1) Déterminer le vecteur normal du plan du cube le plus proche
% de chaque point M (table)

a = 1;
f = abs(V(:,1:2)) == max(abs(V(:,1:2)),[],2);
n = cat(2,a * sign(V(:,1:2)) .* f, zeros(size(V,1),1));

% - (2) Calculer I, le point d'intersection entre le vecteur OM et ce plan (besoin algos line-plane intersection
% distance) ; même point du plan pris que vecteur normal

M = n;
u = cat(2,V(:,1:2)./sqrt(sum(V(:,1:2).^2,2)),zeros(size(V,1),1));

I = V + u .* (dot(n,M,2) - dot(n,V,2)) ./ dot(n,u,2);

% - (3) Calculer le ratio de distances k = OI / r (r, le rayon de la sphère circonscrite; a ici)
% - (4) Multiplier OM par r.

k = a ./ sqrt(sum(I(:,1:2).^2,2));
V(:,1:2) = k .* V(:,1:2);


Mry = @(theta)[cos(theta) 0 -sin(theta);
               0          1  0;
               sin(theta) 0  cos(theta)];

           
V(:,1) = 0.125*pi + 0.5*(1+V(:,1));
V(:,2) = 0.5*V(:,2);
Z = V(:,3);

for k = 1:size(V,1)
    
    V(k,:) = (Mry(V(k,3))*cat(2,V(k,1:2),0)')';
    
end

V(:,3) = -V(:,3) - sin(Z);
V(:,1) =  V(:,1) + cos(Z);

% Other quarter creation
T = cat(1,T,T+size(V,1));
V = cat(1,V,(Mry(0.25*pi)*V')');


% Display
if option_display
    
    figure;        
    trisurf(T,V(:,1),V(:,2),V(:,3),C), shading interp, hold on;
    colormap(parula);
    ax = gca;
    ax.Clipping = 'off';
    set(gcf,'Color',[0 0 0]), set(ax,'Color',[0 0 0]);
    axis square, axis equal, axis tight, axis off;    
    camlight left;
    view(0,-70);
    
end



end % mengerusalem_crescent


% Remove duplicated vertices subfunction
function [V_out, T_out] = remove_duplicated_vertices(V_in, T_in)

tol = 1e4*eps;
[V_out,~,n] = uniquetol(V_in,tol,'ByRows',true);
T_out = n(T_in);

end % remove_duplicated_vertices