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
            p.addParamValue('start_xy', [], @(x) isempty(x) || isnumeric(x));
            p.addParamValue('stop_xy', [], @(x) isempty(x) || isnumeric(x));
            p.addParamValue('pen_width', 1, @(x) isnumeric(x) && x > 0);
            p.addParamValue('smooth', 0, @(x) any(x == 0:2));

            p.addParamValue('lenient', 0, @(x) any(x == 0:1));
            p.addParamValue('center', [], @(x) isempty(x) || dims(x) == dims([0 0]));

            p.parse(varargin{:});
            opts = p.Results;
            for fns = fieldnames(opts)'
                self.(fns{1}) = opts.(fns{1});
            end
        end

        function Draw(self, pointer)
            if self.smooth > 0
                Screen('DrawLines', pointer, )
            else
                Screen('DrawLine', pointer, self.color, self.start_xy(1), self.start_xy(2),...
                       self.stop_xy(1), self.stop_xy(2), self.pen_width);
            end
        end

    end
end
