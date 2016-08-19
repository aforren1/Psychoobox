classdef PobOval < ShapeTexture
    methods
        function self = PobOval()
            self = self@ShapeTexture;
        end

        function Register(self, win_pointer)
            Register@ShapeTexture(self, win_pointer);
            Screen('FillOval', self.proto_pointer(1), ...
                   [255 255 255 255], Screen('Rect', self.proto_pointer(1)));
            Screen('FrameOval', self.proto_pointer(2), ...
                  [255 255 255 255], Screen('Rect', self.proto_pointer(2)), ...
                  self.frame_stroke(1));
        end
    end
end
