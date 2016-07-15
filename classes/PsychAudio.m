classdef PsychAudio < PsychHandle
% PsychAudio Play sounds through PsychPortAudio
%
% PsychAudio Properties:
%    device_id - ID for audio device. Defaults to [].
%    pointer - Handle for PsychAudio object.
%    mode - See `PsychPortAudio Open?` for details. Defaults to 1.
%    req_latency_class - Allows PsychPortAudio to be more aggressive with regards to latency (0 - 4). Defaults to 1.
%    freq - Requested capture/playback rate. Defaults to 44100 Hz.
%    channels - Number of channels to use. Can specify [#output, #input]. Defaults to 2, or two output channels.
%    buffer_size - Size and number of audio buffers. Defaults to [].
%    suggested_latency - Requested latency in seconds. Defaults to [].
%    select_channels - Map channels to device channels. Defaults to [].
%
% PsychAudio Methods:
%    AddSlave - Add slaves to master of mode > 8.
%    CreateBuffer - Make an audio buffer (not yet attached to a device).
%    FillBuffer - Fill the buffer of an audio device.
%    DeleteBuffer - Delete audio buffer.
%    Play - Play sound.
%    Stop - Stop sound.
%    Status - Return device status.
%    Close - Close master device.
%
% Example:
%
% aud = PsychAudio('mode', 9); % Master, playback only
% aud.AddSlave(1);
% aud.AddSlave(2);
%
% % Create a buffer at index 1, and then fill slave 1 with that buffer
% aud.CreateBuffer(mysound, 1);
% aud.FillBuffer(1, 1);
%
% % Directly fill buffer of slave 2
% aud.FillBuffer(mysound, 2);
%
% t1 = GetSecs + 2;
% tout = aud.Play(t1, 2); % Play sound 2 at time t1
%
% aud.Close;

    properties (SetAccess = public, GetAccess = public)
        device_id;
        pointer;
        mode;
        req_latency_class;
        freq;
        channels;
        buffer_size;
        suggested_latency;
        select_channels;
        slaves;
        buffers;
        p;
    end

    methods
        function self = PsychAudio(varargin)
            self.p = inputParser;
            self.p.FunctionName = 'PsychAudio';
            self.p.addParamValue('device_id', [], @(x) isempty(x) || isnumeric(x));
            self.p.addParamValue('mode', 1, @(x) any(x == [1, 2, 3, 7, 9, 10, 11]));
            self.p.addParamValue('req_latency_class', 1, @(x) any(x == 0:4));
            self.p.addParamValue('freq', 44100, @(x) isnumeric(x));
            self.p.addParamValue('channels', 2, @(x) isnumeric(x));
            self.p.addParamValue('buffer_size', [], @(x) isnumeric(x));
            self.p.addParamValue('suggested_latency', [], @(x) isnumeric(x));
            self.p.addParamValue('select_channels', [], @(x) isempty(x) || ismatrix(x));

            self.p.parse(varargin{:});
            opts = self.p.Results;
            for fns = fieldnames(opts)'
                self.(fns{1}) = opts.(fns{1});
            end

            if opts.req_latency_class > 0
                InitializePsychSound(1);
            end

            self.pointer = PsychPortAudio('Open', opts.device_id, opts.mode, ...
                                          opts.req_latency_class, opts.freq, ...
                                          opts.channels, opts.buffer_size, ...
                                          opts.suggested_latency, opts.select_channels);
            PsychPortAudio('Start', self.pointer, 0, 0, 1);
            self.slaves = struct('pointer', [], ...
                                 'mode', [], ...
                                 'channels', [], ...
                                 'select_channels', []);
        end

        function AddSlave(self, index, varargin)
        % AddSlave(index, varargin) Add a slave to a master audio device.
        % Optional named arguments:
        %    mode - See `PsychPortAudio OpenSlave?` for options. Defaults to 1 (playback only).
        %    channels - Number of channels to use. Defaults to 2.
        %    select_channels - Map channels to device channels. Defaults to [].
        %
            if self.mode < 9
                error('Master needs to be started in mode 9, 10, or 11.');
            end
            p = inputParser;
            p.FunctionName = 'AddSlave';
            p.addParamValue('mode', 1, @(x) any(x == [1, 2, 3, 7, 32, 64]));
            p.addParamValue('channels', 2, @(x) isnumeric(x));
            p.addParamValue('select_channels', [], @(x) isempty(x) || ismatrix(x));
            p.parse(varargin{:});
            opts = p.Results;

            self.slaves(index).mode = opts.mode;
            self.slaves(index).channels = opts.channels;
            self.slaves(index).select_channels = opts.select_channels;
            self.slaves(index).pointer = PsychPortAudio('OpenSlave', self.pointer, ...
                                                         opts.mode, opts.channels, ...
                                                         opts.select_channels);
        end

        function CreateBuffer(self, sounds, index)
        % CreateBuffer(sounds, index) Make a buffer and add a sound to it.
            self.buffers(index) = PsychPortAudio('CreateBuffer', [], sounds);
        end

        function result = DeleteBuffer(self, index, wait)
        % result = DeleteBuffer(index, wait) Delete a buffer.
        % If `wait` is unspecified, defaults to 1 (wait until buffer is not in use).
            if exist('wait', 'var')
                wait = 1;
            end
            result = PsychPortAudio('DeleteBuffer', self.buffers(index), wait);
        end

        function FillBuffer(self, sounds_or_index, index)
        % FillBuffer(sound_or_index, index) Fill buffer of a particular audio device.
        % If sounds_or_index is small, treat it as the index to a particular buffer.
        % If index doesn't exist, assume there is only a master, and fill that.
            if exist('index')
                x = self.slaves(index).pointer;
            else
                x = self.master.pointer;
            end

            % check if using buffer, rather than matrix
            if sum(size(sounds_or_index)) < 10
                sounds_or_index = self.buffers(sounds_or_index);
            end
            PsychPortAudio('FillBuffer', x, sounds_or_index);
        end

        function time = Play(self, when, index)
        % time_start = Play(when, index) Plays a sound.
        % If `when` is unspecified, plays immediately.
        % If `index` is unspecified, play the master.
            if ~exist('when', 'var')
                when = 0;
            end
            if exist('index', 'var')
                x = self.slaves(index).pointer;
            else
                x = self.master.pointer;
            end
            time = PsychPortAudio('Start', x, 1, when, 1);
        end

        function Stop(self, index)
        % Stop(index) Stops a sound.
        % If `index` is unspecified, stop the master.
            if exist('index', 'var')
                x = self.slaves(index).pointer;
            else
                x = self.master.pointer;
            end
            PsychPortAudio('Stop', x);
        end

        function Close(self)
        % Close Closes the master device.
            PsychPortAudio('Close');
            delete(self);
        end

        function status = Status(self, index)
        % status = Status(index) Returns the current status of the master or a slave.
        % If `index` is unspecified, return the status of the master.

            if exist('index', 'var')
                x = self.slaves(index).pointer;
            else
                x = self.master.pointer;
            end
            status = PsychPortAudio('GetStatus', x);
        end
    end % end methods
end % end classdef
