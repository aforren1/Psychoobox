classdef Image < TextureManager
    properties
        original_matrix % original image/matrix
    end

    methods
        function self = Image()
            self = self@TextureManager;
            self.p.FunctionName = 'Image';
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
    end
end
