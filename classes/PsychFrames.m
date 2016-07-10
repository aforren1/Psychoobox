classdef (Abstract) PsychFrames < PsychHandle
    properties (SetAccess = private, GetAccess = private)
        color;
        rect;
        pen_width;
    end

    methods
        function Draw(self) end;
    end
end
