%BEHAVIOR ANALYSIS: EXTRACTING INFO FROM A.PROC 

%open the data file for each mouse; going to extract more detailed info
%from A.proc 


prompt = "Subject ID? XX_DDMMYYYY?";
subjectID= input(prompt,'s'); 
subjectID =string(subjectID);

data = A.proc;
numTrials = length(data);

shockByTrial = [];
for i =1:numTrials
    shockByTrial(i,1) = data(i).trial;
    shockByTrial(i,2) = data(i).numShock;
end 

avoidTrials = [];
avSearch = find(shockByTrial(:,2) == 0);
for i =1:length(avSearch)
    avoidTrials(i,1) = shockByTrial(avSearch(i,1),1);
end 

escapeTrials = [];
escSearch = find(shockByTrial(:,2) > 0 & shockByTrial(:,2) <5);
for i =1:length(escSearch)
    escapeTrials(i,1) =shockByTrial(escSearch(i,1),1);
end 

failTrials = [];
fSearch = find(shockByTrial(:,2) == 5);
for i =1:length(fSearch)
    failTrials(i,1) = shockByTrial(fSearch(i,1),1);
end 



%what else do we want to know? 
% 
%probably fine to save this all back in A? 
A.trialResponse.avoidTrials = avoidTrials;
A.trialResponse.escapeTrials = escapeTrials; 
A.trialResponse.failTrials = failTrials; 

save(strcat('data_',subjectID),'A');
clear; 
