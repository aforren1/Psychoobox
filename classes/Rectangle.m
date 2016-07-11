classdef Rectangle < PsychFrames
    methods
        function self = Rectangle(varargin)
            self = self@PsychFrames;
            self.p.FunctionName = 'Rectangle';
            self.p.parse(varargin{:});
            opts = self.p.Results;
            for fns = fieldnames(opts)'
                self.(fns{1}) = opts.(fns{1});
            end

            if isempty(opts.fill_color) && isempty(opts.frame_color)
                error('Need to specify at least one color!');
            end

            if isempty(opts.fill_color)
                self.type = 'FillRect';
            elseif isempty(opts.frame_color)
                self.type = 'FrameRect'; % framearc ?= drawarc + thickness?
            else
                self.type = 'FillFrame';
            end
        end % end constructor

        function Draw(self, pointer)
            if strcmpi(self.type, 'FillRect') || strcmpi(self.type, 'FillFrame')
                Screen('FillRect', pointer, self.fill_color, self.rect);
            end

            if strcmpi(self.type, 'FrameRect') || strcmpi(self.type, 'FillFrame')
                Screen('FrameRect', pointer, self.frame_color, self.rect, self.pen_width);
            end
        end % end Draw
    end % end methods
end % end classdef
