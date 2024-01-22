function V = cube_logtransformation(V)
%
% Author : nicolas.douillet (at) free.fr, 2023.


addpath('tools');


V(:,1) = V(:,1) - min(V(:,1));
V(:,1) = V(:,1) / max(V(:,1));
V(:,1) = (exp(1)-1)*V(:,1);
V(:,1) = log(1+V(:,1));

V(:,2) = V(:,2) - min(V(:,2));
V(:,2) = V(:,2) / max(V(:,2));
V(:,2) = (exp(1)-1)*V(:,2);
V(:,2) = log(1+V(:,2));

V(:,3) = V(:,3) - min(V(:,3));
V(:,3) = V(:,3) / max(V(:,3));
V(:,3) = (exp(1)-1)*V(:,3);
V(:,3) = log(1+V(:,3));


end