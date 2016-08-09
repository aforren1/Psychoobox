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
        end

        function Add(self, mat, indices, varargin)
            self.p.parse(varargin{:});
            opts = self.p.Results;

            self.obj_array(indices).original = mat;

        end

        function Prime(self, pointer, indices)
        % Convert matrix to openGL texture
        % only necessary for image
        self.obj_array(indices).pointer = Screen('MakeTexture', pointer, ...
                                                 self.obj_array(), ...
                                                 self.obj_array(indices).optimize_for_draw_angle, ...
                                                 self.obj_array(indices).special_flags, self.obj_array(indices).float_precision, ...
                                                 self.obj_array(indices).texture_orientation, self.obj_array(indices).texture_shader);


        end


        function Draw(self, pointer, indices)
        % imgs.Draw(win_pointer, indices)
        %
        % Draw selected textures
            Screen('DrawTextures', pointer, [self.obj_array(indices).pointer], ...
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
