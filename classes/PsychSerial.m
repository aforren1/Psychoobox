classdef PsychSerial < PsychHandle
% PsychSerial Communicate with real and imaginary serial devices.
%
% Interface to IOPort.
%
% PsychSerial Properties:
%    port - String representing serial port, eg. '/dev/ttyS0' or 'COM3'. If empty, will make an educated guess on desired port.
%    baud_rate - Specifies how quickly data is sent. Defaults to 9600.
%    parity - None, Even, or Odd.
%    lenient - true/false (good for setting up)
%
%    data_bits -
%    stop_bits -
%    flow_control;
%    terminator;
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
        input_buffer_size; % max_line * sampling_freq * time_buffer
        pointer;

        param_names;
    end

    methods
        function self = PsychSerial(varargin)

            p = inputParser;
            p.FunctionName = 'PsychSerial';
            p.addParamValue('lenient', false, @(x) islogical(x));
            p.addParamValue('port', [], @(x) isempty(x) || ischar(x));
            p.addParamValue('baud_rate', 9600, @(x) isnumeric(x));
            p.addParamValue('parity', 'None', @(x) any(not(cellfun('isempty', strfind(x, {'None', 'Even', 'Odd'})))));

            p.addParamValue('data_bits', 8, @(x) isnumeric(x));
            p.addParamValue('stop_bits', 1, @(x) isnumeric(x));
            p.addParamValue('flow_control', 'None', @(x) ischar(x));
            p.addParamValue('terminator', 10, @(x) isnumeric(x));

            p.addParamValue('send_timeout', 1, @(x) isnumeric(x));
            p.addParamValue('receive_timeout', 0.1, @(x) isnumeric(x));

            p.addParamValue('start_background_read', 1, @(x) isnumeric(x));
            p.addParamValue('blocking_background_read', 0, @(x) any(x == [0 1]));
            p.addParamValue('read_filter_flags', 0, @(x) any(x == [0 1 2 4]));
            p.addParamValue('sampling_freq', 120, @(x) isempty(x) || isnumeric(x));

            % guess at how many bytes per line, max
            p.addParamValue('max_line', 16, @(x) isnumeric(x));
            p.addParamValue('time_buffer', 120, @(x) isnumeric(x));
            p.parse(varargin{:});
            opts = p.Results;
            if isempty(opts.port)
                opts.port = FindSerialPort([], 1);
            end

            if opts.lenient
                opts.lenient = 'Lenient';
            else
                opts.lenient = [];
            end

            for fns = fieldnames(opts)'
                self.(fns{1}) = opts.(fns{1});
            end
            param_names = fieldnames(opts);
            % two minutes' worth of data
            self.input_buffer_size = ceil(opts.max_line * opts.sampling_freq * opts.time_buffer);

            init_settings = sprintf(['%s Parity=%s DataBits=%i StopBits=%i ', ...
                                     'FlowControl=%s BaudRate=%i InputBufferSize=%i ',...
                                     'Terminator=%i ReceiveTimeout=%f ',...
                                     'BlockingBackgroundRead=%i ReadFilterFlags=%i ',...
                                     'StartBackgroundRead=%i'], ...
                                    opts.lenient, opts.parity, ...
                                    opts.data_bits, ...
                                    opts.stop_bits, opts.flow_control,...
                                    opts.baud_rate, self.input_buffer_size, ...
                                    opts.terminator, opts.receive_timeout,...
                                    opts.blocking_background_read, ...
                                    opts.read_filter_flags, ...
                                    opts.start_background_read);

            self.pointer = IOPort('OpenSerialPort', opts.port, init_settings);
        end % end constructor

        function Set(self, property, value)
            % find the index of the property
            Set@PsychHandle(self, property, value);
            property = strrep(property, '_', '');
            idx = find(not(cellfun('isempty', (strfind(property, tolower(self.param_names))))));
            IOPort('ConfigureSerialPort', self.pointer, [self.param_names{idx}, '=', value]);
        end

        function value = Get(self, property)
            if strcmpi(property, 'BytesAvailable')
                value = IOPort('BytesAvailable', self.pointer);
            else
                value = Get@PsychHandle(self, property);
            end
        end

        function [data, timestamp] = Read(self, amount, blocking)
            if ~exist('blocking', 'var')
                blocking = 0;
            end
            if ~exist('amount', 'var')
                amount = [];
            end
            [data, timestamp] = IOPort('Read', self.pointer, blocking, amount);
        end

        function [num_written, timestamp, error_msg,...
                  pre_time, post_time, last_check_time] = Write(self, data, blocking);
            if ~exist('blocking', 'var')
              blocking = 0;
            end
            [num_written, timestamp, error_msg,...
             pre_time, post_time, last_check_time] = IOPort('Write', self.pointer, data, blocking);
        end

        function Flush(self)
            IOPort('Flush', self.pointer);
        end

        % flush write and read data
        function Purge(self)
            IOPort('Purge', self.pointer);
        end

        function Close(self)
            IOPort('ConfigureSerialPort', self.pointer, 'StopBackgroundRead');
            IOPort('Close', self.pointer);
            delete(self);
        end

    end % end methods
end % end classdef
