%%trying to find the trials that had lever presses: 
%extract data.cellTrace_trialStartIdx and data.cellTrace_leverPressIdx 
trialStartIdx = data.cellTrace_TrialStartIdx; 
leverPressIdx = data.cellTrace_LeverPressIdx ; 
%this is going to be messy and will require looping through the data a lot:
%

for i =1:length(leverPressIdx)
    relPos = [];
extractLP = leverPressIdx(i,1); 
for k =1:length(trialStartIdx)
relPos(k,1) = trialStartIdx(k,1) - extractLP ;

end 
%need to stop it from doing this to the last trial: 
checkForPos = find(relPos > 0); 
if length(checkForPos) > 0 
relPos(relPos<=0) = inf; %turn any negative number to infinity 

[minX,index] = min(relPos(:)); %find the value and position of the smallest positive number: the trial this lever press belongs to is ONE LESS than that (the "highest" negative value) 
adjIndex = index -1 ;
leverPressIdx(i,2) = adjIndex; 


elseif length(checkForPos) == 0 
    leverPressIdx(i,2) = length(trialStartIdx);
end



end 

%SAVE THIS INFO BACK IN LEVER PRESS IDX 

data.cellTrace_LeverPressIdx = leverPressIdx; 

save('m59_d7_sessionData.mat','data'); 