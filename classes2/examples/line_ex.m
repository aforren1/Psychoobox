Screen('Preference', 'Verbosity', 1);
lne = Line();
lne.Add(1:3, 'color', [0 0 255; 0 255 0; 255 0 0]',...
        'midpoint', [0.5 0.5 0.5], ...
        'degrees', [30 60 90], ...
        'length', [.5 .5 .5]);
win = PsychWindow('screen', 0, 'color', [25 25 25], 'rect', [50 50 300 400]);
lne.Register(win.pointer);
lne.Prime(1:3);
lne.Draw(1:3);
win.Flip();
