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

txt.Set('rel_y_pos', 0.9, 'size', 30);
txt.Draw();

if IsOctave
    txt2 = PobText('value', 'testme', 'size', 14, ...
                  'color', [200 255 140], ...
                  'rel_x_pos', 0.5, ...
                  'rel_y_pos', 0.5);
    txt2.Register(win.pointer);
else
    txt2 = txt.Copy();
end
txt2.Set('rel_x_pos', 0.9, 'rel_y_pos', 0.1, 'color', [230 40 100]);
txt2.Draw();

win.Flip;
WaitSecs(1);

for ii = 1:500
    txt2.Set('rel_x_pos', (sin(ii*.05) + 1)/2, 'rel_y_pos', (sin(ii*.02) + 1)/2);
    txt2.Draw();
    win.Flip;
end
win.Close;
