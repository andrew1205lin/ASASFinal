
[H,W] = freqz(1,A,Nfreqs);


H_new = H;
for i = 5:15
    H_new(i) = H(i)*10;
end
[B_special, A_special] = invfreqz(H_new,W,3,33,[],200);
omega1 = W(locs(1));
omega2 = W(locs(2));
omega3 = omega1-0.05;
omega4 = omega2+0.05;
r1 = 0.977;
r2 = 0.98;
r3 = 0.97;
r4 = 0.983;

[H1,W1]=freqz(1,[1 -2*r1*cos(omega1) r1*r1],Nfreqs);
[H2,W2]=freqz(1,[1 -2*r2*cos(omega2) r2*r2],Nfreqs);
[H3,W3]=freqz(1,[1 -2*r3*cos(omega3) r3*r3],Nfreqs);
[H4,W4]=freqz(1,[1 -2*r4*cos(omega4) r4*r4],Nfreqs);

figure(3)
    [H,W] = freqz(1,A,Nfreqs);
    [H_real,W_real] = freqz(B_special, A_special,Nfreqs);
    H_real = H./H1./H2.*H3.*H4;
    Hmag = 20*log10(abs(H));
    H_realmag = 20*log10(abs(H_real));
    Hmax = max(Hmag);
    plot(ff,Hmag); hold on;
    plot(ff,20*log10(abs(H1)));
    plot(ff,20*log10(abs(H2)));
    plot(ff,20*log10(abs(H3)));
    plot(ff,20*log10(abs(H4)));
    plot(ff,H_realmag); hold off;
    set(gca,'xlim',[0 fs/2],'ylim',[Hmax-50, Hmax+50]);
    xlabel('Hz')
    legend("H","/H1","/H2","*H3","*H4","H_new")
