%% Real-Time Audio Stream Processing
%
% The Audio System Toolbox provides real-time, low-latency processing of
% audio signals using the System objects audioDeviceReader and
% audioDeviceWriter.
%
% This example shows how to acquire an audio signal using your microphone,
% perform basic signal processing, and play back your processed
% signal.
%
%%
load("../data_analysis_code/vowels.mat", "bone", "air");
load("../data_analysis_code/A_aves.mat", "A_ave_air", "A_ave_bone")
%% parameters
inbuffer_dur = 0.5; % 1sec
outbuffer_dur = 0.3;
sr = 16000;
inbuffer_size = inbuffer_dur*sr;
outbuffer_size = outbuffer_dur*sr;
%% Create input and output objects
deviceReader = audioDeviceReader(16000, inbuffer_size);
deviceWriter = audioDeviceWriter('SampleRate',deviceReader.SampleRate, "BufferSize", outbuffer_size);

%% Specify an audio processing algorithm
% For simplicity, only add gain.
process = @(x) x.*5;

%% Code for stream processing
% Place the following steps in a while loop for continuous stream
% processing:
%   1. Call your audio device reader with no arguments to
%   acquire one input frame. 
%   2. Perform your signal processing operation on the input frame.
%   3. Call your audio device writer with the processed
%   frame as an argument.

disp('Begin Signal Input...')
tic
while toc<30
    mySignal = deviceReader();
    myProcessedSignal = mainAsFunc(mySignal,sr);
    deviceWriter(myProcessedSignal');
end
disp('End Signal Input')

release(deviceReader)
release(deviceWriter)