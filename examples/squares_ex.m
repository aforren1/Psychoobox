% open a small window, make two overlapping squares, and wait for keystroke
scrn = PsychWindow(0, true,...
                   'color', [0 0 0],...
                   'rect', [0 0 300 300], ...
                   'alpha_blending', true);

rect = Rectangle('fill_color', [25 15 160 200; 220 150 3 140]',...
                 'frame_color', [255 255 255; 150 150 150]', ...
                 'rect', [20 20 80 80; 40 40 90 90]', ...
                 'pen_width', [2 4]);

rect.Draw(scrn.Get('pointer'));
scrn.Flip;

KbWait;
scrn.Close;