% sampling_freq * max_line * time_buffer determines the input buffer size
srl = PsychSerial('port', '/dev/ttyACM0',...
                  'sampling_freq', 10,...
                  'max_line', 8,...
                  'time_buffer', 20);

% read one line, Blocking
[data, timestamp] = srl.Read(8, 1);

% read entire buffer, non-blocking
[data, timestamp] = srl.Read([], 0);

% NB: to do a blocking read of the entire buffer, would need something
% like:
% `data = srl.Read(srl.Get('BytesAvailable'), 1);`
% PTB doesn't allow unspecified bytes available in blocking reads

srl.Flush;

srl.Close;
