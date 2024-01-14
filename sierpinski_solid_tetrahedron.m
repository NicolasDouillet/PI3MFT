function [V, T] = sierpinski_solid_tetrahedron(M1, M2, M3, M4, nb_it, option_display)


addpath('C:\Users\Nicolas\Desktop\TMW_contributions\mesh_processing_toolbox\src');


if nargin < 1
    
    % Vertices of tetrahedron basis (level 0) included in the unit sphere
    M1 = [2*sqrt(2)/3  0         -1/3]; % right
    M2 = [-sqrt(2)/3  sqrt(6)/3  -1/3]; % top left
    M3 = [-sqrt(2)/3 -sqrt(6)/3  -1/3]; % bottom left
    M4 = [ 0          0           1  ]; % top
    
    nb_it = 2;
    option_display = true;
    
end


% Body
summit_array = cat(1,M1,M2,M3,M4);
p = 0;
sample_step = 4*2^(nb_it-1) + 1;

% nb_it iterations / loops over tetrahedron split function
while p ~= nb_it
    
    % tetrahedric base
    u = summit_array(2,:,1) - summit_array(1,:,1);
    v = summit_array(3,:,1) - summit_array(1,:,1);
    w = summit_array(4,:,1) - summit_array(1,:,1);
    
    new_summit_array = zeros(4,3,4^p);
    
    for k = 1:size(summit_array,3)
        
        new_summit_array(:,:,1+4*(k-1):4*k) = compute_new_tetra_summits(summit_array(1,:,k),summit_array(2,:,k),...
                                                                        summit_array(3,:,k),summit_array(4,:,k),...
                                                                        u,v,w,sample_step);
        
    end
    
    sample_step = ceil(0.5*sample_step);
    summit_array = new_summit_array;
    p = p+1;
    
end

V = zeros(0,3);
T = zeros(0,3);


for k = 1:size(summit_array,3)        
    
    [V_sub,T_sub] = mesh_tetrahedron(summit_array(:,:,k),sample_step);
            
    if k > 1
        
        T_sub = T_sub + size(V,1);
        
    end
    
    V = cat(1,V,V_sub);
    T = cat(1,T,T_sub);
    
end

% % Octostar / Merkaba option
% V2 = -V;
% V = cat(1,V,V2);
% T2 = T + size(V2,1);
% T = cat(1,T,T2);

% Remove duplicated vertices
[V,T] = remove_duplicated_vertices(V,T);

% Remove duplicated triangles
T = unique(sort(T,2),'rows','stable');

% Remove internal faces (triangles which have > 6 neighbors)
C = cell2mat(cellfun(@(t) numel(find(sum(bitor(bitor(T==T(t,1),T==T(t,2)),T==T(t,3)),2)==2)),num2cell((1:size(T,1))'),'un',0));
tgl_idx_2_remove = find(C > 5);
T = remove_triangles(T,tgl_idx_2_remove,'indices');


if option_display    
    
    display_fractal_tetra(V,T);
    
end


end % sierpinski_solid_tetrahedron


% display_fractal_tetra subfunction
function [] = display_fractal_tetra(V, T)


figure;
set(gcf,'Color',[0 0 0]);
t = trisurf(T,V(:,1),V(:,2),V(:,3));
t.EdgeColor = 'g';

set(gca,'Color',[0 0 0],'XColor',[1 1 1],'YColor',[1 1 1],'ZColor',[1 1 1]);
colormap([0 1 0]);
axis equal, axis tight;
camlight left;
view(-120,0);
axis off;


end % display_fractal_tetra


% compute_new_tetra_summits subfunction
function [M_new] = compute_new_tetra_summits(M1, M2, M3, M4, u, v, w, sample_step)


u_floor_shift = floor(0.5*sample_step)*u/sample_step;
u_ceil_shift  =  ceil(0.5*sample_step)*u/sample_step;
v_floor_shift = floor(0.5*sample_step)*v/sample_step;
v_ceil_shift  =  ceil(0.5*sample_step)*v/sample_step;
w_floor_shift = floor(0.5*sample_step)*w/sample_step;
w_ceil_shift  =  ceil(0.5*sample_step)*w/sample_step;

% Right floor tetra
R1 = M1;
R2 = M1 + u_ceil_shift;
R3 = M1 + v_ceil_shift;
R4 = M1 + w_ceil_shift;
R = cat(1,R1,R2,R3,R4);

% top Left tetra
L1 = M1 + u_floor_shift;
L2 = M2; % M1' + u; 
L3 = M1 + u_floor_shift + v_ceil_shift;
L4 = M1 + u_floor_shift + w_ceil_shift;
L = cat(1,L1,L2,L3,L4);

% Bottom left tetra
B1 = M1 + v_floor_shift;
B2 = M1 + v_floor_shift + u_ceil_shift;
B3 = M3; % M1' + v 
B4 = M1 + v_floor_shift + w_ceil_shift;
B = cat(1,B1,B2,B3,B4);

% Top tetra
T1 = M1 + w_floor_shift;
T2 = M1 + u_ceil_shift + w_floor_shift;
T3 = M1 + v_ceil_shift + w_floor_shift;
T4 = M4; % M1' + w;
T = cat(1,T1,T2,T3,T4);
    
M_new = cat(3,R,L,B,T);    


end % compute_new_tetra_summits


% mesh_tetrahedron subfunction
function [V, T] = mesh_tetrahedron(tetra, nbstep)


M1 = tetra(1,:)';
M2 = tetra(2,:)';
M3 = tetra(3,:)';
M4 = tetra(4,:)';

[V1,T1] = sample_triangle(M1,M2,M4,nbstep);
[V2,T2] = sample_triangle(M2,M3,M4,nbstep);
[V3,T3] = sample_triangle(M3,M1,M4,nbstep);
[V4,T4] = sample_triangle(M1,M3,M2,nbstep);

T2 = T2 + size(V1,1);
T3 = T3 + size(V1,1) + size(V2,1);
T4 = T4 + size(V1,1) + size(V2,1) + size(V3,1);

V = cat(1,V1,V2,V3,V4);
T = cat(1,T1,T2,T3,T4);


end % mesh_tetrahedron



% sample_triangle subfunction
function [V, T, u, v] = sample_triangle(V1, V2, V3, nbstep)


% Create sampling grid
global Ndim;

Ndim = size(V1,1);

% (V1V2, V1V3) base
u = (V2 - V1);
v = (V3 - V1);

V = zeros(sum(1:nbstep+1),Ndim);

nu = u / norm(u);
nv = v / norm(v);
stepu = norm(u) / nbstep;
stepv = norm(v) / nbstep;
k = 1;

% Sampling & vertices generation
for m = 0:nbstep
    
    for n = 0:nbstep
        
        if m+n <= nbstep % in (V1,V2,V3) triangle conditions ; indices # nb segments
            
            % translation vector
            tv = m*stepu*nu + n*stepv*nv;
            V(k,:) = (V1 + tv)';
            k = k+1;
            
        end
        
    end
    
end

% Index triplets list construction
T = zeros(0,3); % zeros(nbstep^2,3);
row_length = 1 + nbstep;
cum_row_length = row_length;
row_idx = 1;
p = 1;

while p <= nbstep^2 && row_length > 1
    
     i = p;
    
    if p < 2 % "right" triangle serie only
        
        while i < cum_row_length
            
            T = cat(1,T,[i i+1 i+row_length]);
            row_idx = row_idx + 1;
            i = i +1;
            
        end
        
        row_length = row_length - 1;
        cum_row_length = cum_row_length + row_length;
        p = p + row_length+1;
        
    else
        
        % Since p >= 2
        while i < cum_row_length % both triangle series
            
            T = cat(1,T,[i i+1 i+row_length]);
            row_idx = row_idx + 1;            
            T = cat(1,T,[i i-row_length i+1]); % + upside-down triangles serie
            row_idx = row_idx + 1;            
            i = i +1;
            
        end
        
        row_length = row_length - 1;
        cum_row_length = cum_row_length + row_length;
        p = p + row_length+1;
        
    end
    
end

T = sort(T,2);
T = unique(T,'rows','stable');


end % sample_triangle


% remove_duplicated_vertices subfunction
function [V_out, T_out] = remove_duplicated_vertices(V_in, T_in)

tol = 1e4*eps;
[V_out,~,n] = uniquetol(V_in,tol,'ByRows',true);
T_out = n(T_in);

end % remove_duplicated_vertices