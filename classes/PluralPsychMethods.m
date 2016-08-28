classdef (Abstract) PluralPsychMethods < handle

    properties (SetAccess = protected, GetAccess = protected)
        p % inputParser
        window_pointer
    end

    methods
        function self = PluralPsychMethods()
            self.p = inputParser;
        end

        function Print(self)
            warning('off');
            disp(struct(self));
            warning('on');
        end

        function Add(self, indices, cell_matching, varargin)
        % Add at indices.
        % Object must have an inputParser (p),
        % and set cell_matching in their particular call, for vector-valued
        % and a `modified` property to keep track of existing...

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
        end % end Add

        function Set(self, indices, cell_matching, varargin)
            % set cell_matching here!
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

        function Register(self, win_pointer)
        % Tell the object which reference to use
            self.window_pointer = win_pointer;
        end % end Register

        function Prime(self)
        % Figure out all absolutes for existing indices against the
        % window given by self.window_pointer
        % only includes indices touched by Add
            if isempty(self.window_pointer)
                error('Set a reference window with `obj.Register(<window_pointer>)`.');
            end
        end % end Prime
        
        function new_obj = Copy(self)
            fname = [tempname '.mat'];
            save(fname, 'self');
            new_obj = load(fname);
            new_obj = new_obj.self;
            delete(fname);
        end
    end

        methods (Hidden = true)
            function RectRelativeToRect(self, reference_rect)
            % Convert relatives to absolutes
                y_size = self.rel_y_scale(self.modified) * (reference_rect(4) - reference_rect(2));
                x_size = self.rel_x_scale(self.modified) * (reference_rect(3) - reference_rect(1));
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
                   error('4-element rectangles are weird, fix...');
                else
                    self.drawing_rect(:, 1:length(self.modified)) = CenterRectOnPoint(tmprct, ...
                                                 self.rel_x_pos(self.modified) * (reference_rect(3) - reference_rect(1)), ...
                                                 self.rel_y_pos(self.modified) * (reference_rect(4) - reference_rect(2)));
                end
            end % end relativetorect
    end % end methods
end % end classdef
