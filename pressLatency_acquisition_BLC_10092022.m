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

avgFirstPress = mean(pressResponse); 

pressData = struct;
pressData.storePress = storePress; 
pressData.firstPress = firstPress; 
pressData.avgLatency = avgFirstPress; 
save(strcat(subjectID,'_',date,'_pressLatencyData'),'pressData');
clear; 

