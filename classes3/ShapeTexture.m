classdef (Abstract) ShapeTexture < Texture
    properties
        fill_color
        fill_alpha
        frame_color
        frame_alpha
        frame_stroke
    end

    properties (SetAccess = protected, GetAccess = protected)
        proto_pointer
    end

    methods
        function self = ShapeTexture()
            self@Texture;
            self.p.addParamValue('fill_color', [nan nan nan], ...
                                 @(x) all(all(isnan(x(:, isnan(x(1,:)))))) &&...
                                 all(all(~isnan(x(:, ~isnan(x(1,:)))))));
            self.p.addParamValue('frame_color', [nan nan nan],...
                                 @(x) all(all(isnan(x(:, isnan(x(1,:)))))) && ...
                                 all(all(~isnan(x(:, ~isnan(x(1,:)))))));
            self.p.addParamValue('fill_alpha', 255, @(x) all(x >= 0) && all(x <= 255));
            self.p.addParamValue('frame_alpha', 255, @(x) all(x >= 0) && all(x <= 255));
            self.p.addParamValue('frame_stroke', 5, @(x) all(x >= 0));

            self.draw_struct.fill_color = [];
            self.draw_struct.frame_color = [];
            self.draw_struct.image_pointer = [];
            self.draw_struct.fill_alpha = [];
            self.draw_struct.frame_alpha = [];
        end

        function Add(self, indices, varargin)
            cell_matching = {'fill_color', 'frame_color'};
            Add@PluralPsychMethods(self, indices, cell_matching, varargin);
        end

        function Prime(self)
            Prime@Texture(self);
            % add to the rest of the struct for drawing & do sorting
        end
    end
end
