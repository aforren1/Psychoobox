classdef (Abstract) TextureManager < handle
    properties
        obj_array
        p
    end

    methods
        function self = TextureManager()
            self.obj_array = struct;
            self.p = inputParser;
            self.p.addParamValue('optimize_for_draw_angle', 0, @(x) isnumeric(x));
            self.p.addParamValue('special_flags', 0, @(x) any(x == [0 1 2 4 8 32]));
            self.p.addParamValue('float_precision', 0, @(x) isnumeric(x));
            self.p.addParamValue('texture_orientation', 0, @(x) any(x == 0:3));
            self.p.addParamValue('texture_shader', 0);
            self.p.addParamValue('source_rect', [], @(x) isempty(x) || isnumeric(x));
            self.p.addParamValue('draw_rect', [], @(x) isempty(x) || isnumeric(x));
            self.p.addParamValue('rotation_angle', 0, @(x) isnumeric(x));
            self.p.addParamValue('filter_mode', 0, @(x) any(x == -3:5));
            self.p.addParamValue('global_alpha', 1, @(x) x >= 0 && x <= 1);
            self.p.addParamValue('modulate_color', []);
            self.p.addParamValue('aux_parameters', []);

            self.p.addParamValue('rel_x_pos', [], @(x) isempty(x) || (all(x >= 0) || all(x <= 1)));
            self.p.addParamValue('rel_y_pos', [], @(x) isempty(x) || (all(x >= 0) || all(x <= 1)));
            self.p.addParamValue('rel_x_scale', [], @(x) isempty(x) || all(x >= 0));
            self.p.addParamValue('rel_y_scale', [], @(x) isempty(x) || all(x >= 0));

            self.obj_array = struct('pointer', [],  ...
                                    'float_precision', 0, ...
                                    'texture_orientation', 0, ...
                                    'source_rect', [], ...
                                    'draw_rect', [], ...
                                    'rotation_angle', 0, ...
                                    'filter_mode', 0, ...% -3 to 5
                                    'global_alpha', 1, ...
                                    'modulate_color', [], ...
                                    'texture_shader', [], ...
                                    'special_flags', [], ...
                                    'aux_parameters', [], ...
                                    'rel_x_pos', [], ...
                                    'rel_y_pos', [], ...
                                    'rel_x_scale', [], ...
                                    'rel_y_scale', [], ...
                                    'temp_rect', []);
        end

        function Add(self, indices, varargin)
            self.p.parse(varargin{:});
            opts = self.p.Results;
            for fns = fieldnames(opts)'
                self.obj_array(indices).(fns{1}) = opts.(fns{1});
            end
        end

        function Remove(self, indices)
        % is it better to do space filling (set all properties to []) or
        % this (which shifts the indices)
            self.obj_array(indices) = [];
        end

        function Prime(self, win_pointer, indices)
        % Associate specific indices with a screen
        % Must be an on-screen window when calling this!

            % figure out the draw_rect
                self.obj_array(indices).original_matrix = image_matrix;
                opts = self.obj_array(indices); % for shorthand

                if isempty(opts.draw_rect)
                    opts.temp_rect = RelativeToRect(opts.rel_x_pos, opts.rel_y_pos, ...
                                                    opts.rel_x_scale, opts.rel_y_scale, ...
                                                    Screen('Rect', win_pointer));
                else
                    opts.temp_rect = opts.draw_rect;
                end
            % Draw prototypes here (depending on shape)
        end

        function Draw(self, pointer, indices)
        % imgs.Draw(win_pointer, indices)
        %
        % Draw selected textures
            Screen('DrawTextures', pointer,...
                   [self.obj_array(indices).pointer], ...
                   reshape([self.obj_array(indices).source_rect], 4, []), ...
                   reshape([self.obj_array(indices).temp_rect], 4, []), ...
                   [self.obj_array(indices).rotation_angle], ...
                   [self.obj_array(indices).filter_mode], ...
                   [self.obj_array(indices).global_alpha],...
                   [self.obj_array(indices).modulate_color], ...
                   [self.obj_array(indices(1)).texture_shader], ...
                   [self.obj_array(indices(1)).special_flags], ...
                   [self.obj_array(indices(1)).aux_parameters]);

        end

        function Set(self, indices, varargin)
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
                self.obj_array(indices).(fns{1}) = opts.(fns{1});
            end
        end % end set

        function value = Get(self, indices, property)
            value = self(indices).(property);
        end
    end % end methods
end % end classdef
