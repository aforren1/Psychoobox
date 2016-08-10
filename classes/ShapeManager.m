classdef (Abstract) ShapeManager < TextureManager
    properties
        proto_pointers
    end
    methods
        function self = ShapeManager()
            self.p.addParamValue('fill_color', [], @(x) isempty(x) || isnumeric(x));
            self.p.addParamValue('frame_color', [], @(x) isempty(x) || isnumeric(x));
            self.p.addParamValue('pen_width', 1, @(x) x >= 0);
        end

        function Prime(self, win_pointer, indices)
            Prime@TextureManager(self, win_pointer, indices);
            % check if only fill, only outline, or both
            % How to handle missing??
            self.proto_pointers(1) = Screen('OpenOffscreenWindow', win_pointer,...
                                            [0 0 0 0], [0 0 800 800]);
            self.proto_pointers(2) = Screen('OpenOffscreenWindow', win_pointer,...
                                            [0 0 0 0], [0 0 800 800]);
        end
    end
end
