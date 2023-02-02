%%extract calcium fluor at time of events of interest 
%open gpio files 
%open normalized cell trace files 
%time points of interest from gpio_files: 
prompt = "Session ID?";
sessionID= input(prompt,'s');
sessionID =string(sessionID);

% prompt2 = "Session date?";
% date = input(prompt2,'s');
% date = string(date); 
%  

trialStartTimes = gpio_files.adjTrialStartTimes;
leverOutTimes = gpio_files.adjLeverOutTimes;
leverPressTimes = gpio_files.adjLeverPressTimes; 
shockTimes = gpio_files.adjShockTimes;


% 
% dffCellTrace = normalData.dffCellTrace;
% a = width(dffCellTrace);
% dffCellsOnly = dffCellTrace(:, 2:a);
% cellTrace_Times = normalData(1).dffCellTrace(:,1);

zScore_cellTrace = zScore_data(1).zScore_cellTrace;
cellTrace_Times = zScore_data(1).cellTimes;

%find values in zScore_cellTrace that are closest to the trial start TTL times; 
for i =1:length(trialStartTimes)
    n = trialStartTimes(i,1);
    [~, idx] = min(abs(cellTrace_Times - n)); 
    minVal(i,1) = cellTrace_Times(idx); 
end 

cellTrace_trialStarts = minVal; 

%index of trial start values: 
for i =1:length(cellTrace_trialStarts)
    cellTrace_trialStartIdx(i,1) = find(cellTrace_Times == cellTrace_trialStarts(i,1));
end 

%%repeat for lever out TTL times: 
n = [];
val = [];
idx = []; 
minVal = [];

for i = 1:length(leverOutTimes)
    n = leverOutTimes(i,1);
    [val, idx] = min(abs(cellTrace_Times - n));
    minVal(i,1) = cellTrace_Times(idx);
end 
cellTrace_leverOut = minVal;

%index of lever Out values: 
for i =1:length(cellTrace_leverOut)
    cellTrace_leverOutIdx(i,1) = find(cellTrace_Times == cellTrace_leverOut(i,1));
end 




%%%%%%%%%%%%%%%%%%%%%%%%%
%%leverpressTTLs 
n = [];
val = [];
idx = [];
minVal = [];

checkPress = length(leverPressTimes);
if checkPress > 0 

for i = 1:length(leverPressTimes)
    n = leverPressTimes(i,1);
    [val, idx] = min(abs(cellTrace_Times - n));
    minVal(i,1) = cellTrace_Times(idx);
end 

cellTrace_leverPress = minVal;

%index of lever Press values: 
for i =1:length(cellTrace_leverPress)
    cellTrace_leverPressIdx(i,1) = find(cellTrace_Times == cellTrace_leverPress(i,1));
end 

elseif checkPress == 0 
    cellTrace_leverPressIdx = [];
end 




%%shock onset TTLs 
n=[];
val = [];
idx = [];
minVal = [];

checkShock = length(shockTimes); 
if checkShock > 0 

for i = 1:length(shockTimes)
    n = shockTimes(i,1);
    [val, idx] = min(abs(cellTrace_Times - n));
    minVal(i,1) = cellTrace_Times(idx);
end 

cellTrace_shockTime = minVal;


%index of shock onset values: 
for i =1:length(cellTrace_shockTime)
    cellTrace_shockTimeIdx(i,1) = find(cellTrace_Times == cellTrace_shockTime(i,1));
end 

elseif checkShock == 0
    cellTrace_shockTimeIdx = [];
end
%%%%%
%%%%


data = struct;
% 
% data.dffCellsOnly = dffCellsOnly; 
% data.cellTrace_trialStartIdx = cellTrace_trialStartIdx; 
% data.cellTrace_leverOutIdx = cellTrace_leverOutIdx; 
% data.cellTrace_leverPressIdx = cellTrace_leverPressIdx; 
% data.cellTrace_shockTimeIdx = cellTrace_shockTimeIdx; 

data.zScore_cellsOnly = zScore_cellTrace; 
data.zScore_cellTrace_trialStartIdx = cellTrace_trialStartIdx;
data.zScore_cellTrace_leverOutIdx = cellTrace_leverOutIdx;
data.zScore_cellTrace_leverPressIdx = cellTrace_leverPressIdx;
data.zScore_cellTrace_shockTimeIdx = cellTrace_shockTimeIdx; 



save(strcat(sessionID,'_zScore_sessionData'),'data');
