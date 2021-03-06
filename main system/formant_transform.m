function [A_new, error_detect] = formant_transform(A, A_last,  F1, F2, vowel, air_data, bone_data, type)
    f1_bound = [200, 1000];
    f2_bound = [650, 2400];
    error_detect = 0;
    debug = 0;
    air = air_data;
    bone = bone_data;
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

    if 20*log10(pks(1)) > 35 || 20*log10(pks(2)) > 35
        fprintf("this frame has dangerous feedback peak\n")
        if debug
            [h, f] = freqz(1,A,Nfreqs, 16000);
            plot(f ,20*log(abs(h)))
            xline(F1)
            xline(F2)
            %pause
        end
    end
    i_3dB = nan;
    for i=locs(1):-1:1
        if abs(H(i)) < pks(1)*0.707
            i_3dB = i;
            break
        end
    end
    if isnan(i_3dB)
        i = locs(1) +1;
        while abs(H(i)) - abs(H(i+1)) >0
        if abs(H(i)) < pks(1)*0.707
            i_3dB = i;
            break
        end
        i = i + 1;
        end
    end
    if isnan(i_3dB)
        A_new = A;
        fprintf("F1 can't find -3db! Won't change!\n");
        % debug
        if debug 
            [h, f] = freqz(1,A,Nfreqs, 16000);
            plot(f ,20*log10(abs(h)))
            xline(F1)
            pause
        end
        error_detect = 1;
        return
    end
    omega1 = W(locs(1));
    %omega1 = F1/dpi;
    f1 = omega1*dpi;
    delta_omega1 = (omega1-W(i_3dB));
    r1 = 1-delta_omega1;
    A1 = [1 -2*r1*cos(omega1) r1*r1];
    i_3dB2 = nan;
    max_i = min(1024, 2*locs(2));
    for i=locs(2):max_i
        if abs(H(i)) < pks(2)*0.707
            i_3dB2 = i;
            break
        end
    end
    if isnan(i_3dB2)
        fprintf("F2 can't find -3db! Use last one!\n");
        A_new = A_last;
        % debug
        if debug
            [h, f] = freqz(1,A,Nfreqs, 16000);
            plot(f ,20*log10(abs(h)))
            xline(F2);
            pause
        end
        return
    end    
    omega2 = W(locs(2));
    %omega2 = F2/dpi;
    f2 = omega2*dpi;
    delta_omega2 = (W(i_3dB2)-omega2);
    r2 = 1-delta_omega2;
    A2 = [1 -2*r2*cos(omega2) r2*r2];
    % error detect
    if f1 < f1_bound(1) || f1 > f1_bound(2) || f2 < f2_bound(1) || f2 > f2_bound(2) 
        fprintf("F1: %.0f, F2: %.0f are not in the right place! Won't change!\n", f1, f2)
        A_new = A;
        return
    end
    if type == "change"
        switch vowel
            case "a"
                avg_f1_a = air.a.f1_ave;
                std_f1_a = air.a.f1_std;
                avg_f2_a = air.a.f2_ave;
                std_f2_a = air.a.f2_std;
                avg_f1_b = bone.i.f1_ave;
                std_f1_b = bone.i.f1_std;
                avg_f2_b = bone.i.f2_ave;
                std_f2_b = bone.i.f2_std;
            case "i"
                avg_f1_a = air.i.f1_ave;
                std_f1_a = air.i.f1_std;
                avg_f2_a = air.i.f2_ave;
                std_f2_a = air.i.f2_std;
                avg_f1_b = bone.u.f1_ave;
                std_f1_b = bone.u.f1_std;
                avg_f2_b = bone.u.f2_ave;
                std_f2_b = bone.u.f2_std;
            case "u"
                avg_f1_a = air.u.f1_ave;
                std_f1_a = air.u.f1_std;
                avg_f2_a = air.u.f2_ave;
                std_f2_a = air.u.f2_std;

                avg_f1_b = bone.e.f1_ave;
                std_f1_b = bone.e.f1_std;
                avg_f2_b = bone.e.f2_ave;
                std_f2_b = bone.e.f2_std;
            case "e"
                avg_f1_a = air.e.f1_ave;
                std_f1_a = air.e.f1_std;
                avg_f2_a = air.e.f2_ave;
                std_f2_a = air.e.f2_std;

                avg_f1_b = bone.o.f1_ave;
                std_f1_b = bone.o.f1_std;
                avg_f2_b = bone.o.f2_ave;
                std_f2_b = bone.o.f2_std;
            case "o"
                avg_f1_a = air.o.f1_ave;
                std_f1_a = air.o.f1_std;
                avg_f2_a = air.o.f2_ave;
                std_f2_a = air.o.f2_std;

                avg_f1_b = bone.a.f1_ave;
                std_f1_b = bone.a.f1_std;
                avg_f2_b = bone.a.f2_ave;
                std_f2_b = bone.a.f2_std;
        end
    else
        switch vowel
            case "a"
                avg_f1_a = air.a.f1_ave;
                std_f1_a = air.a.f1_std;
                avg_f2_a = air.a.f2_ave;
                std_f2_a = air.a.f2_std;
                avg_f1_b = bone.a.f1_ave;
                std_f1_b = bone.a.f1_std;
                avg_f2_b = bone.a.f2_ave;
                std_f2_b = bone.a.f2_std;
            case "i"
                avg_f1_a = air.i.f1_ave;
                std_f1_a = air.i.f1_std;
                avg_f2_a = air.i.f2_ave;
                std_f2_a = air.i.f2_std;
                avg_f1_b = bone.i.f1_ave;
                std_f1_b = bone.i.f1_std;
                avg_f2_b = bone.i.f2_ave;
                std_f2_b = bone.i.f2_std;
            case "u"
                avg_f1_a = air.u.f1_ave;
                std_f1_a = air.u.f1_std;
                avg_f2_a = air.u.f2_ave;
                std_f2_a = air.u.f2_std;
                avg_f1_b = bone.u.f1_ave;
                std_f1_b = bone.u.f1_std;
                avg_f2_b = bone.u.f2_ave;
                std_f2_b = bone.u.f2_std;
            case "e"
                avg_f1_a = air.e.f1_ave;
                std_f1_a = air.e.f1_std;
                avg_f2_a = air.e.f2_ave;
                std_f2_a = air.e.f2_std;
                avg_f1_b = bone.e.f1_ave;
                std_f1_b = bone.e.f1_std;
                avg_f2_b = bone.e.f2_ave;
                std_f2_b = bone.e.f2_std;
            case "o"
                avg_f1_a = air.o.f1_ave;
                std_f1_a = air.o.f1_std;
                avg_f2_a = air.o.f2_ave;
                std_f2_a = air.o.f2_std;
                avg_f1_b = bone.o.f1_ave;
                std_f1_b = bone.o.f1_std;
                avg_f2_b = bone.o.f2_ave;
                std_f2_b = bone.o.f2_std;
        end
    end

    f3 = (((omega1*dpi)-avg_f1_a)*(std_f1_b/std_f1_a)+avg_f1_b);
    f4 = (((omega2*dpi)-avg_f2_a)*(std_f2_b/std_f2_a)+avg_f2_b);
    if f4 - f3 < 300 % fix the clipping bug
        f4 = f3 + 350;
        fprintf("too close! set f2' to f1' + 350\n")
    end
    % bound the value
    f3 = min(max(f3, f1_bound(1)), f1_bound(2));
    f4 = min(max(f4, f2_bound(1)), f2_bound(2));

    if f3 < f1_bound(1) || f3 > f1_bound(2) || f4 < f2_bound(1) || f4 > f2_bound(2)
        fprintf("F1': %.0f, F2': %.0f are not in the right place! Skip this transform!\n", f3, f4)
        A_new = A;
        return
    end
    omega3 = f3/dpi;
    delta_omega3 = delta_omega1*(omega3/omega1);
    r3 = 1-delta_omega3;
    A3 = [1 -2*r3*cos(omega3) r3*r3];


    omega4 = f4/dpi;
    delta_omega4 = delta_omega2*(omega4/omega2);
    r4 = 1-delta_omega4;
    A4 = [1 -2*r4*cos(omega4) r4*r4];


    Atemp = filter(1, A1, A);
    Atemp2= filter(1, A2, Atemp);
    Atemp3= filter(A3, 1, Atemp2);
    A_new = filter(A4, 1, Atemp3);

    [H,W] = freqz(1,A_new,Nfreqs);
    [pks,locs] = findpeaks(20*log10(abs(H)));
    % rules
    %pks(1)> 45 || pks(2) > 40 || pks(3) > 24 || max(pks) > 35 || pks(3) - pks(1) > 15 || pks(1) - pks(2) > 20
    if  pks(2) - pks(1) > 7.5 || pks(1) - pks(2) > 20
        fprintf("this frame produces dangerous feedback pk1: %.3fhz %.2fdB, pk2: %.0fhz %.2fdB\n", ...
            W(locs(1))*fs/(pi), pks(1), W(locs(2))*fs/(pi), pks(2))
        if debug
            [h_new, f] = freqz(1,A_new,Nfreqs, 16000);
            [h, f] = freqz(1,A,Nfreqs, 16000);
            plot(f ,20*log10(abs(h_new)))
            plot(f, 20*log10(abs(h)))
            xline(f3)
            xline(f4)
            legend("new", "original")
            pause;
        end
        A_new = A;
        return;
    end
   
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