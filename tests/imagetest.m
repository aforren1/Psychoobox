
Screen('Preference', 'Verbosity', 1);
Screen('Preference', 'SkipSyncTests', 1);
win = PobWindow('screen', 0,...
                  'color', [0 0 0],...
                  'rect', [20 20 550 600]);

img = imread('res/cat.jpg');

imgmat = PobImage;
imgmat.Add(1, 'original_matrix', {img}, ...
           'rel_x_pos', 0.5, ...
           'rel_y_pos', 0.5, ...
           'rel_x_scale', 0.2, ...
           'rel_y_scale', 0.2);

imgmat.Register(win.pointer);
imgmat.Prime();

imgmat.Draw(1);

win.Flip();

imgmat.Add(2:10, 'original_matrix', {img, img, img,img,img,img, img,img,img}, ...
           'rel_x_pos', unifrnd(0, 1, 1, 9), ...
           'rel_y_pos', unifrnd(0, 1, 1, 9), ...
           'rel_x_scale', unifrnd(0,.5, 1, 9), ...
           'modulate_color', repmat([20 255 180 180]', 1, 9), ...
           'rotation_angle', unifrnd(-60, 60, 1, 9));
imgmat.Prime();
t0 = GetSecs;
imgmat.Draw([2:10, 1]);
disp(GetSecs - t0);
win.Flip();

WaitSecs(2);
win.Close;
sca;
