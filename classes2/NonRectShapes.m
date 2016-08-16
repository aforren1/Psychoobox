classdef (Abstract) NonRectShapes < PsychHandle

    properties (SetAccess = public, GetAccess = public)
        color
        alpha
        diameter % diameter
        relative_to % 'x', 'y', 'xy'/'both'
        window_pointer
    end

    properties (SetAccess = protected, GetAccess = protected)
        drawing_pts
        modified
    end

    methods
        function self = NonRectShapes()
            self@PsychHandle;
            self.p.addParamValue('color', [255 255 255]', @(x) all(isnumeric(x)));
            self.p.addParamValue('alpha', 255, @(x) all(x >= 0) && all(x <= 255));
            self.p.addParamValue('diameter', 5, @(x) all(x > 0));
            self.p.addParamValue('relative_to', 'x', @(x) all(ismember(x, {'x','y','xy'})));
            self.p.addParamValue('window_pointer', nan, @(x) isempty(x) || isnumeric(x));

            self.modified = [];
            self.drawing_pts = [];
        end % end constructor

        function Add(self, indices, varargin)
            self.p.parse(varargin{:});
            opts = self.p.Results;
            for fns = fieldnames(opts)'
                if strcmp(fns, 'color');
                    self.(fns{1})(:, indices) = opts.(fns{1});
                else
                    self.(fns{1})(indices) = opts.(fns{1});
                end

            end
            self.modified = unique([self.modified, indices]);
        end % end Add

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
                if strcmp(fns, 'color')
                    self.(fns{1})(:, indices) = opts.(fns{1});
                else
                    self.(fns{1})(indices) = opts.(fns{1});
                end
            end
        end % end Set

        function Prime(self, indices)
            if isempty(indices)
                indices = self.modified;
                message('Indices unspecified, setting identical values for all...')
            end
            if isempty(self.window_pointer)
                error('No reference window set. Use `shape.Set("window_pointer", win.pointer)` before calling this.')
            end

            % calculate relative-to-screen positions
        end

    end

end
