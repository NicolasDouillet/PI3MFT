function [] = display_meshed_fractal(V, T, C, az, el, cmap)
%
% Author : nicolas.douillet (at) free.fr, 2017-2024.


figure;
set(gcf,'Color',[0 0 0]), set(gca,'Color',[0 0 0]);
trisurf(T,V(:,1),V(:,2),V(:,3),C), shading interp, hold on;
colormap(cmap);
axis square, axis equal, axis tight, axis off;
grid off;
ax = gca;
ax.Clipping = 'off';
camlight head;
view(az,el);


end % dispplay_meshed_fractal