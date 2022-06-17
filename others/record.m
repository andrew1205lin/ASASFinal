DIR = './HW3-sounds/';
FILENAME = 'record.wav';
recObj = audiorecorder;
recordblocking(recObj, 2);
play(recObj);
record_y = getaudiodata(recObj);

%audiowrite(DIR+FILENAME,record_y,recObj.SampleRate);