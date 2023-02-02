%%we want to look separately at the different response types (avoid,
%%escape, fail) 

%the info about the trial type is saved within the data file for each mouse
%("data_47_070722.mat") 

%info about trial times is saved within origTrace_sessionData 

%open origTrace_sessionData and mouse file (data_XX_070722.mat) 
%we're going to save the data we get back into origTrace_sessionData 

prompt = "Session ID? ex: mXX_dX?";
sessionID= input(prompt,'s');
sessionID =string(sessionID);

cellsOnly = data.cellsOnly;
cellTrace_trialStartIdx = data.cellTrace_trialStartIdx;
cellTrace_leverOutIdx = data.cellTrace_leverOutIdx;
cellTrace_leverPressIdx = data.cellTrace_leverPressIdx;
cellTrace_shockTimeIdx = data.cellTrace_shockTimeIdx; 

avoidTrialIdx = A.trialResponse.avoidTrials; 
escapeTrialIdx = A.trialResponse.escapeTrials;
failTrialIdx = A.trialResponse.failTrials;

cellTrace_avoid_trialStartIdx = [];
for i =1:length(avoidTrialIdx)
    cellTrace_avoid_trialStartIdx(i,1) = cellTrace_trialStartIdx(avoidTrialIdx(i,1),1);
end 

cellTrace_escape_trialStartIdx = [];
for i =1:length(escapeTrialIdx)
    cellTrace_escape_trialStartIdx(i,1) = cellTrace_trialStartIdx(escapeTrialIdx(i,1),1);
end 


cellTrace_fail_trialStartIdx = [];
for i =1:length(failTrialIdx)
    cellTrace_fail_trialStartIdx(i,1) = cellTrace_trialStartIdx(failTrialIdx(i,1),1);
end 

cellTrace_avoid_leverOutIdx = []; 
for i =1:length(avoidTrialIdx)
    cellTrace_avoid_leverOutIdx(i,1) = cellTrace_leverOutIdx(avoidTrialIdx(i,1),1);
end 


cellTrace_escape_leverOutIdx = []; 
for i =1:length(escapeTrialIdx)
    cellTrace_escape_leverOutIdx(i,1) = cellTrace_leverOutIdx(escapeTrialIdx(i,1),1);
end 


cellTrace_fail_leverOutIdx = []; 
for i =1:length(failTrialIdx)
    cellTrace_fail_leverOutIdx(i,1) = cellTrace_leverOutIdx(failTrialIdx(i,1),1);
end 
%%%%need to find the trials that had lever presses!!! 

pressTimes=zeros(length(A.proc),1);

for i=1:(length(A.proc))
    
    if ~isempty(A.proc(i).presstime_abs)
   pressTimes(i,1)=round(A.proc(i).presstime_abs/100);
    end

end

noPress = find(pressTimes == 0); 
%gives the positions where there is no press; we now need to take the
%cellTrace_leverPressIdx and add zeros to positions where there was no
%press (so that cellTrace_leverPressIdx will be the full length of the
%session (ex: 50 trials, it's 50 rows long) 

numNoPress = length(noPress) ; 
newPressIdx = cellTrace_leverPressIdx' ; 
 

for i =1:numNoPress 
    idx = noPress(i,1);
    val = 0; 
    newPressIdx = [newPressIdx(1:idx),val,newPressIdx(idx+1:end)]
end 





trialsWithPress=[];
for i=1:length(cellTrace_leverPressIdx)
b=abs(cellTrace_leverPressIdx(i,1)-pressTimes);
[~,c]=min(b);
trialsWithPress=[trialsWithPress;c];
end

temp = length(trialsWithPress);
if temp > 0
trialsWith_escapePress = [];
for i =1:length(escapeTrialIdx)
    trialsWith_escapePress(i,1) = find(trialsWithPress == (escapeTrialIdx(i,1)));
end 

    trialsWith_avoidPress = [];
for i =1:length(avoidTrialIdx)
    trialsWith_avoidPress(i,1) = find(trialsWithPress == avoidTrialIdx(i,1));
end 

cellTrace_avoid_leverPressIdx = [];
for i =1:length(avoidTrialIdx)
    cellTrace_avoid_leverPressIdx(i,1) = cellTrace_leverPressIdx(trialsWith_avoidPress(i,1),1);
end 

cellTrace_escape_leverPressIdx = [];
for i =1:length(escapeTrialIdx)
    cellTrace_escape_leverPressIdx(i,1) = cellTrace_leverPressIdx(trialsWith_escapePress(i,1),1);

end 
data.cellTrace_escape_leverPressIdx = cellTrace_escape_leverPressIdx;
data.cellTrace_avoid_leverPressIdx = cellTrace_avoid_leverPressIdx; 

elseif temp ==0 
    return 
end 

data.cellTrace_avoid_trialStartIdx = cellTrace_avoid_trialStartIdx;
data.cellTrace_avoid_leverOutIdx = cellTrace_avoid_leverOutIdx;
%data.cellTrace_avoid_leverPressIdx = cellTrace_avoid_leverPressIdx; 
data.cellTrace_escape_trialStartIdx = cellTrace_escape_trialStartIdx;
data.cellTrace_escape_leverOutIdx = cellTrace_escape_leverOutIdx;
%data.cellTrace_escape_leverPressIdx = cellTrace_escape_leverPressIdx;
data.cellTrace_fail_trialStartIdx = cellTrace_fail_trialStartIdx;
data.cellTrace_fail_leverOutIdx = cellTrace_fail_leverOutIdx; 

save(strcat(sessionID,'_origTrace_sessionData'),'data');
