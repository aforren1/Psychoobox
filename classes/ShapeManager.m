classdef (Abstract) ShapeManager < TextureManager
    properties
        proto_pointers
        fill_array
        frame_array
    end
    methods
        function self = ShapeManager()
            self.p.addParamValue('fill_color', [], @(x) isempty(x) || isnumeric(x));
            self.p.addParamValue('frame_color', [], @(x) isempty(x) || isnumeric(x));
            self.p.addParamValue('pen_width', 1, @(x) x >= 0);
            self.proto_pointers = [];
            self.fill_array = self.obj_array;
            self.frame_array = self.fill_array;
            self.fill_array.color = [nan nan nan];
            self.frame_array.color = [nan nan nan];
            self.fill_array.alpha = 1;
            self.frame_array.alpha = 1;

        end

        function Add(self, indices, varargin)
        % Need to just distribute *_color appropriately
        % (and send duplicate settings appropriately)
            self.p.parse(varargin{:});
            opts = self.p.Results;
            for fns = fieldnames(opts)'
                if any(size(opts.(fns{1})) > 1)
                    tmpfun = @(x) deal(x)
                elseif any(size(opts.fns{1}) == length(indices)) % check this one
                    tmpfun = @(x) x;
                else
                    error('Settings must be of length 1 or the same length as the indices');
                end

                if strcmp(fns{1}, 'fill_color')
                    [self.fill_array(indices).color] = tmpfun(opts.fill_color);
                elseif strcmp(fns{1}, 'frame_color')
                    [self.frame_array(indices).color] = tmpfun(opts.frame_color);
                else
                    [self.fill_array(indices).(fns{1})] = tmpfun(opts.(fns{1}));
                    [self.frame_array(indices).(fns{1})] = tmpfun(opts.(fns{1}));
                end
            end

        end

        function Prime(self, win_pointer, indices)
            Prime@TextureManager(self, win_pointer, indices);
            % check if only fill, only outline, or both
            % How to handle missing??
            if isempty(self.proto_pointers)
                self.proto_pointers(1) = Screen('OpenOffscreenWindow', win_pointer,...
                                                [0 0 0 0], [0 0 800 800]);
                self.proto_pointers(2) = Screen('OpenOffscreenWindow', win_pointer,...
                                                [0 0 0 0], [0 0 800 800]);
            end
            % draw prototypes here
        end

        function Draw(self, win_pointer, indices)

        end

        function Set(self, indices, varargin)
        % need to set the components on each sub array
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
                if strcmp(fns{1}, 'fill_color')
                    self.fill_array(indices).color = opts.fill_color;
                elseif strcmp(fns{1}, 'frame_color')
                    self.frame_array(indices).color = opts.frame_color;
                else
                    self.fill_array(indices).(fns{1}) = opts.(fns{1});
                    self.frame_array(indices).(fns{1}) = opts.(fns{1});
                end
            end
        end
    end
end
