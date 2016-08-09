classdef ImageManager < TextureManager
    properties
        original % original image matrix
    end

    methods
        function self = ImageManager()
            self = self@TextureManager;
            self.obj_array.original = []; % original image/matrix
        end

        function Add(self, mat, indices, varargin)
            Add@TextureManager(self, indices, varargin);
            self.obj_array(indices).original = mat;
        end

        function Prime(self, win_pointer, indices)
        % Convert matrix to openGL texture via MakeTexture and figure out
        % screen positioning.
        % MakeTexture only necessary for images -- shapes are drawn to offscreen window
            Prime@TextureManager(self, win_pointer, indices);
            self.obj_array(indices).win_pointer = Screen('MakeTexture', win_pointer, ...
                                                     self.obj_array(indices).original, ...
                                                     self.obj_array(indices).rotation_angle, ...
                                                     self.obj_array(indices).special_flags, ...
                                                     self.obj_array(indices).float_precision, ...
                                                     self.obj_array(indices).texture_orientation, ...
                                                     self.obj_array(indices).texture_shader);
        end % end prime
    end % end methods
end % end imagemanager
