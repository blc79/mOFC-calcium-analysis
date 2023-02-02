%%open session data 
%%%%%%%%%%%%%%% TRIAL START %%%%%%%%%%%%%%%%%%%%%%%%%%


% cellTrace_trialStartIdx = data.cellTrace_trialStartIdx;
% cellTrace_leverOutIdx = data.cellTrace_leverOutIdx;
% cellTrace_leverPressIdx = data.cellTrace_leverPressIdx;
% cellTrace_shockTimeIdx = data.cellTrace_shockTimeIdx; 
% dffCellsOnly = data.dffCellsOnly; 


cellTrace_trialStartIdx = data.zScore_cellTrace_trialStartIdx;
cellTrace_leverOutIdx = data.zScore_cellTrace_leverOutIdx;
cellTrace_LeverPressIdx = data.zScore_cellTrace_leverPressIdx;
cellTrace_shockTimeIdx = data.zScore_cellTrace_shockTimeIdx; 
zScore_cellsOnly = data.zScore_cellsOnly;
% 

hold on;

basePre = 30;
evPre = 5;
evPost = 15;
basePost = 20;

% 
% findHalf = length(cellTrace_TrialStartIdx)/2;
% firstHalf = cellTrace_TrialStartIdx(1:findHalf);
% c= width(dffCellsOnly);
% d = length(firstHalf);
% z_tot = [];
% for i =1:c
%     t = [];
%     b2 = [];
%     for j =1:d 
%         a=dffCellsOnly((firstHalf(j)-pre):(firstHalf(j)+post),i);
%         b=dffCellsOnly((firstHalf(j)-pre):(firstHalf(j)-pre2),i);
%         t = [t,a];
%         b2=[b2,b];
%     end 
% 
% t2 = mean(t,2);
% 
% b2_mean = mean(b2,2);
% baseline_m = mean(b2_mean);
% baseline_s =std(b2_mean); 
% z = (t2-baseline_m)./baseline_s;

c = width(zScore_cellsOnly);
d = length(cellTrace_trialStartIdx);
z_tot = [];
for i=1:c   
tempEv = [];
tempBase=[];
    for j=1:d

        evWin=zScore_cellsOnly((cellTrace_trialStartIdx(j)-evPre):(cellTrace_trialStartIdx(j)+evPost),i);
        baseWin= zScore_cellsOnly((cellTrace_trialStartIdx(j)-basePre):(cellTrace_trialStartIdx(j)+basePost),i);
        tempEv=[tempEv,evWin];
        tempBase=[tempBase,baseWin];
    end

    evAvg=mean(tempEv,2);

    baseAvg=mean(mean(tempBase,2));
    baseStd=std(mean(tempBase,2));

    z=(evAvg-baseAvg)./baseStd;

baseX = [(-basePre/10):0.1:(basePost/10)];
    x=[(-evPre/10):0.1:(evPost/10)];
    smZ = smooth(z);
%     figure;
    plot(x,smZ);
   
    z_tot = [z_tot,smZ];
end
    

%%%%%%%%%%%%%%%%%%%%% LEVER OUT %%%%%%%%%%%%%%%%%%%%%%




hold on;

pre = 30;
pre2 = 0;
post = 30;

c = width(dffCellsOnly);
d = length(cellTrace_LeverOutIdx); 

z_tot = [];
for i=1:c 
t = [];
b2=[];
    for j=1:d

        a=dffCellsOnly((cellTrace_LeverOutIdx(j)-pre):(cellTrace_LeverOutIdx(j)+post),i);
        b= dffCellsOnly((cellTrace_LeverOutIdx(j)-pre):(cellTrace_LeverOutIdx(j)-pre2),i);
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
    



%%%%%%%%%%%%%%%%% LEVER PRESS %%%%%%%%%%%%%%%%%%%

hold on;

pre = 30;
pre2 = 0;
post = 30;

c = width(dffCellsOnly);
d = length(cellTrace_LeverPressIdx); 

z_tot = [];
for i=1:c  
t = [];
b2=[];
    for j=1:d

        a=dffCellsOnly((cellTrace_LeverPressIdx(j)-pre):(cellTrace_LeverPressIdx(j)+post),i);
        b= dffCellsOnly((cellTrace_LeverPressIdx(j)-pre):(cellTrace_LeverPressIdx(j)-pre2),i);
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
    
