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

            self.p.addParamValue('rel_x_pos', [], @(x) isempty(x) || (all(x >= 0) || all(x <= 1)));
            self.p.addParamValue('rel_y_pos', [], @(x) isempty(x) || (all(x >= 0) || all(x <= 1)));
            self.p.addParamValue('rel_x_scale', [], @(x) isempty(x) || all(x >= 0));
            self.p.addParamValue('rel_y_scale', [], @(x) isempty(x) || all(x >= 0));

            self.img_array = struct('pointer', [],  ...
                                    'original_matrix', [], ...
                                    'optimize_for_draw_angle', 0, ...
                                    'float_precision', 0, ...
                                    'texture_orientation', 0, ...
                                    'source_rect', [], ...
                                    'draw_rect', [], ...
                                    'rotation_angle', 0, ...
                                    'filter_mode', 0, ...% -3 to 5
                                    'alpha', 1, ...
                                    'modulate_color', [], ...
                                    'texture_shader', [], ...
                                    'special_flags', [], ...
                                    'aux_parameters', [], ...
                                    'rel_x_pos', [], ...
                                    'rel_y_pos', [], ...
                                    'rel_x_scale', [], ...
                                    'rel_y_scale', [], ...
                                    'temp_rect', []); % storage for actual drawing
        end

        function AddImage(self, image_matrix, pointer, image_index, varargin)
            %self.p.parse(image_matrix, pointer, image_index, ...);
            self.p.parse(varargin{:});
            opts = self.p.Results;

            self.img_array(image_index).pointer = pointer;
            self.img_array(image_index).original_matrix = image_matrix;
            % if isempty(opts.source_rect)
            %     opts.source_rect = Screen(pointer, 'rect');
            % end
            if isempty(opts.draw_rect)
                win_rect = Screen('Rect', pointer);

                if any([isempty(opts.rel_x_pos), isempty(opts.rel_y_pos)])
                    error('Must specify either rel_x_pos and rel_y_pos or rect.')
                end

                if all([isempty(opts.rel_x_scale), isempty(opts.rel_y_scale)])
                    error('Must specify the scale of at least one dimension.')
                end

                if isempty(opts.rel_x_scale)
                    % assign dims from y
                    y_size = opts.rel_y_scale * (win_rect(4) - win_rect(2));
                    x_size = y_size;
                elseif isempty(opts.rel_y_scale)
                    % assign dims from x
                    x_size = opts.rel_x_scale * (win_rect(3) - win_rect(1));
                    y_size = x_size;
                else
                    x_size = opts.rel_x_scale * (win_rect(3) - win_rect(1));
                    y_size = opts.rel_y_scale * (win_rect(4) - win_rect(2));
                end
                opts.temp_rect = CenterRectOnPoint([zeros(2, size(x_size, 2)); [x_size; y_size]].', ...
                                             opts.rel_x_pos * (win_rect(3) - win_rect(1)), ...
                                             opts.rel_y_pos * (win_rect(4) - win_rect(2)));

            else
                opts.temp_rect = opts.draw_rect;
            end

            for fns = fieldnames(opts)'
                self.img_array(image_index).(fns{1}) = opts.(fns{1});
            end

            self.img_array(image_index).pointer = Screen('MakeTexture', pointer, ...
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
                   reshape([self.img_array(indices).temp_rect], 4, []), ...
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
            if ~IsOctave
                temp_names = fieldnames(opts)';
                delta_names = temp_names(~ismember(temp_names,...
                                         self.p.UsingDefaults));
            else
                delta_names = fieldnames(opts)';
            end

            for fns = delta_names
                self.img_array(index).(fns{1}) = opts.(fns{1});
            end
        end % end set
    end % end methods
end % end classdef
