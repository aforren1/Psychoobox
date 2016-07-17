classdef FixCross < Line
% Example of inheriting from one of the more basic classes
%
    properties (SetAccess = public, GetAccess = public)
        line_len;
    end

    methods
        function self = FixCross(line_length, varargin)
        % Example call:
        %     fx = FixCross(20, 'color', [0 255 200], 'pen_width', 3);
            self = self@Line(varargin{:});
            self.line_len = line_length;
        end

        function Draw(self, pointer)
        % Example call:
        %    fx.Draw(scrn.pointer);
        %
            [x, y] = RectCenter(Screen(pointer, 'rect'));
            self.start_xy = [x - self.line_len, y; x, y - self.line_len];
            self.stop_xy = [x + self.line_len, y; x, y + self.line_len];

            Draw@Line(self, pointer);
        end
    end
end
