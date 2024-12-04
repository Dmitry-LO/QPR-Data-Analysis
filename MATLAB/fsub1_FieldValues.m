function TT = fsub1_FieldValues(inputdata,Bstep)%Determine field values

clearvars Fnum;
clearvars fields;


p1size=size(inputdata);
Fnum=1:p1size(1,2); %!! define field numbers from struct db "CoolDown..Data. ..."  from which data plot is created


%=========[BODY]====================================

for i=Fnum

ii1=1;
fields=inputdata(i).data(:,23);
fields=fields' ;
sfields=size(fields);
fields=sort(fields);
kstart=1;
kend=sfields(1,2);
mult=0;
for k=1:sfields(1,2);
    if k<sfields(1,2)
        if abs(fields(k)-fields(k+1))>Bstep;
        kend=k;
        currfield(i,ii1)=round(mean(fields(kstart:kend)),1);
        ii1=ii1+1;
        kstart=k+1;
        end
    else
        kend=k;
        currfield(i,ii1)=round(mean(fields(kstart:kend)),1);
    end
end

end


C = unique(currfield);
csize=size(C);


for i=2:csize(1,1)
ss(i)=sum(currfield(:)==C(i,1));
FieldTable(i-1,1)=C(i,1);
FieldTable(i-1,2)=ss(i);
end

TT = table(FieldTable(:,1),FieldTable(:,2),'VariableNames',{'Field_Values_mT','Points_taken'});
end