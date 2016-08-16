Screen('Preference', 'Verbosity', 1);
arc = Arc;
arc.Add(1:3, 'fill_color', [230 150 110; 8 45 68; 32 180 60]',...
       'frame_color', ones(3)*255,...
       'rel_x_pos', [.2 .5 .9],...
       'rel_y_pos', [.9 .5 .6],...
       'rel_x_scale', [.2 .3 .1],...
       'rel_y_scale', [.3 .1 .3],...
       'start_angle', [0 50 70],...
       'arc_angle', [100, 30, 0]);
win = PsychWindow('screen', 0, 'color', [25 25 25], 'rect', [0 0 500 400]);
arc.window_pointer = win.pointer;
arc.Prime(1:3);
arc.Draw(1:3);
win.Flip;
