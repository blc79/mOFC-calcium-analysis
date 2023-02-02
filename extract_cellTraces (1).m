%from "extract_events_GPIO" script, we now have the exact frame when a
%particular event occured; we want to extract the window of neural activity
%surrounding that event happening 

%%First step: 
% OPEN GPIO FILE 
% OPEN CELL TRACE FILE 


%we want to extract just the time values from the cellTrace file (first
%column)
cellTrace_Times = cellTrace(:,1);

%we want to extract these peri-event histograms for each neuron (neurons
%represented in columns) 

trialStartTimes = gpio_files.trialStartTimes; 

%another value that isn't saved in gpio file, but important to have, it
%lever extend times; this happens precisely 2s after trial start times: so
%add 2s to all values in trialStartTimes: 
leverOutTimes = trialStartTimes +2; 

%need to find the values in cellTrace that are closest to the trial start
%TTL times 

for i = 1:length(trialStartTimes)
    n = trialStartTimes(i,1);
    [val, idx] = min(abs(cellTrace_Times - n));
    minVal(i,1) = cellTrace_Times(idx);
end 

cellTrace_TrialStarts = minVal;



%% now that we have the time point when  each trial starts, we want to find the time points around each of these; 

%first, in addition to the times of cellTrace for trial starts, let's also
%extract the index of those values 


for i =1:length(cellTrace_TrialStarts) 
    cellTrace_TrialStartIdx(i,1) = find(cellTrace== cellTrace_TrialStarts(i,1));
end 

%now, use the cellTrace IDX to get the 2s before and 2s after: 20 values
%before, 20 values after 
before = cellTrace_TrialStartIdx - 20;
after = cellTrace_TrialStartIdx + 20; 


periTrial_cellTrace = [];
for i =1:length(cellTrace_TrialStartIdx)
    periTrial_cellTrace(:,i) = cellTrace_Times(before(i,1):after(i,1),1);
end 


%now we have the time windows we want to look at for each cell; we want the
%positions within cellTrace 
a = length(gpio_files.trialStartTimes);
b = 41;

for i = 1:b
    for j = 1:a
periTrial_cellTraceIdx(i,j) = find(cellTrace == periTrial_cellTrace(i,j));
    end 
end 

%% extract peri-trial activity for each trial from a single neuron 

%going to turn the orientation of periTrial_cellTraceIdx to make it easier
%to visual 
periTrial_cellTraceIdx = periTrial_cellTraceIdx';

% we have the number of trials in variable A: 
numTrials = a;
%get number of cells: 
allCells = cellTrace(1,:);
numCells = length(allCells);
numCells = numCells - 1; 

for i =1:numTrials
  for k =1:numCells 
data.trialStart(k).cellByTrial(i,:) = cellTrace(periTrial_cellTraceIdx(i,:),k+1)';

    end 
end 


%now I want to get an average of activity for each neuron across all trials
%

for i =1:numCells 
data.trialStart(i).meanPerCell = mean(data.trialStart(i).cellByTrial);
end 


for i =1:numCells 
    allCellsAvg(i,:) = data.trialStart(i).meanPerCell;
end 

data.trialStart(1).allCellsAvg = allCellsAvg; 


%plot this as heatmap? 
heatmap(data.trialStart(1).allCellsAvg);



%%what about when lever extends? 
%gpio time when lever extends is in leverOutTimes 

%need to find the values in cellTrace that are closest to the lever out times 
%first, set variables back to 0 
n = [];
val = [];
idx = []; 
minVal = [];

for i = 1:length(leverOutTimes)
    n = leverOutTimes(i,1);
    [val, idx] = min(abs(cellTrace_Times - n));
    minVal(i,1) = cellTrace_Times(idx);
end 

cellTrace_LeverOut = minVal;

%in addition to the times of cellTrace for lever out, we also need to
%extract the index of those values: 

for i =1:length(cellTrace_LeverOut) 
    cellTrace_LeverOutIdx(i,1) = find(cellTrace== cellTrace_LeverOut(i,1));
end 


%now, use the cellTrace IDX to get the 2s before and 2s after: 20 values
%before, 20 values after 
before = cellTrace_LeverOutIdx - 20;
after = cellTrace_LeverOutIdx + 20; 

periLever_cellTrace = [];
for i =1:length(cellTrace_LeverOutIdx)
    periLever_cellTrace(:,i) = cellTrace_Times(before(i,1):after(i,1),1);
end 



%now we have the time windows we want to look at for each cell; we want the
%positions within cellTrace 
a = length(leverOutTimes);
b = 41;

for i = 1:b
    for j = 1:a
periLever_cellTraceIdx(i,j) = find(cellTrace == periLever_cellTrace(i,j));
    end 
end 

%% extract peri-lever activity for each trial from a single neuron 

%going to turn the orientation of perilever_cellTraceIdx to make it easier
%to visual 
periLever_cellTraceIdx = periLever_cellTraceIdx';


% we have the number of trials in variable A: 
numTrials = a;
%get number of cells: 
allCells = cellTrace(1,:);
numCells = length(allCells);
numCells = numCells - 1; 

for i =1:numTrials
  for k =1:numCells 
data.leverOut(k).cellByTrial(i,:) = cellTrace(periLever_cellTraceIdx(i,:),k+1)';

    end 
end 



%now I want to get an average of activity for each neuron across all trials
%

for i =1:numCells 
data.leverOut(i).meanPerCell = mean(data.leverOut(i).cellByTrial);
end 


for i =1:numCells 
    allCellsAvg(i,:) = data.leverOut(i).meanPerCell;
end 

data.leverOut(1).allCellsAvg = allCellsAvg; 


%plot this as heatmap? 
heatmap(data.leverOut(1).allCellsAvg);


%%what about for lever press? 
%get times from the gpio file: 
leverPressTimes = gpio_files.leverPressTimes;


%need to find the values in cellTrace that are closest to the lever press 
%TTL times 
%set variables back to []
n = [];
val = [];
idx = [];
minVal = [];

for i = 1:length(leverPressTimes)
    n = leverPressTimes(i,1);
    [val, idx] = min(abs(cellTrace_Times - n));
    minVal(i,1) = cellTrace_Times(idx);
end 

cellTrace_leverPress = minVal;


%% now that we have the time point when  each lever press occurs, we want to find the time points around each of these; 

%first, in addition to the times of cellTrace for lever presses, let's also
%extract the index of those values 


for i =1:length(cellTrace_leverPress) 
    cellTrace_leverPressIdx(i,1) = find(cellTrace== cellTrace_leverPress(i,1));
end 

%now, use the cellTrace IDX to get the 2s before and 2s after: 20 values
%before, 20 values after 
before = cellTrace_leverPressIdx - 20;
after = cellTrace_leverPressIdx + 20; 


periPress_cellTrace = [];
for i =1:length(cellTrace_leverPressIdx)
    periPress_cellTrace(:,i) = cellTrace_Times(before(i,1):after(i,1),1);
end 

%now we have the time windows we want to look at for each cell; we want the
%positions within cellTrace 
a = length(leverPressTimes);
b = 41;

for i = 1:b
    for j = 1:a
periPress_cellTraceIdx(i,j) = find(cellTrace == periPress_cellTrace(i,j));
    end 
end 


%% extract peri-trial activity for each trial from a single neuron 

%going to turn the orientation of periLever_cellTraceIdx to make it easier
%to visual 
periPress_cellTraceIdx = periPress_cellTraceIdx';

% we have the number of trials in variable A: 
numTrials = a;
%get number of cells: 
allCells = cellTrace(1,:);
numCells = length(allCells);
numCells = numCells - 1; 


for i =1:numTrials
  for k =1:numCells 
data.leverPress(k).cellByTrial(i,:) = cellTrace(periPress_cellTraceIdx(i,:),k+1)';

    end 
end 


%now I want to get an average of activity for each neuron across all trials
%

for i =1:numCells 
data.leverPress(i).meanPerCell = mean(data.leverPress(i).cellByTrial);
end 

for i =1:numCells 
    allCellsAvg(i,:) = data.leverPress(i).meanPerCell;
end 

data.leverPress(1).allCellsAvg = allCellsAvg; 


%plot this as heatmap? 
heatmap(data.leverPress(1).allCellsAvg);



%%what about for shocks? 
%get the times from the gpio file: 

shockTimes = gpio_files.shockTimes;

%need to find the values in cellTrace that are closest to the shock
%TTL times
n=[];
val = [];
idx = [];
minVal = [];

for i = 1:length(shockTimes)
    n = shockTimes(i,1);
    [val, idx] = min(abs(cellTrace_Times - n));
    minVal(i,1) = cellTrace_Times(idx);
end 

cellTrace_shockTime = minVal;



%% now that we have the time point when  each shock starts, we want to find the time points around each of these; 

%first, in addition to the times of cellTrace for shock starts, let's also
%extract the index of those values 


for i =1:length(cellTrace_shockTime) 
    cellTrace_shockTimeIdx(i,1) = find(cellTrace== cellTrace_shockTime(i,1));
end 



%now, use the cellTrace IDX to get the 2s before and 2s after: 20 values
%before, 20 values after 
before = cellTrace_shockTimeIdx - 20;
after = cellTrace_shockTimeIdx + 20; 


periShock_cellTrace = [];
for i =1:length(cellTrace_shockTimeIdx)
    periShock_cellTrace(:,i) = cellTrace_Times(before(i,1):after(i,1),1);
end 



%now we have the time windows we want to look at for each cell; we want the
%positions within cellTrace 
a = length(shockTimes);
b = 41;

for i = 1:b
    for j = 1:a
periShock_cellTraceIdx(i,j) = find(cellTrace == periShock_cellTrace(i,j));
    end 
end 



%% extract peri-trial activity for each shock from a single neuron 

%going to turn the orientation of periShock_cellTraceIdx to make it easier
%to visual 
periShock_cellTraceIdx = periShock_cellTraceIdx';



% we have the number of shocks in variable A: 
numShocks = a;
%get number of cells: 
allCells = cellTrace(1,:);
numCells = length(allCells);
numCells = numCells - 1; 


for i =1:numShocks
  for k =1:numCells 
data.shockOnset(k).cellByTrial(i,:) = cellTrace(periShock_cellTraceIdx(i,:),k+1)';

    end 
end 

%now I want to get an average of activity for each neuron across all trials
%

for i =1:numCells 
data.shockOnset(i).meanPerCell = mean(data.shockOnset(i).cellByTrial);
end 


for i =1:numCells 
    allCellsAvg(i,:) = data.shockOnset(i).meanPerCell;
end 

data.shockOnset(1).allCellsAvg = allCellsAvg; 


heatmap(data.shockOnset(1).allCellsAvg);











