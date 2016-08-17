classdef Image < Texture

    properties
        original_matrix
        image_pointer
        modulate_color
    end

    methods
        function self = Image()
            self.p.addParamValue('original_matrix', nan, @(x) isnumeric(x) || iscell(x));
            self.p.addParamValue('modulate_color', [255 255 255 255], @(x) isnumeric(x) || isempty(x));
            self.draw_struct.image_pointer = [];
            self.draw_struct.modulate_color = [];
        end

        function Add(self, indices, varargin)
            cell_matching = {'draw_rect', 'modulate_color'};
            match2 = 'original_matrix';
            self.p.parse(varargin{:});
            opts = self.p.Results;
            for fns = fieldnames(opts)'
                if any(strcmp(fns, cell_matching))
                    self.(fns{1})(:, indices) = opts.(fns{1});
                elseif strcmp(fns, match2)
                    self.(fns{1}){indices} = opts.(fns{1});
                else
                    self.(fns{1})(indices) = opts.(fns{1});
                end
            end
            self.modified = unique([self.modified, indices]);
        end
        function Set(self, indices, varargin)
            % set cell_matching here!
            cell_matching = {'source_rect', 'draw_rect', 'modulate_color'};
            match2 = 'original_matrix';
            if isempty(indices)
                indices = self.modified;
                message('Indices unspecified, setting identical values for all...')
            end
            if ~any(indices == self.modified)
                error('Tried to modify a non-existant entry!');
            end
            self.p.parse(varargin{:});
            opts = self.p.Results;
            temp_names = fieldnames(opts)';
            delta_names = temp_names(~ismember(temp_names,...
                                     self.p.UsingDefaults));
            for fns = delta_names
                if any(strcmp(fns, cell_matching))
                    self.(fns{1})(:, indices) = opts.(fns{1});
                elseif strcmp(fns, match2)
                    self.(fns{1}){indices} = opts.(fns{1});
                else
                    self.(fns{1})(indices) = opts.(fns{1});
                end
            end
        end % end Set

        function Prime(self)
            Prime@Texture(self);
            self.draw_struct.modulate_color = self.modulate_color(:, self.modified);
            for ii = 1:length(self.modified)
                self.draw_struct.image_pointer(ii) = Screen('MakeTexture', ...
                                                            self.window_pointer, ...
                                                            self.original_matrix{self.modified(ii)}, ...
                                                            self.rotation_angle(self.modified(ii)), ...
                                                            [], [], [], []);
            end
        end % end Prime

        function Draw(self, indices)
            Screen('DrawTextures', self.window_pointer, ...
                   self.draw_struct.image_pointer(indices), ...
                   [],...%self.draw_struct.source_rect(:, indices), 
                   self.draw_struct.draw_rect(:, indices), ...
                   self.draw_struct.rotation_angle(indices), ...
                   [], [], ...
                   self.draw_struct.modulate_color(:, indices), ...
                   [], [], []);
        end
    end
end
