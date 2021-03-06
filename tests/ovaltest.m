
Screen('Preference', 'Verbosity', 1);
Screen('Preference', 'SkipSyncTests', 1);
win = PobWindow('screen', 0,...
                  'color', [0 0 0],...
                  'rect', [20 20 550 600]);

ovl = PobOval();
ovl.Add(1, 'rel_x_pos', 0.5, ...
         'rel_y_pos', 0.5, ...
         'rel_x_scale', 0.2, ...
         'rel_y_scale', nan, ...
         'fill_color', [255 255 0], ...
         'frame_color', [255 0 255],...
         'rotation_angle', 30);
ovl.Register(win.pointer);
ovl.Prime();


%f = @() ovl.Draw(1);
%disp(timeit(f));
ovl.Draw(1);
win.Flip();

ovl.Set(1, 'fill_color', [nan nan nan]);
ovl.Prime();
ovl.Draw(1);
%disp(timeit(f));
win.Flip;

ovl.Add(2:3, 'rel_x_pos', [0.7, .2], ...
         'rel_y_pos', [0.3, .5], ...
         'rel_x_scale', [0.15, .1], ...
         'rel_y_scale', [.22, .1], ...
         'fill_color', [253.5 80 230; 33 88 102]', ...
         'frame_color', [120 120 120; nan nan nan]',...
         'fill_alpha', [80, 140]);
% f = @() ovl.Prime();
% disp(timeit(f));
ovl.Prime();
ovl.Draw(1:3);
win.Flip();

WaitSecs(2);
ovl.Close;
win.Close;
sca;
