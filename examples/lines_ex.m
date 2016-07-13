scrn = PsychWindow(0, true,...
                   'color', [255 255 255],...
                   'rect', [50 50 450 450], ...
                   'alpha_blending', true);

% use simple Line
lne = Line('color', [125 0 233], ...
           'start_xy', [25 25], ...
           'stop_xy', [75 120], ...
           'pen_width', 2);
lne.Draw(scrn.pointer);

scrn.Flip();

KbWait;
% use drawlines (unaliased)
lne.Set('start_xy', [25 25; 50 50; 75 75]);
lne.Set('stop_xy', [120 150; 23 45; 55 10]);
lne.Draw(scrn.pointer);
scrn.Flip;

WaitSecs(.5);
KbWait;

% try smoothing
lne.Set('smooth', 2);
lne.Draw(scrn.pointer);
scrn.Flip;
WaitSecs(.5);
KbWait;

scrn.Close;
