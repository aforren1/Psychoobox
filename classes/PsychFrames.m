classdef (Abstract) PsychFrames < PsychHandle
    properties (SetAccess = private, GetAccess = private)
        fill_color; % if empty, frame only
        frame_color; % if empty, fill only
        rect;
        pen_width;
        type;
    end

    methods
        function Draw(self, pointer) end;
    end
end
