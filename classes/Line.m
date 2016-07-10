classdef Line < PsychHandle
    properties (SetAccess = protected, GetAccess = protected)
        color;
        from_h;
        from_v;
        to_h;
        to_v;
        pen_width;
    end

    methods
        function self = Line(varargin)
            p = inputParser;
            p.FunctionName = 'Line';
            p.addParamValue('color',  [], @(x) isempty(x) || isnumeric(x));
            p.addParamValue('from_h', [], @(x) isempty(x) || isnumeric(x));
            p.addParamValue('from_v', [], @(x) isempty(x) || isnumeric(x));
            p.addParamValue('to_h', [], @(x) isempty(x) || isnumeric(x));
            p.addParamValue('to_v', [], @(x) isempty(x) || isnumeric(x));
            p.addParamValue('pen_width', 1, @(x) isnumeric(x) && x > 0);
            p.parse(varargin{:});
            opts = p.Results;
            for fns = fieldnames(opts)'
                self.(fns{1}) = opts.(fns{1});
            end
        end

        function Draw(self, pointer)
            Screen('DrawLine', pointer, self.color, self.from_h, self.from_v,...
                   self.to_h, self.to_v, self.pen_width);
        end

    end
end
