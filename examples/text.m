scrn = PsychWindow(0, true,...
                   'color', [255 255 255],...
                   'rect', [50 50 450 450]);

txt = PsychText('val', 'testing testing 123',...
                'style', 'normal',...
                'size',  80, ...
                'color', [0 255 0],
                'background_color', [255 0 0],...
                'x', 100, 'y', 100);

                Screen('TextSize', scrn.pointer, txt.size);
                Screen('TextStyle', scrn.pointer, txt.styles.(txt.style));
                Screen('TextFont', scrn.pointer, txt.font);
                Screen('TextTransform', scrn.pointer, txt.transform);
                Screen('DrawText', scrn.pointer, txt.val, ...
                       txt.x, txt.y, txt.color, txt.background_color, txt.y_pos_is_baseline, ...
                       txt.swap_text_direction);
%txt.Draw(scrn.pointer);

scrn.Flip;

KbWait;
scrn.Close;