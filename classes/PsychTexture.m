classdef PsychTexture < PsychHandle
% PsychTexture Draw an image.
%
% PsychTexture Properties:
%
%
    properties (SetAccess = public, GetAccess = public)
        struct_array;
        struct_proto;
        p; % input parser
    end

    methods
        function self = PsychTexture(varargin)
            self.p = inputParser;
            self.p.FunctionName = 'AddImage';
            self.p.addRequired('image_matrix', @(x) ismatrix(x));
            self.p.addRequired('screen_index', @(x) isnumeric(x));
            self.p.addRequired('image_index', @(x) isnumeric(x));
            self.p.addParamValue('draw_angle', 0, @(x) isnumeric(x));
            self.p.addParamValue('special_flags', 0, @(x) any(x == [0 1 2 4 8 32]));
            self.p.addParamValue('float_precision', 0, @(x) isnumeric(x));
            self.p.addParamValue('texture_orientation', 0, @(x) any(x == 0:3));
            self.p.addParamValue('texture_shader', 0);

            draw_settings = struct('source_rect', [], ...
                                   'rect', ...
                                   'rotation_angle', 0, ...
                                   'filter_mode', 0, ...% -3 to 5
                                   'alpha', 1, ...
                                   'modulate_color', [], ...
                                   'texture_shader', [], ...
                                   'special_flags', [], ...
                                   'aux_parameters', []);

            self.struct_proto = struct('pointer', [], 'window_index', [], ...
                                          'original_matrix', [], ...
                                          'optimize_for_draw_angle', 0, ...
                                          'special_flags', 0, ...
                                          'float_precision', 0, ...
                                          'texture_orientation', 0, ...
                                          'texture_shader', 0, ...
                                          'draw_settings', draw_settings);
        end

        function AddImage(self, image_matrix, window_index, image_index, varargin)
            self.p.parse(image_matrix, window_index, image_matrix, varargin{:});
            opts = self.p.Results;

            self.struct_array(image_index) = self.struct_proto;
            self.struct_array(image_index).window_index = opts.window_index;
            self.struct_array(image_index).original_matrix = opts.image_matrix;
            for fns = fieldnames(opts)'
                self.struct_array(image_index).(fns{1}) = opts.(fns{1});
            end

            self.struct_array(image_index).pointer = Screen('MakeTexture', opts.window_index, ...
                                                            opts.image_matrix, opts.optimize_for_draw_angle, ...
                                                            opts.special_flags, opts.float_precision, ...
                                                            opts.texture_orientation, opts.texture_shader);


        end

        function Draw(self, pointer, indices)

            Screen('DrawTextures', pointer, [self.struct_array(indices).pointer], ...
                   [self.struct_array(indices).source_rect], [self.struct_array(indices).rect], ...
                   [self.struct_array(indices).rotation_angle], [self.struct_array(indices).filter_mode], ...
                   [self.struct_array(indices).alpha], [self.struct_array(indices).modulate_color], ...
                   [self.struct_array(indices).texture_shader], [self.struct_array(indices).special_flags], ...
                   [self.struct_array(indices).aux_parameters]);

        end

        function Set(self, indices, varargin)
        % Updates (groups of) settings for MakeTexture (overwriting previous entry)

        end

        function DrawSettings(self, indices, varargin)
        % Updates (groups of) settings for DrawTextures (overwriting previous entry)

        end
    end
end
