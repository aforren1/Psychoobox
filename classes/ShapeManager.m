classdef (Abstract) ShapeManager < TextureManager

    methods
        function self = ShapeManager()

        end

        function Prime(self, win_pointer, indices)
            Prime@TextureManager(self, win_pointer, indices);
            self.obj_array(indices).pointer = Screen('OpenOffscreenWindow', win_pointer, [0 0 0 0], ...
                                                     [0 0 800 800]);
        end
    end
end
