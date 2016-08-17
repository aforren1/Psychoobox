classdef Rectangle < ShapeTexture
    methods
        function self = Rectangle()
            self = self@ShapeTexture;
        end

        function Register(self)
            self.window_pointer = win_pointer;

        end

        function Prime(self)
            Prime@ShapeTexture(self);

        end
    end
end
