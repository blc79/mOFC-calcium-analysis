%responses to CS+ by outcome type 

%find all trials that result in an avoid, escape, or fail 

%open cell data and behavior 
avoidTrials = A.trialResponse.avoidTrials; 
escapeTrials = A.trialResponse.escapeTrials; 
failTrials = A.trialResponse.failTrials;
cellTrace_trialStartIdx = data.cellTrace_TrialStartIdx;
cellTrace_leverOutIdx = data.cellTrace_LeverOutIdx;
cellTrace_leverPressIdx = data.cellTrace_LeverPressIdx;
cellTrace_shockTimeIdx = data.cellTrace_shockTimeIdx; 
cellsOnly = data.dffCellsOnly; 

%let's look at CS+ onset based on the diff trial types: 
avoidTrialIdx = [];
for i =1:length(avoidTrials)
    avoidTrialIdx(i,1) = cellTrace_trialStartIdx(avoidTrials(i,1),1);
end 


escapeTrialIdx = [];
for i =1:length(escapeTrials)
    escapeTrialIdx(i,1) = cellTrace_trialStartIdx(escapeTrials(i,1),1);
end 

failTrialIdx = [];
for i =1:length(failTrials)
    failTrialIdx(i,1) = cellTrace_trialStartIdx(failTrials(i,1),1);
end 

%great. now we do everything just like we did before but we do it three
%times 

hold on;
evPre = 50;
evPost = 40;
basePre = 50;
basePost = 0;

%goal of this for loop: go through each cell and extract values around each
%event index (ex: we know all the positions of trial start from
%cellTrace_trialStartIdx; we use this code to first X seconds of CS+
%presentation 
%after that event happens AND to get a baseline period to normalize to (ex:
%10s before trial starts (I should make this more like 6 seconds because
%the ITI can be as little as 7.5s) 

%AVOID TRIALS FIRST 

c = size(cellsOnly,2); 
d = length(avoidTrialIdx);
avoid_allCells_Z = [];
broadZ_allCells_avoid = [];
sepTrialZ = struct;
trialStart_avgAcrossTrials_Z_avoidT=[];
for i=1:c   
tempEv = [];
tempBase=[];
trialAvg_Z = [];

    for j=1:d

        evWin=cellsOnly((avoidTrialIdx(j)-evPre):(avoidTrialIdx(j)+evPost),i);
        baseWin= cellsOnly((avoidTrialIdx(j)-basePre):(avoidTrialIdx(j)-basePost),i);
        tempEv=[tempEv,evWin];
        tempBase=[tempBase,baseWin];
    end
%NORMALIZE ON TRIAL BY TRIAL BASIS: 


    %to z-score on a trial by trial basis: 
    %then take the average of THAT z-score: 
   %if you dont care about trial by trial zscoring, ignore this!!! 
    byTrial_Z = [];
for k = 1:d 
    oneTrial_evWin = tempEv(:,k);
    oneTrial_baseWin = tempBase(:,k);

    oneTrial_baseWin_mean = mean(oneTrial_baseWin);
    oneTrial_baseWin_std = std(oneTrial_baseWin);
    oneTrial_Z = (oneTrial_evWin - oneTrial_baseWin_mean)./oneTrial_baseWin_std ;
    byTrial_Z = [byTrial_Z , oneTrial_Z];
    
end 

%average z-scores
acrossTrialAvg_ZscoredTrace_avoidT = mean(byTrial_Z,2);

trialStart_avgAcrossTrials_Z_avoidT =[ trialStart_avgAcrossTrials_Z_avoidT,acrossTrialAvg_ZscoredTrace_avoidT];

evMean = mean(tempEv,2);
baseMean = mean(mean(tempBase,2));
baseStd = std(mean(tempBase,2));


broadZ_byCell = (evMean-baseMean)./baseStd ;
broadZ_allCells_avoid = [broadZ_allCells_avoid,broadZ_byCell];

end 

%ESCAPE TRIALS NEXT 


c = size(cellsOnly,2); 
d = length(escapeTrialIdx);
escape_allCells_Z = [];
broadZ_allCells_escape= [];
sepTrialZ = struct;
trialStart_avgAcrossTrials_Z_escapeT=[];
for i=1:c   
tempEv = [];
tempBase=[];
trialAvg_Z = [];

    for j=1:d

        evWin=cellsOnly((escapeTrialIdx(j)-evPre):(escapeTrialIdx(j)+evPost),i);
        baseWin= cellsOnly((escapeTrialIdx(j)-basePre):(escapeTrialIdx(j)-basePost),i);
        tempEv=[tempEv,evWin];
        tempBase=[tempBase,baseWin];
    end
%NORMALIZE ON TRIAL BY TRIAL BASIS: 


    %to z-score on a trial by trial basis: 
    %then take the average of THAT z-score: 
   %if you dont care about trial by trial zscoring, ignore this!!! 
    byTrial_Z = [];
for k = 1:d 
    oneTrial_evWin = tempEv(:,k);
    oneTrial_baseWin = tempBase(:,k);

    oneTrial_baseWin_mean = mean(oneTrial_baseWin);
    oneTrial_baseWin_std = std(oneTrial_baseWin);
    oneTrial_Z = (oneTrial_evWin - oneTrial_baseWin_mean)./oneTrial_baseWin_std ;
    byTrial_Z = [byTrial_Z , oneTrial_Z];
    
end 

%average z-scores
acrossTrialAvg_ZscoredTrace_escapeT = mean(byTrial_Z,2);

trialStart_avgAcrossTrials_Z_escapeT =[ trialStart_avgAcrossTrials_Z_escapeT,acrossTrialAvg_ZscoredTrace_escapeT];

evMean = mean(tempEv,2);
baseMean = mean(mean(tempBase,2));
baseStd = std(mean(tempBase,2));


broadZ_byCell = (evMean-baseMean)./baseStd ;
broadZ_allCells_escape = [broadZ_allCells_escape,broadZ_byCell];

end 

%FAILURES





c = size(cellsOnly,2); 
d = length(failTrialIdx);
fail_allCells_Z = [];
broadZ_allCells_fail= [];
sepTrialZ = struct;
trialStart_avgAcrossTrials_Z_failT=[];
for i=1:c   
tempEv = [];
tempBase=[];
trialAvg_Z = [];

    for j=1:d

        evWin=cellsOnly((failTrialIdx(j)-evPre):(failTrialIdx(j)+evPost),i);
        baseWin= cellsOnly((failTrialIdx(j)-basePre):(failTrialIdx(j)-basePost),i);
        tempEv=[tempEv,evWin];
        tempBase=[tempBase,baseWin];
    end
%NORMALIZE ON TRIAL BY TRIAL BASIS: 


    %to z-score on a trial by trial basis: 
    %then take the average of THAT z-score: 
   %if you dont care about trial by trial zscoring, ignore this!!! 
    byTrial_Z = [];
for k = 1:d 
    oneTrial_evWin = tempEv(:,k);
    oneTrial_baseWin = tempBase(:,k);

    oneTrial_baseWin_mean = mean(oneTrial_baseWin);
    oneTrial_baseWin_std = std(oneTrial_baseWin);
    oneTrial_Z = (oneTrial_evWin - oneTrial_baseWin_mean)./oneTrial_baseWin_std ;
    byTrial_Z = [byTrial_Z , oneTrial_Z];
    
end 

%average z-scores
acrossTrialAvg_ZscoredTrace_failT = mean(byTrial_Z,2);

trialStart_avgAcrossTrials_Z_failT =[ trialStart_avgAcrossTrials_Z_failT,acrossTrialAvg_ZscoredTrace_failT];

evMean = mean(tempEv,2);
baseMean = mean(mean(tempBase,2));
baseStd = std(mean(tempBase,2));


broadZ_byCell = (evMean-baseMean)./baseStd ;
broadZ_allCells_fail = [broadZ_allCells_fail,broadZ_byCell];

end 


%export all of these vars: 
save('m60_d1_trialStart_avoid.mat','trialStart_avgAcrossTrials_Z_avoidT');
save('m60_d1_trialStart_escape.mat','trialStart_avgAcrossTrials_Z_escapeT');
save('m60_d1_trialStart_fail,mat','trialStart_avgAcrossTrials_Z_failT');


%dif between LP that's an escape vs. avoid response? 

hold on;
evPre = 30;
evPost = 30;
basePre = 30;
basePost = 0;

%goal of this for loop: go through each cell and extract values around each
%event index (ex: we know all the positions of trial start from
%cellTrace_trialStartIdx; we use this code to first X seconds of CS+
%presentation 
%after that event happens AND to get a baseline period to normalize to (ex:
%10s before trial starts (I should make this more like 6 seconds because
%the ITI can be as little as 7.5s) 

%AVOID TRIALS FIRST 
%need new avoid and escape trial indices: 
%let's look at CS+ onset based on the diff trial types: 
avoidTrialIdx_LP= [];
for i =1:length(avoidTrials)
    tempPos = find(cellTrace_leverPressIdx(:,2) == avoidTrials(i,1));
    avoidTrialIdx_LP(i,1) = cellTrace_leverPressIdx(tempPos,1);
end 
   


escapeTrialIdx_LP = [];
for i =1:length(escapeTrials)
    tempPos= find(cellTrace_leverPressIdx(:,2) == escapeTrials(i,1));
    escapeTrialIdx_LP(i,1) = cellTrace_leverPressIdx(tempPos,1);
end 



c = size(cellsOnly,2); 
d = length(avoidTrialIdx_LP);
avoid_allCells_Z = [];
broadZ_allCells_avoidLP = [];
sepTrialZ = struct;
LP_avgAcrossTrials_Z_avoid=[];
for i=1:c   
tempEv = [];
tempBase=[];
trialAvg_Z = [];

    for j=1:d

        evWin=cellsOnly((avoidTrialIdx_LP(j)-evPre):(avoidTrialIdx_LP(j)+evPost),i);
        baseWin= cellsOnly((avoidTrialIdx_LP(j)-basePre):(avoidTrialIdx_LP(j)-basePost),i);
        tempEv=[tempEv,evWin];
        tempBase=[tempBase,baseWin];
    end
%NORMALIZE ON TRIAL BY TRIAL BASIS: 


    %to z-score on a trial by trial basis: 
    %then take the average of THAT z-score: 
   %if you dont care about trial by trial zscoring, ignore this!!! 
    byTrial_Z = [];
for k = 1:d 
    oneTrial_evWin = tempEv(:,k);
    oneTrial_baseWin = tempBase(:,k);

    oneTrial_baseWin_mean = mean(oneTrial_baseWin);
    oneTrial_baseWin_std = std(oneTrial_baseWin);
    oneTrial_Z = (oneTrial_evWin - oneTrial_baseWin_mean)./oneTrial_baseWin_std ;
    byTrial_Z = [byTrial_Z , oneTrial_Z];
    
end 

%average z-scores
acrossTrialAvg_ZscoredTrace_avoidLP = mean(byTrial_Z,2);

LP_avgAcrossTrials_Z_avoid =[ LP_avgAcrossTrials_Z_avoid,acrossTrialAvg_ZscoredTrace_avoidLP];

evMean = mean(tempEv,2);
baseMean = mean(mean(tempBase,2));
baseStd = std(mean(tempBase,2));


broadZ_byCell = (evMean-baseMean)./baseStd ;
broadZ_allCells_avoidLP= [broadZ_allCells_avoidLP,broadZ_byCell];

end 

%ESCAPE TRIALS NEXT 


c = size(cellsOnly,2); 
d = length(escapeTrialIdx_LP);
escape_allCells_Z = [];
broadZ_allCells_escapeLP= [];
sepTrialZ = struct;
LP_avgAcrossTrials_Z_escape=[];
for i=1:c   
tempEv = [];
tempBase=[];
trialAvg_Z = [];

    for j=1:d

        evWin=cellsOnly((escapeTrialIdx_LP(j)-evPre):(escapeTrialIdx_LP(j)+evPost),i);
        baseWin= cellsOnly((escapeTrialIdx_LP(j)-basePre):(escapeTrialIdx_LP(j)-basePost),i);
        tempEv=[tempEv,evWin];
        tempBase=[tempBase,baseWin];
    end
%NORMALIZE ON TRIAL BY TRIAL BASIS: 


    %to z-score on a trial by trial basis: 
    %then take the average of THAT z-score: 
   %if you dont care about trial by trial zscoring, ignore this!!! 
    byTrial_Z = [];
for k = 1:d 
    oneTrial_evWin = tempEv(:,k);
    oneTrial_baseWin = tempBase(:,k);

    oneTrial_baseWin_mean = mean(oneTrial_baseWin);
    oneTrial_baseWin_std = std(oneTrial_baseWin);
    oneTrial_Z = (oneTrial_evWin - oneTrial_baseWin_mean)./oneTrial_baseWin_std ;
    byTrial_Z = [byTrial_Z , oneTrial_Z];
    
end 

%average z-scores
acrossTrialAvg_ZscoredTrace_escapeLP = mean(byTrial_Z,2);

LP_avgAcrossTrials_Z_escape =[ LP_avgAcrossTrials_Z_escape,acrossTrialAvg_ZscoredTrace_escapeLP];

evMean = mean(tempEv,2);
baseMean = mean(mean(tempBase,2));
baseStd = std(mean(tempBase,2));


broadZ_byCell = (evMean-baseMean)./baseStd ;
broadZ_allCells_escapeLP = [broadZ_allCells_escapeLP,broadZ_byCell];

end 

%save this info: 
save('m60_d1_LP_avoid.mat','LP_avgAcrossTrials_Z_avoid');
save('m60_d1_LP_escape.mat','LP_avgAcrossTrials_Z_escape');
