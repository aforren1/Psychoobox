classdef PsychTexture < PsychHandle
% PsychTexture Draw an image.
%
% PsychTexture Properties:
%
%     img_array - Contains all of the settings for a given texture.
%         image_matrix - Original 2-3d matrix representing the image.
%         screen_index - Number of screen to be drawn to?
%         image_index - Which
%     make_proto - p
    properties (SetAccess = public, GetAccess = public)
        img_array;
        p;
    end

    methods
        function self = PsychTexture
            self.p = inputParser;
            self.p.FunctionName = 'AddImage';
            %self.p.addRequired('image_matrix');
            %self.p.addRequired('screen_index', @(x) isnumeric(x));
            %self.p.addRequired('image_index', @(x) isnumeric(x));
            self.p.addParamValue('optimize_for_draw_angle', 0, @(x) isnumeric(x));
            self.p.addParamValue('special_flags', 0, @(x) any(x == [0 1 2 4 8 32]));
            self.p.addParamValue('float_precision', 0, @(x) isnumeric(x));
            self.p.addParamValue('texture_orientation', 0, @(x) any(x == 0:3));
            self.p.addParamValue('texture_shader', 0);
            self.p.addParamValue('source_rect', [], @(x) isempty(x) || isnumeric(x));
            self.p.addParamValue('draw_rect', [], @(x) isempty(x) || isnumeric(x));
            self.p.addParamValue('rotation_angle', 0, @(x) isnumeric(x));
            self.p.addParamValue('filter_mode', 0, @(x) any(x == -3:5));
            self.p.addParamValue('alpha', 1, @(x) x >= 0 && x <= 1);
            self.p.addParamValue('modulate_color', []);
            self.p.addParamValue('aux_parameters', []);

            self.img_array = struct('pointer', [], 'window_index', [], ...
                                    'original_matrix', [], ...
                                    'optimize_for_draw_angle', 0, ...
                                    'special_flags', 0, ...
                                    'float_precision', 0, ...
                                    'texture_orientation', 0, ...
                                    'texture_shader', 0, ...
                                    'source_rect', [], ...
                                    'draw_rect', [], ...
                                    'rotation_angle', 0, ...
                                    'filter_mode', 0, ...% -3 to 5
                                    'alpha', 1, ...
                                    'modulate_color', [], ...
                                    'texture_shader', [], ...
                                    'special_flags', [], ...
                                    'aux_parameters', []);
        end

        function AddImage(self, image_matrix, window_index, image_index, varargin)
            %self.p.parse(image_matrix, window_index, image_index, varargin{:});
            self.p.parse(varargin{:});
            opts = self.p.Results;

            self.img_array(image_index).window_index = window_index;
            self.img_array(image_index).original_matrix = image_matrix;
            if isempty(opts.source_rect)
                opts.source_rect = Screen(window_index, 'rect');
            end

            if isempty(opts.draw_rect)
                opts.draw_rect = Screen(window_index, 'rect');
            end

            for fns = fieldnames(opts)'
                self.img_array(image_index).(fns{1}) = opts.(fns{1});
            end

            self.img_array(image_index).pointer = Screen('MakeTexture', window_index, ...
                                                            image_matrix, self.img_array(image_index).optimize_for_draw_angle, ...
                                                            self.img_array(image_index).special_flags, self.img_array(image_index).float_precision, ...
                                                            self.img_array(image_index).texture_orientation, self.img_array(image_index).texture_shader);
        end

        function Draw(self, pointer, indices)
        % imgs.Draw(win_pointer, indices)
        %
        % Draw selected textures
            Screen('DrawTextures', pointer, [self.img_array(indices).pointer], ...
                   reshape([self.img_array(indices).source_rect], 4, []), ...
                   reshape([self.img_array(indices).draw_rect], 4, []), ...
                   [self.img_array(indices).rotation_angle], ...
                   [self.img_array(indices).filter_mode], ...
                   [self.img_array(indices).alpha],...
                   [self.img_array(indices).modulate_color], ...
                   [self.img_array(indices(1)).texture_shader], ...
                   [self.img_array(indices(1)).special_flags], ...
                   [self.img_array(indices(1)).aux_parameters]);

        end

        function Set(self, index, varargin)
            self.p.parse(varargin{:});
            opts = self.p.Results;

            for fns = fieldnames(opts)'
                self.img_array(index).(fns{1}) = opts.(fns{1});
            end
        end % end set
    end % end methods
end % end classdef
