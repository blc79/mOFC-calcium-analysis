
prompt = "Session ID? ex: mX_dayZ ";
sessionID= input(prompt,'s');
sessionID =string(sessionID);

%first, need to pull cellData and relevant behavioral timepoints 

%for original data: 
cellTrace_trialStartIdx = data.cellTrace_trialStartIdx;
cellTrace_leverOutIdx = data.cellTrace_leverOutIdx;
cellTrace_leverPressIdx = data.cellTrace_leverPressIdx;
cellTrace_shockTimeIdx = data.cellTrace_shockTimeIdx; 
cellsOnly = data.cellsOnly; 

%for normalized data 
cellTrace_trialStartIdx = data.cellTrace_TrialStartIdx;
cellTrace_leverOutIdx = data.cellTrace_LeverOutIdx;
cellTrace_leverPressIdx = data.cellTrace_LeverPressIdx;
cellTrace_shockTimeIdx = data.cellTrace_shockTimeIdx; 
%cellsOnly = cellTrace(:,2:end); 
cellsOnly = data.dffCellsOnly; 


%select time bin you want to look within: 
%evPre: how much time before the event of interest (ex: evPre = 0: we will
%start looking at the time of the event of interest) 
%baseline timepoints are times BEFORE the event happens 

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

c = width(cellsOnly);
d = length(cellTrace_trialStartIdx);
allCells_Z = [];
broadZ_allCells = [];
sepTrialZ = struct;
trialStart_avgAcrossTrials_Z=[];
for i=1:c   
tempEv = [];
tempBase=[];
trialAvg_Z = [];

    for j=1:d

        evWin=cellsOnly((cellTrace_trialStartIdx(j)-evPre):(cellTrace_trialStartIdx(j)+evPost),i);
        baseWin= cellsOnly((cellTrace_trialStartIdx(j)-basePre):(cellTrace_trialStartIdx(j)-basePost),i);
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
acrossTrialAvg_ZscoredTrace = mean(byTrial_Z,2);

trialStart_avgAcrossTrials_Z =[ trialStart_avgAcrossTrials_Z,acrossTrialAvg_ZscoredTrace];

evMean = mean(tempEv,2);
baseMean = mean(mean(tempBase,2));
baseStd = std(mean(tempBase,2));


broadZ_byCell = (evMean-baseMean)./baseStd ;
broadZ_allCells = [broadZ_allCells,broadZ_byCell];

end 

%to save: save('m60_d1_trialStart_Z.mat','trialStart_avgAcrossTrials_Z')


%%this looks OK: but how to decide significance? 
%I feel like there should be 2 different rules: 
% 1. average z-score activity (averaged by trials) should be significantly
% different than average baseline activity

%how to break that down? trialStart_avgAcrossTrials_Z stores baseline
%period in first X trials, then event period in the remaining X trials 
%how to find this range? basePre


position = size(trialStart_avgAcrossTrials_Z,1);
extractBaseline = position - basePre; 
baselineZ = [];
for i =1:c %c = num cells 
    baselineZ(:,i) = trialStart_avgAcrossTrials_Z(1:extractBaseline-1,i);
end 

%now I want to extract the event period 
eventZ = [];
for i =1:c % c = num cells 
    eventZ(:,i) =trialStart_avgAcrossTrials_Z(extractBaseline:end,i);
end 

%now I want to compare baselineZ and eventZ on a cell by cell basis (across
%columns) 
compareToBaseline = [];
for i =1:c 
    tempBZ = baselineZ(:,i); 
    tempEZ = eventZ(:,i); 
    base_v_event = ranksum(tempBZ,tempEZ); 
    compareToBaseline = [compareToBaseline, base_v_event]; 
end 

diffFromBase = find(compareToBaseline < .05); 

%other criteria: eventZ should be >Xsd above mean for at least 200ms 
thresh = 1;
validCellsPos = [];
for i =1:c 
    cellValues = eventZ(:,i); 
    idx = find(cellValues>thresh);
    j = 1;
while j < length(idx) 

    if idx(j) == idx(j+1) - 1 
        validCellsPos = [validCellsPos, i];
        break
    end 
    j = j+1;
end
end
trialStart_validCellPos_trace = eventZ(:,validCellsPos);


%what about negatively modulated cells? 
thresh = 1;
validCellsNeg = [];
for i =1:c 
    cellValues = eventZ(:,i); 
    idx = find(cellValues<-thresh);
    j = 1;
while j < length(idx) 

    if idx(j) == idx(j+1) - 1 
        validCellsNeg = [validCellsNeg, i];
        break
    end 
    j = j+1;
end
end
trialStart_validCellNeg_trace = eventZ(:,validCellsNeg);

% 
% 
% 
% x2 = [(-basePre/10):0.1:(basePost/10)];
% 
%   x = [(-evPre/10):0.1:(evPost/10)];
% %    shadedErrorBar(x,rotateByTrial_Z,{@mean,@std},'lineProps',{'r-o','markerfacecolor','r'});
% 
% allCells = [];
% m47 = trialStart_avgAcrossTrials_Z;
% %etc etc for rest of the cells 
% 
% 
% restrictedWindow = allCells(30:end,:);
% 
% %means of restricted windows? 
% restrictedMean = mean(restrictedWindow,1);
% [out,idx] = sort(restrictedMean);
% sortedRestrictedWindow = restrictedWindow(:,idx);
% imagesc(sortedRestrictedWindow',clims)



restrictedWindow = allCells(30:end,:);

%means of restricted windows? 
restrictedMean = mean(restrictedWindow,1);
[out,idx] = sort(restrictedMean);
sortedRestrictedWindow = restrictedWindow(:,idx);
imagesc(sortedRestrictedWindow',clims)
%analyzing lever press: should still be relative to the period of time
%before each trial (the inactive, ITI period)  

%for original data: 
cellTrace_trialStartIdx = data.cellTrace_trialStartIdx;
cellTrace_leverOutIdx = data.cellTrace_leverOutIdx;
cellTrace_leverPressIdx = data.cellTrace_leverPressIdx;
cellTrace_shockTimeIdx = data.cellTrace_shockTimeIdx; 
cellsOnly = data.cellsOnly; 

%for normalized data 
cellTrace_trialStartIdx = data.cellTrace_TrialStartIdx;
cellTrace_leverOutIdx = data.cellTrace_LeverOutIdx;
cellTrace_leverPressIdx = data.cellTrace_LeverPressIdx;
cellTrace_shockTimeIdx = data.cellTrace_shockTimeIdx; 
cellsOnly = data.dffCellsOnly; 


%select time bin you want to look within: 
%evPre: how much time before the event of interest (ex: evPre = 0: we will
%start looking at the time of the event of interest) 
%baseline timepoints are times BEFORE the event happens 
%to get the timepoint before the respective trial starts: we need: 

%hold on;
evPre = 30;
evPost = 30;
basePre = 30;
basePost = 0;

%timelocking for lever press: 
%first, need to get the appropriate windows for the trials that went on to
%have a successful LP response 
trialStartLog = [];
for i =1:length(cellTrace_leverPressIdx) 
    trialStartLog(i,:) = cellTrace_trialStartIdx(cellTrace_leverPressIdx(i,2),1);
end 
%this puts trial starts in the same order as lever press IDX 


c = width(cellsOnly);
d = length(cellTrace_leverPressIdx);
allCells_Z = [];
sepTrialZ = struct;
leverPress_avgAcrossTrials_Z=[];
broadZ_allCells = [];
for i=1:c  
tempEv = [];
tempBase=[];
trialAvg_Z = [];

    for j=1:d

        evWin=cellsOnly((cellTrace_leverPressIdx(j)-evPre):(cellTrace_leverPressIdx(j)+evPost),i);
        baseWin= cellsOnly((cellTrace_leverPressIdx(j)-basePre):(cellTrace_leverPressIdx(j)-basePost),i);
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
acrossTrialAvg_ZscoredTrace = mean(byTrial_Z,2);

leverPress_avgAcrossTrials_Z =[leverPress_avgAcrossTrials_Z,acrossTrialAvg_ZscoredTrace];


%broad z-score: not trial by trial: (average across trials first, then
%z-score) 
evMean = mean(tempEv,2);
baseMean = mean(mean(tempBase,2));
baseStd = std(mean(tempBase,2));


broadZ_byCell = (evMean-baseMean)./baseStd ;
broadZ_allCells = [broadZ_allCells,broadZ_byCell];

end 

%to save: save('mXX_dX_leverPress_Z.mat','leverPress_avgAcrossTrials_Z'); 


%%this looks OK: but how to decide significance? 
%I feel like there should be 2 different rules: 
% 1. average z-score activity (averaged by trials) should be significantly
% different than average baseline activity

%how to break that down? trialStart_avgAcrossTrials_Z stores baseline
%period in first X trials, then event period in the remaining X trials 
%how to find this range? basePre
position = size(leverPress_avgAcrossTrials_Z,1);
extractBaseline = position - basePre; 
baselineZ = [];
for i =1:c %c = num cells 
    baselineZ(:,i) = leverPress_avgAcrossTrials_Z(1:extractBaseline-1,i);
end 

%now I want to extract the event period 
eventZ = [];
for i =1:c % c = num cells 
    eventZ(:,i) =leverPress_avgAcrossTrials_Z(extractBaseline:end,i);
end 

%now I want to compare baselineZ and eventZ on a cell by cell basis (across
%columns) 
compareToBaseline = [];
for i =1:c 
    tempBZ = baselineZ(:,i); 
    tempEZ = eventZ(:,i); 
    base_v_event = ranksum(tempBZ,tempEZ); 
    compareToBaseline = [compareToBaseline, base_v_event]; 
end 

diffFromBase = find(compareToBaseline < .05); 

%other criteria: eventZ should be >Xsd above mean for at least 200ms 
thresh = 1;
validCellsPos = [];
for i =1:c 
    cellValues = eventZ(:,i); 
    idx = find(cellValues>thresh);
    j = 1;
while j < length(idx) 

    if idx(j) == idx(j+1) - 1 
        validCellsPos = [validCellsPos, i];
        break
    end 
    j = j+1;
end
end
leverPress_validCellPos_trace = eventZ(:,validCellsPos);


%what about negatively modulated cells? 
thresh = 1;
validCellsNeg = [];
for i =1:c 
    cellValues = eventZ(:,i); 
    idx = find(cellValues<-thresh);
    j = 1;
while j < length(idx) 

    if idx(j) == idx(j+1) - 1 
        validCellsNeg = [validCellsNeg, i];
        break
    end 
    j = j+1;
end
end
trialStart_validCellNeg_trace = eventZ(:,validCellsNeg);

%find shared values 
