% Demonstrate creating custom subclasses

scrn = PsychWindow(0, true,...
                   'color', [255 255 255],...
                   'rect', [50 50 450 450], ...
                   'alpha_blending', true);

% Create fixation cross, defined in FixCross.m
fx = FixCross(20, 'color', [0 255 200], 'pen_width', 3);

% Defined a `Draw` method to accept a rect, and place the cross at the center
fx.Draw(scrn.pointer, scrn.rect);
scrn.Flip;

KbWait;
scrn.Close;
