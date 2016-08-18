classdef Rectangle < ShapeTexture
    methods
        function self = Rectangle()
            self = self@ShapeTexture;
        end

        function Register(self, win_pointer)
            Register@ShapeTexture(self, win_pointer);
            Screen('FillRect', self.proto_pointers(1), ...
                   [255 255 255 255], Screen('Rect', self.proto_pointer(1)));
            Screen('FrameRect', self.proto_pointers(2), ...
                  [255 255 255 255], Screen('Rect', self.proto_pointer(2)), ...
                  self.frame_stroke(1));
        end

        function Draw(self, indices)

        end
    end
end
