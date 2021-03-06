%% EE6641 HW: minimal pair comparisons
% Created March 24, 2022 for this year's HW4.
% Yi-Wen Liu
% Modified by Tung Cheng Su
%%%%%%%%%%%%%%%%
% Input:  wav path, thres_percent(comp. to max), # of coefs
% Output: F1,F2, F3 (arrays)
%%%%%%%%%%%%%%%%

function [A_ave] = formant_analysis2(wav_path,numCoefs,thres_percent)
[y, fs1] = audioread(wav_path);

%% stereo to mono

[h, w] = size(y);
if w == 2
    y = y(:,1) + y(:,2);
end

%soundsc(y1,fs1);
fs = 16000;

if fs1 ~= fs
    y = resample(y,fs,fs1);
end
%% Parameters to play with
framelen = 0.050; % second. [INVESTIGATE]
p = numCoefs; % linear prediction order. [INVESTIGATE]
%% remove the head zeros
start = 1;
while y(start)==0
    start = start + 1;
end
y = y(start:end);

%%
L = framelen*fs; % window len

if L<=p
    disp('Linear prediction requires the num of equations to be greater than the number of variables.');
end

sw.emphasis = 1; % default = 1
sw.plotEveryFrame = 0; % default = 0

numFrames = floor(length(y)/L);

excitat = zeros(size(y));
e_n = zeros(p+L,1);

%LPcoeffs = zeros(p+1,numFrames);
f1 = zeros(1,numFrames); % 1st formant
f2 = zeros(1,numFrames); % 2nd formant
f3 = zeros(1,numFrames); % 3rd formant

Nfreqs = 2^nextpow2(2*L-1)/2; % Num points for plotting the inverse filter response
df = fs/2/Nfreqs; 
ff = 0:df:fs/2-df;

if sw.emphasis == 1
    y_emph = filter([1 -0.95],1,y); 
                %[PARAM] -0.95 may be tuned anywhere from 0.9 to 0.99
else
    y_emph = y;
end

%% set a threshold for voice activity detection
ymax = max(abs(y_emph));
thres = thres_percent*ymax;

%% Linear prediction and smooth synthesis of the estimated source e_n
win = ones(L,1); % Rectangular window.
LPcoeffs = zeros(p+1, 1);
for kk = 1:numFrames
    ind = (kk-1)*L+1:kk*L;
    ywin = y_emph(ind).*win;
    Y = fft(ywin,2*Nfreqs);
    A = lpc(ywin,p); %% This is actually the more direct way to obtain the
    
    % LP coefficients. But, in this script, we used levinson() instead
    % because it gives us the "reflection coefficients". 
    % 
    % (Below, the fast way to calculate R is copied and modified from MATLAB's lpc() function)
    % R = ifft(Y.*conj(Y));
    %[A,errvar,K] = levinson(R,p); 
    
    %% Preparation for data visualization
    if kk == 1      
        e_n(p+1:end) = filter(A,[1],ywin);
    else
        ywin_extended = y((kk-1)*L+1-p:kk*L);  %% WORTH TWEAKING
        e_n = filter(A,[1],ywin_extended);
    end
    excitat(ind) = e_n(p+1:end);
    
    if sw.plotEveryFrame
        figure(1);
        subplot(221);
        plot(ind/fs*1000, y(ind));
        xlabel('ms')
        set(gca,'xlim',[kk-1 kk]*framelen*1000);
        subplot(222);
        plot(ind/fs*1000, e_n(p+1:end));
        set(gca,'xlim',[kk-1 kk]*framelen*1000);
        
        subplot(223);
        [H,W] = freqz(1,A,Nfreqs);
        Hmag = 20*log10(abs(H));
        Ymag = 20*log10(abs(Y(1:Nfreqs))); % NEED DEBUG
        Hmax = max(Hmag);
        offset = max(Hmag) - max(Ymag);
        plot(ff,Hmag); hold on;
        plot(ff,Ymag+offset,'r'); hold off;
        set(gca,'xlim',[0 fs/2],'ylim',[Hmax-50, Hmax+5]);
        xlabel('Hz')
        
        subplot(224);
        plot(ff,Ymag+offset-Hmag);
        set(gca,'xlim',[0 fs/2],'ylim',[-30, 25]);
        xlabel('Hz');
        
        drawnow;
        %pause;
    end
    A = A';
    
    if max(abs(y_emph(ind))) > thres % voice activity detected
        LPcoeffs = [LPcoeffs A];
    end
end
A_ave = zeros(1, p+1);
LPcoeffs(:,1) = [];
for i = 1: p+1
    A_ave(i) = median(LPcoeffs(i, :));
end
end
