classdef (Abstract) PsychFrames < PsychHandle
% PsychFrames (Abstract) superclass for many shapes.
%
% PsychFrames Methods:
%    Draw - Draw the object on the specified window.
%
    properties (SetAccess = public, GetAccess = public)
        fill_color; % if empty, frame only
        frame_color; % if empty, fill only
        rect;

        % alternatively to rect...
        x_pos;
        y_pos;
        x_scale;
        y_scale;
        
        pen_width;
        type;
        p;
    end

    methods
        function self = PsychFrames
            self.p = inputParser;
            self.p.addParamValue('fill_color', [], @(x) isempty(x) || isnumeric(x));
            self.p.addParamValue('frame_color', [], @(x) isempty(x) || isnumeric(x));
            self.p.addParamValue('rect', [], @(x) isempty(x) || isnumeric(x));
            self.p.addParamValue('pen_width', 1, @(x) isnumeric(x) && x > 0);
        end

        function Draw(self, pointer)
        % Draw(window_pointer) Draw to the specified window.
        %
        end
    end
end
