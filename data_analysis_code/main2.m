% for average formant coparison
clear; close all;

DIR = './sounds/';
%FILENAME = '魚兒-餘額.wav';
%FILENAME = '知識-姿勢.wav';
%FILENAME = '白金-白鯨.wav'
%FILENAME = '銀幕-螢幕.wav';
FILENAME_1 = 'aiueo_b_denoised';
FILENAME_2 = 'aiueo_a_aligned';
FILENAME_3 = 'rec_p18_LB_OL50_TR_50ms';
wav_path1 = [DIR FILENAME_1 '.wav'];
wav_path2 = [DIR FILENAME_2 '.wav'];
wav_path3 = [DIR FILENAME_3 '.wav'];
[y, fs1] = audioread(wav_path3);

[A_ave_1] = formant_analysis2(wav_path1,5);
[A_ave_2] = formant_analysis2(wav_path2, 4);

out = filter(2*A_ave_2, A_ave_1,y);
%sound(out, fs1);
audiowrite("./Results/ouput_low.wav",out, fs1)
Nfreqs = 1024;
fs = 16000;
df = fs/2/Nfreqs;
ff = 0:df:fs/2-df;

figure(1)
[H1,~]=freqz(1,A_ave_1,Nfreqs);
[H2,~]=freqz(1,A_ave_2,Nfreqs);
plot(ff,20*log10(abs(H1)));
hold on;
plot(ff,20*log10(abs(H2)));
legend("bone", "air")
[H3, ~]= freqz(A_ave_2, A_ave_1, Nfreqs);
figure(2)
plot(ff,20*log10(abs(H3)));
legend("gain")
% remove zeros
% F1_1 = F1_1(F1_1~=0);
% F2_1 = F2_1(F2_1~=0);
% F1_2 = F1_2(F1_2~=0);
% F2_2 = F2_2(F2_2~=0);
% F1_3 = F1_3(F1_3~=0);
% F2_3 = F2_3(F2_3~=0);
% F1_4 = F1_4(F1_4~=0);
% F2_4 = F2_4(F2_4~=0);
% F1_5 = F1_5(F1_5~=0);
% F2_5 = F2_5(F2_5~=0);





%legend("air", "bone")

setFontSizeForAll(12);
%% data mean variance display







