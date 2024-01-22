function [V, T, u, v] = sample_triangle(V1, V2, V3, nb_steps)
%
% Author : nicolas.douillet (at) free.fr, 2017-2024.


% global Ndim;
Ndim = size(V1,1);

% (V1V2, V1V3) base
u = (V2 - V1);
v = (V3 - V1);

V = zeros(sum(1:nb_steps+1),Ndim);

nu = u / norm(u);
nv = v / norm(v);
stepu = norm(u) / nb_steps;
stepv = norm(v) / nb_steps;
k = 1;

% Sampling & vertices generation
for m = 0:nb_steps
    for n = 0:nb_steps
        if m+n <= nb_steps % in (V1,V2,V3) triangle conditions ; indices # nb segments
            tv = m*stepu*nu + n*stepv*nv; % translation vector
            V(k,:) = (V1 + tv)';
            k = k+1;
        end
    end
end

% Index triplets list construction
T = zeros(0,3); % zeros(nb_steps^2,3);
row_length = 1 + nb_steps;
cum_row_length = row_length;
row_idx = 1;
p = 1;

while p <= nb_steps^2 && row_length > 1
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

% T = sort(T,2);
% T = unique(T,'rows','stable');


end