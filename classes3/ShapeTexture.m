classdef (Abstract) ShapeTexture < Texture
    properties
        fill_color
        fill_alpha
        frame_color
        frame_alpha
        frame_stroke
    end

    properties (SetAccess = protected, GetAccess = protected)
        proto_pointer
    end

    methods
        function self = ShapeTexture()
            self@Texture;
            self.p.addParamValue('fill_color', [nan nan nan], ...
                                 @(x) all(all(isnan(x(:, isnan(x(1,:)))))) &&...
                                 all(all(~isnan(x(:, ~isnan(x(1,:)))))));
            self.p.addParamValue('frame_color', [nan nan nan],...
                                 @(x) all(all(isnan(x(:, isnan(x(1,:)))))) && ...
                                 all(all(~isnan(x(:, ~isnan(x(1,:)))))));
            self.p.addParamValue('fill_alpha', 255, @(x) all(x >= 0) && all(x <= 255));
            self.p.addParamValue('frame_alpha', 255, @(x) all(x >= 0) && all(x <= 255));
            self.p.addParamValue('frame_stroke', 20, @(x) all(x >= 0));

            self.draw_struct.color = [];
            self.draw_struct.image_pointer = [];
            self.proto_pointer = [];
        end

        function Add(self, indices, varargin)
            cell_matching = {'fill_color', 'frame_color'};
            self.p.parse(varargin{:});
            opts = self.p.Results;
            for fns = fieldnames(opts)'
                if any(strcmp(fns, cell_matching));
                    self.(fns{1})(:, indices) = opts.(fns{1});
                else
                    self.(fns{1})(indices) = opts.(fns{1});
                end

            end
            self.modified = unique([self.modified, indices]);
            %Add@PluralPsychMethods(self, indices, cell_matching, varargin);
        end

        function Register(self, win_pointer)
            self.window_pointer = win_pointer;

            % re-do textures (in case the pointers are from a previous session)
            if ~isempty(self.proto_pointer)
                Screen('Close', self.proto_pointer);
            end

            self.proto_pointer(1) = Screen('OpenOffscreenWindow', win_pointer, ...
                                           [0 0 0 0], [0 0 512 512]);
            self.proto_pointer(2) = Screen('OpenOffscreenWindow', win_pointer, ...
                                           [0 0 0 0], [0 0 512 512]);
            % draw shapes here

        end


        function Prime(self)
            Prime@Texture(self);
            if IsOctave
                tmpfun = @repelem2;
            else
                tmpfun = @repelem;
            end
            % reshape things to allow correct drawing order
            tmp_size = size(self.drawing_rect, 2) * 2;
            self.draw_struct.draw_rect = zeros(4, tmp_size);
            self.draw_struct.rotation_angle = zeros(1, tmp_size);
            self.draw_struct.filter_mode = zeros(1, tmp_size);
            self.draw_struct.color = zeros(4, tmp_size); % add on alphas!!
            self.draw_struct.image_pointer = zeros(1, tmp_size);

            % subset based on modified AND nans in fill/frame_color
            self.draw_struct.draw_rect(1:4, 1:2:end) = self.drawing_rect;
            self.draw_struct.draw_rect(1:4, 2:2:end) = self.drawing_rect;
            self.draw_struct.rotation_angle(1, :) = tmpfun(self.rotation_angle(self.modified), 2);
            self.draw_struct.filter_mode(1, :) = tmpfun(self.filter_mode(self.modified), 2);
            self.draw_struct.color(1:3, 1:2:end) = self.fill_color(:, self.modified);
            self.draw_struct.color(1:3, 2:2:end) = self.frame_color(:, self.modified);
            self.draw_struct.color(4, 1:2:end) = self.fill_alpha(self.modified);
            self.draw_struct.color(4, 2:2:end) = self.frame_alpha(self.modified);
            self.draw_struct.image_pointer(1, 1:2:end) = self.proto_pointer(1);
            self.draw_struct.image_pointer(1, 2:2:end) = self.proto_pointer(2);

        end

        function Draw(self, indices)
            tmpstrct = self.draw_struct;
            % figure out which indices are not missing
            %indices2 = logical(~(isnan(tmpstrct.fill_color(1, :)) + ...
            %              isnan(tmpstrct.frame_color(1, :))));
            indices2 = isnan(tmpstrct.color(1,:));
            % Subset based on requested indices first
            if length(indices) == 1
                indices = [indices, indices + 1];
            else
                indices = [indices, indices + length(indices)];
            end
            tmpstrct.draw_rect = tmpstrct.draw_rect(1:4, indices);
            tmpstrct.rotation_angle = tmpstrct.rotation_angle(1, indices);
            tmpstrct.filter_mode = tmpstrct.filter_mode(1, indices);
            tmpstrct.color = tmpstrct.color(1:4, indices);
            tmpstrct.image_pointer = tmpstrct.image_pointer(1, indices);

            if any(indices2 ~= 0)
                tmpstrct.draw_rect(:, indices2) = [];
                tmpstrct.rotation_angle(:, indices2) = [];
                tmpstrct.filter_mode(:, indices2) = [];
                tmpstrct.color(:, indices2) = [];
                tmpstrct.image_pointer(:, indices2) = [];
            end

            Screen('DrawTextures', self.window_pointer, ...
                   tmpstrct.image_pointer, [], ...
                   tmpstrct.draw_rect, ...
                   tmpstrct.rotation_angle, ...
                   tmpstrct.filter_mode, [], ...
                   tmpstrct.color, [], [], []);
        end

        function Close(self)
            Screen('Close', self.proto_pointer);
            delete(self);
        end

        function Set(self, indices, varargin)
            % set cell_matching here!
            cell_matching = {'fill_color', 'frame_color'};
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
                else
                    self.(fns{1})(indices) = opts.(fns{1});
                end
            end
        end % end Set
    end
end
