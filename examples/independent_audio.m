
aud = PsychAudio('');
aud.AddSlave(1, 'channels', 1, 'select_channels', 1); % left ear
aud.AddSlave(2, 'channels', 1, 'select_channels', 2); % right ear

aud.Fill(snd1, 1);
aud.Fill(snd2, 2);

simultaneous_time = GetSecs + 2;
aud.Play(simultaneous_time, 1);
aud.Play(simultaneous_time, 2);

aud.Close;
