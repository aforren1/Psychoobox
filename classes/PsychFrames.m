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
        % *_pos give the point to center on, *_scale gives the amount to scale by
        % if one pos exist, both pos and at least one scale exist
        % if one scale is missing, scale by the existing scale
        x_pos; % 1xN matrix, N being the number of rects
        y_pos;
        x_scale; % 1xN matrix, N being the number of rects
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

            self.p.addParamValue('x_pos', [], @(x) isempty(x) || (x >= 0 || x <= 1));
            self.p.addParamValue('y_pos', [], @(x) isempty(x) || (x >= 0 || x <= 1));
            self.p.addParamValue('x_scale', [], @(x) isempty(x) || x >= 0);
            self.p.addParamValue('y_scale', [], @(x) isempty(x) || x >= 0);

        end

        function Draw(self, pointer)
        % Draw(window_pointer) Draw to the specified window.
        %
        end
    end
end
