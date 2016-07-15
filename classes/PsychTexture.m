classdef PsychTexture < PsychHandle
% PsychTexture Draw an image.
%
% PsychTexture Properties:
%
%     make_array - Contains all of the settings for a given texture.
%         image_matrix - Original 2-3d matrix representing the image.
%         screen_index - Number of screen to be drawn to?
%         image_index - Which
%     make_proto - p
    properties (SetAccess = public, GetAccess = public)
        make_array;
        make_proto;
        draw_array;
        draw_proto;
        p;
    end

    methods
        function self = PsychTexture
            self.p = inputParser;
            self.p.FunctionName = 'AddImage';
            self.p.addRequired('image_matrix');
            self.p.addRequired('screen_index', @(x) isnumeric(x));
            self.p.addRequired('image_index', @(x) isnumeric(x));
            self.p.addParamValue('draw_angle', 0, @(x) isnumeric(x));
            self.p.addParamValue('special_flags', 0, @(x) any(x == [0 1 2 4 8 32]));
            self.p.addParamValue('float_precision', 0, @(x) isnumeric(x));
            self.p.addParamValue('texture_orientation', 0, @(x) any(x == 0:3));
            self.p.addParamValue('texture_shader', 0);

            self.draw_proto = struct('source_rect', [], ...
                                   'rect', [], ...
                                   'rotation_angle', 0, ...
                                   'filter_mode', 0, ...% -3 to 5
                                   'alpha', 1, ...
                                   'modulate_color', [], ...
                                   'texture_shader', [], ...
                                   'special_flags', [], ...
                                   'aux_parameters', []);

            self.make_proto = struct('pointer', [], 'window_index', [], ...
                                          'original_matrix', [], ...
                                          'optimize_for_draw_angle', 0, ...
                                          'special_flags', 0, ...
                                          'float_precision', 0, ...
                                          'texture_orientation', 0, ...
                                          'texture_shader', 0);
            self.draw_array = self.draw_proto;
            self.make_array = self.make_proto;
        end

        function AddImage(self, image_matrix, window_index, image_index, varargin)
            self.p.parse(image_matrix, window_index, image_matrix, varargin{:});
            opts = self.p.Results;

            self.draw_array(image_index) = self.draw_proto;
            self.make_array(image_index) = self.make_proto;

            self.make_array(image_index).window_index = window_index;
            self.make_array(image_index).original_matrix = image_matrix;
            for fns = fieldnames(opts)'
                self.make_array(image_index).(fns{1}) = opts.(fns{1});
            end

            self.make_array(image_index).pointer = Screen('MakeTexture', window_index, ...
                                                            image_matrix, self.make_array(image_index).optimize_for_draw_angle, ...
                                                            self.make_array(image_index).special_flags, self.make_array(image_index).float_precision, ...
                                                            self.make_array(image_index).texture_orientation, self.make_array(image_index).texture_shader);
        end

        function Draw(self, pointer, indices)
        % imgs.Draw(win_pointer, indices)
        %
        % Draw selected textures
            Screen('DrawTextures', pointer, [self.make_array(indices).pointer], ...
                   [self.draw_array(indices).source_rect], [self.draw_array(indices).rect], ...
                   [self.draw_array(indices).rotation_angle], [self.draw_array(indices).filter_mode], ...
                   [self.draw_array(indices).alpha], [self.draw_array(indices).modulate_color], ...
                   [self.draw_array(indices).texture_shader], [self.draw_array(indices).special_flags], ...
                   [self.draw_array(indices).aux_parameters]);

        end

        function MakeSettings(self, indices, varargin)
        % Updates (groups of) settings for MakeTexture (overwriting previous entry)

        end

        function DrawSettings(self, indices, varargin)
        % Updates (groups of) settings for DrawTextures (overwriting previous entry)

        end
    end
end
