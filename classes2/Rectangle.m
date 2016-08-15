classdef Rectangle < RectShapes
% Example:
%
% rct = Rectangle;
% rct.Add(1:3, 'fill_color', [230 150 110; 8 45 68; 32 12 60]',...
%        'frame_color', ones(3)*255,...
%        'rel_x_pos', [.2 .5 .9],...
%        'rel_y_pos', [.9 .5 .2],...
%        'rel_x_scale', [.1 .3 .1],...
%        'rel_y_scale', [.3 .1 .3]);
% win = PsychWindow('screen', 0, 'color', [25 25 25], 'rect', [0 0 500 400]);
% rct.window_pointer = win.pointer;
% aa.Prime([1,3]);
% aa.Draw([1,3]);
% win.Flip;

    methods
        function Draw(self, indices)
            valid_fills = ~isnan(self.fill_color(1, indices));
            valid_frames = ~isnan(self.frame_color(1, indices));

            Screen('FillRect', self.window_pointer,...
                   [self.fill_color(:, valid_fills); self.fill_alpha(valid_fills)],...
                   self.drawing_rect(:, valid_fills));
            Screen('FrameRect', self.window_pointer,...
                   [self.frame_color(:, valid_frames); self.frame_alpha(valid_frames)],...
                   self.drawing_rect(:, valid_frames), self.frame_stroke(valid_frames));
        end
    end

end
