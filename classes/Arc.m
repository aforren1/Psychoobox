classdef Arc < PsychFrames
% Arc Draw one arc with or without antialiasing.
%
% Arc Properties:
%        fill_color - Fill shape with this color (3x1 or 4x1). Defaults to [].
%        frame_color - Fill frame with this color (3x1 or 4x1). Defaults to [].
%        rect - 4x1 rectangle in which the shape is inscribed. Defaults to [].
%        pen_width - Width of the frame, if it exists. Defaults to 1.
%        type - Internally used to signal if fill and/or frame drawers are called.
%        start_angle - Initial angle of the arc.
%        arc_angle - Angle of arc.
%
% Arc Methods:
%        Draw - Draw the arc to the specified window.
%
    properties (SetAccess = public, GetAccess = public)
        start_angle;
        arc_angle;
    end

    methods
        function self = Arc(varargin)
            self = self@PsychFrames;
            self.p.FunctionName = 'Arc';
            self.p.addParamValue('start_angle', 0, @(x) isnumeric(x));
            self.p.addParamValue('arc_angle', 0, @(x) isnumeric(x));
            self.p.parse(varargin{:});
            opts = self.p.Results;
            self.p = []; % Remove parser after use (print method in Octave dumps loads of errors)

            % shuffle options into the obj
            for fns = fieldnames(opts)'
                self.(fns{1}) = opts.(fns{1});
            end

            % check whether frame, fill, or both
            if isempty(opts.fill_color) && isempty(opts.frame_color)
                error('Need to specify at least one color!');
            end
            if isempty(opts.fill_color)
                self.type = 'FillArc';
            elseif isempty(opts.frame_color)
                self.type = 'FrameArc'; % framearc ?= drawarc + thickness?
            else
                self.type = 'FillFrame';
            end

        end % end constructor

        function Draw(self, pointer)
            % Draw(window_pointer) Draw to the specified window.

            if strcmpi(self.type, 'FillArc') || strcmpi(self.type, 'FillFrame')
                Screen('FillArc', pointer, self.fill_color, self.rect, ...
                       self.start_angle, self.arc_angle);
            end

            if strcmpi(self.type, 'FrameArc') || strcmpi(self.type, 'FillFrame')
                Screen('FrameArc', pointer, self.frame_color, self.rect, ...
                       self.start_angle, self.arc_angle, self.pen_width);
            end
        end % end Draw
    end % end methods
end % end classdef
