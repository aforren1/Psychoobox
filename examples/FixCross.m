classdef FixCross < Line
% Example of inheriting from one of the more basic classes
%
    properties (SetAccess = public, GetAccess = public)
        line_length;
        x;
        y;
    end

    methods
        function self = FixCross(x, y, line_length, varargin)
        % Example call:
        %     fx = FixCross(20, 'color', [0 255 200], 'pen_width', 3);
            self = self@Line(varargin{:});
            self.line_length = line_length;
            h_len = self.line_length/2;
            self.start_xy = [x - h_len, y; x, y - h_len];
            self.stop_xy = [x + h_len, y; x, y + h_len];

        end

        function Draw(self, pointer)
        % Example call:
        %    fx.Draw(scrn.pointer);
        %
            Draw@Line(self, pointer);
        end
    end
end
