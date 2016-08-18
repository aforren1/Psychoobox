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
            self.p.addParamValue('frame_stroke', 10, @(x) all(x >= 0));

            self.draw_struct.fill_color = [];
            self.draw_struct.frame_color = [];
            self.draw_struct.image_pointer = [];
            self.draw_struct.fill_alpha = [];
            self.draw_struct.frame_alpha = [];
            self.proto_pointer = [];
        end

        function Add(self, indices, varargin)
            cell_matching = {'fill_color', 'frame_color'};
            Add@PluralPsychMethods(self, indices, cell_matching, varargin);
        end

        function Register(self, win_pointer)
            self.window_pointer = win_pointer;

            % re-do textures (in case the pointers are from a previous session)
            if ~isempty(self.proto_pointer)
                Screen('Close', self.proto_pointer);
            end

            self.proto_pointer(1) = Screen('OpenOffscreenWindow', win_pointer, ...
                                           [0 0 0 0], [0 0 512 512]);
            self.proto_pointer(2) = Screen('OpenOffscreenWindow', win_pointer, ...
                                           [0 0 0 0], [0 0 512 512]);

        end


        function Prime(self)
            Prime@Texture(self);
            % reshape things to allow correct drawing order
            self.draw_struct.draw_rect = zeros();
            self.draw_struct.rotation_angle = zeros();
            self.draw_struct.filter_mode = zeros();
            self.draw_struct.fill_color = zeros(); % add on alphas!!
            self.draw_struct.frame_color = zeros();
            self.draw_struct.image_pointer = zeros();
        end
    end
end
