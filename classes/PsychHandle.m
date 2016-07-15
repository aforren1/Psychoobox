classdef (Abstract) PsychHandle < handle
% PsychHandle (Abstract) superclass for Psychoobox.
%
% Provides generic getters/setters/closers. Does not do much more than that.
%
% PsychHandle Methods:
%    Print - See current field values.
%    Get - Get value of a field.
%    Set - Set value of a field.
%    Close - Delete handle.
    methods

        function Print(self)
        % Print See all current values of an object.
        %     Calls `disp(struct(self))` with warnings turned off.
            warning off;
            disp(struct(self));
            warning on;
        end

        function value = Get(self, property)
        % Get(property) Get the value of a property
        %    Returns the value of a given field, passed in as a string.
        %
        %    See also SET.
            value = self.(property);
        end

        function Set(self, varargin)
        % Set(property, value) Set the value of a property
        %    Sets a field "property" to the value "value".
        %
        %    See also GET.
            self.p.parse(varargin{:});
            opts = self.p.Results;
             for fns = fieldnames(opts)'
                 self.(fns{1}) = opts.(fns{1});
             end
        end

        function Close(self)
        % Close Delete the handle to the object.
            delete(self);
        end
    end % end methods

end % end classdef
