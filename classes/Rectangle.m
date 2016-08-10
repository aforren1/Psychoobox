classdef Rectangle < ShapeManager

    methods

        function self = Rectangle(varargin)
            self.p.FunctionName = 'Rectangle';
        end
        function Prime(self, win_pointer, indices)
            Prime@ShapeManager(self, win_pointer, indices);
            Screen('FillRect', self.proto_pointers(1), [255 255 255], ...
                   Screen('Rect', self.proto_pointers(1)));
            Screen('FrameRect', self.proto_pointers(2), [255 255 255], ...
                   Screen('Rect', self.proto_pointers(2)),...
                   self.obj_array(indices, 1).pen_width);

            % Screen('DrawTextures', win_pointer, ...
            % {alternating fill/frame proto pointers depending on missing colors},...
            % source_rect (subset), ...
            % destination_rect (size adj), rotation_angle, filter_mode, ...
            % global_alpha, modulate_color, texture_shader, special_flags, ...
            % aux_parameters)

        end
    end
end
