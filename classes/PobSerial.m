classdef PobSerial < handle
% PobSerial Communicate with real and imaginary serial devices.
%
% Interface to IOPort.
%
% PobSerial Properties:
%    port - String representing serial port, eg. '/dev/ttyS0' or 'COM3'. If empty, will make an educated guess on desired port.
%    baud_rate - Specifies how quickly data is sent. Defaults to 9600.
%    terminator - ASCII representation of the end-of-line. Defaults to 10 (newline).
%
%    The following three args are used to determine the input buffer size:
%    max_line - Maximum expected bytes per line.
%    time_buffer - Duration of buffer. Defaults to 120 seconds.
%    sampling_freq - Expected sampling rate. Defaults to 120 Hz.
%
%    lenient - Keep going despite some errors (true/false). Defaults to false.
%    parity - None, Even, or Odd. Defaults to None.
%    data_bits - Number of data bits per character (5 - 8). Defaults to 8.
%    stop_bits - Signals end of a character (1 - 2). Defaults to 1.
%
%    flow_control - Defaults to None.
%    send_timeout - (Windows only) Inter-byte send timeout (seconds). Defaults to 1.
%    receive_timeout - Inter-byte receive timeout (seconds). Defaults to 1.
%    receive_latency - (Some OSX, Linux) Latency for processing new bytes (seconds). Defaults to 0.0001.
%
%    poll_latency - Latency between polls (seconds). Defaults to 0.0005.
%    start_background_read - Asynchronous read (in bytes). Defaults to 1.
%    blocking_background_read - Blocking background reads (1) vs. polling reads (0). Defaults to 1.
%    read_filter_flags - See `IOSerial OpenSerialPort?`. Defaults to 0.
%
% PobSerial Methods:
%
%     Read - Blocking and non-blocking reads.
%     Write - Blocking and non-blocking writes.
%     Flush - Purge data queued for writeout to device.
%     Purge - Purge data queued for reading and writing.
%     Close - Close the device and delete the handle.
%     Get - Get values.
%     Set - Set values.
%     Print - See values.
%
% Example:
%
% srl = IOPort('lenient', true, ...
%              'port', '/dev/ttyACM0', ...
%              'baud_rate', 9600, ...
%              'sampling_freq', 200,...
%              'max_line', 16,...
%              'time_buffer', 20);
%
% [data, timestamp] = srl.Read(self.max_line, 1); % blocking read
%
% [num_written, timestamp, error_msg,...
%  pre_time, post_time, last_check_time] = srl.Write('s', 0); % non-blocking write
%
% srl.Close; % Stop any background operations and close the device
    properties (SetAccess = public, GetAccess = public)
        lenient;
        port;
        baud_rate;
        parity;

        data_bits;
        stop_bits;
        flow_control;
        terminator;

        send_timeout;
        receive_timeout;
        receive_latency;
        poll_latency;

        start_background_read;
        blocking_background_read;
        read_filter_flags;
        sampling_freq;

        max_line;
        time_buffer;
        input_buffer_size;
        pointer;

        param_names;
        p;
    end

    methods
        function self = PobSerial(varargin)
            self.p = inputParser;
            self.p.FunctionName = 'PobSerial';
            self.p.addParamValue('lenient', false, @(x) islogical(x));
            self.p.addParamValue('port', [], @(x) isempty(x) || ischar(x));
            self.p.addParamValue('baud_rate', 9600, @(x) isnumeric(x));
            self.p.addParamValue('parity', 'None', @(x) any(not(cellfun('isempty', strfind({'None', 'Even', 'Odd'}, x)))));

            self.p.addParamValue('data_bits', 8, @(x) isnumeric(x));
            self.p.addParamValue('stop_bits', 1, @(x) isnumeric(x));
            self.p.addParamValue('flow_control', 'None', @(x) ischar(x));
            self.p.addParamValue('terminator', 10, @(x) isnumeric(x));

            self.p.addParamValue('send_timeout', 1, @(x) isnumeric(x));
            self.p.addParamValue('receive_timeout', 1, @(x) isnumeric(x));

            self.p.addParamValue('start_background_read', 1, @(x) isnumeric(x));
            self.p.addParamValue('blocking_background_read', 0, @(x) any(x == [0 1]));
            self.p.addParamValue('read_filter_flags', 0, @(x) any(x == [0 1 2 4]));
            self.p.addParamValue('sampling_freq', 120, @(x) isempty(x) || isnumeric(x));

            % guess at how many bytes per line, max
            self.p.addParamValue('max_line', 16, @(x) isnumeric(x));
            self.p.addParamValue('time_buffer', 120, @(x) isnumeric(x));
            self.p.parse(varargin{:});
            opts = self.p.Results;
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
