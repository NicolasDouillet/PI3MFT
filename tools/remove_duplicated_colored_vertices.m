function [V_out, T_out, C_out] = remove_duplicated_colored_vertices(V_in, T_in, C_in)
%
% Author : nicolas.douillet (at) free.fr, 2017-2024.


tol = eps;
[V_out,idx,n] = uniquetol(V_in,tol,'ByRows',true);
T_out = n(T_in);
C_out = C_in(idx);


end