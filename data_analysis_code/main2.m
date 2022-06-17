% for average formant coparison
clear; close all;
%%
input = "andrew";
%%
DIR = './sounds/';
%FILENAME = '魚兒-餘額.wav';
%FILENAME = '知識-姿勢.wav';
%FILENAME = '白金-白鯨.wav'
%FILENAME = '銀幕-螢幕.wav';
switch input
    case "tony"
        FILENAME_1 = 'aiueo_a_aligned';
        wav_path1 = [DIR FILENAME_1 '.wav'];
    case "andrew"
        FILENAME_1 = 'aiueo';
        wav_path1 = [DIR FILENAME_1 '.flac'];
end
FILENAME_2 = 'aiueo_b_denoised';


wav_path2 = [DIR FILENAME_2 '.wav'];

%[y, fs1] = audioread(wav_path3);

[A_ave_air] = formant_analysis2(wav_path1, 4, 0.4);
[A_ave_bone] = formant_analysis2(wav_path2, 10, 0.2);
save("A_aves.mat", "A_ave_bone", "A_ave_air")

%out = filter(A_ave_2, A_ave_1,y);

%[out_low, d] = lowpass(out,5000,fs1);

%sound(out, fs1);
%audiowrite("./Results/ouput_low_med.wav",out, fs1)

Nfreqs = 1024;
fs = 16000;
df = fs/2/Nfreqs;
ff = 0:df:fs/2-df;

figure(1)
[H1,~]=freqz(1,A_ave_air,Nfreqs);
[H2,~]=freqz(1,A_ave_bone,Nfreqs);
plot(ff,20*log10(abs(H1)));
hold on;
plot(ff,20*log10(abs(H2)));
legend("air", "bone")
xlabel("Frequency(Hz)")
ylabel("Gain(dB)")
[H3, ~]= freqz(A_ave_air, A_ave_bone, Nfreqs);
figure(2)
plot(ff,20*log10(abs(H3)));
legend("gain")
xlabel("Frequency(Hz)")
ylabel("Gain(dB)")
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

setFontSizeForAll(14);
%% data mean variance display







