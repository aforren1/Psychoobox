classdef PsychHandle < handle
% PsychHandle()
% 
% Provides generic getters/setters/closers. Does not do much more than that.

    methods

        function value = Get(self, property)
            value = self.(property);
        end

        function Set(self, property, value)
            self.(property) = value;
        end

        function Close(self)
            delete(self);
        end

    end % end methods
end % end classdef
