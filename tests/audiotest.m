
aud = PobAudio();
snd1 = audioread('res/scaled_coin.wav');
aud.Add('slave', 1);
aud.Add('slave', 2);
aud.Add('buffer', 1, 'audio', [snd1, snd1]');
aud.Map(1, 1);
aud.Map(2, 1);

aud.Play(1, 0);
WaitSecs(.5);
aud.Stop(1);
aud.Remove('buffer', 1);
aud.Remove('slave', 1);
aud.Close;
