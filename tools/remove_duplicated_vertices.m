function [V_out, T_out] = remove_duplicated_vertices(V_in, T_in)
%
% Author : nicolas.douillet (at) free.fr, 2017-2024.


tol = eps;
[V_out,~,n] = uniquetol(V_in,tol,'ByRows',true);
T_out = n(T_in);


end