%50% reinforced analysis: 

%open behavioral data file and navigate to A.proc 

trialInfo = A.proc; 
reinforced = [];
null = [];
trialType = [];

a = length(trialInfo); 
for i =1:a 
    trialType(i,1) = trialInfo(i).trialType; 
end 

for i = 1:length(A.proc)
    trialType(i,1) = A.proc(i).trialType;
end 

reinforcedTrialIdx = find(trialType == 1);
nullTrialIdx = find(trialType == 0); 


%what's all the info we want to know about reinforced trials? 
%pAvoid, pEscape, pFail 
c =length(reinforcedTrialIdx);
reinforcedShocks = [];
for i = 1:c 
   reinforcedShocks(i,1) = trialInfo(reinforcedTrialIdx(i,1)).numShock; 
end 

find_rAvoid = find(reinforcedShocks == 0); 
p_rAvoid = (length(find_rAvoid)/length(reinforcedShocks))*100;

find_rEscape = find(reinforcedShocks > 0 & reinforcedShocks <5); 
p_rEscape = (length(find_rEscape)/length(reinforcedShocks))*100; 

find_rFail = find(reinforcedShocks == 5); 
p_rFail = (length(find_rFail)/length(reinforcedShocks))*100; 

%what do we want to know about null trials? 
%number of presses overall; then number of avoid vs. escape responses 
%need to collect all press times (relative) 

% I already have this pressData that I want stored in pressLatencyData:
% open that file: 

pressInfo = pressData.storePress; %has number of presses and time of presses for all trials; separate by trial type: 
%null trial idx

null_pressInfo = [];
for i =1:length(nullTrialIdx)
    null_pressInfo(i,:) = pressInfo(nullTrialIdx(i,1),:);
end 

%now that we have "null press info" we want to know how many presses
%happened before 22000 (time of light off / shock on) 
%convert zeros to Nans in null_pressInfo: 
null_pressInfo(null_pressInfo == 0) = NaN; 

avoidAttempt_byTrial = [];
for i =1:size(null_pressInfo,1) 
    tempAvoidAttempt = find(null_pressInfo(i,:) < 22000); 
    numAA = length(tempAvoidAttempt); 
    avoidAttempt_byTrial(i,1) = numAA; 
end 

escapeAttempt_byTrial = [];
for i =1:size(null_pressInfo,1)
    tempEscAttempt = find(null_pressInfo(i,:) > 22000);
    numEA = length(tempEscAttempt);
    escapeAttempt_byTrial(i,1) = numEA; 
end 

%nulltrials with an avoid attempt? 
avoidAttemptPresent = find(avoidAttempt_byTrial > 0); 
null_pAvoidAttempt = (length(avoidAttemptPresent)/length(avoidAttempt_byTrial))*100;

escapeAttemptPresent = find(escapeAttempt_byTrial > 0); 
null_pEscapeAttempt = (length(escapeAttemptPresent)/length(escapeAttempt_byTrial))*100; 


%overall avoid presses in null trials of the session 
totalAvoidPress = sum(avoidAttempt_byTrial);
%overall escape presses in nulltrials of the session: 
totalEscapePress = sum(escapeAttempt_byTrial); 
%on trials with an escape attempt, how many were there? same for avoid
%attempt
avoidAttempt_byTrial(avoidAttempt_byTrial ==0) = NaN; 
escapeAttempt_byTrial(escapeAttempt_byTrial == 0) = NaN; 
avgAvoidAttempts_perTrial = nanmean(avoidAttempt_byTrial); 
avgEscapeAttempts_perTrial = nanmean(escapeAttempt_byTrial); 


%we want to keep this info! 
%store in pressLatencyData since we are already storing a bunch there 
pressData.behavior = struct; 
pressData.behavior.reinforcedAvoids = p_rAvoid; 
pressData.behavior.reinforcedEscapes = p_rEscape; 
pressData.behavior.reinforcedFail = p_rFail; 
pressData.behavior.null_withAvoidAttempts = null_pAvoidAttempt; 
pressData.behavior.null_withEscapeAttempts = null_pEscapeAttempt; 
pressData.behavior.nullAvoidAttempt_perTrial = avgAvoidAttempts_perTrial; 
pressData.behavior.nullEscapeAttempt_perTrial = avgEscapeAttempts_perTrial; 
pressData.behavior.null_totalAvoidPresses = totalAvoidPress;
pressData.behavior.null_totalEscapePress = totalEscapePress; 

save('48_070822_pressLatencyData.mat','pressData');


