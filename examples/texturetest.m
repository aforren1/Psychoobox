Screen('Preference', 'Verbosity', 1);

% open a small window, make two overlapping squares, and wait for keystroke
scrn = Screen('OpenWindow', 0, [0 0 0 0], [0 0 600 600]);
Screen(scrn, 'BlendFunction', GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
offscrn = Screen('OpenOffscreenWindow', scrn, [0 0 0 0], Screen('Rect', scrn));
offscrn2 = Screen('OpenOffscreenWindow', scrn, [0 0 0 0], Screen('Rect', scrn));
Screen('FillOval', offscrn, [255 255 255], Screen('Rect', offscrn));
Screen('FrameOval', offscrn2, [255 255 255], Screen('Rect', offscrn2), 20);

Screen('DrawTextures', scrn, [offscrn, offscrn2, offscrn], [],...
       [80 20 140 200; 80 20 140 200; 160 300 450 400].', [30 80 -20],...
       [], [], [10 0 230; 255 30 60; 180 190 2].');

Screen('Flip', scrn);
KbWait;
sca;
