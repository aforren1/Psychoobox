scrn = PsychWindow(0, true,...
                   'color', [255 255 255],...
                   'rect', [0 0 400 400], ...
                   'alpha_blending', true);

% pkg load image
[kitty, map, alp] = imread('misc/kitten.png');
textures = PsychTexture;
textures.AddImage(kitty, scrn.pointer, 1);
textures.Draw(scrn.pointer, 1);
scrn.Flip;
KbWait;

textures.AddImage(kitty, scrn.pointer, 2, 'optimize_for_draw_angle', 30);
textures.draw_array(2).rotation_angle = 30;
textures.draw_array(2).rect = [50 50 200 200];
textures.draw_array(2).alpha = 1;
textures.Draw(scrn.pointer, 1:2);
scrn.Flip;
WaitSecs(.5);
KbWait;

textures.AddImage(kitty, scrn.pointer, 3, 'optimize_for_draw_angle', 60);
textures.draw_array(3).rotation_angle = 60;
textures.draw_array(3).rect = [100 100 300 300];
textures.draw_array(3).alpha = .4;
textures.Draw(scrn.pointer, 2:3);
scrn.Flip;
WaitSecs(.5);
KbWait;
scrn.Close;
%textures.DrawSettings(1:2, )
