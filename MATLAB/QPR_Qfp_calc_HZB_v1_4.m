%% Input parameters
%clc,clear

modes=[3]; %[1,2,3]
MakePlot=1;


%FPath1='D:\CERNbox\QPR tests & Operation\2019-09-10 - test #17 - ARIES-QPR-HZB-B2 (3µm Nb on Cu frim UniSiegen)\trace for Qpickup Q1 ALL\'%'..\trace_testQ1\'
FPath1='D:\nextcloud\QPR tests & Operation\2022-02-25 - test #35 - ARIES B-2.13 Siegen SIS\pulsesQ1\'

FPath2='D:\nextcloud\QPR tests & Operation\2022-02-25 - test #35 - ARIES B-2.13 Siegen SIS\pulsesQ2\'%'..\Qfp2_ALL\';
FPath3='D:\nextcloud\QPR tests & Operation\2022-04-04 - test #36 - ARIES B-3.19 Siegen SIS\Qfp3_day4\'%'..\trace_testQ1\'

%% Trace data archive creation (not needed if already exists)

disp('=================================');
disp('<strong>STATUS:</strong>');

%TraceDataX.QX.Transmitted(i).data - trace!
    %TraceDataX.QX.Transmitted(i).data(:,1) - time, ms
    %TraceDataX.QX.Transmitted(i).data(:,2) - power, dBm
    %TraceDataX.QX.Transmitted(i).data(:,3) - power, W

%TraceDataX.QX.Transmitted(i).dataline(1,23) - pick field
%TraceDataX.QX.Transmitted(i).dataline(1,25) - sensor temp
%TraceDataX.QX.Transmitted(i).dataline(1,1) - set temp
%TraceDataX.QX.Transmitted(i).PowerData(2,1) - max power dBm
%TraceDataX.QX.Transmitted(i).PowerData(2,2) - max power W
%TraceDataX.QX.Transmitted(i).RealBm - calculated pick field

if isempty(find(modes(:)==1, 1))==0
TraceData.Q1=fQfp1_PulseTraceImport_HZB(FPath1); %Set the name of the Archive Q1 mode
disp(['Import operation <strong>for Q1</strong> finished']);
end

if isempty(find(modes(:)==2, 1))==0
TraceData.Q2=fQfp1_PulseTraceImport_HZB(FPath2); %Set the name of the Archive Q1 mode
disp(['Import operation <strong>for Q2</strong> finished']);
end

if isempty(find(modes(:)==3, 1))==0
TraceData.Q3=fQfp1_PulseTraceImport_HZB(FPath3); %Set the name of the Archive Q1 mode
disp(['Import operation <strong>for Q3</strong> finished']);
end

%save('TraceData19Q1_1.mat','TraceData')

disp('=================================');
%clearvars -TraceData

%% ------------ Q_all ----------------------------
for ii=3%modes
clearvars procdata Xstart Xend

if ii==1
procdata=TraceData.Q1;
plot1name='Qfp1';
clearvars Qfp1;
elseif ii==2
procdata=TraceData.Q2;
plot1name='Qfp2';
clearvars Qfp2;
elseif ii==3
procdata=TraceData.Q3;
plot1name='Qfp3';
clearvars Qfp3;
end

MaxTrace=size(procdata.Reflected);
%MakePlot=0;
sc1=1.5;

traceNvalues=1:1:MaxTrace(1,2);
MakePlotii=MakePlot;


%=======Safty QUESTION==========================%
if MakePlotii==1
if max(size(traceNvalues))>15
%  answer = questdlg(['<strong>WARNING!</strong> Mode <strong>Q',num2str(ii),...
%      '</strong> has large number of pulse trace plots (<strong>',num2str(max(size(traceNvalues))),...
%      '</strong>) Do you want to create plots (performance issues possible)?']);
 
  answer = questdlg(['WARNING! Mode Q',num2str(ii),...
     ' has large number of pulse trace plots (',num2str(max(size(traceNvalues))),...
     ') Do you want to create plots (performance issues possible)?']);
 
switch answer
    case 'Yes'
        MakePlotii=1;
    case 'No'
        MakePlotii=0;
    case 'Cancel'
        MakePlotii=0;
end
end
end
%=======/Safty QUESTION=========================%

for traceN=traceNvalues
err3=0;
err2=0;
err1=0;
fQ=procdata.Reflected(traceN).dataline(1,2);

PT = procdata.Transmitted(traceN).data;
PR = procdata.Reflected(traceN).data;
PF = procdata.Forward(traceN).data;

if MakePlotii==1
figure('Position', [100 -100 900*sc1 600*sc1]);
subplot(2,2,1);
tracename=[procdata.Reflected(traceN).filenName,'; Real Bm: ',...
    num2str(procdata.Transmitted(traceN).RealBm),'; PeakField: ', num2str(procdata.Reflected(traceN).PeakField),...
    '; SetTemp: ', num2str(procdata.Reflected(traceN).SetTemp),'; traceN ',num2str(traceN)];
scatter(PR(:,1),PR(:,3),'.','DisplayName',tracename);
title(tracename);
set(gca,'FontSize',14);
end
Xstart = find(PR(:,3)==max(PR(:,3)),1);
%Xend = find(PR(:,1)>115,1)

%~~~~~~~~~~~~~~~~search Xend~~~~~~~~~~~~~~~~~~~
k1=1;
PTsize=size(PT);
stept=round(PTsize(1,1)/625);
enddiff=0.09e-3;
MaxXid(1)=(find(PR(:,1)==max(PR(:,1)))-2*stept);

for k=Xstart:stept:(find(PR(:,1)==max(PR(:,1)))-2*stept)
MeanP1 = mean(PR(k:(k+stept),3));
MeanP2 = mean(PR((k+stept+1):(k+2*stept),3));
if abs(MeanP1-MeanP2)<enddiff
MaxXid(k1)=k;
k1=k+1;
end
end
Xend = MaxXid(1);
if (Xend-Xstart)<10
    Xend = find(PR(:,1)==max(PR(:,1)),1);
    err1=1;
end
clearvars MaxXid
%~~~~~~~~~~~~~~~~~/search Xend~~~~~~~~~~~~~~~~~~~~~

X=PR(Xstart:Xend,1);
Y=PR(Xstart:Xend,3);

if MakePlotii==1
hold on;
scatter(X,Y);
hold off;
end
%---------------fitting function------------

EQ = [num2str(mean(PR(Xstart:Xstart+3,3))),'*exp(-tau*(x-',num2str(PR(Xstart,1)),'))'];


startPoints=[0.1];
upSP1=[inf] ;
lowSP1=[0];

MyfitOptions = fitoptions('Method','NonlinearLeastSquares','Lower',lowSP1,'upper',upSP1,'Startpoint',startPoints,'MaxIter',10000,'MaxFunEvals',10000);

f1=fit(X,Y,EQ,MyfitOptions);
TauRef = coeffvalues(f1)*1e-3;

if MakePlotii==1
%figure
subplot(2,2,2);
plot(PF(:,1),PF(:,2));
ylim([0 30])
%plot(f1,X,Y);
end
%-----------------/fitting----------------

%~~~~~~~~~~~~~~~~search Xend2~~~~~~~~~~~~~~~~~~~

k1=1;
stept=round(PTsize(1,1)/625);
enddiff=6e-8;
MaxXid(1)=(find(PT(:,1)==max(PT(:,1)))-2*stept);

for k=Xstart:stept:(find(PT(:,1)==max(PT(:,1)))-2*stept)
MeanP1 = mean(PT(k:(k+stept),3));
MeanP2 = mean(PT((k+stept+1):(k+2*stept),3));
if abs(MeanP1-MeanP2)<enddiff
MaxXid(k1)=k;
k1=k+1;
end
end
Xend2 = MaxXid(1);
clearvars MaxXid;

if (Xend2-Xstart)<10
    Xend2 = find(PT(:,1)==max(PT(:,1)),1);
    err2=1;
end
%~~~~~~~~~~~~~~~~~/search Xend2~~~~~~~~~~~~~~~~~~~~~


Xt=PT(Xstart:Xend2,1);
Yt=PT(Xstart:Xend2,3);
sampr=10000; %sampling range for avaraging power befor the pulse ends (in points)
if Xstart<sampr+10
    sampr=round(Xstart/2);
    err3=1;
end

if MakePlotii==1
%figure
subplot(2,2,3);
scatter(PT(:,1),PT(:,3),'.r');
%legend('show','Location','northwest');
set(gca,'FontSize',14);
hold on;
scatter(Xt,Yt,'ob');
scatter(PT(Xstart-sampr:Xstart,1),PT(Xstart-sampr:Xstart,3),'oy');
errorbar(PT(Xstart-10,1),mean(PT(and(PT(:,1)>PT((Xstart-sampr),1),PT(:,1)<PT((Xstart),1)),3)),2*std(PT(and(PT(:,1)>PT((Xstart-sampr),1),PT(:,1)<PT((Xstart),1)),3)),...
'o','LineWidth',2,'Color','[0.1490    0.1490    0.1490]');
hold off;
end


EQ1 = [num2str(mean(PT(Xstart:Xstart+3,3))),'*exp(-tau*(x-',num2str(PT(Xstart,1)),'))'];

f2=fit(Xt,Yt,EQ1,MyfitOptions);
TauTrans = coeffvalues(f2)*1e-3;

if MakePlotii==1
%figure
subplot(2,2,4);
plot(f2,Xt,Yt);
end

WR=trapz(X,f1(X))/1000;

PR1=mean(PR(and(PR(:,1)>PR((Xstart-sampr),1),PR(:,1)<PR((Xstart),1)),3));
PT1=mean(PT(and(PT(:,1)>PT((Xstart-sampr),1),PT(:,1)<PT((Xstart),1)),3));


QLref=2*fQ*pi*TauRef;
QLtrans=2*fQ*pi*TauTrans;

Qfpc=WR*2*pi*fQ/PR1;

Qfp=WR*2*pi*fQ/PT1;
dQfp=WR*2*pi*fQ/(PT1^2)*2*std(PT(and(PT(:,1)>PT((Xstart-sampr),1),PT(:,1)<PT((Xstart),1)),3));

dQfpPowererr=sqrt(2)*0.05*WR*2*pi*fQ/PT1;




Qfp0(traceN,1)=Qfp;
Qfp0(traceN,2)=dQfp;
Qfp0(traceN,3)=procdata.Transmitted(traceN).PeakField;
Qfp0(traceN,4)=procdata.Transmitted(traceN).SetTemp;
Qfp0(traceN,5)=Qfpc;
Qfp0(traceN,6)=QLtrans;
Qfp0(traceN,7)=QLref;
Qfp0(traceN,8)=TauRef;
Qfp0(traceN,9)=TauTrans;
Qfp0(traceN,10)=traceN;
Qfp0(traceN,12)=procdata.Transmitted(traceN).dataline(1,25);
Qfp0(traceN,13)=dQfpPowererr;
Qfp0(traceN,14)=WR;
Qfp0(traceN,15)=PT1;


err3=0;
err2=0;
err1=0;
end



sc1=1;
figure('Position', [100 100 900*sc1 600*sc1])
xtitle='TraceN';
ytitle='Qfp, estimated from the pulse';
MarkSize=10*sc1;
LineW=1.0*sc1;
MarkShape='s';
FontS=20*sc1;
MarkColor='none'; %Q2[.85 0.33 .10] Q1[.0 0.45 .74]
Lcol='k';

errorbar(Qfp0(3*Qfp0(:,2)<Qfp0(:,1),10),Qfp0(3*Qfp0(:,2)<Qfp0(:,1),1),3*Qfp0(3*Qfp0(:,2)<Qfp0(:,1),2),...
    MarkShape,...
    'LineWidth',LineW,'Color',Lcol,'MarkerEdgeColor',Lcol,... 
    'MarkerFaceColor',MarkColor,'MarkerSize',MarkSize,...
    'DisplayName',plot1name);

xlabel(xtitle);
ylabel(ytitle);
grid off
box on
set(gca,'LineWidth',1);
legend('show','Location','northwest');
set(gca,'FontSize',FontS);
set(gca,'fontname','calibri')

xlim('auto')
ylim('auto')

%scatter(Qfp1(:,10),Qfp1(:,1))
% figure
% errorbar(Qfp1(:,3),Qfp1(:,1),3*Qfp1(:,2),'o')
% 
% figure
% scatter(Qfp1(:,3),Qfp1(:,2))
end
clearvars -except TraceData modes Qfp1 Qfp2 Qfp3 MakePlot
