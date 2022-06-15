clear; close all;
%%
DIR = './sounds/';
save2txt = 0;
%FILENAME = '魚兒-餘額.wav';
%FILENAME = '知識-姿勢.wav';
%FILENAME = '白金-白鯨.wav'
%FILENAME = '銀幕-螢幕.wav';
FILENAME_1 = 'i_a_aligned';
FILENAME_2 = 'e_a_aligned';
FILENAME_3 = 'a_a_aligned';
FILENAME_4 = 'o_a_aligned';
FILENAME_5 = 'u_a_aligned';

FILENAME_6 = 'i_b_denoised';
FILENAME_7 = 'e_b_denoised';
FILENAME_8 = 'a_b_denoised';
FILENAME_9 = 'o_b_denoised';
FILENAME_10 = 'u_b_denoised';



wav_path1 = [DIR FILENAME_1 '.wav'];
wav_path2 = [DIR FILENAME_2 '.wav'];
wav_path3 = [DIR FILENAME_3 '.wav'];
wav_path4 = [DIR FILENAME_4 '.wav'];
wav_path5 = [DIR FILENAME_5 '.wav'];
wav_path6 = [DIR FILENAME_6 '.wav'];

wav_path7 = [DIR FILENAME_7 '.wav'];
wav_path8 = [DIR FILENAME_8 '.wav'];
wav_path9 = [DIR FILENAME_9 '.wav'];
wav_path10 = [DIR FILENAME_10 '.wav'];

[F1_1, F2_1, F3_1, ~] = formant_analysis(wav_path1, 0.01);
[F1_2, F2_2, F3_2, ~] = formant_analysis(wav_path2, 0.01);
[F1_3, F2_3, F3_3, ~] = formant_analysis(wav_path3, 0.01);
[F1_4, F2_4, F3_4, ~] = formant_analysis(wav_path4, 0.01);
[F1_5, F2_5, F3_5, ~] = formant_analysis(wav_path5, 0.01);

[F1_6, F2_6, F3_6, ~] = formant_analysis(wav_path6, 0.4);
[F1_7, F2_7, F3_7, ~] = formant_analysis(wav_path7, 0.4);
[F1_8, F2_8, F3_8, ~] = formant_analysis(wav_path8, 0.4);
[F1_9, F2_9, F3_9, ~] = formant_analysis(wav_path9, 0.4);
[F1_10, F2_10, F3_10, ~] = formant_analysis(wav_path10, 0.4);
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

% remove unreliable points(distance bigger than 1 std will be rm)
[F1_1, F2_1] = data_cleaner(F1_1, F2_1, 2.5); 
[F1_2, F2_2] = data_cleaner(F1_2, F2_2, 2.5);
[F1_3, F2_3] = data_cleaner(F1_3, F2_3, 2.5);
[F1_4, F2_4] = data_cleaner(F1_4, F2_4, 2.5);
[F1_5, F2_5] = data_cleaner(F1_5, F2_5, 2.5);

[F1_6, F2_6] = data_cleaner(F1_6, F2_6, 1.2); 
[F1_7, F2_7] = data_cleaner(F1_7, F2_7, 1.2);
[F1_8, F2_8] = data_cleaner(F1_8, F2_8, 1.2);
[F1_9, F2_9] = data_cleaner(F1_9, F2_9, 1.2);
[F1_10, F2_10] = data_cleaner(F1_10, F2_10, 1.2);

 
f1f2_diagram(F1_1, F2_1, 0, 1, 'red', 1); %(f1,f2, save, overlay, color, filled)
f1f2_diagram(F1_2, F2_2, 0, 1, 'yellow', 1);
f1f2_diagram(F1_3, F2_3, 0, 1, 'black', 1);
f1f2_diagram(F1_4, F2_4, 0, 1, 'green', 1);
f1f2_diagram(F1_5, F2_5, 0, 1, 'blue', 1);

f1f2_diagram(F1_6, F2_6, 0, 1, 'red', 0); %(f1,f2, save, overlay, color, filled)
f1f2_diagram(F1_7, F2_7, 0, 1, 'yellow', 0);
f1f2_diagram(F1_8, F2_8, 0, 1, 'black', 0);
f1f2_diagram(F1_9, F2_9, 0, 1, 'green', 0);
f1f2_diagram(F1_10, F2_10, 0, 1, 'blue', 0);
%legend("air", "bone")

title("vowels")
setFontSizeForAll(12);

air.i.f1_ave =  median(F1_1);
air.i.f1_std = std(F1_1);
air.i.f2_ave = median(F2_1);
air.i.f2_std = std(F2_2);

air.e.f1_ave =  median(F1_2);
air.e.f1_std = std(F1_2);
air.e.f2_ave = median(F2_2);
air.e.f2_std = std(F2_2);

air.a.f1_ave =  median(F1_3);
air.a.f1_std = std(F1_3);
air.a.f2_ave = median(F2_3);
air.a.f2_std = std(F2_3);

air.o.f1_ave =  median(F1_4);
air.o.f1_std = std(F1_4);
air.o.f2_ave = median(F2_4);
air.o.f2_std = std(F2_4);

air.u.f1_ave =  median(F1_5);
air.u.f1_std = std(F1_5);
air.u.f2_ave = median(F2_5);
air.u.f2_std = std(F2_5);

bone.i.f1_ave =  median(F1_6);
bone.i.f1_std = std(F1_6);
bone.i.f2_ave = median(F2_6);
bone.i.f2_std = std(F2_6);

bone.e.f1_ave =  median(F1_7);
bone.e.f1_std = std(F1_7);
bone.e.f2_ave = median(F2_7);
bone.e.f2_std = std(F2_7);

bone.a.f1_ave =  median(F1_8);
bone.a.f1_std = std(F1_8);
bone.a.f2_ave = median(F2_8);
bone.a.f2_std = std(F2_8);

bone.o.f1_ave =  median(F1_9);
bone.o.f1_std = std(F1_9);
bone.o.f2_ave = median(F2_9);
bone.o.f2_std = std(F2_9);

bone.u.f1_ave =  median(F1_10);
bone.u.f1_std = std(F1_10);
bone.u.f2_ave = median(F2_10);
bone.u.f2_std = std(F2_10);

save('vowels.mat', "bone", "air")
%% data mean variance display
if save2txt 
    fileID = fopen('./Results/vowel_formant_b.txt','w');
    fprintf(fileID, "----i----\n");
    fprintf(fileID, "F1 median: %.0f\n", median(F1_1));
    fprintf(fileID, "F1 std: %.0f\n", std(F1_1));
    fprintf(fileID, "F2 median: %.0f\n", median(F2_1));
    fprintf(fileID, "F2 std: %.0f\n", std(F2_1));
    fprintf(fileID, "----e----\n");
    fprintf(fileID, "F1 median: %.0f\n", median(F1_2));
    fprintf(fileID, "F1 std: %.0f\n", std(F1_2));
    fprintf(fileID, "F2 median: %.0f\n", median(F2_2));
    fprintf(fileID, "F2 std: %.0f\n", std(F2_2));
    fprintf(fileID, "----a----\n");
    fprintf(fileID, "F1 median: %.0f\n", median(F1_3));
    fprintf(fileID, "F1 std: %.0f\n", std(F1_3));
    fprintf(fileID, "F2 median: %.0f\n", median(F2_3));
    fprintf(fileID, "F2 std: %.0f\n", std(F2_3));
    fprintf(fileID, "----o----\n");
    fprintf(fileID, "F1 median: %.0f\n", median(F1_4));
    fprintf(fileID, "F1 std: %.0f\n", std(F1_4));
    fprintf(fileID, "F2 median\n: %.0f", median(F2_4));
    fprintf(fileID, "F2 std: %.0f\n", std(F2_4));
    fprintf(fileID, "----u----\n");
    fprintf(fileID, "F1 median: %.0f\n", median(F1_5));
    fprintf(fileID, "F1 std: %.0f\n", std(F1_5));
    fprintf(fileID, "F2 median: %.0f\n", median(F2_5));
    fprintf(fileID, "F2 std: %.0f\n", std(F2_5));
end





