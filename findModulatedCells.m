pos = [];
neg = [];
thresh = 1
for i=1:518

    if length(find(leverPressCa(26:51,i) >= thresh)) > 1
        pos = [pos;i];
    end
   % if length(find(leverPressCa(26:51,i) <= -thresh)) > 1
     %   neg = [neg;i];
   % end

end
    

%%
hold on;

for i=1:length(pos)
cell = pos(i,1);

x=[-3:0.1:3];

plot(x',leverPressCa(:,cell));

end



%%%% 
% imagesc (x) ; casxis([-1  1]);