function [f1, f2, vowel] = vowel_classifier(A, fs)
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

end


