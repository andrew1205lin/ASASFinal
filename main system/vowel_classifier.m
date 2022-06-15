function [f1, f2, vowel] = vowel_classifier(A, fs, threshold ,air_data)
air = air_data;
% input: LPC coefs, fs
% output: f1, f2, vowel
poles = roots(A); % A->zero; 1/A->pole\, this will on a complex plain: poles = moduli*e^(j*omega)
omega = angle(poles); % between  -pi and pi
moduli = abs(poles); % magnitude
qq = (omega > 0); % find those with their angles between 0 and pi
poles = poles(qq);
omega = omega(qq);
moduli = moduli(qq);
tmp_matrix = [poles omega moduli];
tmp_matrix = sortrows(tmp_matrix,2);
f1 = tmp_matrix(1,2)/pi*fs/2; % Hz, 1st formant
f2 = tmp_matrix(2,2)/pi*fs/2; % Hz, 2nd formant
% f3 = tmp_matrix(3,2)/pi*fs/2; % 3rd formant
% New version( multivariate normal distribution)
probab_a = mvnpdf([f1, f2], [air.a.f1_ave, air.a.f2_ave], [air.a.f1_std^2, air.a.f2_std^2]);
probab_i = mvnpdf([f1, f2], [air.i.f1_ave, air.i.f2_ave], [air.i.f1_std^2, air.i.f2_std^2]);
probab_u = mvnpdf([f1, f2], [air.u.f1_ave, air.u.f2_ave], [air.u.f1_std^2, air.u.f2_std^2]);
probab_e = mvnpdf([f1, f2], [air.e.f1_ave, air.e.f2_ave], [air.e.f1_std^2, air.e.f2_std^2]);
probab_o = mvnpdf([f1, f2], [air.o.f1_ave, air.o.f2_ave], [air.o.f1_std^2, air.o.f2_std^2]);
% fprintf("a's probability: %.4f\n", probab_a*2500);
% fprintf("i's probability: %.4f\n", probab_i*2500);
% fprintf("u's probability: %.4f\n", probab_u*2500);
% fprintf("e's probability: %.4f\n", probab_e*2500);
% fprintf("o's probability: %.4f\n", probab_o*2500);
[max_probab, idx] = max([probab_a, probab_i, probab_u, probab_e, probab_o]);
if max_probab*2500 < threshold
    vowel = "undefinable";
    return
end
switch idx
    case 1 
        vowel = "a";
    case 2
        vowel = "i";
    case 3
        vowel = "u";
    case 4
        vowel = "e";
    case 5
        vowel = "o";
end
% old version
%{
if f1 > 300 && f1 < 450  && f2  > 1700 && f2 < 2000
    vowel = 'i';
elseif f1 > 450 && f1 < 610  && f2  > 1500 && f2 < 2000
    vowel = 'e';
elseif f1 > 600 && f1 < 800  && f2  > 1300 && f2 < 1500
    vowel = 'a';
elseif f1 > 480 && f1 < 800  && f2  > 1000 && f2 < 1300
    vowel = 'o';
elseif f1 > 250 && f1 < 480  && f2  > 900 && f2 < 1300
    vowel = 'u';
else
    vowel = 'undefinable';
end
%}
end


