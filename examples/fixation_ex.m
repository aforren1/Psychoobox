% Demonstrate creating custom subclasses
Screen('Preference', 'Verbosity', 1);
scrn = PsychWindow(0, true,...
                   'color', [0 0 0],...
                   'rect', [50 50 450 450], ...
                   'alpha_blending', true);

% Create fixation cross, defined in FixCross.m
fx = FixCross(20, 'color', [0 255 200], 'pen_width', 3);
fx.Draw(scrn.pointer);
scrn.Flip;

KbWait;
scrn.Close;
Screen('Preference', 'Verbosity', 3);
