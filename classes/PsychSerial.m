classdef PsychSerial < PsychHandle

    properties (SetAccess = public, GetAccess = public)
        port;
        baud_rate;
        terminator;
         %BaudRate=%i InputBufferSize=%i Terminator=0 ReceiveTimeout=%f ReceiveLatency=0.0001'
        %asyncSetup = sprintf('%s BlockingBackgroundRead=1 StartBackgroundRead=1', joker);
%IOPort('ConfigureSerialPort', myport, asyncSetup);


    end

    methods
        function self = PsychSerial(varargin)

            p = inputParser;
            p.FunctionName = 'PsychSerial';
            p.addParamValue('port', [], @(x) isempty(x) || ischar(x));
            if isempty(opts.port)
                opts.port = FindSerialPort([], 1);
            end

        end



    end


end
