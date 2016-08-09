classdef (Abstract) ShapeManager < TextureManager

    methods
        function self = ShapeManager()

        end

        function Prime(self, win_pointer, indices)
            Prime@TextureManager(self, win_pointer, indices);
            % check if only fill, only outline, or both
            % How to handle missing??
            self.obj_array(indices).pointer(1) = Screen('OpenOffscreenWindow', win_pointer, [0 0 0 0], ...
                                                        [0 0 800 800]);
            self.obj_array(indices).pointer(2) = Screen('OpenOffscreenWindow', win_pointer, [0 0 0 0], ...
                                                        [0 0 800 800]);
        end
    end
end
