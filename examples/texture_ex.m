Screen('Preference', 'Verbosity', 1);
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
textures.DrawSettings(1:2, )
