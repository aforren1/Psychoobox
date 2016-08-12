classdef Image < TextureManager
    properties
        original_matrix % original image/matrix
        pointers % pointers per texture
        alpha
        modulate_color
        special_flags
        texture_shader
        texture_orientation
        float_precision %
    end

    methods
        function self = Image()
        % includes alpha for entire texture
            self = self@TextureManager;
            self.p.FunctionName = 'Image';
            self.p.addParamValue('alpha', 1, @(x) x >= 0 && x <= 1);
            self.p.addParamValue('modulate_color', []);
            self.p.addParamValue('special_flags', 0, @(x) any(x == [0 1 2 4 8 32]));
            self.p.addParamValue('texture_orientation', 0, @(x) any(x == 0:3));
            self.p.addParamValue('texture_shader', 0);
            self.p.addParamValue('float_precision', 1, @(x) isnumeric(x));

            % self.p.addRequired('mat', []);
            self.original_matrix = [];
        end

        function Add(self, indices, mat, varargin)
        % Usage:
        %
        % img.Add(1, mat, 'rel_x_pos', .5, 'rel_y_pos', .5, 'rel_x_scale', 0.2, ...
        %         'rel_y_scale', nan, 'global_alpha', 0.8);
            Add@TextureManager(self, indices, varargin);
            self.original_matrix{indices} = mat;
        end

        function Prime(self, win_pointer, indices)
        % Prepares images at specific indices for drawing on window `win_pointer`.
        % Usage:
        %
        % img.Prime(win_pointer, 1);
            Prime@TextureManager(self, win_pointer, indices);
            self.pointer(indices) = Screen('MakeTexture', win_pointer, ...
                                            self.original_matrix{indices}, ...
                                            self.rotation_angle(indices), ...
                                            self.special_flags(indices), ...
                                            self.float_precision(indices), ...
                                            self.texture_orientation(indices), ...
                                            self.texture_shader(indices));
        end

        function Draw(self, win_pointer, indices)
        % Draw objects from specified indices to the window.
            Screen('DrawTextures', win_pointer, ...
                   [self.pointers(indices)], ...
                   [self.source_rect(:, indices)], ...
                   [self.temp_rect(:, indices)], ...
                   [self.rotation_angle(indices)], ...
                   [self.filter_mode(indices)], ...
                   [self.alpha(indices)], ...
                   [self.modulate_color(:, indices)], ...
                   [self.texture_shader(indices)], ...
                   [self.special_flags(indices)], ...
                   [self.aux_parameters(indices)]);
        end

    end
end
