function [V, T] = Mengerusalem_cube(nb_it)
%
% Author & support : nicolas.douillet (at) free.fr, 2017-2022.


% Body
% Summits of original cube (living in the unit sphere R(O,1))
a = 1;

V1 = [a a a];
V2 = [-a a a];
V3 = [-a -a a];
V4 = [a -a a];
V5 = -V3;
V6 = -V4;
V7 = -V1;
V8 = -V2;

C = cube(V1, V2, V3, V4, V5, V6, V7, V8);

for k = 1:nb_it
              
    C = Jerusalem_cube_main_algo(C,k);
    if k < 2
    C = Menger_cube_main_algo(C);  
    end
    
end

[V,T] = squares2triangles(C);
cmap = max(abs(V),[],2); % sqrt(sum(V.^2,2));
disp_Mengerusalem_cube(V, T, cmap);


end % Mengerusalem_cube


function [C] = cube(V1, V2, V3, V4, V5, V6, V7, V8)
%
% Author & support : nicolas.douillet (at) free.fr, 2017-2022.
%
% V1, V2, V3, V4, V5, V6, V7, V8 : line vectors of cube eight vertices coordinates
%
% Vn = [Vxn Vyn Vzn]

F1 = [1 2 3 4];
F2 = [5 6 7 8];
F3 = [1 4 8 5];
F4 = [2 1 5 6];
F5 = [2 3 7 6];
F6 = [3 4 8 7];

C = struct('vertex', [V1; V2; V3; V4; V5; V6; V7; V8], ...
    'facet', [F1; F2; F3; F4; F5; F6]);

end % cube


% Squares to triangles conversion subfunction
function [V, T] = squares2triangles(C)
%
% Author & support : nicolas.douillet (at) free.fr, 2017-2022.
%
% Split struct array into two arrays : vertices & facets

S = size(C,3);
V = zeros(8*S,3);
T = zeros(12*S,3);

for k = 1:S
    
    for i = 1:size(C(:,:,k).vertex,1)
        
        V(8*(k-1)+i,:) = C(:,:,k).vertex(i,:);
        
    end
    
    for j = 1:size(C(:,:,k).facet,1) % 6
        
        a = C(:,:,k).facet(j,1) + 8*(k-1);
        b = C(:,:,k).facet(j,2) + 8*(k-1);
        c = C(:,:,k).facet(j,3) + 8*(k-1);
        d = C(:,:,k).facet(j,4) + 8*(k-1);
        
        T1 = sort([a b c]);
        T2 = sort([a d c]);
        
        T(12*(k-1)+2*(j-1)+1,:) = T1;
        T(12*(k-1)+2*j,:) = T2;
        
    end
    
end

% Remove duplicated triangles
T = unique(sort(T,2),'rows','stable');

end % squares2triangles


% Display subfunction
function [] = disp_Mengerusalem_cube(V, T, cmap)
%
% Author & support : nicolas.douillet (at) free.fr, 2017-2022.

figure;
set(gcf,'Color',[1 1 1]), set(gca,'Color',[1 1 1]);
trisurf(T,V(:,1),V(:,2),V(:,3),cmap), shading flat, hold on;
colormap(flipud(1-hsv.^0.5));
axis square, axis equal, axis tight, axis off;
grid off;
ax = gca;
ax.Clipping = 'off';
camlight left;
view(3);

end % disp_Jerusalem_cube
