function [V, T] = solid_sierpinskube(nb_it, option_display)


addpath('C:\Users\Nicolas\Desktop\TMW_contributions\mesh_processing_toolbox\src');

% Body
% Summits of original cube (living in the unit sphere R(O,1))
C = (sqrt(3)/3)*[ 1  1  1;...
                 -1  1  1;...
                 -1 -1  1;...
                  1 -1  1;...
                  1  1 -1;...
                 -1  1 -1;...
                 -1 -1 -1;...
                  1 -1 -1];   

% Summits of one corner tetrahedron (living in the unit sphere R(O,1))
V1 = C(2,:);
V2 = C(1,:);
V3 = C(6,:);
V4 = C(3,:);
V8 = C(8,:);

% Create root / mother meshed tetrahedron
[V,T] = sierpinski_solid_tetrahedron(V1,V2,V3,V4,nb_it,false);

% Top bottom right tetra
Vtbr = cat(2,-V(:,1),-V(:,2),V(:,3));
Ttbr = T + size(V,1);

% Bottom bottom left tetra
Vbbl = cat(2,V(:,1),-V(:,2),-V(:,3));
Tbbl = T + 2*size(V,1);

% Bottom top right tetra
Vbtr = cat(2,-V(:,1),V(:,2),-V(:,3));
Tbtr = T + 3*size(V,1);

% Intern tetra
[Vin,Tin] = sierpinski_solid_tetrahedron(V2,V4,V3,V8,nb_it,false);
Tin = Tin + 4*size(Vin,1);

V = cat(1,V,Vtbr,Vbbl,Vbtr,Vin);
T = cat(1,T,Ttbr,Tbbl,Tbtr,Tin);


ball_option = false;

if ball_option        
    
    % - (1) Déterminer le vecteur normal du plan du cube le plus proche
    % de chaque point M (table)
   
    f = abs(V) == max(abs(V),[],2); 
    n = a * sign(V) .* f;        
    
    % - (2) Calculer I, le point d'intersection entre le vecteur OM et ce plan (besoin algos line-plane intersection
    % distance) ; même point du plan pris que vecteur normal
      
    M = n;
    u = V ./ sqrt(sum(V.^2,2));        
    
    I = V + u .* (dot(n,M,2) - dot(n,V,2)) ./ dot(n,u,2);     
        
    % - (3) Calculer le ratio de distances k = OI / r (r, le rayon de la sphère circonscrite; a ici)
    % - (4) Multiplier OM par r.
    
    k = a * sqrt(sum(I.^2,2));
    V = k .* V;        
    
end


% Remove duplicated vertices
[V,T] = remove_duplicated_vertices(V,T);

% Remove duplicated triangles
T = unique(sort(T,2),'rows','stable');

% Remove internal faces (triangles which have > 6 neighbors)
C = cell2mat(cellfun(@(t) numel(find(sum(bitor(bitor(T==T(t,1),T==T(t,2)),T==T(t,3)),2)==2)),num2cell((1:size(T,1))'),'un',0));
tgl_idx_2_remove = find(C > 7);
T = remove_triangles(tgl_idx_2_remove,T,'indices');


if option_display        
    display_fractal_octahedron(V,T);    
end


end % solid_sierpinskube


% remove_duplicated_vertices subfunction
function [V_out, T_out] = remove_duplicated_vertices(V_in, T_in)

tol = 1e4*eps;
[V_out,~,n] = uniquetol(V_in,tol,'ByRows',true);
T_out = n(T_in);

end % remove_duplicated_vertices


% display_fractal_tetra subfunction
function [] = display_fractal_octahedron(V, T)


figure;
set(gcf,'Color',[0 0 0]);
C = sqrt(sum(V.^2,2));
trisurf(T,V(:,1),V(:,2),V(:,3),C); colormap(flipud('hot'));
shading interp;

set(gca,'Color',[0 0 0],'XColor',[1 1 1],'YColor',[1 1 1],'ZColor',[1 1 1]);
ax = gca;
ax.Clipping = 'off';
axis equal, axis tight, axis off;
% camlight right;
% camlight head;
view(-17.64,16.95);


end % display_fractal_tetra