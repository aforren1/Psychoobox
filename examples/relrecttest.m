cd ~/Documents/BLAM/Psychoobox

ref_rect = [0 0 800 800];

rel_x_pos = [0.1 0.3 0];
rel_y_pos = [.9 .7 1];
rel_x_scale = [0.2 0.2 .05];
rel_y_scale = [0.2, nan, .03];

RelativeToRect(rel_x_pos, rel_y_pos, ...
               rel_x_scale, rel_y_scale, ...
               ref_rect)

isnan([4, 2, nan])
nan * 1

xx = [1 nan 6] * 200
yy = [nan 6 3] * 100

isnan([1])
800*.05
