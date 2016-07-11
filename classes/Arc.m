classdef Arc < PsychFrames

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
