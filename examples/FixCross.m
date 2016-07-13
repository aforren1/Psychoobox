classdef FixCross < Line
% Example of inheriting from one of the more basic classes
%
    properties (SetAccess = public, GetAccess = public)
        line_length;
    end

    methods
        function self = FixCross(line_length, varargin)
        % Example call:
        %     fx = FixCross(20, 'color', [0 255 200], 'pen_width', 3);
            self = self@Line(varargin{:});
            self.line_length = line_length;

        end

        function Draw(self, pointer, rect)
        % Example call:
        %    fx.Draw(scrn.pointer, scrn.rect);
        %
            [rect_x, rect_y] = RectCenter(rect);
            h_len = self.line_length/2;
            self.start_xy = [rect_x - h_len, rect_y; rect_x, rect_y - h_len];
            self.stop_xy = [rect_x + h_len, rect_y; rect_x, rect_y + h_len];
            Draw@Line(self, pointer);
        end
    end
end
