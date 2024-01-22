function [V, T, C] = infinity_sign_transformation(Vc, Tc, Cc) % Vc, Tc, Cc are vertex, triangle, and color sets from the crescent shape
%
% Author : nicolas.douillet (at) free.fr, 2021-2024.


Mry = @(theta)[cos(theta)    0    -sin(theta);
               0             1     0;
               sin(theta)    0     cos(theta)];           
           
Mrz = @(theta)[cos(theta)    -sin(theta)     0;
               sin(theta)     cos(theta)     0;
               0              0              1];

% Upper crescent
Vu = (Mry(0.25*pi)*Vc')';
Vu(:,1) = Vu(:,1) - 1.8927;
Vu = (Mrz(0.5*pi)*Vu')';
Vu(:,1) = Vu(:,1) + 1.8927;
Vu = (Mry(0.25*pi)*Vu')';

Tu = Tc + size(Vc,1);
Cu = Cc;

% Lower crescent
Vl = (Mry(-0.25*pi)*Vc')';
Vl(:,1) = Vl(:,1) - 1.8927;
Vl = (Mrz(0.5*pi)*Vl')';
Vl(:,1) = Vl(:,1) + 1.8927;
Vl = (Mry(-0.25*pi)*Vl')';

Tl = Tc + 2*size(Vc,1);
Cl = Cc;

% Rotation
% 1st concatenation
V = cat(1,Vc,Vu,Vl);
T = cat(1,Tc,Tu,Tl);
C = cat(1,Cc,Cu,Cl);

% Symetric part
Vs = cat(2,V(:,1),-V(:,2)-2*1.8927,V(:,3));
Ts = T + size(V,1);
Cs = C;

% Final concatenation
V = cat(1,V,Vs);
V = (Mry(-0.5*pi)*V')';
V(:,3) = -V(:,3);
T = cat(1,T,Ts);
C = cat(1,C,Cs);


end