classdef Line < PsychHandle
    properties (SetAccess = private, GetAccess = private)
        color;
        from_h;
        from_v;
        to_h;
        to_v;
        pen_width;
        p;
    end

    methods
        function self = Line(varargin)
            p.inputParser;
            p.addParamValue('color',  [], @(x) isempty(x) || isnumeric(x));
            p.addParamValue('from_h', [], @(x) isempty(x) || isnumeric(x));
            p.addParamValue('from_v', [], @(x) isempty(x) || isnumeric(x));
            p.addParamValue('to_h', [], @(x) isempty(x) || isnumeric(x));
            p.addParamValue('to_v', [], @(x) isempty(x) || isnumeric(x));
            p.addParamValue('pen_width', 1, @(x) isnumeric(x) && x > 0);
            self.p.parse(varargin{:});
            opts = self.p.Results;
            for fns = fieldnames(opts)'
                self.(fns{1}) = opts.(fns{1});
            end
        end

        function Draw(self, pointer)
            Screen('DrawLine', pointer, self.color, self.from_h, self.from_v,...
                   self.to_h, self.to_v, self.pen_width);
        end


Screen('DrawLine', windowPtr [,color], fromH, fromV, toH, toV [,penWidth]);
