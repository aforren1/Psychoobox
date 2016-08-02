% sampling_freq * max_line * time_buffer determines the input buffer size
srl = PsychSerial('port', '/dev/ttyACM0',...
                  'sampling_freq', 10,...
                  'max_line', 8,...
                  'time_buffer', 20);

% purge the first two seconds of data
WaitSecs(2);
srl.Purge;

% read one line, blocking
[data, timestamp] = srl.Read(8, 1);

% convert to "true" values
teensy_time = typecast(uint8(data(1:4), 'int32'));
teensy_point1 = typecast(uint8(data(5:6), 'int16'));
teensy_point2 = typecast(uint8(data(7:8), 'int16'));

% read entire buffer, non-blocking
[data, timestamp] = srl.Read([], 0);

%en masse conversion
data = reshape(data, 8, length(data))';
% ???

% NB: to do a blocking read of the entire buffer, would need something
% like:
% `data = srl.Read(srl.Get('BytesAvailable'), 1);`
% PTB doesn't allow unspecified bytes available in blocking reads

srl.Flush;

srl.Close;
