function plot_formant_trajectories(y, f1, f2, f3 ,win_period, fs, save=1)
%F1F2_TRAJECTORIES Summary of this function goes here
% INPUT: y(sound), F1, F2, F3(canBeEmpty), window period, sampling rate
% OUTPUT: a trajectories plot

L = win_period*fs;
framelen = win_period;
%% Plotting the f1, f2 trajectories
win_hann = hann(L+1);
win_hann = win_hann(1:end-1);
param.fs = fs;
% spectrogram
S = mySpecgram(y_emph, win_hann, 0, 2*Nfreqs, param); % x, win, Novlp, Nfft, param
hold on;
% Formant trajectories
h = plot((1:numFrames)*L/fs, f1/1000, 'x');
set(h,'color','g');
plot((1:numFrames)*L/fs, f2/1000, '.');
if isempty(f3) ~= 0
    plot((1:numFrames)*L/fs, f3/1000, '.');
end
set(gcf,'position',[300 360 1100 420]);
ti = "p"+ num2str(p) + ", " + num2str(framelen*1000) + "ms";
title(ti);

%setFontSizeForAll(18); % This function is a plotting routine I created. 
                        % It goes through all the figures and set the font
                        % the same size.
% output path
Folder = "./Results/";
name = FILENAME + "_p"+ num2str(p) + "_" + num2str(framelen*1000) + "_ms.png";
path = Folder + name;

if save == 1
    saveas(gcf,path);
end


end

