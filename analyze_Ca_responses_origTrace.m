%%open normalCellTrace session data 
%%%%%%%%%%%%%%% TRIAL START %%%%%%%%%%%%%%%%%%%%%%%%%%


% cellTrace_trialStartIdx = data.cellTrace_trialStartIdx;
% cellTrace_leverOutIdx = data.cellTrace_leverOutIdx;
% cellTrace_leverPressIdx = data.cellTrace_leverPressIdx;
% cellTrace_shockTimeIdx = data.cellTrace_shockTimeIdx; 
% dffCellsOnly = data.dffCellsOnly; 

cellsOnly = data.cellsOnly;
cellTrace_trialStartIdx = data.cellTrace_trialStartIdx;
cellTrace_leverOutIdx = data.cellTrace_leverOutIdx;
cellTrace_leverPressIdx = data.cellTrace_leverPressIdx;
cellTrace_shockTimeIdx = data.cellTrace_shockTimeIdx; 

hold on;

basePre = 20;
evPre = 20;
evPost = 20;
basePost = 0;


c = width(cellsOnly);
trialNum = length(cellTrace_trialStartIdx);
z_tot = [];
for i=1:c   
tempEv = [];
tempBase=[];
    for j=1:trialNum

        evWin=cellsOnly((cellTrace_trialStartIdx(j)-evPre):(cellTrace_trialStartIdx(j)+evPost),i);
        baseWin= cellsOnly((cellTrace_trialStartIdx(j)-basePre):(cellTrace_trialStartIdx(j)-basePost),i);
        tempEv=[tempEv,evWin];
        tempBase=[tempBase,baseWin];
    end

    evAvg=mean(tempEv,2);

    baseAvg=mean(mean(tempBase,2));
    baseStd=std(mean(tempBase,2));

    z=(evAvg-baseAvg)./baseStd;


    x=[(-evPre/10):0.1:(evPost/10)];
   smZ = smooth(z);
  % figure;
    plot(x,smZ);
   
    z_tot = [z_tot,z];
end

%find modulated cells: values >2 for at least 2 consecutive locations 
thresh = 2;
validCellsPos = [];
for i =1:c 
    cellValues = z_tot(1:15,i); 
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

 x=[(-5/10):0.1:(9/10)];
for i =1:size(smoothPosCells,2)
    figure(i);
    plot(x,smoothPosCells(:,i));
end 




% 
% 
% thresh = -1.5; 
% validCellsNeg = [];
% for i =1:c 
%     cellValues = z_tot(:,i); 
%     idx = find(cellValues<thresh);
%     j = 1;
% while j < length(idx) 
% 
%     if idx(j) == idx(j+1) - 1 
%         validCellsNeg = [validCellsNeg, i];
%         break
%     end 
%     j = j+1;
% end
% end
% 


% %%%%%%%%%%%%%%%%%%%%% LEVER OUT %%%%%%%%%%%%%%%%%%%%%%
% 
% 
hold on 

basePre = 20;
evPre = 20;
evPost = 20;
basePost = 0;


c = width(cellsOnly);
trialNum = length(cellTrace_leverOutIdx);
z_tot = [];
for i=1:c   
tempEv = [];
tempBase=[];
    for j=1:trialNum

        evWin=cellsOnly((cellTrace_leverOutIdx(j)-evPre):(cellTrace_leverOutIdx(j)+evPost),i);
        baseWin= cellsOnly((cellTrace_leverOutIdx(j)-basePre):(cellTrace_leverOutIdx(j)-basePost),i);
        tempEv=[tempEv,evWin];
        tempBase=[tempBase,baseWin];
    end

    evAvg=mean(tempEv,2);

    baseAvg=mean(mean(tempBase,2));
    baseStd=std(mean(tempBase,2));

    z=(evAvg-baseAvg)./baseStd;


    x=[(-evPre/10):0.1:(evPost/10)];
   smZ = smooth(z);
  %figure;
    plot(x,smZ);
   
    z_tot = [z_tot,z];
end

%find modulated cells: values >2 for at least 2 consecutive locations 
thresh = 1.5;
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




% %%%%%%%%%%%%%%%%%%%%% LEVER PRESS %%%%%%%%%%%%%%%%%%%%%%
% 
% 
hold on 
basePre = 30;
evPre = 10;
evPost = 30;
basePost = 0;


c = width(cellsOnly);
trialNum = length(cellTrace_leverPressIdx);
z_tot = [];
for i=1:c   
tempEv = [];
tempBase=[];
    for j=1:trialNum

        evWin=cellsOnly((cellTrace_leverPressIdx(j)-evPre):(cellTrace_leverPressIdx(j)+evPost),i);
        baseWin= cellsOnly((cellTrace_leverPressIdx(j)-basePre):(cellTrace_leverPressIdx(j)+basePost),i);
        tempEv=[tempEv,evWin];
        tempBase=[tempBase,baseWin];
    end

    evAvg=mean(tempEv,2);
    sessionBase = cellsOnly(:,i); 
    sessionBase_mean = nanmean(sessionBase);
    sessionBase_std = std(sessionBase);
    sessionZ  = (evAvg - sessionBase_mean)./sessionBase_std;
    baseAvg=mean(mean(tempBase,2));
    baseStd=std(mean(tempBase,2));

    z=(evAvg-baseAvg)./baseStd;
 i = 3 


    x=[(-evPre/10):0.1:(evPost/10)];
   smZ = smooth(z);
  % figure;
    plot(x,smZ);
   
    z_tot = [z_tot,z];
end

%find modulated cells: values >2 for at least 2 consecutive locations 
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



