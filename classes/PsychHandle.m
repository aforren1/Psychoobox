classdef PsychHandle < handle
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

        function Set(self, property, value)
        % Set(property, value) Set the value of a property
        %    Sets a field "property" to the value "value".
        %
        %    See also GET.
            self.(property) = value;
        end

        function Close(self)
        % Close Delete the handle to the object.
            delete(self);
        end
    end % end methods

end % end classdef
