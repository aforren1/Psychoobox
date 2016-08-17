classdef (Abstract) Texture < PluralPsychMethods
    properties
        %source_rect % subset of the texture to draw
        rotation_angle % angle of the texture
        filter_mode % -3 to 5, deals with zooming on texture

        rel_x_pos % relative x position. Must be specified if draw_rect is unspecified.
        rel_y_pos % relative y position. Must be specified if draw_rect is unspecified.
        rel_x_scale % length along x dimension relative to onscreen window.
                    % If nan, use exact length of y (to get squares, etc.)
        rel_y_scale % length along y dimension relative to onscreen window.
                    % if nan, use exact length of x (to get squares, etc.)
        modified

        drawing_rect
        draw_struct
    end

    properties (SetAccess = 'protected', GetAccess = 'protected')
 %       drawing_rect % used by RectRelativeToRect
 %       draw_struct % structure used to manage Primed indices
    end

    methods
        function self = Texture()
            self = self@PluralPsychMethods();
            self.p = inputParser;
            %self.p.addParamValue('source_rect', [], @(x) isempty(x) || isnumeric(x));
            self.p.addParamValue('rotation_angle', 0, @(x) isnumeric(x));
            self.p.addParamValue('filter_mode', 0, @(x) any(x == -3:5));

            self.p.addParamValue('rel_x_pos', nan, @(x) all(isnan(x)) || (all(x >= 0) || all(x <= 1)));
            self.p.addParamValue('rel_y_pos', nan, @(x) all(isnan(x)) || (all(x >= 0) || all(x <= 1)));
            self.p.addParamValue('rel_x_scale', nan, @(x) all(x(~isnan(x)) >= 0));
            self.p.addParamValue('rel_y_scale', nan, @(x) all(x(~isnan(x)) >= 0));
            self.draw_struct = struct('source_rect', [], ...
                                      'draw_rect', [], ... % figured out by Prime
                                      'rotation_angle', [], ...
                                      'filter_mode', []);
        end % end constructor

        function Add(self, indices, varargin)
            cell_matching = {'source_rect', 'draw_rect'};
            Add@PluralPsychMethods(self, indices, cell_matching, varargin);
        end

        function Set(self, indices, varargin)
            cell_matching = {'source_rect', 'draw_rect'};
            Set@PluralPsychMethods(self, indices, cell_matching, varargin);
        end

        function Prime(self)
            Prime@PluralPsychMethods(self);
            self.RectRelativeToRect(Screen('Rect', self.window_pointer));
            self.draw_struct.draw_rect = self.drawing_rect;
            %self.draw_struct.source_rect = self.source_rect(:, self.modified);
            self.draw_struct.rotation_angle = self.rotation_angle(self.modified);
            self.draw_struct.filter_mode = self.filter_mode(self.modified);

            % MakeTexture for image here
        end % end prime
    end
end
