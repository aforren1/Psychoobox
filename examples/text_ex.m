Screen('Preference', 'Verbosity', 1);

scrn = PsychWindow(0, true,...
                   'color', [255 255 255],...
                   'rect', [50 50 450 450]);

txt = PsychText('val', 'testing testing 123',...
                'style', 'normal',...
                'size',  30, ...
                'color', [0 255 0],...
                'background_color', [0 0 255],...
                'x', 100, 'y', 100);

txt.Draw(scrn.pointer);

scrn.Flip;
KbWait;

txt.Set('formatted', true, 'wrapat', 10);
txt.Draw(scrn.pointer);
scrn.Flip;

WaitSecs(.5);
KbWait;
scrn.Close;
