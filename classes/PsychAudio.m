classdef PsychAudio < PsychHandle

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
    end

    methods
        function self = PsychAudio(varargin)
            p = inputParser;
            p.FunctionName = 'PsychAudio';
            p.addParamValue('device_id', [], @(x) isempty(x) || isnumeric(x));
            p.addParamValue('mode', 1, @(x) any(x == [1, 2, 3, 7, 9, 10, 11]));
            p.addParamValue('req_latency_class', 0, @(x) any(x == 1:4));
            p.addParamValue('freq', 44100, @(x) isnumeric(x));
            p.addParamValue('channels', 2, @(x) isnumeric(x));
            p.addParamValue('buffer_size', [], @(x) isnumeric(x));
            p.addParamValue('suggested_latency', [], @(x) isnumeric(x));
            p.addParamValue('select_channels', [], @(x) isempty(x) || ismatrix(x));

            p.parse(varargin{:});
            opts = p.Results;
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
            PsychPortAudio('Start', self.pointer, 0, 0, 1, 0);
        end

        function AddSlave(self, index, varargin)
            p = inputParser;
            p.FunctionName = 'AddSlave';
            p.addParamValue('mode', 1, @(x) any(x == [1, 2, 3, 7, 32, 64]));
            p.addParamValue('channels', 2, @(x) isnumeric(x));
            p.addParamValue('select_channels', [], @(x) isempty(x) || ismatrix(x));
            p.parse(varargin{:});
            opts = p.Results;

            self.slaves(index) = struct('pointer', [], ...
                            'mode', opts.mode, ...
                            'channels', opts.channels, ...
                            'select_channels', opts.select_channels);
            self.slaves(index).pointer = PsychPortAudio('OpenSlave', self.pointer, ...
                                                         opts.mode, opts.channels, ...
                                                         opts.select_channels);


        end

        function Fill(self, sounds, index)
            if exist(index)
                x = self.slaves(index).pointer;
            else
                x = self.master.pointer;
            end
            PsychPortAudio('FillBuffer', x, sounds);
        end

        function time = Play(self, when, index)
            if exist(index)
                x = self.slaves(index).pointer;
            else
                x = self.master.pointer;
            end
            time = PsychPortAudio('Start', x, 1, when, 1);
        end

        function Stop(self, index)
            if exist(index)
                x = self.slaves(index).pointer;
            else
                x = self.master.pointer;
            end
            PsychPortAudio('Stop', x);
        end

        function Close(self)
            PsychPortAudio('Close');
            delete(self);
        end

        function status = Status(self, index)
            if exist(index)
                x = self.slaves(index).pointer;
            else
                x = self.master.pointer;
            end
            status = PsychPortAudio('GetStatus', x);
        end
        
end
