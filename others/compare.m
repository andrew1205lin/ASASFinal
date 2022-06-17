function compare(y1,y2)
    numFrames = 75; % copy from Workspace
    Nfreqs = 512;    % copy from Workspace
    step = Nfreqs/2;      % copy from Workspace
    win = ones(1,Nfreqs); % Rectangular window.
    Fs = 16000;
    stepLen = step/Fs;
    for kk = 1:numFrames % frame index
        start = (kk-1)*step+1;
        final = start - 1+Nfreqs;

        ind = [start:final];

        %Step1, windowing to take a frame
        y1win = y1(ind).*win; 
        y2win = y2(ind).*win; 

        %Step2, Data visualization
        Y1 = fft(y1win,2*Nfreqs);
        Y2 = fft(y2win,2*Nfreqs);

        figure(1);
        subplot(2,1,1);
        plot(ind/Fs*1000, y1(ind));
        hold on
        plot(ind/Fs*1000, y2(ind));
        hold off
        xlabel('ms')
        set(gca,'xlim',[kk-1 kk]*stepLen*1000);
        legend("y1","y2")

        subplot(2,1,2);

        f = Fs*(0:(Nfreqs/2))/Nfreqs;
        P2_1 = 20*log10(abs(Y1));
        P1_1 = P2_1(1:Nfreqs/2+1);
        plot(f,P1_1) 
        hold on
        P2_2 = 20*log10(abs(Y2));
        P1_2 = P2_2(1:Nfreqs/2+1);
        plot(f,P1_2) 
        hold off
        
        title('Single-Sided Amplitude Spectrum of S(t)')
        xlabel('f (Hz)')
        ylabel('|P1(f)|')

        drawnow;
        pause;
    end
end