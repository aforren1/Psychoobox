classdef Oval < PsychFrames
% Oval Draw one or more ovals.
%
% Oval Properties:
%        fill_color - Fill shape with this color (3xN or 4xN). Defaults to [].
%        frame_color - Fill frame with this color (3xN or 4xN). Defaults to [].
%        rect - 4xN rectangle in which the shape is inscribed. Defaults to [].
%        pen_width - Width of the frame, if it exists. Defaults to 1.
%        type - Internally used to signal if fill and/or frame drawers are called.
%
% Oval Methods:
%        Draw - Draw the oval(s) to the specified window.
%
    methods
        function self = Oval(varargin)
            self = self@PsychFrames;
            self.p.FunctionName = 'Oval';
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
                self.type = 'FrameOval';
            elseif isempty(opts.frame_color)
                self.type = 'FillOval';
            else
                self.type = 'FillFrame';
            end
        end

        function Draw(self, pointer)
            % Draw(window_pointer) Draw to the specified window.

            if strcmpi(self.type, 'FillOval') || strcmpi(self.type, 'FillFrame')
                Screen('FillOval', pointer, self.fill_color, self.rect);
            end

            if strcmpi(self.type, 'FrameOval') || strcmpi(self.type, 'FillFrame')
                Screen('FrameOval', pointer, self.frame_color, self.rect, self.pen_width);
            end
        end % end Draw
    end % end methods
end % end classdef
