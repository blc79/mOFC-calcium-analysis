%%normalize calcium activity to activity of the entire session 

%open cellTrace
%we need to go through each cell, get its average activity and std across the
%entire session; then use this to calculate z-score 

prompt = "Session ID?";
sessionID= input(prompt,"s");
sessionID =string(sessionID);

% prompt2 = "Session date?";
% date = input(prompt2,'s');
% date = string(date); 
zScore_data = struct;

cellTimes = cellTrace(:,1);
zScore_data(1).cellTimes = cellTimes;
a= width(cellTrace);
allCells = cellTrace(:,2:a);


zScore_data(1).origCellTrace = cellTrace;

cellMeans = nanmean(allCells);
zScore_data(1).cellMeans =cellMeans; 
cellStd = std(allCells); 
zScore_data(1).cellStd = cellStd;




for i =1:width(allCells)
  x= allCells(:,i);
 zScore_cellTrace(:,i) = (x-cellMeans(:,1))/cellStd(:,i);
end 

zScore_data(1).zScore_cellTrace = zScore_cellTrace; 

save(strcat(sessionID,'_session_zScore'),'zScore_data');
