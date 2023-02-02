%%extract calcium fluor at time of events of interest 
%open gpio files 
%open normalized cell trace files 
%time points of interest from gpio_files: 
prompt = "Session ID?";
sessionID= input(prompt);
sessionID =string(sessionID);

prompt2 = "Session date?";
date = input(prompt2,'s');
date = string(date); 
 

trialStartTimes = gpio_files.adjTrialStartTimes;
leverOutTimes = gpio_files.adjLeverOutTimes;
leverPressTimes = gpio_files.adjLeverPressTimes; 
shockTimes = gpio_files.adjShockTimes;



dffCellTrace = normalData.dffCellTrace;
a = width(dffCellTrace);
dffCellsOnly = dffCellTrace(:, 2:a);
cellTrace_Times = normalData(1).dffCellTrace(:,1);

%find values in cellTrace that are closest to the trial start TTL times; 
for i =1:length(trialStartTimes)
    n = trialStartTimes(i,1);
    [~, idx] = min(abs(cellTrace_Times - n)); 
    minVal(i,1) = cellTrace_Times(idx); 
end 

cellTrace_TrialStarts = minVal; 

%index of trial start values: 
for i =1:length(cellTrace_TrialStarts)
    cellTrace_TrialStartIdx(i,1) = find(cellTrace_Times == cellTrace_TrialStarts(i,1));
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
cellTrace_LeverOut = minVal;

%index of lever Out values: 
for i =1:length(cellTrace_LeverOut)
    cellTrace_LeverOutIdx(i,1) = find(cellTrace_Times == cellTrace_LeverOut(i,1));
end 




%%%%%%%%%%%%%%%%%%%%%%%%%
%%leverpressTTLs 
n = [];
val = [];
idx = [];
minVal = [];

for i = 1:length(leverPressTimes)
    n = leverPressTimes(i,1);
    [val, idx] = min(abs(cellTrace_Times - n));
    minVal(i,1) = cellTrace_Times(idx);
end 

cellTrace_LeverPress = minVal;

%index of lever Press values: 
for i =1:length(cellTrace_LeverPress)
    cellTrace_LeverPressIdx(i,1) = find(cellTrace_Times == cellTrace_LeverPress(i,1));
end 






%%shock onset TTLs 
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


%index of shock onset values: 
for i =1:length(cellTrace_shockTime)
    cellTrace_shockTimeIdx(i,1) = find(cellTrace_Times == cellTrace_shockTime(i,1));
end 
%%%%%
%%%%




data.dffCellsOnly = dffCellsOnly; 
data.cellTrace_TrialStartIdx = cellTrace_TrialStartIdx; 
data.cellTrace_LeverOutIdx = cellTrace_LeverOutIdx; 
data.cellTrace_LeverPressIdx = cellTrace_LeverPressIdx; 
data.cellTrace_shockTimeIdx = cellTrace_shockTimeIdx; 





save(strcat(date,'_', sessionID,'_sessionData'),'data');

%%%%%%%%%%%%%%% TRIAL START %%%%%%%%%%%%%%%%%%%%%%%%%%


cellTrace_trialStartIdx = data.cellTrace_trialStartIdx;
cellTrace_leverOutIdx = data.cellTrace_leverOutIdx;
cellTrace_leverPressIdx = data.cellTrace_leverPressIdx;
cellTrace_shockTimeIdx = data.cellTrace_shockTimeIdx; 
cellsOnly = data.cellsOnly; 

cellTrace_trialStartIdx = data.cellTrace_TrialStartIdx;
cellTrace_leverOutIdx = data.cellTrace_LeverOutIdx;
cellTrace_leverPressIdx = data.cellTrace_LeverPressIdx;
cellTrace_shockTimeIdx = data.cellTrace_shockTimeIdx; 
cellsOnly = data.dffCellsOnly; 




hold on;
evPre = 50;
evPost = 40;
basePre = 50;
basePost = 0;
% pre = 30;
% pre2 = 10;
% post = 30;

c = width(cellsOnly);
d = length(cellTrace_trialStartIdx);
z_tot = [];
for i=1:c   
t = [];
b2=[];
    for j=1:d

        a=cellsOnly((cellTrace_trialStartIdx(j)-evPre):(cellTrace_trialStartIdx(j)+evPost),i);
        b= cellsOnly((cellTrace_trialStartIdx(j)-basePre):(cellTrace_trialStartIdx(j)-basePost),i);
        t=[t,a];
        b2=[b2,b];
    end

    t2=mean(t,2);

    base_m = mean(mean(b2,2));
    base_s = std(mean(b2,2));

    z = (t2-base_m)./base_s;

    x=[(-evPre/10):0.1:(evPost/10)];
       smZ = smooth(z);
    plot(x,smZ);
   
    z_tot = [z_tot,z];
end
    
%find modulated cells: values >2 for at least 2 consecutive locations 
%just in the period once the event happens!!! 

%what's the average z-score within the baseline period? 
for i =1:101 
    selectZ(:,i) = z_tot(40:end,i)
end 


thresh = 2;
validCellsPos = [];
for i =1:c 
    cellValues = selectZ(:,i); 
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
validCellPos_trace = z_tot(:,validCellsPos);
smoothPosCells = smoothdata(validCellPos_trace,1);


thresh = 2;
validCellsPos = [];
for i =1:c 
    cellValues = z_tot(:,i); 
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
validCellPos_trace = z_tot(:,validCellsPos);
smoothPosCells = smoothdata(validCellPos_trace,1);

for i =1:size(smoothPosCells,2)
    figure(i);
    plot(x,smoothPosCells(:,i));
end 



%%%%%%%%%%%%%%%%%%%%% LEVER OUT %%%%%%%%%%%%%%%%%%%%%%




hold on;

evPre = 30;
evPost = 30;
basePre = 30;
basePost =10;
% pre = 30;
% pre2 = 0;
% post = 30;

c = width(cellsOnly);
d = length(cellTrace_leverOutIdx); 

z_tot = [];
for i=1:c 
t = [];
b2=[];
    for j=1:d

        a=cellsOnly((cellTrace_leverOutIdx(j)-evPre):(cellTrace_leverOutIdx(j)+evPost),i);
        b= cellsOnly((cellTrace_leverOutIdx(j)-basePre):(cellTrace_leverOutIdx(j)-basePost),i);
        t=[t,a];
        b2=[b2,b];
    end

    t2=mean(t,2);

    base_m = mean(mean(b2));
    base_s = std(mean(b2));

    z = (t2-base_m)./base_s;

    x=[(-evPre/10):0.1:(evPost/10)];

           smZ = smooth(z);
  plot(x,smZ);
   
    z_tot = [z_tot,z];
end
    



%%%%%%%%%%%%%%%%% LEVER PRESS %%%%%%%%%%%%%%%%%%%

hold on;

evPre = 30;
evPost = 30;
basePre = 30;
basePost = 0;
% pre = 30;
% pre2 = 0;
% post = 30;

c = width(dffCellsOnly);
d = length(cellTrace_LeverPressIdx); 

z_tot = [];
for i=1:c  
t = [];
b2=[];
    for j=1:d

        a=cellsOnly((cellTrace_leverPressIdx(j)-evPre):(cellTrace_leverPressIdx(j)+evPost),i);
        b= cellsOnly((cellTrace_leverPressIdx(j)-basePre):(cellTrace_leverPressIdx(j)-basePost),i);
        t=[t,a];
        b2=[b2,b];
    end

    t2=mean(t,2);

    base_m = mean(mean(b2));
    base_s = std(mean(b2));

    z = (t2-base_m)./base_s;

    x=[(-evPre/10):0.1:(evPost/10)];
       smZ = smooth(z);
  plot(x,smZ);
   
    z_tot = [z_tot,z];
end
    


%%%%%%%%%%%%%%%%%% SHOCK ONSET %%%%%%%%%%%%%%%%%%%%


hold on;

pre = 30;
pre2 = 10;
post = 50;

c = width(dffCellsOnly);
d = length(cellTrace_shockTimeIdx); 

z_tot = [];
for i=1:c  
t = [];
b2=[];
    for j=1:d

        a=dffCellsOnly((cellTrace_shockTimeIdx(j)-pre):(cellTrace_shockTimeIdx(j)+post),i);
        b= dffCellsOnly((cellTrace_shockTimeIdx(j)-pre):(cellTrace_shockTimeIdx(j)-pre2),i);
        t=[t,a];
        b2=[b2,b];
    end

   t2=mean(t,2);

    base_m = mean(mean(b2));
    base_s = std(mean(b2));

    z = (t2-base_m)./base_s;

    x=[(-pre/10):0.1:(post/10)];
  plot(x,z);
   
    z_tot = [z_tot,z];
end
    
