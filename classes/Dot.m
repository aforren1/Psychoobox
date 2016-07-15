classdef Dot < PsychHandle
% Dot Draw fast dots (uses DrawDots under the hood)
%
% Draw dots with this dot drawer.
%
% Dot Properties:
%     xy - A 2xN matrix containing (x,y) pairs for each dot.
%     size - A scalar or vector the same length as xy. Defaults to 1.
%     color - A 3xN or 4xN matrix containing color info ([r g b] or [r g b alpha], if alpha blending is on).
%     center - The 1x2 vector specifying the point that xy coordinates are relative to (defaults to [0 0]).
%     dot_type - 0 and 4 are square dots (4 is a faster version), and 1 - 3 are circular dots (works only if alpha blending is on).
%     lenient - Tells Screen to not check dot sizes.
% Dot Methods:
%     Draw - Draw the dots on the specified window.
%     Get - Get values.
%     Set - Set values.
%     Print - See values.
%
% Example:
%
% dot_obj = Dot('xy', [0:5:20; 5:10:45]', ...
%               'dot_type', 3, ...
%               'size', [4 15 3 1]);
% dot_obj.Draw(window_pointer);

    properties (SetAccess = public, GetAccess = public)
        xy;
        size;
        color;
        center;
        dot_type;
        lenient;
        p;
    end

    methods
        function self = Dot(varargin)
            self.p = inputParser;
            self.p.FunctionName = 'Dot';
            self.p.addParamValue('xy', [], @(x) isempty(x) || (isnumeric(x) && any(size(x) == 2)));
            self.p.addParamValue('size', 1, @(x) x > 0);
            self.p.addParamValue('color', [0 0 0], @(x) isnumeric(x));
            self.p.addParamValue('center', [0 0], @(x) isnumeric(x));
            self.p.addParamValue('dot_type', 0, @(x) any(x == 0:4));
            self.p.addParamValue('lenient', 0, @(x) any(x == 0:1));
            self.p.parse(varargin{:});
            opts = self.p.Results;

            % try to catch incorrectly-sized matrices
            if size(opts.xy, 2) == 2
                opts.xy = opts.xy';
            end

            for fns = fieldnames(opts)'
                self.(fns{1}) = opts.(fns{1});
            end
        end

        function Draw(self, pointer)
            Screen('DrawDots', pointer, self.xy, self.size, self.color,...
                   self.center, self.dot_type, self.lenient);
        end
    end % end methods
end % end classdef
