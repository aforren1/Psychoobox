classdef Oval < PsychFrames

    methods
        function self = Oval(varargin)
            self.p.FunctionName = 'Oval';
            self.p.parse(varargin{:});
            opts = self.p.Results;
            % check whether frame, fill, or both
            if isempty(opts.fill_color) && isempty(opts.frame_color)
                error('Need to specify at least one color!');
            end
            if isempty(opts.fill_color)
                p.type = 'FrameOval';
            elseif isempty(opts.frame_color)
                p.type = 'FillOval';
            else
                p.type = 'FillFrame';
            end
            % shuffle options into the obj
            for fns = fieldnames(opts)'
                self.(fns{1}) = opts.(fns{1});
            end

        end
        function Draw(self, pointer)
            if strcmpi(self.type, 'FillOval') || strcmpi(self.type, 'FillFrame')
                Screen('FillOval', pointer, self.fill_color, self.rect);
            end

            if strcmpi(self.type, 'FrameOval') || strcmpi(self.type, 'FillFrame')
                Screen('FrameOval', pointer, self.frame_color, self.rect, self.pen_width);
            end
        end % end Draw
    end % end methods
end % end classdef
