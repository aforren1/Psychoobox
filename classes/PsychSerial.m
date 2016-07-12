classdef PsychSerial < PsychHandle

    properties (SetAccess = public, GetAccess = public)
        lenient; % true/false
        port; % /dev/ttyACM0
        baud_rate; % 9600
        parity; % None

        data_bits; % 8
        stop_bits; % 1
        flow_control; % None
        terminator; % 10

        send_timeout; % 1
        receive_timeout; % 0.1
        receive_latency; % 0.0001
        poll_latency; % 0.0005

        start_background_read; % 1
        blocking_background_read; % 1
        read_filter_flags; % 4
        sampling_freq; % 120??

        max_line; % in bytes
        time_buffer; % in seconds
        read_buffer; % max_line * sampling_freq * time_buffer
        pointer;

         %BaudRate=%i InputBufferSize=%i Terminator=0 ReceiveTimeout=%f ReceiveLatency=0.0001'
        %asyncSetup = sprintf('%s BlockingBackgroundRead=1 StartBackgroundRead=1', joker);
%IOPort('ConfigureSerialPort', myport, asyncSetup);


    end

    methods
        function self = PsychSerial(varargin)

            p = inputParser;
            p.FunctionName = 'PsychSerial';
            p.addParamValue('lenient', false, @(x) islogical(x));
            p.addParamValue('port', [], @(x) isempty(x) || ischar(x));
            p.addParamValue('baud_rate', 9600, @(x) isnumeric(x));
            p.addParamValue('parity', 'None', @(x) ischar(x));

            p.addParamValue('data_bits', 8, @(x) isnumeric(x));
            p.addParamValue('stop_bits', 1, @(x) isnumeric(x));
            p.addParamValue('flow_control', 'None', @(x) ischar(x));
            p.addParamValue('terminator', 10, @(x) isnumeric(x));

            p.addParamValue('send_timeout', 1, @(x) isnumeric(x));
            p.addParamValue('receive_timeout', 0.1, @(x) isnumeric(x));
            p.addParamValue('receive_latency', 0.0001, @(x) isnumeric(x));

            p.addParamValue('start_background_read', 1, @(x) isnumeric(x));
            p.addParamValue('blocking_background_read', 0, @(x) any(x == [0 1]));
            p.addParamValue('read_filter_flags', 0, @(x) any(x == [1 2 4]));
            p.addParamValue('sampling_freq', 120, @(x) isempty(x) || isnumeric(x));

            % guess at how many bytes per line, max
            p.addParamValue('max_line', 16, @(x) isnumeric(x));
            p.addParamValue('time_buffer', 120, @(x) isnumeric(x));
            p.parse(varargin{:});
            opts = p.Results;
            for fns = fieldnames(opts)'
                self.(fns{1}) = opts.(fns{1});
            end

            % two minutes' worth of data
            self.read_buffer = ceil(opts.max_line * opts.sampling_freq * opts.time_buffer);

            if isempty(opts.port)
                opts.port = FindSerialPort([], 1);
            end

            if opts.lenient
                opts.lenient = 'Lenient';
            else
                opts.lenient = [];
            end

            init_settings = sprintf('%s Parity=%i DataBits=%i StopBits=%i FlowControl=%s BaudRate=%i InputBufferSize=%i Terminator=0 ReceiveTimeout=%f ReceiveLatency=%f',...
                                   opts.lenient, opts.parity, ...
                                   opts.data_bits, ...
                                   opts.stop_bits, opts.flow_control,...
                                   opts.baud_rate, self.read_buffer, ...
                                   opts.terminator, opts.receive_timeout,...
                                   opts.receive_latency);

             async_settings = sprintf('BlockingBackgroundRead=%i ReadFilterFlags=%i StartBackgroundRead=%i', ...
                                      opts.blocking_background_read, ...
                                      opts.read_filter_flags, ...
                                      opts. start_background_read);

             self.pointer = IOPort('OpenSerialPort', opts.port, init_settings);

             IOPort('ConfigureSerialPort', self.pointer, async_settings);
        end



    end


end
