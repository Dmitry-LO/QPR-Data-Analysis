function CoolDownData = fm1_LoadingData_HZB(Datapath1,Q1,Q2,Q3,modes)

TXTnames{1,1} = Q1;
TXTnames{1,2} = Q2;
TXTnames{1,3} = Q3;

for k=modes
FolderInfo = dir(strcat(Datapath1,TXTnames{1,k}));
maxFilID = size(FolderInfo);


clearvars procdata;


ii=1;
for i=1:maxFilID(1,1)
filesinfo = FolderInfo(i);
filenNameI = strcat(Datapath1,'\',filesinfo.name);

if filesinfo.bytes > 600
procdata(ii) = importdata(filenNameI, '\t', 1);
ii=ii+1;
end


end


%Assign filenames to datasets in struct CoolDown16Data
ii=1;
for i=1:maxFilID(1,1)

filesinfo = FolderInfo(i);
filenName = filesinfo.name;

if filesinfo.bytes > 600
procdata(ii).FName = filenName;
procdata(ii).SetTemp = procdata(ii).data(1,1);
ifrun=size(strfind(filenName,'Run'));
if ifrun(1,1)>=1
    as=size(str2num(filenName(strfind(filenName,'Run')+4)));
    if as(1,1)>=1
        procdata(ii).RunN = str2num(filenName((strfind(filenName,'Run')+3):(strfind(filenName,'Run')+4)))
    else
        procdata(ii).RunN = str2num(filenName(strfind(filenName,'Run')+3));
    end
    ii=ii+1;
else
    procdata(ii).RunN = 0;
    ii=ii+1;
end
    
end

end

if k==1
    CoolDownData.Q1 = procdata;
elseif k==2
    CoolDownData.Q2 = procdata;
elseif k==3
    CoolDownData.Q3 = procdata;
end

end
end