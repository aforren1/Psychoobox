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
                win_rect = Screen('Rect', win_pointer);

                if any([isempty(self.rel_x_pos), isempty(self.rel_y_pos)])
                    error('Must specify either rel_x_pos and rel_y_pos or rect.')
                end

                if all([isempty(self.rel_x_scale), isempty(self.rel_y_scale)])
                    error('Must specify the scale of at least one dimension.')
                end

                if isempty(self.rel_x_scale)
                    % assign dims from y
                    y_size = self.rel_y_scale * (win_rect(4) - win_rect(2));
                    x_size = y_size;
                elseif isempty(self.rel_y_scale)
                    % assign dims from x
                    x_size = self.rel_x_scale * (win_rect(3) - win_rect(1));
                    y_size = x_size;
                else
                    x_size = self.rel_x_scale * (win_rect(3) - win_rect(1));
                    y_size = self.rel_y_scale * (win_rect(4) - win_rect(2));
                end
                tmprct = [zeros(2, size(x_size, 2)); [x_size; y_size]];
                tmpx = self.rel_x_pos * (win_rect(3) - win_rect(1));
                tmpy = self.rel_y_pos * (win_rect(4) - win_rect(2));
                if all(size(tmprct) == 4)
                    [cx, cy] = RectCenter(tmprct);
                    tmprct([1, 3], :) = tmprct([1, 3], :) + tmpx - cx;
                    tmprct([2, 4], :) = tmprct([2, 4], :) + tmpy - cy;
                    self.temp_rect = tmprct;
                else
                    self.temp_rect = CenterRectOnPoint(tmprct, ...
                                                 tmpx, ...
                                                 tmpy);
                end

            else
                self.temp_rect = self.rect;
            end

        end
    end
end
