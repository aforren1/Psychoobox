classdef (Abstract) RectShapes < PsychHandle

    properties (SetAccess = public, GetAccess = public)
        fill_color
        fill_alpha
        frame_color
        frame_alpha
        frame_stroke
        rel_x_pos
        rel_y_pos
        rel_x_scale
        rel_y_scale
        window_pointer
    end

    properties (SetAccess = protected, GetAccess = protected)
        drawing_rect
        modified % keep track of `Add`ed indices
    end

    methods
        function self = RectShapes()
            self@PsychHandle;
            self.p.addParamValue('fill_color', [nan nan nan], ...
                                 @(x) all(all(isnan(x(:, isnan(x(1,:)))))) &&...
                                 all(all(~isnan(x(:, ~isnan(x(1,:)))))));
            self.p.addParamValue('frame_color', [nan nan nan],...
                                 @(x) all(all(isnan(x(:, isnan(x(1,:)))))) && ...
                                 all(all(~isnan(x(:, ~isnan(x(1,:)))))));
            self.p.addParamValue('fill_alpha', 255, @(x) all(x >= 0) && all(x <= 255));
            self.p.addParamValue('frame_alpha', 255, @(x) all(x >= 0) && all(x <= 255));
            self.p.addParamValue('frame_stroke', 5, @(x) all(x >= 0));
            self.p.addParamValue('rel_x_pos', nan, @(x) all(x >= 0) && all(x <= 1));
            self.p.addParamValue('rel_y_pos', nan, @(x) all(x >= 0) && all(x <= 1));
            self.p.addParamValue('rel_x_scale', nan, @(x) any(isnan(x)) || (all(x >= 0) && all(x <= 1)));
            self.p.addParamValue('rel_y_scale', nan, @(x) any(isnan(x)) || (all(x >= 0) && all(x <= 1)));
            self.p.addParamValue('window_pointer', nan, @(x) isempty(x) || isnumeric(x));

            self.modified = [];
            self.drawing_rect = [];

        end

        function Add(self, indices, varargin)
            self.p.parse(varargin{:});
            opts = self.p.Results;
            for fns = fieldnames(opts)'
                if any(strcmp(fns, {'fill_color', 'frame_color'}));
                    self.(fns{1})(:, indices) = opts.(fns{1});
                else
                    self.(fns{1})(indices) = opts.(fns{1});
                end

            end
            self.modified = unique([self.modified, indices]);

        end

        function Set(self, indices, varargin)
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
                if any(strcmp(fns, {'fill_color', 'frame_color'}))
                    self.(fns{1})(:, indices) = opts.(fns{1});
                else
                    self.(fns{1})(indices) = opts.(fns{1});
                end
            end
        end

        function Register(self, win_pointer)
        % Tell the shape which reference to use
            self.window_pointer = win_pointer;
        end

        function Prime(self, indices)
        % calculate the absolute positions & sizes of things
        % This is only offsets the (potentially slow) calculation of relative -> abs rect
        % and checks for potential errors...
            if isempty(indices)
                indices = self.modified;
                message('Indices unspecified, setting identical values for all...')
            end
            if isempty(self.window_pointer)
                error('No reference window set. Use `shape.Register(<window_pointer>)` before calling this.')
            end
            % overlap_nans = find(isnan(self.fill_color(1, indices)) == isnan(self.frame_color(1, indices)));
            % if any(overlap_nans)
            %     problem_indices = find(overlap_nans);
            %     warning(['Need to specify a frame OR fill color at relative index(es) ',...
            %             sprintf('%d ', problem_indices), ', ', 'or this will fail.']);
            % end

            self.RelativeToRect(indices, Screen('Rect', self.window_pointer));
        end
    end

    methods (Hidden = true)
        function RelativeToRect(self, indices, reference_rect)
        % Convert relatives to absolutes
            y_size = self.rel_y_scale(indices) * (reference_rect(4) - reference_rect(2));
            x_size = self.rel_x_scale(indices) * (reference_rect(3) - reference_rect(1));
            if any(isnan(y_size))
                y_size(isnan(y_size)) = x_size(isnan(y_size));
            end
            if any(isnan(x_size))
                x_size(isnan(x_size)) = y_size(isnan(x_size));
            end

            if any([isnan(y_size), isnan(x_size)])
                % todo: add index at least, for debugging
                error('One dimension must not be nan!')
            end

            tmprct = [zeros(2, size(x_size, 2)); [x_size; y_size]];
            if size(tmprct, 2) == 1
                tmprct = tmprct.';
            end
            % Manual hack for 4x4 rect array
            if all(size(tmprct) == 4)
                [cx, cy] = RectCenter(tmprct);
                tmprct([1, 3], :) = tmprct([1, 3], :) + (reference_rect(3) - reference_rect(1)) - cx;
                tmprct([2, 4], :) = tmprct([2, 4], :) + (reference_rect(4) - reference_rect(2)) - cy;
                self.drawing_rect(:, indices) = tmprct;
            else
                self.drawing_rect(:, indices) = CenterRectOnPoint(tmprct, ...
                                             self.rel_x_pos(indices) * (reference_rect(3) - reference_rect(1)), ...
                                             self.rel_y_pos(indices) * (reference_rect(4) - reference_rect(2)));
            end
        end % end relativetorect

    end
end
