classdef (Abstract) PsychFrames < PsychHandle
    properties (SetAccess = public, GetAccess = public)
        fill_color; % if empty, frame only
        frame_color; % if empty, fill only
        rect;
        pen_width;
        type;
        p; % parser
    end

    methods
        function self = PsychFrames
            self.p = inputParser;
            self.p.addParamValue('fill_color', [], @(x) isempty(x) || isnumeric(x));
            self.p.addParamValue('frame_color', [], @(x) isempty(x) || isnumeric(x));
            self.p.addParamValue('rect', [], @(x) isempty(x) || isnumeric(x));
            self.p.addParamValue('pen_width', 1, @(x) isnumeric(x) && x > 0);
        end
        function Draw(self, pointer) end;
    end
end
