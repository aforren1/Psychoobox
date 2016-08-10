cd ~/Documents/BLAM/Psychoobox

ref_rect = [0 0 800 800];

rel_x_pos = [0.1 0.3 0.5 0];
rel_y_pos = [.9 .7 .5 1];
rel_x_scale = [0.2 0.2 0.2 .05];
rel_y_scale = [0.2, 0.4, 0.3 .03];

RelativeToRect(rel_x_pos, rel_y_pos, ...
               rel_x_scale, rel_y_scale, ...
               ref_rect)
