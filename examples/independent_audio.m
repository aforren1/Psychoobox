
snd1 = wavread('misc/beep.wav');
snd2 = wavread('misc/smw_coin.wav');

aud = PsychAudio('mode', 9);
aud.AddSlave(1, 'channels', 1, 'select_channels', 1); % left ear
aud.AddSlave(2, 'channels', 1, 'select_channels', 2); % right ear

aud.Fill(snd1', 1);
aud.Fill(snd2', 2);

simultaneous_time = GetSecs + 2;
t1 = aud.Play(simultaneous_time, 1);
t2 = aud.Play(simultaneous_time, 2);

% give it enough time to play
WaitSecs(2);
aud.Close;
t2 - t1
