

%load gpio.csv file; import entire selection 

prompt = "Session ID?";
sessionID= input(prompt,'s');
sessionID =string(sessionID);

prompt2 = "Session date?"
date = input(prompt2,'s');
date = string(date); 

times= gpio(:,1); 
channel=gpio(:,2); 
value=gpio(:,3); 
channelArray=table2array(channel); 
timesArray=table2array(times);
valueArray=table2array(value);


%%need to export TRIG (the time the session actually starts recording) 

gpio_trig_column=find(channelArray=='BNC Trigger Input');
gpio_trig = [];
gpio_trig(:,1) = timesArray(gpio_trig_column);
gpio_trig(:,2)=valueArray(gpio_trig_column);
%first value we want to extract? GPIO2 (trial start)

gpio_2_column=find(channelArray == 'GPIO-2'); 

gpio_2 = [];
gpio_2(:,1) = timesArray(gpio_2_column);
gpio_2(:,2) = valueArray(gpio_2_column);

%this is sampled at 5000Hz; we do NOT need it sampled that fast: want to
%get it down to 50Hz: take every 100th value 
gpio_2_downsample=gpio_2(1:10:end,:);

%what are the other values I need? I need gpio3 and gpio4 
%same process (lever presses and shocks)
gpio_3_column = find(channelArray =='GPIO-3');
gpio_3=[];
gpio_3(:,1) = timesArray(gpio_3_column);
gpio_3(:,2) = valueArray(gpio_3_column);
gpio_3_downsample = gpio_3(1:10:end,:);

%same for gpio_4 
gpio_4_column = find(channelArray =='GPIO-4');
gpio_4 = [];
gpio_4(:,1) = timesArray(gpio_4_column);
gpio_4(:,2) = valueArray(gpio_4_column);
gpio_4_downsample = gpio_4(1:10:end,:); 

a = find(gpio_trig(:,2)==1 & gpio_trig(:,1) >0);
b = min(a); 
sessionStart = gpio_trig(b,1);

gpio_files = struct;
gpio_files.sessionStart = sessionStart; 
gpio_files.gpio_2 = gpio_2_downsample;
gpio_files.gpio_3 = gpio_3_downsample;
gpio_files.gpio_4 = gpio_4_downsample;
%clearvars -except gpio_files ; 
save(strcat(date,'_', sessionID,'_gpio_files'),'gpio_files');
