function outdata=RsvTData(inputdata,Bstep) %Rs(T) database creation

%Bstep=0.2
%inputdata=CoolDown16Data.Q1

clearvars Fnum;
clearvars fields;

p1size=size(inputdata);
Fnum=1:p1size(1,2); %!! define field numbers from struct db "CoolDown..Data. ..."  from which data plot is created

%Bstep=0.2;
%=========[BODY]====================================
LineN=1;
for i=Fnum

ii2=1;
fields=inputdata(i).data(:,23);
sfields=size(fields);
kend=sfields(1,1);
kstart=1;

for k=1:sfields(1,1);
    if k<sfields(1,1)
        if abs(fields(k)-fields(k+1))>Bstep;
        kend=k;
        Barray=inputdata(i).data(kstart:kend,23);
        Rsarray=inputdata(i).data(kstart:kend,24);
            if mean(Rsarray(isnan(Rsarray)==0))>0 %eliminating errors in Rs
            procdata2(LineN).data(ii2,1)=mean(Barray(isnan(Barray)==0)); %avg B
            procdata2(LineN).data(ii2,2)=mean(Rsarray(isnan(Rsarray)==0)); %avg Rs
            procdata2(LineN).data(ii2,3)=std(Rsarray(isnan(Rsarray)==0)); %errors Rs
            procdata2(LineN).data(ii2,4)=std(Barray(isnan(Barray)==0)); %errors B (optional)
            ii2=ii2+1;
            end
        kstart=k+1;
        clearvars Rsarray;
        clearvars Barray;
        end
    else
        kend=k;
        Barray=inputdata(i).data(kstart:kend,23);
        Rsarray=inputdata(i).data(kstart:kend,24);
            if mean(Rsarray(isnan(Rsarray)==0))>0 %eliminating errors in Rs
            procdata2(LineN).data(ii2,1)=mean(Barray(isnan(Barray)==0)); %avg B
            procdata2(LineN).data(ii2,2)=mean(Rsarray(isnan(Rsarray)==0)); %avg Rs
            procdata2(LineN).data(ii2,3)=std(Rsarray(isnan(Rsarray)==0)); %errors Rs
            procdata2(LineN).data(ii2,4)=std(Barray(isnan(Barray)==0)); %errors B (optional)
            ii2=ii2+1;
            end
        kstart=k+1;
        clearvars Rsarray;
        clearvars Barray;
    end
end

procdata2(LineN).FName=inputdata(i).FName;
procdata2(LineN).SetTemp=inputdata(i).SetTemp;
LineN=LineN+1;
end

outdata=procdata2
end
