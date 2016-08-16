ovl = Oval;
ovl.Add(1:3, 'fill_color', [230 150 110; 8 45 68; 32 12 60]',...
       'frame_color', ones(3)*255,...
       'rel_x_pos', [.2 .5 .9],...
       'rel_y_pos', [.9 .5 .2],...
       'rel_x_scale', [.1 .3 .1],...
       'rel_y_scale', [.3 .1 .3]);
win = PsychWindow('screen', 0, 'color', [25 25 25], 'rect', [0 0 500 400]);
ovl.window_pointer = win.pointer;
ovl.Prime(1:3);
ovl.Draw(1:3);
win.Flip;