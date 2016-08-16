classdef Arc < RectShapes
% Example:
%
% arc = Arc;
% arc.Add(1:3, 'fill_color', [230 150 110; 8 45 68; 32 12 60]',...
%        'frame_color', ones(3)*255,...
%        'rel_x_pos', [.2 .5 .9],...
%        'rel_y_pos', [.9 .5 .2],...
%        'rel_x_scale', [.1 .3 .1],...
%        'rel_y_scale', [.3 .1 .3]);
% win = PsychWindow('screen', 0, 'color', [25 25 25], 'rect', [0 0 500 400]);
% arc.window_pointer = win.pointer;
% arc.Prime(1:3);
% arc.Draw(1:3);
% win.Flip;

    properties
        start_angle
        arc_angle
    end

    methods
        function self = Arc()
            self = self@RectShapes;
            self.p.addParamValue('start_angle', 0, @(x) isnumeric(x));
            self.p.addParamValue('arc_angle', 0, @(x) isnumeric(x));
        end
        function Draw(self, indices)
            valid_fills = find(~isnan(self.fill_color(1, indices)));
            valid_frames = find(~isnan(self.frame_color(1, indices)));

            % hack around # of allowed arcs
            for ii = 1:length(valid_fills)
                Screen('FillArc', self.window_pointer,...
                       [self.fill_color(:, valid_fills(ii)); self.fill_alpha(valid_fills(ii))],...
                       self.drawing_rect(:, valid_fills(ii)), self.start_angle(valid_fills(ii)),...
                       self.arc_angle(valid_fills(ii)));
            end

            for ii = 1:length(valid_frames)
                Screen('FrameArc', self.window_pointer,...
                       [self.frame_color(:, valid_frames(ii)); self.frame_alpha(valid_frames(ii))],...
                       self.drawing_rect(:, valid_frames(ii)),...
                       self.start_angle(valid_frames(ii)), self.arc_angle(valid_frames(ii)),...
                       self.frame_stroke(valid_frames(ii)), self.frame_stroke(valid_frames(ii)));
            end
        end
    end
end
