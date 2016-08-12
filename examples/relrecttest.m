cd ~/Documents/BLAM/Psychoobox

ref_rect = [0 0 600 800];

rel_x_pos = [0.1 0.3 0 ];
rel_y_pos = [.9 .7 1 ];
rel_x_scale = [0.2 0.2 .05];
rel_y_scale = [0.2, nan, .03];
az = struct('a',[]);
az(1).a = RelativeToRect(rel_x_pos, rel_y_pos, ...
               rel_x_scale, rel_y_scale, ...
               ref_rect);
az(2).a = az(1).a;
az(1).a(:,1)
zz = [1,3,4,5];
zz(:,4)
(az(1:2).a)
(1,2)
(1 2)
