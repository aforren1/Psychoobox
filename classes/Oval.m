classdef Oval < PsychFrames

    methods
        function self = Oval(varargin)
            p = inputParser;
            p.FunctionName = 'Oval';
            p.addParamValue('fill_color', [], @(x) isempty(x) || isnumeric(x));
            p.addParamValue('frame_color', [], @(x) isempty(x) || isnumeric(x));
            p.addParamValue('rect', [], @(x) isempty(x) || isnumeric(x));
            p.addParamValue('pen_width', 1, @(x) isnumeric(x) && x > 0);
            p.parse(varargin{:});
            opts = p.Results;
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

        end
        function Draw(self, pointer)
            if strcmpi(self.type, 'FillOval') || strcmpi(self.type, 'FillFrame')
                Screen('FillOval', pointer, self.fill_color, self.rect);
            end

            if strcmpi(self.type, 'FrameOval') || strcmpi(self.type, 'FillFrame')
                Screen('FrameOval', pointer, self.frame_color, self.rect,...
                       self.pen_width, self.pen_height, self.)
            end
        end

    end
Screen('FillOval', windowPtr [,color] [,rect] [,perfectUpToMaxDiameter]);
Screen('FrameOval', windowPtr [,color] [,rect] [,penWidth] [,penHeight] [,penMode]);


end
