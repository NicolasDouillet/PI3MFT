% Four elements

M1 = [2*sqrt(2)/3  0         -1/3]; % right
M2 = [-sqrt(2)/3  sqrt(6)/3  -1/3]; % top left
M3 = [-sqrt(2)/3 -sqrt(6)/3  -1/3]; % bottom left
M4 = [ 0          0           1  ]; % top

[V1,T1] = sierpinski_solid_tetrahedron(M1,M2,M3,M4,5,false);

[V2,T2] = solid_Sierpinskube(5,false);

[V3,T3] = sierpinski_solid_octahedron(5,false);

[V4,T4] = solid_sierpinskicosahedron(5,false);


figure;
set(gcf,'Color',[0 0 0]);
subplot(221);
t1 = trisurf(T1,V1(:,1),V1(:,2),V1(:,3)); shading interp;
t1.FaceColor = 'r';
axis equal, axis tight, axis off;
ax1 = gca;
ax1.Clipping = 'off';
camlight head;
view(3);

subplot(222);
t2 = trisurf(T2,V2(:,1),V2(:,2),V2(:,3)); shading interp;
t2.FaceColor = 'g';
axis equal, axis tight, axis off;
ax2 = gca;
ax2.Clipping = 'off';
camlight head;
view(3);

subplot(223);
t3 = trisurf(T3,V3(:,1),V3(:,2),V3(:,3)); shading interp;
t3.FaceColor = 'y';
axis equal, axis tight, axis off;
ax3 = gca;
ax3.Clipping = 'off';
camlight head;
view(3);

subplot(224);
t4 = trisurf(T4,V4(:,1),V4(:,2),V4(:,3)); shading interp;
t4.FaceColor = 'c';
axis equal, axis tight, axis off;
ax4 = gca;
ax4.Clipping = 'off';
camlight head;
view(3);