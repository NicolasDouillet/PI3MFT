function [V, T] = solid_sierpinskuboctahedron(nb_it, option_display)


addpath('C:\Users\Nicolas\Desktop\TMW_contributions\mesh_processing_toolbox\src');

% Basis vectors
V1 = [0 0 0];
V2 = [2*sqrt(2)/3 0 -4/3];
V3 = [-sqrt(2)/3 sqrt(6)/3 -4/3];
V4 = [-sqrt(2)/3 -sqrt(6)/3 -4/3];

% Create root / mother meshed tetrahedron
[V,T] = sierpinski_solid_tetrahedron(V1,V2,V3,V4,nb_it,false);

Rmy = @(theta)[cos(theta) 0 -sin(theta);
    0          1  0;
    sin(theta) 0  cos(theta)];

Rmz = @(theta)[cos(theta) -sin(theta) 0;
    sin(theta)  cos(theta) 0;
    0           0          1];

Vs = cat(2,-V(:,1),V(:,2:3));
Vr1 = (Rmy(-acos(-1/3))*Vs')';
Vr2 = (Rmz(2*pi/3)*Vr1')';
Vr3 = (Rmz(-2*pi/3)*Vr1')';

Tr1 = T + size(V,1);
Tr2 = T + 2*size(V,1);
Tr3 = T + 3*size(V,1);

V = cat(1,V,Vr1,Vr2,Vr3);
T = cat(1,T,Tr1,Tr2,Tr3);

% Top tetrahedra
V2 = -V;
T2 = T + size(V,1);
V = cat(1,V,V2);
T = cat(1,T,T2);

% Square face tetrahedra
V5 = [sqrt(2)    -sqrt(6)/3 0];
V6 = [sqrt(2)     sqrt(6)/3 0];
V7 = [sqrt(2)/3   sqrt(6)/3 4/3];
V8 = [sqrt(2)/3  -sqrt(6)/3 4/3];

% 1st tetrahedron of the cubic part 
[Vc1,Tc1] = sierpinski_solid_tetrahedron(V5,V6,V7,V1,nb_it,false);

% 2nd tetrahedron of the cubic part 
[Vc2,Tc2] = sierpinski_solid_tetrahedron(V5,V7,V8,V1,nb_it,false);
Tc2 = Tc2 + size(Vc1,1);

Vcu1 = cat(1,Vc1,Vc2);
Tcu1 = cat(1,Tc1,Tc2);

% Rotations
Vcu2 = (Rmz( 2*pi/3)*Vcu1')';
Tcu2 = Tcu1 + size(Vcu1,1);
Vcu3 = (Rmz(-2*pi/3)*Vcu1')';
Tcu3 = Tcu1 + 2*size(Vcu1,1);
Vcu = cat(1,Vcu1,Vcu2,Vcu3);
Tcu = cat(1,Tcu1,Tcu2,Tcu3);

Vcd = -Vcu;
Tcd = Tcu + size(Vcu,1);

Vc = cat(1,Vcu,Vcd);
Tc = cat(1,Tcu,Tcd);
Tc = Tc + size(V,1);

V = cat(1,V,Vc);
T = cat(1,T,Tc);

% Remove duplicated vertices
[V,T] = remove_duplicated_vertices(V,T);

% Remove duplicated triangles
T = unique(sort(T,2),'rows','stable');

% Remove internal faces (triangles which have > 6 neighbors)
C = cell2mat(cellfun(@(t) numel(find(sum(bitor(bitor(T==T(t,1),T==T(t,2)),T==T(t,3)),2)==2)),num2cell((1:size(T,1))'),'un',0));
tgl_idx_2_remove = find(C > 6);
T = remove_triangles(tgl_idx_2_remove,T,'indices');

% Display
if option_display
    
    figure;
    trisurf(T,V(:,1),V(:,2),V(:,3),'EdgeColor',[0 0 1]), shading interp, hold on;
    colormap([0 0 1]);
    camlight('left');
    axis equal, axis tight;
    view(-43.7058,21.3485);
    
end


end % solid_sierpinskuboctahedron


% remove_duplicated_vertices subfunction
function [V_out, T_out] = remove_duplicated_vertices(V_in, T_in)

tol = 1e4*eps;
[V_out,~,n] = uniquetol(V_in,tol,'ByRows',true);
T_out = n(T_in);

end % remove_duplicated_vertices