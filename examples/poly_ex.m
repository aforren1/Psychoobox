Screen('Preference', 'Verbosity', 1);

scrn = PsychWindow(0, true,...
                   'color', [0 0 0],...
                   'rect', [0 0 600 600], ...
                   'alpha_blending', true);
% from https://github.com/kleinerm/Psychtoolbox-3/blob/master/Psychtoolbox/PsychTests/FillPolyTest.m
pointList=zeros(36, 2);
for i=1:36
    j=abs(sin(i*20/1*3.14/180));
    pointList(i,1)=300 + 100 * j * cos((36-i)*10/1 * 3.14 / 180);
    pointList(i,2)=300 + 100 * j * sin((36-i)*10/1 * 3.14 / 180);
end

poly = Poly('fill_color', [25 15 160 200].',...
                 'frame_color', [255 255 255 255].', ...
                 'point_list', pointList,...
                 'pen_width', 2, 'is_convex', 0);
poly.Draw(scrn.pointer);

scrn.Flip;

KbWait;

scrn.Close;
