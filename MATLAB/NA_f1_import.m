function importNAData=NA_f1_import(FPath)

FPath1ID = strcat(FPath,'*.txt');
clearvars procdata

FolderInfo1 = dir(FPath1ID)
maxFilID1 = size(FolderInfo1)

k1=1;
k2=1;
k3=1;

for i=1:maxFilID1(1,1)
filesinfo = FolderInfo1(i);    
filenName = filesinfo.name;
FileID = strcat(FPath,filenName);

clearvars procdata
procdata = importdata(FileID,'\t', 7);
procdata.dataline = dlmread(FileID,'\t',[1 2 1 38]);

if and(425>procdata.data(1,1),procdata.data(1,1)>400)
    datett=char(procdata.textdata{2, 1});
    procdata.date=datetime(datett(1:19),'InputFormat','yyyy/MM/dd HH:mm:ss');
    clearvars datett
    procdata.SensA=procdata.dataline(1,25);
    procdata.SensB=procdata.dataline(1,26);
    procdata.SensC=procdata.dataline(1,27);
    procdata.SensD=procdata.dataline(1,28);
    
    importNAData.Q1(k1)=procdata;
	k1=k1+1;
elseif and(875>procdata.data(1,1),procdata.data(1,1)>825)
    datett=char(procdata.textdata{2, 1});
    procdata.date=datetime(datett(1:19),'InputFormat','yyyy/MM/dd HH:mm:ss');
    clearvars datett
    procdata.SensA=procdata.dataline(1,25);
    procdata.SensB=procdata.dataline(1,26);
    procdata.SensC=procdata.dataline(1,27);
    procdata.SensD=procdata.dataline(1,28);
    
    importNAData.Q2(k2)=procdata;
    k2=k2+1;
elseif and(1325>procdata.data(1,1),procdata.data(1,1)>1250)
    datett=char(procdata.textdata{2, 1});
    procdata.date=datetime(datett(1:19),'InputFormat','yyyy/MM/dd HH:mm:ss');
    clearvars datett
    procdata.SensA=procdata.dataline(1,25);
    procdata.SensB=procdata.dataline(1,26);
    procdata.SensC=procdata.dataline(1,27);
    procdata.SensD=procdata.dataline(1,28);
    importNAData.Q3(k3)=procdata;
    k3=k3+1; 
end

end

%!NOTE NAData.Q1(i).dataline(1,25)  Sens A - real temperature

psize=size(procdata);

clearvars procdata

end
