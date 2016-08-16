classdef Line < NonRectShapes
% still broken:
% skipping indices (and single lines)
% centering when dimensions are relative to one axis
% shading along line (one color allowed currently)
% inefficient calculation of x/y min/max (can do fancy linalg?)

    properties
        midpoint
        degrees
        length
        smooth_mode
        draw_cols
    end


    methods
        function self = Line()
            self@NonRectShapes;
            self.p.addParamValue('midpoint', 0,  @(x) all(x >= 0) && all(x <= 1));
            self.p.addParamValue('degrees', 0, @(x) all(isnumeric(x)) && all(~isnan(x))); % degrees
            self.p.addParamValue('length', 0, @(x) all(x >= 0) && all(x <= 1));
            self.p.addParamValue('smooth_mode', 1, @(x) any(x == [0 1 2]));
        end

        function Prime(self, indices)
            indices = Prime@NonRectShapes(self, indices);
            % x positions
            % more compact way:
            % self.drawing_pts = self.midpoint(indices) + [-1; 1] * ((self.length(indices)/2) * [cos(self.degrees * (pi/180)), sin(self.degrees * (pi/180))])
            scrn = Screen('Rect', self.window_pointer);
            if all(self.relative_to == 0)
                tmprelx = scrn(3) - scrn(1);
                tmprely = scrn(3) - scrn(1);
            elseif all(self.relative_to == 1)
                tmprelx = scrn(4) - scrn(2);
                tmprely = scrn(4) - scrn(2);
            else
                tmprelx = scrn(3) - scrn(1);
                tmprely = scrn(4) - scrn(2);
            end

            x_min(indices) = tmprelx * (self.midpoint(indices) - ...
                                  ((self.length(indices)/2) .* cos(self.degrees .* (pi/180))));
            x_max(indices) = tmprelx * (self.midpoint(indices) + ...
                                ((self.length(indices)/2) .* cos(self.degrees .* (pi/180))));
            y_min(indices) = tmprely * (self.midpoint(indices) - ...
                                  ((self.length(indices)/2) .* sin(self.degrees .* (pi/180))));
            y_max(indices) = tmprely * (self.midpoint(indices) + ...
                                ((self.length(indices)/2) .* sin(self.degrees .* (pi/180))));

            self.drawing_pts = reshape([[x_min(indices); y_min(indices)];...
                                       [x_max(indices); y_max(indices)]],[], 2*size(y_min, 2));
            self.draw_cols = reshape([[self.color(:,indices); self.alpha(indices)];...
                                      [self.color(:, indices); self.alpha(indices)]],...
                                      [], 2 * size(self.color(indices), 2));

        end

        function Draw(self, indices)
            Screen('DrawLines', self.window_pointer, self.drawing_pts(:,[indices, indices + numel(indices)]), ...
                   self.diameter(indices), self.draw_cols(:, [indices, indices + numel(indices)]),...
                   [], self.smooth_mode(1), 1);
        end
    end
end
