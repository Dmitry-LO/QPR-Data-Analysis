function outdata=fQfp1_PulseTraceImport_HZB(FPath)
%FPath=FPath2
FPath1ID = strcat(FPath,'*Transmitted*.txt'); %transmitted wave
FPath2ID = strcat(FPath,'*Forward*.txt'); %Forward wave
FPath3ID = strcat(FPath,'*Reflected*.txt'); %Reflect wave


FolderInfo1 = dir(FPath1ID);
maxFilID1 = size(FolderInfo1);

FolderInfo2 = dir(FPath2ID);
maxFilID2 = size(FolderInfo2);

FolderInfo3 = dir(FPath3ID);
maxFilID3 = size(FolderInfo3);

%transmitted-------------------------------------------

for i=1:maxFilID1(1,1)

filesinfo = FolderInfo1(i);
filenName = filesinfo.name;
FileID = strcat(FPath,filenName);

outdata.Transmitted(i) = importdata(FileID,'\t', 6);
end

for i=1:maxFilID1(1,1)

filesinfo = FolderInfo1(i);
filenName = filesinfo.name;
FileID = strcat(FPath,filenName);

outdata.Transmitted(i).dataline = dlmread(FileID,'\t',[1 2 1 38]);
outdata.Transmitted(i).PowerData = dlmread(FileID,'\t',[2 1 4 2]);
outdata.Transmitted(i).PeakField = outdata.Transmitted(i).dataline(1,23);
outdata.Transmitted(i).SetTemp = outdata.Transmitted(i).dataline(1,1);

%Ptm =	outdata.Transmitted(i).PowerData(2,2);
Ptm =	max(outdata.Transmitted(i).data(:,3));
Qt =	outdata.Transmitted(i).dataline(15);
c2 =    outdata.Transmitted(i).dataline(17);
fset =	outdata.Transmitted(i).dataline(2);
Barr1 = 1000*(c2*Qt*Ptm/(2*pi*fset))^0.5;
outdata.Transmitted(i).RealBm = Barr1;

outdata.Transmitted(i).filenName=filenName;
end

%/transmitted-------------------------------------------

%Forward------------------------------------------------

for i=1:maxFilID2(1,1)

filesinfo = FolderInfo2(i);
filenName = filesinfo.name;
FileID = strcat(FPath,filenName);

outdata.Forward(i) = importdata(FileID,'\t', 6);
end

for i=1:maxFilID2(1,1)

filesinfo = FolderInfo2(i);
filenName = filesinfo.name;
FileID = strcat(FPath,filenName);

outdata.Forward(i).dataline = dlmread(FileID,'\t',[1 2 1 38]);
outdata.Forward(i).PowerData = dlmread(FileID,'\t',[2 1 4 2]);
outdata.Forward(i).PeakField = outdata.Forward(i).dataline(1,23);
outdata.Forward(i).SetTemp = outdata.Forward(i).dataline(1,1);
outdata.Forward(i).filenName=filenName;

end

%/Forward------------------------------------------------

%Reflected-----------------------------------------------


for i=1:maxFilID3(1,1)

filesinfo = FolderInfo3(i);
filenName = filesinfo.name;
FileID = strcat(FPath,filenName);


outdata.Reflected(i) = importdata(FileID,'\t', 6);
end

for i=1:maxFilID3(1,1)

filesinfo = FolderInfo3(i);
filenName = filesinfo.name;
FileID = strcat(FPath,filenName);

outdata.Reflected(i).dataline = dlmread(FileID,'\t',[1 2 1 38]);
outdata.Reflected(i).PowerData = dlmread(FileID,'\t',[2 1 4 2]);
outdata.Reflected(i).PeakField = outdata.Reflected(i).dataline(1,23);
outdata.Reflected(i).SetTemp = outdata.Reflected(i).dataline(1,1);

outdata.Reflected(i).filenName=filenName;

end

%/Reflected-----------------------------------------------

end 