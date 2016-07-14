classdef Poly < PsychFrames
% Poly Draw one polygon.
%
% Poly Properties:
%        fill_color - Fill shape with this color (3x1 or 4x1). Defaults to [].
%        frame_color - Fill frame with this color (3x1 or 4x1). Defaults to [].
%        pen_width - Width of the frame, if it exists. Defaults to 1.
%        type - Internally used to signal if fill and/or frame drawers are called.
%        is_convex - If the shape is known to be convex, set to 1 for better performance. Defaults to 0.
%        point_list - Nx2 matrix of (x, y) pairings.
%
% Poly Methods:
%        Draw - Draw the polygon to the specified window.
%
    properties (SetAccess = public, GetAccess = public)
        is_convex;
        point_list;
    end

    methods
        function self = Poly(varargin)
            self = self@PsychFrames;
            self.p.FunctionName = 'Poly';
            self.p.addParamValue('is_convex', 0, @(x) any(x == 0:1));
            self.p.addParamValue('point_list', [], @(x) isempty(x) || isnumeric(x))
            self.p.parse(varargin{:});
            opts = self.p.Results;

            % shuffle options into the obj
            for fns = fieldnames(opts)'
                self.(fns{1}) = opts.(fns{1});
            end

            % check whether frame, fill, or both
            if isempty(opts.fill_color) && isempty(opts.frame_color)
                error('Need to specify at least one color!');
            end
            if isempty(opts.fill_color)
                self.type = 'FillPoly';
            elseif isempty(opts.frame_color)
                self.type = 'FramePoly';
            else
                self.type = 'FillFrame';
            end

        end % end constructor

        function Draw(self, pointer)
            % Draw(window_pointer) Draw to the specified window.

            if strcmpi(self.type, 'FillPoly') || strcmpi(self.type, 'FillFrame')
                Screen('FillPoly', pointer, self.fill_color, ...
                       self.point_list, self.is_convex);
            end

            if strcmpi(self.type, 'FramePoly') || strcmpi(self.type, 'FillFrame')
                Screen('FramePoly', pointer, self.frame_color, ...
                       self.point_list, self.pen_width);
            end
        end % end Draw
    end % end methods
end % end classdef
