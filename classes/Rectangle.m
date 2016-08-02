classdef Rectangle < PsychFrames
% Rectangle Draw one or more rectangles.
%
% Rectangle Properties:
%        fill_color - Fill shape with this color (3xN or 4xN). Defaults to [].
%        frame_color - Fill frame with this color (3xN or 4xN). Defaults to [].
%        rect - 4xN rectangle in which the shape is inscribed. Defaults to [].
%        pen_width - Width of the frame, if it exists. Defaults to 1.
%        type - Internally used to signal if fill and/or frame drawers are called.
%
% Rectangle Methods:
%        Draw - Draw the rectangle to the specified window.
%
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
            % Draw(window_pointer) Draw to the specified window.
            Draw@PsychFrames(self, pointer);
            if strcmpi(self.type, 'FillRect') || strcmpi(self.type, 'FillFrame')
                Screen('FillRect', pointer, self.fill_color, self.temp_rect);
            end

            if strcmpi(self.type, 'FrameRect') || strcmpi(self.type, 'FillFrame')
                Screen('FrameRect', pointer, self.frame_color, self.temp_rect, self.pen_width);
            end
        end % end Draw
    end % end methods
end % end classdef
