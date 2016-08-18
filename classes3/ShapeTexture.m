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

            self.draw_struct.color = [];
            self.draw_struct.image_pointer = [];
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
            tmp_size = size(self.drawing_rect, 2) * 2;
            self.draw_struct.draw_rect = zeros(4, tmp_size);
            self.draw_struct.rotation_angle = zeros(1, tmp_size);
            self.draw_struct.filter_mode = zeros(1, tmp_size);
            self.draw_struct.color = zeros(4, tmp_size); % add on alphas!!
            self.draw_struct.image_pointer = zeros(1, tmp_size);

            % subset based on modified AND nans in fill/frame_color
            self.draw_struct.draw_rect(1:4, 1:2:end) = self.drawing_rect;
            self.draw_struct.draw_rect(1:4, 2:2:end) = self.drawing_rect;
            self.draw_struct.rotation_angle(1, :) = self.rotation_angle(self.modified);
            self.draw_struct.filter_mode(1, :) = self.filter_mode(self.modified);
            self.draw_struct.color(1:3, 1:2:end) = self.fill_color(self.modified);
            self.draw_struct.color(1:3, 2:2:end) = self.frame_color(self.modified);
            self.draw_struct.color(4, 1:2:end) = self.fill_alpha(self.modified);
            self.draw_struct.color(4, 2:2:end) = self.frame_alpha(self.modified);
            self.draw_struct.image_pointer(1, 1:2:end) = self.proto_pointer(1);
            self.draw_struct.image_pointer(1, 2:2:end) = self.proto_pointer(2);

        end

        function Draw(self, indices)
            tmpstrct = self.draw_struct;
            % figure out which indices are not missing
            indices2 = logical(~(isnan(tmpstrct.fill_color(1, :)) + ...
                          isnan(tmpstrct.frame_color(1, :))));
            % Subset based on requested indices first
            indices = sort([indices, indices + 1]);
            tmpstrct.draw_rect(1:4, indices) = [];
            tmpstrct.rotation_angle(1, indices) = [];
            tmpstrct.filter_mode(1, indices) = [];
            tmpstrct.color(1:4, indices) = [];
            tmpstrct.image_pointer(1, indices) = [];

            tmpstrct.draw_rect(1:4, indices2) = [];
            tmpstrct.rotation_angle(1, indices2) = [];
            tmpstrct.filter_mode(1, indices2) = [];
            tmpstrct.color(1:4, indices2) = [];
            tmpstrct.image_pointer(1, indices2) = [];

            Screen('DrawTextures', tmpstrct.image_pointer, ...
                   tmpstrct.image_pointer, [], ...
                   tmpstrct.draw_rect, ...
                   tmpstrct.rotation_angle, ...
                   tmpstrct.filter_mode, [], ...
                   tmpstrct.color, [], [], []);
        end

        function Close(self)
            Screen('Close', self.proto_pointer);
            delete(self);
        end
    end
end
