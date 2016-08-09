classdef TextureManager < handle
    properties
        obj_array = []
    end

    methods
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

        function value = Get(self, index, property)
            value = self(index).(property);
        end
    end % end methods
end % end classdef
