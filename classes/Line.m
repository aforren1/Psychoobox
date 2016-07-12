classdef Line < PsychHandle
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
