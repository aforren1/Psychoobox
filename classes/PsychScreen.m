classdef PsychScreen < PsychHandle

    properties (access = Private)
        % settings
        pointer;
        on_screen;
        rect;
        color;
        pixel_size;
        number_buffers;
        stereo_mode;
        multisample;
        imaging_mode;
        p = inputParser;
        p.FunctionName = 'PsychScreen';
        p.addRequired('pointer', @(x) isnumeric(x) && x >= 0);
        p.addRequired('on_screen', @(x) islogical(x));
        p.addOptional('rect', [], @(x) isempty(x) || (ismatrix(x) && length(x) == 4));
        p.addOptional('color', [], @(x) isempty(x) || (ismatrix(x)));
        p.addOptional('pixel_size', [], @(x) isempty(x) || isnumeric(x));
        p.addOptional('number_buffers', [], @(x) isempty(x) || x > 0);
        p.addOptional('stereo_mode', [], @(x) isempty(x) || (x >= 0 && x <= 10));
        p.addOptional('multisample', [], @(x) isempty(x) || (isnumeric(x) && x > 0));
        p.addOptional('imaging_mode', [], @(x) isempty(x) || (isnumeric(x) && x >= 0));
        p.addOptional('skip_sync_tests', false, @(x) islogical(x));
        p.addOptional('visual_debug_level', [], @(x) isempty(x) || (isnumeric(x) && x >= 0 && x <= 5));
        p.addOptional('conserve_vram', [], @(x) isempty(x) || (isnumeric(x) && x >= 0 && x <= 3));
        p.addOptional('enable_3d', [], @(x) isempty(x) || islogical(x)); %??

        % derived quantities
        flip_interval;
        frame_rate;
    end

    methods
        function self = PsychScreen(pointer, on_screen, varargin)
            parse(p, varargin{:});
            if p.Results.on_screen
                tempstr = 'OpenWindow';
            else
                tempstr = 'OpenOffscreenWindow';
            end
            [self.pointer, self.rect]=Screen(tempstr,windowPtrOrScreenNumber [,color] [,rect] [,pixelSize] [,numberOfBuffers] [,stereomode] [,multisample][,imagingmode][,specialFlags][,clientRect]);

            self.flip_interval = Screen('GetFlipInterval', self.pointer);
        end

        function Set(self, property, value)
            switch property
                case 'frame_rate'
                    Screen('FrameRate', self.pointer, 2, value);
                otherwise
                    self.(property) = value;
            end
        end

        function out_time = Flip(self, flip_time)
            if nargin < 2
                flip_time = 0;
            end
            out_time = Screen('Flip', self.pointer, flip_time);
        end

        function Close(self)
            Screen('Close', self.pointer);
            delete(self);
        end
    end

end
