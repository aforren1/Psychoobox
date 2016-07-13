classdef Line < PsychHandle
% Line Draw one or multiple lines with or without antialiasing.
%
% Line Properties:
%    start_xy - Nx2 matrix of (x, y) pairings.
%    stop_xy - Nx2 matrix of (x, y) pairings. Must be the same dimensions as start_xy.
%    color - A 3xN or 4xN matrix containing color info ([r g b] or [r g b alpha], if alpha blending is on).
%    pen_width - Width of the line. Default is 1.
%    smooth - 0 is no smoothing, 1 is smoothing with antialiasing, 2 is higher-quality antialiasing. Defaults to 0.
%    lenient - If 1, width of lines isn't checked for validity. Defaults to 0.
%    center - Define a new center that coordinates are relative to. Defaults to [0, 0].
%
% Line Methods:
%     Draw - Draw the line(s) on the specified window.
%     Get - Get values.
%     Set - Set values.
%     Print - See values.
%
% Example:
% lne = Line('color', [125 0 233], ...
%            'start_xy', [25 25], ...
%            'stop_xy', [75 120], ...
%            'pen_width', 2);
% lne.Draw(scrn.pointer);
%
    properties (SetAccess = public, GetAccess = public)
        color;
        start_xy;
        stop_xy;
        pen_width;
        smooth;
        lenient;
        center;
    end

    methods
        function self = Line(varargin)
            p = inputParser;
            p.FunctionName = 'Line';
            p.addParamValue('color',  [], @(x) isempty(x) || isnumeric(x));
            p.addParamValue('start_xy', [], @(x) isempty(x) || (isnumeric(x) && size(x, 2) == 2));
            p.addParamValue('stop_xy', [], @(x) isempty(x) || (isnumeric(x) && size(x, 2) == 2));
            p.addParamValue('pen_width', 1, @(x) isnumeric(x) && x > 0);
            p.addParamValue('smooth', 0, @(x) any(x == 0:2));

            p.addParamValue('lenient', 0, @(x) any(x == 0:1));
            p.addParamValue('center', [0 0], @(x) isempty(x) || size(x) == size([0 0]));

            p.parse(varargin{:});
            opts = p.Results;

            for fns = fieldnames(opts)'
                self.(fns{1}) = opts.(fns{1});
            end
        end

        function Draw(self, pointer)
            if self.smooth > 0 || sum(size(self.start_xy)) > 3
                tempdims = zeros(length(self.start_xy) + length(self.stop_xy), 2);
                tempdims(1:2:end, :) = self.start_xy;
                tempdims(2:2:end, :) = self.stop_xy;
                tempdims = tempdims';
                Screen('DrawLines', pointer, tempdims, self.pen_width, ...
                       self.color, self.center, self.smooth, self.lenient);
            else
                Screen('DrawLine', pointer, self.color, self.start_xy(1), self.start_xy(2),...
                       self.stop_xy(1), self.stop_xy(2), self.pen_width);
            end
        end

    end
end
