%%normalize calcium activity 
%open cellTrace
%we need to go through each cell, get its average activity across the
%entire session, then divide each point in time by that number 

prompt = "Session ID?";
sessionID= input(prompt);
sessionID =string(sessionID);

% prompt2 = "Session date?";
% date = input(prompt2,'s');
% date = string(date); 


cellTimes = cellTrace(:,1);
a= width(cellTrace);
allCells = cellTrace(:,2:a);

normalData = struct;
normalData(1).origCellTrace = cellTrace;

cellMeans = nanmean(allCells);
normalData(1).cellMeans =cellMeans; 


for i =1:width(allCells)
  x= allCells(:,i);
  dff(:,i) = x/cellMeans(:,i);
end 
dffCellTrace = [];
dffCellTrace(:,1) = cellTimes;
dffCellTrace(:,2:a)=dff;

normalData(1).dffCellTrace = dffCellTrace; 

save(strcat(sessionID,'_normalCellTrace'),'normalData');
