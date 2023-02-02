%%%purpose: z-score activity based on either normalized data (saved in
%%%"sessionData") or original cell trace data (origTrace_sessionData) 

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
cellsOnly = data.dffCellsOnly; 

%select time bin you want to look within: 
%evPre: how much time before the event of interest (ex: 2s seconds before
%CS light on: evPre = 20) 
%evPre should include time BEFORE the event happens and continue until
%AFTER the event happens 
%baseline timepoints are just times BEFORE the event happens 

hold on;
evPre = 40;
evPost = 30;
basePre = 40;
basePost = 0;

%goal of this for loop: go through each cell and extract values around each
%event index (ex: we know all the positions of trial start from
%cellTrace_trialStartIdx; we use this code to extract 2s before through 2s
%after that event happens AND to get a baseline period to normalize to (ex:
%2s before trial start until time of trial start (t=0s))

c = width(cellsOnly);
d = length(cellTrace_trialStartIdx);
allCells_Z = [];
sepTrialZ = struct;
avgAcrossTrials_Z=[];
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
sepTrialZ(i).byTrial_Z = byTrial_Z;
%within sepTrialZ (struct), we have responses of each neuron z score on
%trial by trial basis: take average of that to get an average z-score for
%each neuron 

sepTrialZ(i).trialAvgZ = mean(byTrial_Z,2); 
avg_trialZScores = mean(byTrial_Z,2);
avgAcrossTrials_Z = [avgAcrossTrials_Z,avg_trialZScores];




%more broad Z-score (not individual trial by trial basis): 
evMean = mean(tempEv,2);
baseMean = mean(mean(tempBase,2));
baseStd = std(mean(tempBase,2));


oneCell_Z = (evMean-baseMean)./baseStd ;
allCells_Z = [allCells_Z,oneCell_Z];

   x = [(-evPre/10):0.1:(evPost/10)];
   smoothZ = smooth(oneCell_Z);
   plot(x,smoothZ);

end 

%THRESHOLDING BY allCells_Zscore 
%we want to know what cells are modulated in the period that does NOT
%include the baseline period 

%first, find that baseline period so that we can remove it
position = size(allCells_Z,1); 
selectZwindow = position - basePre;
restrictZ = []
for i =1:c
    restrictZ(:,i) = allCells_Z(selectZwindow-1:end,i);
end 

%now, find the positions that meet threshold criteria within restrictZ
thresh = 3;
validCellsPos = [];
for i =1:c 
    cellValues = restrictZ(:,i); 
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
validCellPos_trace = allCells_Z(:,validCellsPos);
smoothPosCells = smoothdata(validCellPos_trace,1);


%%%%repeat this process for lever press: 


hold on;
evPre = 30;
evPost = 30;
basePre = 30;
basePost = 0;

%goal of this for loop: go through each cell and extract values around each
%event index (ex: we know all the positions of leverpress from
%cellTrace_leverPressIdx; we use this code to extract 2s before through 2s
%after that event happens AND to get a baseline period to normalize to (ex:
%2s before lever press  until time of lever press  (t=0s))

c = width(cellsOnly);
d = length(cellTrace_leverPressIdx);
allCells_Z = [];
sepTrialZ = struct;
avgAcrossTrials_Z=[];
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
sepTrialZ(i).byTrial_Z = byTrial_Z;
%within sepTrialZ (struct), we have responses of each neuron z score on
%trial by trial basis: take average of that to get an average z-score for
%each neuron 

sepTrialZ(i).trialAvgZ = mean(byTrial_Z,2); 
avg_trialZScores = mean(byTrial_Z,2);
avgAcrossTrials_Z = [avgAcrossTrials_Z,avg_trialZScores];




%more broad Z-score (not individual trial by trial basis): 
evMean = mean(tempEv,2);
baseMean = mean(mean(tempBase,2));
baseStd = std(mean(tempBase,2));


oneCell_Z = (evMean-baseMean)./baseStd ;
allCells_Z = [allCells_Z,oneCell_Z];

   x = [(-evPre/10):0.1:(evPost/10)];
   smoothZ = smooth(oneCell_Z);
   plot(x,smoothZ);

end 

%THRESHOLDING BY allCells_Zscore 
%we want to know what cells are modulated in the period that does NOT
%include the baseline period 

%first, find that baseline period so that we can remove it
position = size(allCells_Z,1); 
selectZwindow = position - basePre;
restrictZ = []
for i =1:c
    restrictZ(:,i) = allCells_Z(selectZwindow-1:end,i);
end 

%now, find the positions that meet threshold criteria within restrictZ
thresh = 3;
validCellsPos = [];
for i =1:c 
    cellValues = restrictZ(:,i); 
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
validCellPos_trace = allCells_Z(:,validCellsPos);
smoothPosCells = smoothdata(validCellPos_trace,1);




% 
% %diff ways to take the threshold: 
% %look within avgAcrossTrials_Z 
% thresh = 2;
% validCellsPos = [];
% for i =1:c 
%     cellValues = avgAcrossTrials_Z(:,i); 
%     idx = find(cellValues>thresh);
%     j = 1;
% while j < length(idx) 
% 
%     if idx(j) == idx(j+1) - 1 
%         validCellsPos = [validCellsPos, i];
%         break
%     end 
%     j = j+1;
% end
% end
% validCellPos_trace = avgAcrossTrials_Z(:,validCellsPos);
% smoothPosCells = smoothdata(validCellPos_trace,1);
% 
%  x=[(-5/10):0.1:(9/10)];
% for i =1:size(smoothPosCells,2)
%     figure(i);
%     plot(x,smoothPosCells(:,i));
% end 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% %if we wanted to plot each cell at a time: 
% %need x axis: 
%    x = [(-evPre/10):0.1:(evPost/10)];
% 
% 
% 
% %to plot this for a single trial: 
%    x = [(-evPre/10):0.1:(evPost/10)];
%    %need to flip the orientation of byTrial_Z 
%    rotateByTrial_Z = byTrial_Z'
%   
%    shadedErrorBar(x,rotateByTrial_Z,{@mean,@std},'lineProps',{'r-o','markerfacecolor','r'});
% 
% 
% 
% allTrials_Z = mean(byTrial_Z,2);
% 
% trialAvg_Z = [trialAvg_Z, allTrials_Z]
% 
% 
%     %we just went through every trial (for a single cell: we are still
%     %inside of a bigger for loop) and found the window around an event
%     %occuring. we want to take an average of that across each of the trials
%     %
%     evMean=mean(tempEv,2);
% 
%     %tempBase is the baseline period around each event on each trial; we
%     %want to get an average of that across each of the trials 
%     %we need to take the mean 2x ("mean of the mean") to get a single
%     %number 
%     baseMean = mean(mean(tempBase,2));
% 
%     % we need to get the std of the mean of tempBase
%     baseStd = std(mean(tempBase,2));
% 
%     %z-scored eventZ 
%    evZ = (evMean - baseMean)./baseStd;
% 
%    %if we want to plot this, we need an x axis: 
%    x = [(-evPre/10):0.1:(evPost/10)];
% 
% 
% 
% rotateByTrial_Z 
% 

%%%%%
% 
% 
% 
% hold on;
% evPre = 40;
% evPost = 20;
% basePre = 40;
% basePost = 0;
% % pre = 30;
% % pre2 = 10;
% % post = 30;
% 
% c = width(cellsOnly);
% d = length(cellTrace_trialStartIdx);
% z_tot = [];
% for i=1:c   
% t = [];
% b2=[];
%     for j=1:d
% 
%         a=cellsOnly((cellTrace_trialStartIdx(j)-evPre):(cellTrace_trialStartIdx(j)+evPost),i);
%         b= cellsOnly((cellTrace_trialStartIdx(j)-basePre):(cellTrace_trialStartIdx(j)-basePost),i);
%         t=[t,a];
%         b2=[b2,b];
%     end
% 
%     t2=mean(t,2);
% 
%     base_m = mean(mean(b2,2));
%     base_s = std(mean(b2,2));
% 
%     z = (t2-base_m)./base_s;
% 
%     x=[(-evPre/10):0.1:(evPost/10)];
%        smZ = smooth(z);
%     plot(x,smZ);
%    
%     z_tot = [z_tot,z];
% end
%     
% %find modulated cells: values >2 for at least 2 consecutive locations 
% %just in the period once the event happens!!! 
% 
% %what's the average z-score within the baseline period? 
% for i =1:101 
%     selectZ(:,i) = z_tot(40:end,i)
% end 
% 
% 
% thresh = 2;
% validCellsPos = [];
% for i =1:c 
%     cellValues = selectZ(:,i); 
%     idx = find(cellValues>thresh);
%     j = 1;
% while j < length(idx) 
% 
%     if idx(j) == idx(j+1) - 1 
%         validCellsPos = [validCellsPos, i];
%         break
%     end 
%     j = j+1;
% end
% end
% validCellPos_trace = z_tot(:,validCellsPos);
% smoothPosCells = smoothdata(validCellPos_trace,1);

% 
% 
% for i =1:size(smoothPosCells,2)
%     figure(i);
%     plot(x,smoothPosCells(:,i));
% end 
% oneCell = sepTrialZ(94).byTrial_Z;
% 
% 
% rotateOneCell = oneCell' ;
% shadedErrorBar(x,rotateOneCell,{@mean,@std},'lineProps','-b','patchSaturation',0.33)
% 
% 
% 
% x = [your values];
% v = [your values];
% xi = [x(1):0.0000001:x(end)];
% vid=interp1(x,v,xi,'spline');
% plot(x,v,'b*')
% hold on
% plot(xi,vid,'r')
% 
% v = oneCell(:,1);
% xi = [x(1):0.0000001:x(end)];
% vid=interp1(x,v,xi,'spline');
% plot(x,v,'b*')
% hold on
% plot(xi,vid,'r')
% 
% 
% 
%  v = oneCell(:,1);
% xi = [x(1):0.0000001:x(end)];
% vid=interp1(x,v,xi,'spline');
% plot(x,v,'b*')
% hold on
% plot(xi,vid,'r')
% 
% 
% 
% 
% 
% 
% hold on 
% for i =1:size(oneCell,1)
%     plot(x,oneCell(:,i));
% end 
% 
% smoothCells = []
% for i =1:size(oneCell,2)
% smoothCells(:,i) = smooth(oneCell(:,i))
% end 
% 
% % shadedErrorBar(x,smoothCells',{@mean,@std},'lineProps','-b','patchSaturation',0.33)




restrict = allCells_Z(20:50,:)

flipRestrict = restrict' 

sortRestrict = sortrows(flipRestrict,10)





%%%%repeat for lever extension 

hold on;
evPre = 30;
evPost = 30;
basePre = 30;
basePost = 0;

%goal of this for loop: go through each cell and extract values around each
%event index (ex: we know all the positions of trial start from
%cellTrace_trialStartIdx; we use this code to extract 2s before through 2s
%after that event happens AND to get a baseline period to normalize to (ex:
%2s before trial start until time of trial start (t=0s))

c = width(cellsOnly);
d = length(cellTrace_leverOutIdx);
allCells_Z = [];
sepTrialZ = struct;
avgAcrossTrials_Z=[];
for i=1:c   
tempEv = [];
tempBase=[];
trialAvg_Z = [];

    for j=1:d

        evWin=cellsOnly((cellTrace_leverOutIdx(j)-evPre):(cellTrace_leverOutIdx(j)+evPost),i);
        baseWin= cellsOnly((cellTrace_leverOutIdx(j)-basePre):(cellTrace_leverOutIdx(j)-basePost),i);
        tempEv=[tempEv,evWin];
        tempBase=[tempBase,baseWin];
    end



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
sepTrialZ(i).byTrial_Z = byTrial_Z;
%within sepTrialZ (struct), we have responses of each neuron z score on
%trial by trial basis: take average of that to get an average z-score for
%each neuron 

sepTrialZ(i).trialAvgZ = mean(byTrial_Z,2); 
avg_trialZScores = mean(byTrial_Z,2);
avgAcrossTrials_Z = [avgAcrossTrials_Z,avg_trialZScores];




%more broad Z-score (not individual trial by trial basis): 
evMean = mean(tempEv,2);
baseMean = mean(mean(tempBase,2));
baseStd = std(mean(tempBase,2));


oneCell_Z = (evMean-baseMean)./baseStd ;
allCells_Z = [allCells_Z,oneCell_Z];

   x = [(-evPre/10):0.1:(evPost/10)];
   smoothZ = smooth(oneCell_Z);
   plot(x,smoothZ);

end 

