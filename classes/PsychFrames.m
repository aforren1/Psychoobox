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
        % If rect is empty, use these
        rel_x_pos; % 1xN matrix, N being the number of rects
        rel_y_pos;
        %rel_pos;
        rel_x_scale; % 1xN matrix, N being the number of rects
        rel_y_scale;
        %rel_scale;

        temp_rect;

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
            self.p.addParamValue('pen_width', 1, @(x) isnumeric(x) && all(x > 0));

            self.p.addParamValue('rel_x_pos', [], @(x) isempty(x) || (all(x >= 0) || all(x <= 1)));
            self.p.addParamValue('rel_y_pos', [], @(x) isempty(x) || (all(x >= 0) || all(x <= 1)));
            self.p.addParamValue('rel_x_scale', [], @(x) isempty(x) || all(x >= 0));
            self.p.addParamValue('rel_y_scale', [], @(x) isempty(x) || all(x >= 0));

        end

        function Draw(self, win_pointer)
        % Draw(window_pointer) Draw to the specified window.
        %

            if isempty(self.rect)
                self.temp_rect = RelativeToRect(self.rel_x_pos, self.rel_y_pos, ...
                                                self.rel_x_scale, self.rel_y_scale, ...
                                                Screen('Rect', win_pointer));

            else
                self.temp_rect = self.rect;
            end

        end
    end
end
