clear; close all;

DIR = './sounds/';
%FILENAME = '魚兒-餘額.wav';
%FILENAME = '知識-姿勢.wav';
%FILENAME = '白金-白鯨.wav'
%FILENAME = '銀幕-螢幕.wav';
FILENAME_1 = 'i_b_denoised';
FILENAME_2 = 'e_b_denoised';
FILENAME_3 = 'a_b_denoised';
FILENAME_4 = 'o_b_denoised';
FILENAME_5 = 'u_b_denoised';

wav_path1 = [DIR FILENAME_1 '.wav'];
wav_path2 = [DIR FILENAME_2 '.wav'];
wav_path3 = [DIR FILENAME_3 '.wav'];
wav_path4 = [DIR FILENAME_4 '.wav'];
wav_path5 = [DIR FILENAME_5 '.wav'];


[F1_1, F2_1, F3_1] = formant_analysis(wav_path1, 0.35);
[F1_2, F2_2, F3_2] = formant_analysis(wav_path2, 0.35);
[F1_3, F2_3, F3_3] = formant_analysis(wav_path3, 0.35);
[F1_4, F2_4, F3_4] = formant_analysis(wav_path4, 0.35);
[F1_5, F2_5, F3_5] = formant_analysis(wav_path5, 0.35);

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

f1f2_diagram(F1_2, F2_2, 0, 0, 'black');
% remove unreliable points(distance bigger than 1 std will be rm)
[F1_1, F2_1] = data_cleaner(F1_1, F2_1, 1.2); 
[F1_2, F2_2] = data_cleaner(F1_2, F2_2, 1.2);
[F1_3, F2_3] = data_cleaner(F1_3, F2_3, 1.2);
[F1_4, F2_4] = data_cleaner(F1_4, F2_4, 1.2);
[F1_5, F2_5] = data_cleaner(F1_5, F2_5, 1.2);

 
f1f2_diagram(F1_1, F2_1, 0, 0, 'red'); %(f1,f2, save, overlay, color)
f1f2_diagram(F1_2, F2_2, 0, 1, 'yellow');
f1f2_diagram(F1_3, F2_3, 0, 1, 'black');
f1f2_diagram(F1_4, F2_4, 0, 1, 'green');
f1f2_diagram(F1_5, F2_5, 0, 1, 'blue');


%legend("air", "bone")

title("vowels")
setFontSizeForAll(12);
%% data mean variance display
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






