classdef PsychWindow < PsychHandle
% PsychWindow Manipulate the display.
%
% PsychWindow Properties:
%     on_screen - If true, create on-screen window. Defaults to true.
%     rect - Requested dimensions of the screen. Defaults to [] (fullscreen).
%     color - Screen color. Defaults to [] (white).
%     pixel_size - Defaults to [] (unchanged).
%     number_buffers - Defaults to 2.
%
%     stereo_mode - Defaults to 0 (monoscopic viewing). See `Screen OpenWindow?` for advanced usage.
%     multisample - If greater than 0, enables hardware anti-aliasing. Defaults to 0.
%     imaging_mode - See `help PsychImaging`. Default is 0 (off).
%     skip_sync_tests - If true, skips sync tests. Default is false.
%     alpha_blending - If true, executes `Screen('BlendFunction', self.pointer, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA')`. Default is false.
%
%     flip_interval - The inter-flip interval in seconds.
%     frame_rate - The frame rate in hertz.
%     priority - Contains the maximum priority for the window.
%
% PsychWindow Methods:
%     Flip - Flip the window.
%     ToFront - Bring the window to the front.
%     Wipe - Draw a rectangle over the entire window.
%     DrawingFinished - Signal that drawing is finished before the flip.
%     Priority - Toggle high/low priority.
%
%     Close - Close the window.
%     Set - Set parameters.
%     Get - Get the value of a parameter.
%     Print - Show values of all properties.
%
% Example:
% win = PsychWindow('screen', 0, 'color', [25 25 25], 'rect', [0 0 200 200]);
%
% win.Priority(true);
% % Draw something
% win.DrawingFinished();
% t_flip = win.Flip(GetSecs + 2);
% win.Wipe(); %
% win.Flip();
%
% win.Close();

    properties (SetAccess = public, GetAccess = public)
        % settings
        screen
        pointer
        on_screen
        rect
        color
        pixel_size
        number_buffers
        stereo_mode
        multisample
        imaging_mode
        skip_sync_tests
        alpha_blending
        verbosity
        % derived quantities
        center
        flip_interval
        frame_rate
        priority
    end

    methods
        function self = PsychWindow(varargin)
            self = self@PsychHandle();
            self.p.FunctionName = 'PsychWindow';
            self.p.addParamValue('screen', 0, @(x) isnumeric(x) && x >= 0);
            self.p.addParamValue('on_screen', true, @(x) islogical(x));
            self.p.addParamValue('rect', [], @(x) isempty(x) || (isnumeric(x) && length(x) == 4));
            self.p.addParamValue('color', [], @(x) isempty(x) || (isnumeric(x)));
            self.p.addParamValue('pixel_size', [], @(x) isempty(x) || isnumeric(x));
            self.p.addParamValue('number_buffers', 2, @(x) isempty(x) || x > 0);
            self.p.addParamValue('stereo_mode', 0, @(x) isempty(x) || (x >= 0 && x <= 10));
            self.p.addParamValue('multisample', 0, @(x) isempty(x) || (isnumeric(x) && x >= 0));
            self.p.addParamValue('imaging_mode', 0, @(x) isempty(x) || (isnumeric(x) && x >= 0));
            self.p.addParamValue('alpha_blending', true, @(x) islogical(x));

            self.p.parse(varargin{:});
            opts = self.p.Results;

            % assign vals to struct
            for fns = fieldnames(opts)'
                self.(fns{1}) = opts.(fns{1});
            end

            if opts.on_screen
                [self.pointer, self.rect] = Screen('OpenWindow', self.screen,...
                                                   opts.color, opts.rect,...
                                                   opts.pixel_size, opts.number_buffers,...
                                                   opts.stereo_mode, opts.multisample, ...
                                                   opts.imaging_mode, [], []);
            else
                [self.pointer, self.rect] = Screen('OpenOffscreenWindow', ...
                                                   self.screen, opts.color, ...
                                                   opts.rect, opts.pixel_size,...
                                                   [], opts.multisample);
            end
            self.flip_interval = Screen('GetFlipInterval', self.pointer);
            self.frame_rate = Screen('FrameRate', self.pointer);
            self.priority = MaxPriority(self.pointer);
            [self.center(1), self.center(2)] = RectCenter(self.rect);
            % inflexible at the moment, allow getting/setting
            if opts.alpha_blending
                Screen('BlendFunction', self.pointer, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
            end

        end

        % function Set(self, varargin)
        %     Set@PsychHandle(self, varargin);
        %     % TODO: Allow on-the-fly settings?
        % end

        function out_time = Flip(self, flip_time)
        % win.Flip(flip_time)
        %
        % Flips the front and back display surfaces at optional time `flip_time`.
        %
        % Example:
        %
        % flip_time = win.Flip(GetSecs + 2); % Flip two seconds from present
            if nargin < 2
                flip_time = 0;
            end
            out_time = Screen('Flip', self.pointer, flip_time);
        end

        function Close(self)
            % win.Close()
            %
            % Closes the window.
            Screen('Close', self.pointer);
            delete(self);
        end

        function ToFront(self)
            % win.ToFront()
            %
            % Brings the window to the front.
            Screen('WindowToFront', self.pointer);
        end

        function Wipe(self)
            % win.Wipe()
            %
            % Fill the entire window with a color.
            Screen('FillRect', self.pointer, self.color, self.rect);
        end

        function Priority(self, flag)
            % Toggle the priority.
            % Usage:
            %
            % win.Priority(true)

            if flag
                Priority(self.priority);
            else
                Priority(0);
            end
        end

        function time_elapsed = DrawingFinished(self, dont_clear, sync)
            % time_elapsed = win.DrawingFinished([dont_clear], [sync])
            %
            % Signal that drawing is finished before the next flip.
            % Arguments:
            %     dont_clear - Currently unused. Defaults to [].
            %     sync - Time how long the previous draw cycle took. Defaults to [].
            %            If set to 1, `time_elapsed` is the amount of time since the
            %            previous flip.
            % Both `dont_clear` and `sync` are optional.
            if ~exist('dont_clear', 'var')
                dont_clear = [];
            end
            if ~exist('sync', 'var')
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
