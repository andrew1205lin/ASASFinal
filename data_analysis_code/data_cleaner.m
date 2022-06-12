function [F1_out, F2_out] = data_cleaner(F1, F2, thres_range)
% input : intput vector, threhold range(outier will be removed)
% output : output vector

display = 1; % display med, std
assert(length(F1)==length(F2), "length of F1, F2 should be equal!")
%% Preprocess: remove [0,0] [0,x] [x,0]
for i = 1: length(F1)
    if F1(i) == 0 || F2(i) == 0
        F1(i) = 0;
        F2(i) = 0;
    end
    %fprintf("rm!\n")
end
F1 = F1(F1~=0);
F2 = F2(F2~=0);
%%
med_F1 = median(F1);
med_F2 = median(F2);
std_F1 = std(F1);
std_F2 = std(F2);
fprintf("F1 median: %.0f\n", med_F1);
fprintf("F1 std: %.0f\n", std_F1);
fprintf("F2 median: %.0f\n", med_F2);
fprintf("F2 std: %.0f\n\n", std_F2);

for i = 1: length(F1)
    if (abs(F1(i) - med_F1) > thres_range*std_F1) || (abs(F2(i) - med_F2) > thres_range*std_F2)
        F1(i) = 0;
        F2(i) = 0;
    end
    %fprintf("rm!\n")
end
F1 = F1(F1~=0);
F2 = F2(F2~=0);

F1_out = F1;
F2_out = F2;

end

