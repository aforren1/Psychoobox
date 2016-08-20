classdef PobAudio < handle
    properties
        device_id
        pointer
        mode % play, record, both
        req_latency_class
        freq
        channels
        buffer_size
        suggested_latency
        select_channels
        slaves
        buffers
        p
        p2
        p3
    end


    methods
        function self = PobAudio(varargin)
            self.p = inputParser;
            self.p.FunctionName = 'PobAudio';
            self.p.addParamValue('device_id', [], @(x) isempty(x) || isnumeric(x));
            self.p.addParamValue('mode', 'play', @(x) ismember(x, {'play', 'record', 'both'}));
            self.p.addParamValue('req_latency_class', 1, @(x) any(x == 0:4));
            self.p.addParamValue('freq', 44100, @(x) isnumeric(x));
            self.p.addParamValue('channels', 2, @(x) isnumeric(x));
            self.p.addParamValue('buffer_size', [], @(x) isnumeric(x));
            self.p.addParamValue('suggested_latency', [], @(x) isnumeric(x));
            self.p.addParamValue('select_channels', [], @(x) isempty(x) || isnumeric(x));
            self.p.parse(varargin{:});
            opts = self.p.Results;
            for fns = fieldnames(opts)'
                self.(fns{1}) = opts.(fns{1});
            end
            if opts.req_latency_class > 0
                InitializePsychSound(1);
            end

            tmp_mode = [9 10 11];
            tmp_mode = tmp_mode(ismember({'play', 'record', 'both'}, opts.mode));


            self.pointer = PsychPortAudio('Open', opts.device_id, tmp_mode, ...
                                          opts.req_latency_class, opts.freq, ...
                                          opts.channels, opts.buffer_size, ...
                                          opts.suggested_latency, opts.select_channels);
            PsychPortAudio('Start', self.pointer, 0, 0, 1);
            self.slaves = struct('pointer', [], ...
                                 'mode', [], ...
                                 'channels', [], ...
                                 'select_channels', []);
            self.buffers = [];

            self.p2 = inputParser;
            self.p2.FunctionName = 'Add_Slave';
            self.p2.addParamValue('mode', @(x)  ismember(x, {'play', 'record', 'both'}));
            self.p2.addParamValue('select_channels', [], @(x) isempty(x) || isnumeric(x));

            self.p3 = inputParser;
            self.p3.FunctionName = 'Add_Buffer';
            self.p3.addParamValue('audio', [], @(x) isempty(x) || isnumeric(x));

        end

        function Add(self, type, index, varargin)
            if strcmp(type, 'slave')
                self.p2.parse(varargin{:});
                opts = self.p2.Results;
                tmp_mode = [1 2 3];
                tmp_mode = tmp_mode(ismember({'play', 'record', 'both'}, opts.mode));
                self.slaves(index).mode = tmp_mode;
                self.slaves(index).channels = opts.channels;
                self.slaves(index).select_channels = opts.select_channels;
                self.slaves(index).pointer = PsychPortAudio('OpenSlave', self.pointer, ...
                                                             tmp_mode, opts.channels, ...
                                                             opts.select_channels);
            elseif strcmp(type, 'buffer')
                self.p3.parse(varargin{:});
                opts = self.p3.Results;
                self.buffers(index) = PsychPortAudio('CreateBuffer', [], opts.audio);
            else
                error('Unknown type.')
            end
        end % end add

        function time = Play(self, index, when)
            if ~exist('when', 'var')
                when = 0;
            end
            time = PsychPortAudio('Start', self.slaves(index).pointer, 1, when, 1);
        end

        function Stop(self, index)
            PsychPortAudio('Stop', self.slaves(index).pointer);
        end

        function Remove(self, type, index)
            if strcmp(type, 'slave')
                PsychPortAudio('Close', self.slaves(index).pointer);
            elseif strcmp(type, 'buffer')
                PsychPortAudio('DeleteBuffer', self.buffers(index));
            else
                error('Unknown type.');
            end

        end % end remove

        function Map(self, slave_index, buffer_index)
            PsychPortAudio('FillBuffer', self.slaves(slave_index).pointer,...
                           self.buffers(buffer_index));

        end

        function Close(self, index)
            if exist(index, 'var')
                PsychPortAudio('Close', self.slaves(index).pointer);
            else
                PsychPortAudio('Close');
            end
        end

    end
end
