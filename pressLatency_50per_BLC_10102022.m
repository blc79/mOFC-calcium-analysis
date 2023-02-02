%%%extract latency to first lever press 

%%for today, we can do this the lazy way where we will open each file
%%separately... 

%once file is open, ask which file: 
prompt = "Subject?";
subjectID = input(prompt,'s');
subjectID = string(subjectID);

prompt2 = "Session date?";
date = input(prompt2,'s');
date = string(date);

% navigate to A.proc: 
%want to extract A.proc.presstime_rel 

pressTimes = [];
for i =1:length(A.proc)
    pressTimes{i,1} = A.proc(i).presstime_rel; 
end 


%now we have all the values but in a cell array; want to be able to see
%each individual press time 
b = length(pressTimes); 
for j =1:b
    convertPress=pressTimes{j,1};
    a = length(convertPress);
    storePress(j,1:a)=convertPress;

end 

firstPress = storePress(1:b,1);
%%want to average across press latencies, but do not want to include trials
%%when an animal did not make a lever press 

hasPress = find(firstPress ~=0); 
pressResponse = firstPress(hasPress,1);
avgFirstPress_allTrials = nanmean(pressResponse); 

%I want to separate out reinforced and non-reinforced trials 
for i = 1:length(A.proc)
    trialType(i,1) = A.proc(i).trialType;
end 

reinforcedTrial = find(trialType == 1);
nullTrial = find(trialType == 0); 

%find reinforced press 
c =length(reinforcedTrial);
for i = 1:c 
    reinforcedPress = pressTimes{reinforcedTrial(i,1),1};
    d = length(reinforcedPress); 
    storeReinforced(i,1:d)=reinforcedPress; 
end 
%%first press reinforced? 
firstReinforcedPress = storeReinforced(1:c,1);
%avg reinforced? exclude any zeros 
hasPress_r = find(firstReinforcedPress~=0);
r_pressResponse = firstReinforcedPress(hasPress_r,1);
avgFirstPress_r = nanmean(r_pressResponse); 

%%find null press 
e = length(nullTrial);
for i = 1:e
    nullPress = pressTimes{nullTrial(i,1),1};
    f = length(nullPress);
    storeNull(i,1:f)=nullPress; 
end 
%first null press? 
firstNullPress =storeNull(1:e,1);
hasPress_n =find(firstNullPress ~=0);
n_pressResponse = firstNullPress(hasPress_n,1);
avgFirstPress_n = nanmean(n_pressResponse); 

trialType = trialType; 



% NOTE: MORE IMPORTANT THAN LATENCY TO PRESS ON A NULL OR REINFORCED TRIAL IS LATENCY TO PRESS FOLLOWING A NULL OR REINFORCED TRIAL: 

%from trial type: we know that trials 1 and 2 will always be reinforced. 
trialType2 = trialType; 
%move values down one position to show the trial type of previous trial:
%cannot study trial 1 for this 
trialType3 = circshift(trialType2,1);
trialType3(1,1) = NaN;
%now, using this info in trial type 3, we can extract trials based on if
%the PREVIOUS TRIAL was reinforced or null 
afterReinforced = find(trialType3 == 1);
afterNull = find(trialType3 == 0);

%%latency FOLLOWING reinforced trials?
g =length(afterReinforced);
for i = 1:g
    latencyAfter_R = pressTimes{afterReinforced(i,1),1};
    h = length(latencyAfter_R); 
    storePress_After_R(i,1:h)=latencyAfter_R; 
end 
storePress_After_R(storePress_After_R ==0) = NaN;


%%first press time following reinforced trial? 
firstPress_After_R = storePress_After_R(1:g,1);
%avg Latency after reinforced? exclude any zeros 
pressedAfter_R = find(firstPress_After_R~=0);
response_AfterR = firstPress_After_R(pressedAfter_R,1);
avgLatency_After_R = nanmean(response_AfterR); 

%%latency FOLLOWING null trials? 
k = length(afterNull);
for i = 1:k
    latencyAfter_N = pressTimes{afterNull(i,1),1};
    l=length(latencyAfter_N);
    storePress_After_N(i,1:l) = latencyAfter_N;
end 
storePress_After_N(storePress_After_N ==0) = NaN; 

%first press time FOLLOWING null trials? 
firstPress_After_N = storePress_After_N(1:k,1); 
%avg latency after null? exclude zeros
pressedAfter_N = find(firstPress_After_N ~=0);
response_AfterN = firstPress_After_N(pressedAfter_N,1); 
avgLatency_After_N = nanmean(response_AfterN); 



pressData = struct;
pressData.storePress = storePress; 
pressData.firstPress = firstPress; 
pressData.avgLatency_allTrials = avgFirstPress_allTrials; 
pressData.allReinforcedPress = storeReinforced; 
pressData.allNullPress = storeNull; 
pressData.firstPress_R = firstReinforcedPress; 
pressData.avgLatency_R = avgFirstPress_r; 
pressData.firstPress_N = firstNullPress; 
pressData.avgLatency_N = avgFirstPress_n;
pressData.allPress_afterR = storePress_After_R;
pressData.firstPress_afterR = firstPress_After_R;
pressData.avgLatency_afterR = avgLatency_After_R;
pressData.allPress_afterN = storePress_After_N;
pressData.firstPress_afterN =firstPress_After_N;
pressData.avgLatency_afterN = avgLatency_After_N;

save(strcat(subjectID,'_',date,'_pressLatencyData'),'pressData');
clear; 

