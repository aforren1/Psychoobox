addpath('classes');
addpath('functions');
addpath('res');

Screen('Preference', 'Verbosity', 1);
Screen('Preference', 'SkipSyncTests', 1);
win = PobWindow('screen', 0,...
                  'color', [0 0 0],...
                  'rect', [20 20 550 600]);


txt = PobText('value', 'testme', 'size', 14, ...
              'color', [200 255 140], ...
              'rel_x_pos', 0.5, ...
              'rel_y_pos', 0.5);

txt.Register(win.pointer);

txt.Draw();

win.Flip();
WaitSecs(1);

txt.Set('rel_y_pos', 0.8, 'size', 30);
txt.Draw();

txt2 = txt.Copy();
txt2.Set('rel_x_pos', 0.3, 'rel_y_pos', 0.3);
txt2.Draw();

win.Flip;
WaitSecs(1);
win.Close;
