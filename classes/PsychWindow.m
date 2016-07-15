classdef PsychWindow < PsychHandle
%
% Example:
% scrn = PsychWindow(0, true, 'color', [25 25 25], 'rect', [0 0 50 50]);
%
    properties (SetAccess = public, GetAccess = public)
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
        skip_sync_tests;
        alpha_blending;
        % derived quantities
        flip_interval;
        frame_rate;
        priority;
        p;
    end

    methods
        function self = PsychWindow(pointer, on_screen, varargin)
            self.p = inputParser;
            self.p.FunctionName = 'PsychWindow';
            self.p.addRequired('pointer', @(x) isnumeric(x) && x >= 0);
            self.p.addRequired('on_screen', @(x) islogical(x));
            self.p.addParamValue('rect', [], @(x) isempty(x) || (ismatrix(x) && length(x) == 4));
            self.p.addParamValue('color', [], @(x) isempty(x) || (ismatrix(x)));
            self.p.addParamValue('pixel_size', 24, @(x) isempty(x) || isnumeric(x));
            self.p.addParamValue('number_buffers', 2, @(x) isempty(x) || x > 0);
            self.p.addParamValue('stereo_mode', 0, @(x) isempty(x) || (x >= 0 && x <= 10));
            self.p.addParamValue('multisample', 1, @(x) isempty(x) || (isnumeric(x) && x > 0));
            self.p.addParamValue('imaging_mode', 0, @(x) isempty(x) || (isnumeric(x) && x >= 0));
            self.p.addParamValue('skip_sync_tests', false, @(x) islogical(x));
            self.p.addParamValue('alpha_blending', false, @(x) islogical(x));

            self.p.parse(pointer, on_screen, varargin{:});
            opts = self.p.Results;
            if opts.skip_sync_tests
                Screen('Preference', 'SkipSyncTests', 2);
            end

            % assign vals to struct
            for fns = fieldnames(opts)'
                self.(fns{1}) = opts.(fns{1});
            end

            if opts.on_screen
                [self.pointer, self.rect] = Screen('OpenWindow', pointer,...
                                                   opts.color, opts.rect,...
                                                   opts.pixel_size, opts.number_buffers,...
                                                   opts.stereo_mode, opts.multisample, ...
                                                   opts.imaging_mode, [], []);
            else
                [self.pointer, self.rect] = Screen('OpenOffscreenWindow', ...
                                                   pointer, opts.color, ...
                                                   opts.rect, opts.pixel_size,...
                                                   [], opts.multisample);
            end
            self.flip_interval = Screen('GetFlipInterval', self.pointer);
            self.frame_rate = Screen('FrameRate', self.pointer);
            self.priority = MaxPriority(self.pointer);

            % inflexible at the moment, allow getting/setting
            if opts.alpha_blending
                Screen('BlendFunction', self.pointer, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
            end

        end

        function Set(self, varargin)
            Set@PsychHandle(self,varargin);
            % switch property
            %     case 'frame_rate'
            %         Screen('FrameRate', self.pointer, 2, value);
            %     otherwise
            % end
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

        function ToFront(self)
            Screen('WindowToFront', self.pointer);
        end

        function Wipe(self, color) % or Clear?
            Screen('FillRect', self.pointer, color, self.rect);
        end

        function time_elapsed = DrawingFinished(self, dont_clear, sync)
            if ~exist('dont_clear')
                dont_clear = [];
            end
            if ~exist('sync')
                sync = [];
            end
            time_elapsed = Screen('DrawingFinished', self.pointer, dont_clear, sync);
        end

    end % end methods

    methods (Static)
        function screens = Screens(self)
            screens = Screen('Screens');
        end
    end % end static methods
end % end classdef
