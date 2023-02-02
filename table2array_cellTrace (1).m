%load the .mat cellTrace file (still formatted as a table 

prompt = "Session ID?";
sessionID= input(prompt);
sessionID =string(sessionID);

prompt2 = "Session date?"
date = input(prompt2);
date = string(date); 

cellTrace = table2array(cellTrace);
%also would be good to remove first 2 rows (empty rows) from file 
cellTrace(1,:) = [];
cellTrace(1,:) = [];
filename = strcat(date,'_',sessionID,'_cellTrace.mat'); 
save(filename,'cellTrace');