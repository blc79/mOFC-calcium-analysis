> m = mean(trialStartCa); plot(m)
m = mean(trialStartCa,2); plot(m)
m = mean(trialStartCa); plot(m)
m = mean(trialStartCa); s=std(trialStartCa); plot(m)
shadedErrorBar([1:1:61],m,s);
m = mean(trialStartCa); s=std(trialStartCa)/sqrt(101);
shadedErrorBar([1:1:61],m,s);
m = mean(trialStartCa); s=std(trialStartCa);
shadedErrorBar([1:1:61],m,s);