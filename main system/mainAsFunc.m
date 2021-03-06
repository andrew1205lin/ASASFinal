%% EE6641 HW: Linear prediction and time-varying filtering
% Created May 2013.data
% Last updated March 9, 2022 for this year's HW3.
% Yi-Wen Liu
% Modified to vowels transfrom final project
function y_low = mainAsFunc(y, sr)
%%
load("../data_analysis_code/vowels.mat", "bone", "air");
load("../data_analysis_code/A_aves.mat", "A_ave_air", "A_ave_bone")
%%
% Methods 
Overlap = 1; %[CHANGE THIS!]
Lookback =1; %[CHANGE THIS!]
Tail_rm = 1; %[CHANGE THIS!]
Voice_Convert = 0; %[CHANGE THIS!]
write_to_disk = 1; %[CHANGE THIS!]
fs = sr;


if Voice_Convert == 1
    [excit_disk, fs2] = audioread(EXCITAT);
    excit_disk = resample(excit_disk, fs, fs2);
end
sz = size(y);
% stereo 2 mono
if sz(2) ==2 
    y = (y(:, 1) + y(:, 2))./2;
end

%% Parameters to play with
framelen = 0.05; % second. [CHANGE THIS!]
p = 18; % linear prediction order. [CHANGE THIS!]
thres_percent = 0.01;
L = framelen*fs;
if L<=p
    disp('Linear prediction requires the num of equations to be greater than the number of variables.');
end
%%
if Overlap == 1
    Tail_rm =1;
end
Window = "Hann";
% SPECs
Nx = length(y); % signal length
nsc = L; % window length
if Overlap == 1
    nov = floor(nsc/2); % overlap length
else 
    nov = 0;
end

step = nsc - nov; % step length
stepLen = step/fs;
Nfreqs = 2^nextpow2(2*L-1)/2; 
numFrames = floor((Nx - nsc)/step) + 1;


% State
sw.emphasis = 1; % default = 1
sw.visOnly = 0; % Visualize the signal only. default = 0.
sw.display = 0;

% initialize excitation signal
excitat = zeros(1,length(y));
e_n = zeros(1,p+L);


% axis
df = fs/2/Nfreqs;
ff = 0:df:fs/2-df;

if sw.emphasis == 1
    y_emph = filter([1 -0.95],1,y); 
                %[PARAM] -0.95 may be tuned anywhere from 0.9 to 0.99
else
    y_emph = y;
end
y_emph = y_emph.';
%%
%sound(y_emph,fs);


%% Linear prediction and smooth synthesis of the estimated source e_n
%y_emph = excitat;
win = ones(1,nsc); % Rectangular window.
win2 = hamming(1,nsc); 
win3 = hann(1,nsc);
excitat = zeros(1,length(y));
e_n = zeros(1,p+nsc);
y_rec = zeros(1,length(y));
y_rec_n = zeros(1,p+nsc);
y_vc = zeros(1,length(y));
y_vc_n = zeros(1,p+nsc);

% set a threshold for voice activity detection
ymax = max(abs(y_emph));
thres = thres_percent*ymax;
for kk = 1:numFrames % frame index
    start = (kk-1)*step+1;
    final = start - 1+L;
    final_l = final + p;

    ind = [start:final];
    ind_l = [start:final_l];
    %Step1, windowing to take a frame
    ywin = y_emph(ind).*win; 

    % Step2, look-back method(concate this frame with past p smaples)
    if Lookback == 1
        if kk > 1
            ind_past = start-p: start-1;
            y_past = y_emph(ind_past);
        else
            y_past = zeros(1, p);
        end
        y_n = [y_past y_emph(ind)].*hann(1, L+p);
    else
        y_n = y_emph(ind).*win;
    end

    % Step3, Do prediction to get a sequence of params
    A = lpc(y_n,p); 
    
    if sw.visOnly
        excitat(ind) = 0; % Fill an output frame.
    else
        % Step4,  Use this params to calculate predicton error(ecitation signal)
        if ~Voice_Convert
            e_n = conv(A, y_n); % E = A*Y_N
            % Formant Conversion
            %voiced = IsVoiced(A);
            if median(abs(y_emph(ind))) > thres
                [F1, F2, vowel] = vowel_classifier(A, fs, 0, air); % LP coefs, sf, mimum_vowel_probability
                disp(vowel);
                [A] = formant_transform(A, F1, F2, vowel, air, bone, "change");
            else 
                disp("unvoiced");
            end
            
            y_rec_n = filter(1, A, e_n); % Y_N = E/A
        else
            e_n = excit_disk(ind);
            y_vc_n = filter(1, A, e_n);
        end
        
        
        if ~Voice_Convert
            if Lookback == 1 && Tail_rm == 1
                e_n = e_n(length(A) : length(A) + length(ind) - 1); % remove the tail (last p points) eand head
                y_rec_n = y_rec_n(length(A) : length(A) + length(ind) - 1);
            elseif Lookback == 1 && ~Tail_rm
                e_n = e_n(length(A) : end);  % remove head
                y_rec_n = y_rec_n(length(A) : end);
            elseif Tail_rm == 1
                e_n = e_n(1: 1 + length(ind)-1);
                y_rec_n = y_rec_n(1: 1 + length(ind)-1);
            else
                e_n = e_n(1: end);
                y_rec_n = y_rec_n(1: 1 + length(ind)-1); %???
            end
        end
        
        if Overlap == 1
            if Window == "Hann"
                e_n = e_n.*win3;
            elseif Window == "Hamming"
                e_n = e_n.*win2;
            else
                assert(0, "Please use Hann or Hamming Window!")
            end
        end
        
        if ~Voice_Convert
            if Tail_rm == 1
                excitat(ind) = excitat(ind) + e_n;
                y_rec(ind) =  y_rec(ind) + y_rec_n;
            else
                if kk >  1
                    excitat(start: start+p-1) = (excitat(start: start+p-1) + e_n(1:p))./2 ; %ave tail and head
                    if sum(excitat(start + p: final_l))>0
                        figure()
                        plot(excitat(start + p: final_l))
                    end
                    assert(sum(excitat(start + p: final_l))==0, "only head can have stored values!");

                    excitat(start + p: final_l) = e_n(p+1: end);
                else
                    excitat(ind_l) = excitat(ind_l) + e_n;
                end
            end
        else
            y_vc(ind) = y_vc(ind) + y_vc_n.'; %voice convert signal
        end
    end
    Y = fft(ywin,2*Nfreqs);
    %% Data visualization
    if sw.display
        figure(1);
        subplot(221);
        plot(ind/fs*1000, y(ind));
        xlabel('ms')
        set(gca,'xlim',[kk-1 kk]*stepLen*1000);
        subplot(222);
        if Tail_rm == 1
            plot(ind/fs*1000, e_n);
        else
            plot(ind_l/fs*1000, e_n);
        end
        set(gca,'xlim',[kk-1 kk]*stepLen*1000);

        subplot(223);
        [H,W] = freqz(1,A,Nfreqs);
        Hmag = 20*log10(abs(H));
        Ymag = 20*log10(abs(Y(1:Nfreqs))); % NEED DEBUG
        Hmax = max(Hmag);
        offset = max(Hmag) - max(Ymag);
        plot(ff,Hmag); hold on;
        plot(ff,Ymag+offset,'r'); hold off;
        set(gca,'xlim',[0 fs/2],'ylim',[Hmax-50, Hmax+50]);
        xlabel('Hz')

        subplot(224);
        plot(ff,Ymag+offset-Hmag.');
        set(gca,'xlim',[0 fs/2],'ylim',[-30, 25]);
        xlabel('Hz');

        drawnow;
    end
    %pause;
end
%% remove nan 
y_rec(isnan(y_rec)) = 0;
y_rec = limiter(y_rec);
%% LOW gain using average envelope/coefs
y_low = filter(A_ave_air, A_ave_bone ,y_rec);
%freqz(A_ave_air, A_ave_bone, [], 16000)
%% limiter
y_low = limiter(y_low);


end
