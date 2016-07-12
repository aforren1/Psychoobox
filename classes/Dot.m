classdef Dot < PsychHandle

    properties (SetAccess = public, GetAccess = public)
        pointer;
        xy;
        size;
        color;
        center;
        dot_type;
        lenient;
    end

    methods
        function self = Dot(varargin)
            p = inputParser;
            p.addParamValue('xy', [], @(x) isempty(x) || (isnumeric(x) && any(size(x) == 2)));
            p.addParamValue('size', 1, @(x) x > 0);
            p.addParamValue('color', [0 0 0], @(x) isnumeric(x));
            p.addParamValue('center', [0 0], @(x) isnumeric(x));
            p.addParamValue('dot_type', 0, @(x) any(x == 0:4));
            p.addParamValue('lenient', 0, @(x) any(x == 0:1));
            p.parse(varargin{:});
            opts = p.Results;
            for fns = fieldnames(opts)'
                self.(fns{1}) = opts.(fns{1});
            end


        end

        function Draw(self, pointer)
            % use DrawDots in all situations
            Screen('DrawDots', pointer, self.xy, self.size, self.color,...
                   self.center, self.dot_type, self.lenient);
        end
    end % end methods
end % end classdef
