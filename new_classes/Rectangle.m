classdef Rectangle < ShapeManager
    methods
        function self = Rectangle()
            self = self@ShapeManager;
            self.p.FunctionName = 'Rectangle';
        end
        function Register(self, win_pointer)
            Prime@ShapeManager(self, win_pointer, indices);
            Screen('FillRect', self.proto_pointers(1), ...
                   [255 255 255], Screen('Rect', self.proto_pointers(1)));
            Screen('FrameRect', self.proto_pointers(2), ...
                   [255 255 255], Screen('Rect', self.proto_pointers(2)), ...
                   30); %TODO: Unfix stroke width
        end
    end
end
