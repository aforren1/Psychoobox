classdef PsychHandle < handle
% PsychHandle (Abstract) superclass for Psychoobox.
% 
% Provides generic getters/setters/closers. Does not do much more than that.
%
% PsychHandle Methods:
%    Get - Get value of a field.
%    Set - Set value of a field.
%    Close - Delete handle.

    methods

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

    methods (Access = private)
        function opts = CheckInputs(opts, varargin)
	    % all credit to 
	    % http://stackoverflow.com/questions/2775263/how-to-deal-with-name-value-pairs-of-function-arguments-in-matlab
	
	    % read the acceptable names
	    opt_names = fieldnames(opts);
	
	    % count arguments
	    num_args = length(varargin);
	    if round(num_args/2) ~= num_args/2
	       error('FUNCTION needs propertyName/propertyValue pairs')
	    end
	
	    for pair = reshape(varargin, 2, []) %# pair is {propName;propValue}
	        input_name = pair{1}; %# make case insensitive
	        if any(strcmpi(input_name, opt_names))
	           % overwrite opts. If you want you can test for the right class here
	           % Also, if you find out that there is an option you keep getting wrong,
	           % you can use "if strcmp(input_name, 'problemOption'),testMore,end"-statements
	           opts.(input_name) = pair{2};
	        else
	            error('%s is not a recognized parameter name', input_name)
	        end
            end
        end % end CheckInputs

    end % end private methods
end % end classdef
