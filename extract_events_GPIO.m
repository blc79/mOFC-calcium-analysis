%first, open gpio_files (structure) 


prompt = "Session ID?";
sessionID= input(prompt,'s');
sessionID =string(sessionID);
% 
% prompt2 = "Session date?"
% date = input(prompt2,'s');
% date = string(date); 

%separate out GPIO_2
gpio_2=gpio_files.gpio_2; 

%GPIO_2 is logging trial starts: need to find every time the value changes
%from high to low 

gpioValues = gpio_2(:,2);
 
lowNum = find(gpioValues < 1000);
%but are there consecutive lowNum values? 

a = length(lowNum);

for i = 2: a
    consec(i,1) = lowNum(i,1) - lowNum(i-1,1);
end 

toKeep = find(consec ~= 1);
trialStarts = lowNum(toKeep,1);

trialStartTimes = gpio_2(trialStarts,1);

gpio_files.trialStartTimes = trialStartTimes;

%%also worth saving leverOut times (2s after trial start) 
leverOutTimes = trialStartTimes +2; 
gpio_files.leverOutTimes = leverOutTimes; 

%reset variables 
clearvars -except trialStartTimes leverOutTimes gpio_files date sessionID;
%separate out GPIO_3 
gpio_3 = gpio_files.gpio_3;

%gpio_3 is logging lever presses; find every time value changes from high
%to low 

gpioValues = gpio_3(:,2);
 
lowNum = find(gpioValues < 1000);
%but are there consecutive lowNum values? 
checkPress = length(lowNum);
if checkPress > 0



a = length(lowNum);

for i = 2: a
    consec(i,1) = lowNum(i,1) - lowNum(i-1,1);
end 

toKeep = find(consec ~= 1);
leverPress = lowNum(toKeep,1);

leverPressTimes = gpio_3(leverPress,1);

gpio_files.leverPressTimes = leverPressTimes;
elseif checkPress == 0
    gpio_files.leverPressTimes = [];
end 
%reset variables 
clearvars -except trialStartTimes gpio_files date sessionID;
%separate out GPIO_4 
gpio_4 = gpio_files.gpio_4; 

%gpio_4 is logging shocks; find every time value changes from high to low 
gpioValues = gpio_4(:,2);
 
lowNum = find(gpioValues < 1000);
%but are there consecutive lowNum values? 
checkShock = length(lowNum);
if checkShock > 0 


a = length(lowNum);

for i = 2: a
    consec(i,1) = lowNum(i,1) - lowNum(i-1,1);
end 

toKeep = find(consec ~= 1);
shockStart = lowNum(toKeep,1);

shockTimes = gpio_4(shockStart,1);



gpio_files.shockTimes = shockTimes;
elseif checkShock == 0 
    gpio_files.shockTimes = [];
end 

%%adjusted times (based on sessionStart) 
gpio_files.adjTrialStartTimes = gpio_files.trialStartTimes - gpio_files.sessionStart; 
gpio_files.adjLeverOutTimes = gpio_files.leverOutTimes - gpio_files.sessionStart;
gpio_files.adjLeverPressTimes = gpio_files.leverPressTimes - gpio_files.sessionStart;
gpio_files.adjShockTimes = gpio_files.shockTimes - gpio_files.sessionStart; 
save(strcat(sessionID,'_gpio_files.mat'),'gpio_files')