function [PlXax,PlYax,PlXer,PlYer]=fpost1_plotRs_sort(CW_sort,RunN,MinLim,MaxLim,BorT,CW_mode,Pulse_mode,PlotModeData)

%===========func input==========
%CW_sort=1
%RunN=[0]%1,4,6 %starting from min 1 0 - all

%MaxLim=7
%MinLim=0
%BorT=5

%CW_mode=1
%Pulse_mode=0 %all if not sorted

%PlotModeData=RsvT.Q1

%======/func input==============

PlotModeDatas=size(PlotModeData)
BorTN=NaN
fnames=fieldnames(PlotModeData);
chartest=char(fnames(3,1))=='B';
if chartest(1,1)==1

for i = 1:PlotModeDatas(1,2)
if (PlotModeData(i).Bfield==BorT)
BorTN=i %Field number for plot 1
end
end

if isnan(BorTN)==1
disp('=================================');
disp('<strong>ERROR!</strong>');
disp(['NO data Found for the spec FIELD or TEMP']);
disp('=================================');
error('NO DATA FOUND')
end

else
    
for i = 1:PlotModeDatas(1,2)
if (PlotModeData(i).Temp==BorT)
BorTN=i %Field number for plot 1
end
end

if isnan(BorTN)==1
disp('=================================');
disp('<strong>ERROR!</strong>');
disp(['NO data Found for the spec FIELD or TEMP']);
disp('=================================');
error('NO DATA FOUND')
end

end

PlotData=PlotModeData(BorTN).data;
PlotDatas=size(PlotData);

if RunN(1,1)>0
PIndexRun=PlotData(:,5)==RunN;
    PIndexRunCOL=logical(sum(PIndexRun,2));
else
PIndexRunCOL=true(PlotDatas(1,1),1);
end

if CW_sort==1
    if CW_mode==1
    PIndexCW=PlotData(:,6)==100;
    else
    PIndexCW=zeros(PlotDatas(1,1),1);
    end
    if Pulse_mode==1
    PIndexPulse=PlotData(:,6)<100;
    else
    PIndexPulse=zeros(PlotDatas(1,1),1);
    end 

    PIndexDC=logical(PIndexCW+PIndexPulse);
else
    PIndexDC=true(PlotDatas(1,1),1);
end

PIndexALL=and(PIndexDC,PIndexRunCOL)

PlotData1=PlotData(PIndexALL,:);

PlXax=PlotData1(and(PlotData1(:,1)<MaxLim,PlotData1(:,1)>MinLim),1);
PlYax=PlotData1(and(PlotData1(:,1)<MaxLim,PlotData1(:,1)>MinLim),3);
%PlXer=PlotData1(and(PlotData1(:,1)<MaxLim,PlotData1(:,1)>MinLim),2);
PlXer=PlotData1(and(PlotData1(:,1)<MaxLim,PlotData1(:,1)>MinLim),9);
%PlYer=PlotData1(and(PlotData1(:,1)<MaxLim,PlotData1(:,1)>MinLim),4);
PlYer=PlotData1(and(PlotData1(:,1)<MaxLim,PlotData1(:,1)>MinLim),11); %full error

if isnan(mean(PlXax))==1
    disp('=================================');
disp('<strong>ERROR!</strong>');
disp(['NO data Found for the spec REGION: RunN, CW/Pulse, Limits']);
disp('=================================');

error('NO DATA FOUND')
end

end
%%