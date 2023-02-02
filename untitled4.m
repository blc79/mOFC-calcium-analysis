a=zeros(50,1);

for i=1:50
    
    if ~isempty(A.proc(i).presstime_abs)
   a(i,1)=round(A.proc(i).presstime_abs/100);
    end

end

final=[];
for i=1:length(cellTrace_leverPressIdx)
    b=abs(cellTrace_leverPressIdx(i,1)-a);
    [~,c]=min(b);
    final=[final;c];
end
