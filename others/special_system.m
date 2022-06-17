function [B_special, A_special] = special_system(A,Nfreqs)

[H,W] = freqz(1,A,Nfreqs);


H_new = H;
for i = 5:15
    H_new(i) = H(i)*10;
end
[B_special, A_special] = invfreqz(H_new,W,3,33,[],200);


%     [H,W] = freqz(1,A,Nfreqs);
%     [H_real,W_real] = freqz(B_special, A_special,Nfreqs);
%     Hmag = 20*log10(abs(H));
%     H_realmag = 20*log10(abs(H_real));
%     Hmax = max(Hmag);
%     plot(ff,Hmag); hold on;
%     plot(ff,H_realmag); hold off;
%     set(gca,'xlim',[0 fs/2],'ylim',[Hmax-50, Hmax+50]);
%     xlabel('Hz')
%     legend("H","H_new")
end