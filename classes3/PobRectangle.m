classdef PobRectangle < ShapeTexture
    methods
        function self = PobRectangle()
            self = self@ShapeTexture;
        end

        function Register(self, win_pointer)
            Register@ShapeTexture(self, win_pointer);
            Screen('FillRect', self.proto_pointer(1), ...
                   [255 255 255 255], Screen('Rect', self.proto_pointer(1)));
            Screen('FrameRect', self.proto_pointer(2), ...
                  [255 255 255 255], Screen('Rect', self.proto_pointer(2)), ...
                  self.frame_stroke(1));
        end
    end
end
