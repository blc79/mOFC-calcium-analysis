% first step: open file (going to open 1 at a time for now) 

%once file is open, ask which file: 
prompt = "Subject?";
subjectID = input(prompt,'s');
subjectID = string(subjectID);

prompt2 = "Session date?";
date = input(prompt2,'s');
date = string(date);

%navigate to A.proc 
%want to extract numShock for each trial
numShock = [];
for i =1:length(A.proc)
    numShock{i,1} = A.proc(i).numShock; 
end 
numShock = cell2mat(numShock); 

%avoids
trialNum = length(numShock);
findAvoid = find(numShock == 0);
pAvoid = length(findAvoid)/trialNum; 

%escapes 
findEscape = find(numShock > 0 & numShock <5); 
pEscape = length(findEscape)/trialNum; 

%failures
findFail = find(numShock ==5); 
pFail = length(findFail)/trialNum; 

%want to save this data in a structure: 
behaviorData = struct;
behaviorData.pAvoid = pAvoid;
behaviorData.pEscape = pEscape;
behaviorData.pFail = pFail;
save(strcat(subjectID,'_',date,'_behaviorData'),'behaviorData');
clear; 
