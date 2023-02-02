
cellsOnly = data.cellsOnly;
cellTrace_trialStartIdx = data.cellTrace_trialStartIdx;
cellTrace_leverOutIdx = data.cellTrace_leverOutIdx;
cellTrace_leverPressIdx = data.cellTrace_leverPressIdx;
cellTrace_shockTimeIdx = data.cellTrace_shockTimeIdx; 

hold on;

basePre = 30;
evPre = 0;
evPost = 15;
basePost = 20;


%c = width(cellsOnly);
c = 1;

numTrial = length(cellTrace_trialStartIdx);
z_tot = [];
%for i=1:c   
zEv = [];
tempBase=[];
    for j=1:numTrial

        evWin=cellsOnly((cellTrace_trialStartIdx(j)-basePre):(cellTrace_trialStartIdx(j)+basePost),i);
        baseWin= cellsOnly((cellTrace_trialStartIdx(j)-basePre):(cellTrace_trialStartIdx(j)),i);
       
        a=(evWin-mean(baseWin))./std(baseWin)
        zEv=[zEv,a];


%
       % tempBase=[tempBase,baseWin];
  %
    
    
    
    
    
    end

z_m=mean(zEv,2);


    evAvg=mean(tempEv,2);

    baseAvg=mean(mean(tempBase,2));
    baseStd=std(mean(tempBase,2));

    z=(evAvg-baseAvg)./baseStd;


    x=[(-evPre/10):0.1:(evPost/10)];
   smZ = smooth(z);
   % figure;
    plot(x,smZ);
   
    z_tot = [z_tot,z];
%end

%want to z-score each trial 
%across trial , you average the z-scores 

%z-score per trial. then average the z-scores and take the Std of the
%z-scores. so that for every single cell, you 