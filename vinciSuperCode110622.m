%trial start 
thresh = 1.5;
posCellIdx = trialStartCa > thresh;
posCells = trialStartCa(:,any(posCellIdx));

negCellIdx = trialStartCa < -thresh;
negCells = trialStartCa(:,any(negCellIdx));

%%%%%%%%%
%lever extension 
thresh = 1.5;
posCellIdx = leverOutCa > thresh;
posCells = leverOutCa(:,any(posCellIdx));

negCellIdx = leverOutCa < -thresh;
negCells = leverOutCa(:,any(negCellIdx));

%%%%%%%%%%
%lever press 
thresh = 1.5;
posCellIdx=[];
posCells = [];
posCellIdx = leverPressCa > thresh;
posCells = leverPressCa(:,any(posCellIdx));

negCellIdx=[];
negCells=[];
negCellIdx = leverPressCa < -thresh;
negCells = leverPressCa(:,any(negCellIdx));