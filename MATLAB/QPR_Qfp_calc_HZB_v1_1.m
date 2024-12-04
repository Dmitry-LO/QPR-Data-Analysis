%% Input parameters
clc,clear

FPath1='D:\CERNbox\QPR tests & Operation\2019-12-16 - test #18 - ARIES-QPR-HZB-B5.4 (3µm Nb on Cu from STFC)\day_4_Qp_trace_Q1 (1,8K vs B field)\'
%'D:\CERNbox\QPR tests & Operation\2019-09-10 - test #17 - ARIES-QPR-HZB-B2 (3µm Nb on Cu frim UniSiegen)\trace for Qpickup Q1 ALL\'  %test 17
%'D:\CERNbox\QPR tests & Operation\2019-12-16 QPR Cooldown #18 ARIES-QPR-HZB-B5.4 (3µm Nb on Cu from STFC)\day_5_PowerPulse_trace_Q1\trace with OPEN loop\'
FPath2='D:\CERNbox\QPR tests & Operation\2020-11-12 QPR Cooldown #23\Q2_Qfpc_47mBar_new_cal_DAY6\';
%'D:\CERNbox\QPR tests & Operation\2019-09-10 - test #17 - ARIES-QPR-HZB-B2 (3µm Nb on Cu frim UniSiegen)\trace for Qpickup Q2 ALL\' %test 17
%'D:\CERNbox\QPR tests & Operation\2019-12-16 QPR Cooldown #18 ARIES-QPR-HZB-B5.4 (3µm Nb on Cu from STFC)\day_4_Qp_trace_Q2 (1,8K vs B field)\'
FPath3='D:\CERNbox\QPR tests & Operation\2020-11-12 QPR Cooldown #23\Q3_Qfpc_47mBar_old_cal_DAY7\'

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


TraceData.Q1=fQfp1_PulseTraceImport_HZB(FPath1); %Set the name of the Archive Q1 mode
disp(['Import operation <strong>for Q1</strong> finished']);

TraceData.Q2=fQfp1_PulseTraceImport_HZB(FPath2); %Set the name of the Archive Q1 mode
disp(['Import operation <strong>for Q2</strong> finished']);% 

TraceData.Q3=fQfp1_PulseTraceImport_HZB(FPath3); %Set the name of the Archive Q1 mode
disp(['Import operation <strong>for Q3</strong> finished']);

%save('TraceData18QALL.mat','TraceData')

disp('=================================');

%% ------------ Q1 rebuilt based on Q3 eval -----------

clearvars Qfp1 procdata Xstart Xend
procdata=TraceData.Q1
MaxTrace=size(procdata.Reflected)
MakePlot=1;
sc1=1.5;

for traceN=[1:1:MaxTrace(1,2)]%1:1:MaxTrace(1,2)
err3=0;
err2=0;
err1=0;
fQ=procdata.Reflected(traceN).dataline(1,2);

PT = procdata.Transmitted(traceN).data;
PR = procdata.Reflected(traceN).data;
PF = procdata.Forward(traceN).data;

if MakePlot==1
figure('Position', [100 100 900*sc1 600*sc1]);
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
enddiff=2e-4;
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

if MakePlot==1
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

if MakePlot==1
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

if MakePlot==1
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

if MakePlot==1
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




Qfp1(traceN,1)=Qfp;
Qfp1(traceN,2)=dQfp;
Qfp1(traceN,3)=procdata.Transmitted(traceN).PeakField;
Qfp1(traceN,4)=procdata.Transmitted(traceN).SetTemp;
Qfp1(traceN,5)=Qfpc;
Qfp1(traceN,6)=QLtrans;
Qfp1(traceN,7)=QLref;
Qfp1(traceN,8)=TauRef;
Qfp1(traceN,9)=TauTrans;
Qfp1(traceN,10)=traceN;
Qfp1(traceN,12)=procdata.Transmitted(traceN).dataline(1,25);

% if or(or(err1==1,err2==1),err3==1)
% Qfp1(traceN,1)=NaN;
% Qfp1(traceN,2)=NaN;
% Qfp1(traceN,3)=NaN;
% Qfp1(traceN,4)=NaN;
% Qfp1(traceN,5)=NaN;
% Qfp1(traceN,6)=NaN;
% Qfp1(traceN,7)=NaN;
% Qfp1(traceN,8)=NaN;
% Qfp1(traceN,9)=NaN;
% Qfp1(traceN,10)=NaN;
% end
err3=0;
err2=0;
err1=0;
end


sc1=1
%hold on
figure('Position', [100 100 900*sc1 600*sc1])
xtitle='TraceN'
ytitle='Qfp, estimated from the pulse'
MarkSize=10*sc1;
LineW=0.8*sc1;
MarkShape='p';
FontS=20*sc1;
MarkColor='[.85 0.33 .10]'; %Q2[.85 0.33 .10] Q1[.0 0.45 .74]
Lcol='k';

errorbar(Qfp1(3*Qfp1(:,2)<Qfp1(:,1),10),Qfp1(3*Qfp1(:,2)<Qfp1(:,1),1),3*Qfp1(3*Qfp1(:,2)<Qfp1(:,1),2),...
    MarkShape,...
    'LineWidth',LineW,'Color',Lcol,'MarkerEdgeColor',Lcol,... 
    'MarkerFaceColor',MarkColor,...
    'MarkerSize',MarkSize);

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
clearvars -except TraceData Qfp1 Qfp2 Qfp3
%% Q3 rebuilt based on Q3 eval

clearvars Qfp3 procdata Xstart Xend
procdata=TraceData.Q3
MaxTrace=size(procdata.Reflected)
MakePlot=0;
sc1=1.5;

for traceN=[1:1:MaxTrace(1,2)]
err3=0;
err2=0;
err1=0;
fQ=procdata.Reflected(traceN).dataline(1,2);

PT = procdata.Transmitted(traceN).data;
PR = procdata.Reflected(traceN).data;
PF = procdata.Forward(traceN).data;

if MakePlot==1
figure('Position', [100 100 900*sc1 600*sc1]);
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
enddiff=2e-4;
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

if MakePlot==1
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

if MakePlot==1
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

if MakePlot==1
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

if MakePlot==1
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




Qfp3(traceN,1)=Qfp;
Qfp3(traceN,2)=dQfp;
Qfp3(traceN,3)=procdata.Transmitted(traceN).PeakField;
Qfp3(traceN,4)=procdata.Transmitted(traceN).SetTemp;
Qfp3(traceN,5)=Qfpc;
Qfp3(traceN,6)=QLtrans;
Qfp3(traceN,7)=QLref;
Qfp3(traceN,8)=TauRef;
Qfp3(traceN,9)=TauTrans;
Qfp3(traceN,10)=traceN;
Qfp3(traceN,12)=procdata.Transmitted(traceN).dataline(1,25);

if or(or(err1==1,err2==1),err3==1)
Qfp3(traceN,1)=NaN;
Qfp3(traceN,2)=NaN;
Qfp3(traceN,3)=NaN;
Qfp3(traceN,4)=NaN;
Qfp3(traceN,5)=NaN;
Qfp3(traceN,6)=NaN;
Qfp3(traceN,7)=NaN;
Qfp3(traceN,8)=NaN;
Qfp3(traceN,9)=NaN;
Qfp3(traceN,10)=NaN;
Qfp3(traceN,12)=NaN;
end
err3=0;
err2=0;
err1=0;
end


sc1=1
% hold on
figure('Position', [100 100 900*sc1 600*sc1])
xtitle='~Bpeak on sample (based on Qfp~3e10)'
ytitle='Qfp, estimated from the pulse'
MarkSize=8*sc1;
LineW=0.8*sc1;
MarkShape='^';
FontS=20*sc1;
MarkColor='[.85 0.33 .10]'; %Q2[.85 0.33 .10] Q1[.0 0.45 .74]
Lcol='k';

errorbar(Qfp3(3*Qfp3(:,2)<Qfp3(:,1),10),Qfp3(3*Qfp3(:,2)<Qfp3(:,1),1),3*Qfp3(3*Qfp3(:,2)<Qfp3(:,1),2),...
    MarkShape,...
    'LineWidth',LineW,'Color',Lcol,'MarkerEdgeColor',Lcol,... 
    'MarkerFaceColor',MarkColor,...
    'MarkerSize',MarkSize);

xlabel(xtitle);
ylabel(ytitle);
grid off
box on
set(gca,'LineWidth',1);
legend('hide','Location','northwest');
set(gca,'FontSize',FontS);
set(gca,'fontname','calibri')

xlim([5 30])
ylim('auto')

%scatter(Qfp3(:,10),Qfp3(:,1))
% figure
% errorbar(Qfp3(:,3),Qfp3(:,1),3*Qfp3(:,2),'o')
% 
% figure
% scatter(Qfp3(:,3),Qfp3(:,2))

clearvars -except TraceData Qfp1 Qfp2 Qfp3
%% Q2 rebuilt based on Q3 eval

clearvars Qfp2 procdata Xstart Xend
procdata=TraceData.Q2
MaxTrace=size(procdata.Reflected)
MakePlot=1;
sc1=1.5;

for traceN=[1:1:9]
err3=0;
err2=0;
err1=0;
fQ=procdata.Reflected(traceN).dataline(1,2);

PT = procdata.Transmitted(traceN).data;
PR = procdata.Reflected(traceN).data;
PF = procdata.Forward(traceN).data;

if MakePlot==1
figure('Position', [100 100 900*sc1 600*sc1]);
hold on;
subplot(2,2,1);
tracename=[procdata.Reflected(traceN).filenName,'; Real Bm: ',...
    num2str(procdata.Transmitted(traceN).RealBm),'; PeakField: ', num2str(procdata.Reflected(traceN).PeakField),...
    '; SetTemp: ', num2str(procdata.Reflected(traceN).SetTemp),'; traceN ',num2str(traceN)];
scatter(PR(:,1),PR(:,3),'.','DisplayName',tracename);
title(tracename);
ylim([0 inf])
set(gca,'FontSize',14);
hold off;
end
Xstart = find(PR(:,3)==max(PR(:,3)),1);
%Xend = find(PR(:,1)>115,1)

%~~~~~~~~~~~~~~~~search Xend~~~~~~~~~~~~~~~~~~~
k1=1;
PTsize=size(PT);
stept=round(PTsize(1,1)/625);
enddiff=2e-4;
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

if MakePlot==1
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

if MakePlot==1
%figure
hold on;
subplot(2,2,2);
plot(PF(:,1),PF(:,3));
ylim([0 inf])
plot(f1,X,Y);
hold off;
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

if MakePlot==1
%figure
subplot(2,2,3);
scatter(PT(:,1),PT(:,3),'.');
hold on;
%ylim([-25 inf])
%legend('show','Location','northwest');
set(gca,'FontSize',14);
scatter(Xt,Yt,'ob');
scatter(PT(Xstart-sampr:Xstart,1),PT(Xstart-sampr:Xstart,3),'oy');
errorbar(PT(Xstart-10,1),mean(PT(and(PT(:,1)>PT((Xstart-sampr),1),PT(:,1)<PT((Xstart),1)),3)),2*std(PT(and(PT(:,1)>PT((Xstart-sampr),1),PT(:,1)<PT((Xstart),1)),3)),...
'o','LineWidth',2,'Color','[0.1490    0.1490    0.1490]');
hold off;
end


EQ1 = [num2str(mean(PT(Xstart:Xstart+3,3))),'*exp(-tau*(x-',num2str(PT(Xstart,1)),'))'];

f2=fit(Xt,Yt,EQ1,MyfitOptions);
TauTrans = coeffvalues(f2)*1e-3;

if MakePlot==1
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




Qfp2(traceN,1)=Qfp;
Qfp2(traceN,2)=dQfp;
Qfp2(traceN,3)=procdata.Transmitted(traceN).PeakField;
Qfp2(traceN,4)=procdata.Transmitted(traceN).SetTemp;
Qfp2(traceN,5)=Qfpc;
Qfp2(traceN,6)=QLtrans;
Qfp2(traceN,7)=QLref;
Qfp2(traceN,8)=TauRef;
Qfp2(traceN,9)=TauTrans;
Qfp2(traceN,10)=traceN;
Qfp2(traceN,11)=procdata.Transmitted(traceN).RealBm;
Qfp2(traceN,12)=procdata.Transmitted(traceN).dataline(1,25);

% if or(or(err1==1,err2==1),err3==1)
% Qfp2(traceN,1)=NaN;
% Qfp2(traceN,2)=NaN;
% Qfp2(traceN,3)=NaN;
% Qfp2(traceN,4)=NaN;
% Qfp2(traceN,5)=NaN;
% Qfp2(traceN,6)=NaN;
% Qfp2(traceN,7)=NaN;
% Qfp2(traceN,8)=NaN;
% Qfp2(traceN,9)=NaN;
% Qfp2(traceN,10)=NaN;
% Qfp2(traceN,11)=NaN;
% Qfp2(traceN,12)=NaN;
% end
err3=0;
err2=0;
err1=0;
end

% Qfp2(:,1) - Qfp;
% Qfp2(:,2) - dQfp;
% Qfp2(:,3) - PeakField;
% Qfp2(:,4) - SetTemp;
% Qfp2(:,5) - Qfpc;
% Qfp2(:,6) - QLtrans;
% Qfp2(:,7) - QLref;
% Qfp2(:,8) - TauRef;
% Qfp2(:,9) - TauTrans;
% Qfp2(:,10)- traceN;

sc1=1
%hold on
figure('Position', [100 100 900*sc1 600*sc1])
xtitle='~TraceN'
ytitle='Qfp, estimated from the pulse'
MarkSize=8*sc1;
LineW=0.8*sc1;
MarkShape='d';
FontS=20*sc1;
MarkColor='[.0 0.45 .74]'; %Q2[.85 0.33 .10] Q1[.0 0.45 .74]
Lcol='k';

errorbar(Qfp2(3*Qfp2(:,2)<Qfp2(:,1),10),Qfp2(3*Qfp2(:,2)<Qfp2(:,1),1),3*Qfp2(3*Qfp2(:,2)<Qfp2(:,1),2),...
    MarkShape,...
    'LineWidth',LineW,'Color',Lcol,'MarkerEdgeColor',Lcol,... 
    'MarkerFaceColor',MarkColor,...
    'MarkerSize',MarkSize);

xlabel(xtitle);
ylabel(ytitle);
grid off
box on
set(gca,'LineWidth',1);
legend('show','Location','northwest');
set(gca,'FontSize',FontS);
set(gca,'fontname','calibri')

xlim('auto')%[5 30]
ylim('auto')


%scatter(Qfp2(:,10),Qfp2(:,1))
% figure
% errorbar(Qfp2(:,3),Qfp2(:,1),3*Qfp2(:,2),'o')
% 
% figure
% scatter(Qfp2(:,3),Qfp2(:,2))

clearvars -except TraceData Qfp1 Qfp2 Qfp3
