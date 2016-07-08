classdef PsychScreen < PsychHandle

    properties (access = Private)
        pointer;
        rect;
        color;
        pixel_size;
        number_buffers;
        stereo_mode;
        multisample;
        imaging_mode;
        inputs.p = inputParser;
        inputs.p.addRequired('pointer', @(x) isnumeric(x) && x >= 0);
        inputs.p.addRequired('on_screen', @(x) islogical(x));
        inputs.p.addOptional('rect', [], @(x) isempty(x) || (ismatrix(x) && length(x) == 4));
        inputs.p.addOptional('color', [], @(x) isempty(x) || (ismatrix(x)));
        inputs.p.addOptional('pixel_size', [], @(x) isempty(x) || isnumeric(x));
        inputs.p.addOptional('number_buffers', [], @(x) isempty(x) || x > 0);
        inputs.p.addOptional('stereo_mode', [], @(x) x >= 0 && x <= 10);
        inputs.p.addOptional('multisample', [], @(x) isnumeric(x) && x > 0);
        inputs.p.addOptional('imaging_mode', [], @(x) isnumeric(x) && x >= 0);
        framerate;
        on_screen;
    end

    methods
        function self = PsychScreen(pointer, on_screen, varargin)
            
        end

    function Close(self)
        Screen('Close', self.pointer);
        delete(self);
    end

end
