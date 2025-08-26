% stereogram display example
%
% Press F5 to run


addpath(genpath('pwd/'));


[V,T] = main_PI3MFT(2,2,false); % Cubic base Koch snowflake
C = sqrt(sum(V.^2,2)); % radial distance based colormap 
cross_eye_vision_stereogram_display(V,T,C);

