function [A_new] = formant_transform(A, F1, F2, vowel)
    display = 0;
    if vowel == "undefinable"
        A_new = A;
        return
    end

    Nfreqs = 1024;
    fs = 16000;
    df = fs/2/Nfreqs;
    dpi = fs/2/pi;
    ff = 0:df:fs/2-df;
    
    [H,W] = freqz(1,A,Nfreqs);
    [pks,locs] = findpeaks(abs(H));
    true_F1 = [pks(1) locs(1)*df];
    true_F2 = [pks(2) locs(2)*df];
    i_3dB = nan;
    for i=locs(1):-1:1
        if abs(H(i)) < pks(1)*0.707
            i_3dB = i;
            break
        end
    end
    if isnan(i_3dB)
        A_new = A;
        return
    end
    omega1 = W(locs(1));
    delta_omega1 = (omega1-W(i_3dB));
    r1 = 1-delta_omega1;
    A1 = [1 -2*r1*cos(omega1) r1*r1];
    i_3dB2 = nan;
    for i=locs(2):2*locs(2)
        if abs(H(i)) < pks(2)*0.707
            i_3dB2 = i;
            break
        end
    end
    if isnan(i_3dB2)
        A_new = A;
        return
    end    
    omega2 = W(locs(2));
    delta_omega2 = (W(i_3dB2)-omega2);
    r2 = 1-delta_omega2;
    A2 = [1 -2*r2*cos(omega2) r2*r2];

    switch vowel
        case "a"
            avg_f1_a = 681;
            std_f1_a = 44;
            avg_f2_a = 1419;
            std_f2_a = 125;
            avg_f1_b = 766;
            std_f1_b = 85;
            avg_f2_b = 1246;
            std_f2_b = 27;
        case "i"
            avg_f1_a = 370;
            std_f1_a = 17;
            avg_f2_a = 1864;
            std_f2_a = 59;
            avg_f1_b = 354;
            std_f1_b = 6;     
            avg_f2_b = 1162;
            std_f2_b = 165;
        case "u"
            avg_f1_a = 386;
            std_f1_a = 20;
            avg_f2_a = 1121;
            std_f2_a = 87;
            avg_f1_b = 352;
            std_f1_b = 12;    
            avg_f2_b = 982;
            std_f2_b = -220;
        case "e"
            avg_f1_a = 531;
            std_f1_a = 43;
            avg_f2_a = 1763;
            std_f2_a = 51;
            avg_f1_b = 500;
            std_f1_b = 34;     
            avg_f2_b = 1696;
            std_f2_b = 188;
        case "o"
            avg_f1_a = 566;
            std_f1_a = 44;
            avg_f2_a = 1117;
            std_f2_a = 56;
            avg_f1_b = 460;
            std_f1_b = 35;
            avg_f2_b = 895;
            std_f2_b = 59;      
    end

    omega3 = (((omega1*dpi)-avg_f1_a)*(std_f1_b/std_f1_a)+avg_f1_b)/dpi;
    delta_omega3 = delta_omega1*(omega3/omega1);
    r3 = 1-delta_omega3;
    A3 = [1 -2*r3*cos(omega3) r3*r3];


    omega4 = (((omega2*dpi)-avg_f2_a)*(std_f2_b/std_f2_a)+avg_f2_b)/dpi;
    delta_omega4 = delta_omega2*(omega4/omega2);
    r4 = 1-delta_omega4;
    A4 = [1 -2*r4*cos(omega4) r4*r4];


    Atemp = filter(1, A1, A);
    Atemp2= filter(1, A2, Atemp);
    Atemp3= filter(A3, 1, Atemp2);
    A_new = filter(A4, 1, Atemp3);


    if display 
        [H1,~]=freqz(1,A1,Nfreqs);
        [H2,~]=freqz(1,A2,Nfreqs);
        [H3,~]=freqz(1,A3,Nfreqs);
        [H4,~]=freqz(1,A4,Nfreqs);
        [H,~] = freqz(1,A,Nfreqs);
        [H_real,~]=freqz(1,A_new,Nfreqs);
        figure(3)
        %H_real = H./H1./H2.*H3.*H4;
        Hmag = 20*log10(abs(H));
        H_realmag = 20*log10(abs(H_real));
        Hmax = max(Hmag);
        plot(ff,Hmag); hold on;
        plot(ff,H_realmag);
        plot(ff,20*log10(abs(H1)));
        plot(ff,20*log10(abs(H2)));
        plot(ff,20*log10(abs(H3)));
        plot(ff,20*log10(abs(H4)));
        yline(abs(Hmag(i_3dB)))
        yline(abs(Hmag(i_3dB2)))
        hold off;
        set(gca,'xlim',[0 fs/2],'ylim',[Hmax-50, Hmax+50]);
        xlabel('Hz')
        legend("H","H_real","H1","H2","H3","H4")
    end

end