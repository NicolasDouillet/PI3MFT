function [] = cross_eye_vision_stereogram_display(V,T,C) 
% Learn to see cross eye vision stereograms to be able to see it in 3D !
%
%%% Author : nicolas.douillet9 (at) gmail.com, 2025.


% View point
azimut = 45;
elevation = 35;

% delta : stereo vision angle to tune
% Depends on the object and on your distance to the screen
delta = 4; % small angle, 2° <= delta <= 10°


figure;
subplot(121);
trisurf(T,V(:,1),V(:,2),V(:,3),C), shading interp, hold on;
colormap(flipud(1-hot)); % icy colormap


axis equal, axis tight, axis off;
view(azimut+0.5*delta,elevation);
camlight left;

ax = gca;
ax.Clipping = 'off';

set(gcf,'Color',[0 0 0]), set(gca,'Color',[0 0 0]);

subplot(122);
trisurf(T,V(:,1),V(:,2),V(:,3),C), shading interp, hold on;
colormap(flipud(1-hot));


axis equal, axis tight, axis off;
view(azimut-0.5*delta,elevation);
camlight left;


ax = gca;
ax.Clipping = 'off';

set(gcf,'Color',[0 0 0]), set(gca,'Color',[0 0 0]);


end % cross_eye_vision_stereogram_display