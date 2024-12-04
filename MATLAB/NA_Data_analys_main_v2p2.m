clc,clear
FPath = 'D:\nextcloud\QPR tests & Operation\2022-04-04 - test #36 - ARIES B-3.19 Siegen SIS\NA_Data\' %

NAData=NA_f1_import(FPath)
disp(['Import operation <strong>finished</strong>']);

archname='NAData36.mat';
save(archname,'NAData') 
disp(['file <strong>',archname,'</strong> saved']);

%NOTE NAData.Q1(i).dataline(1,25)  Sens A - real temperature
%% simple plot from MAX(S21) vs T

PlotModes=[1,2,3];

for PlotModesn=PlotModes
if PlotModesn==1
    FQ1data=figure('Position', [100 100 1600*1 1000*1])
    figtitle=('FQ1 data')
    
    subplot(2,1,1);
    figurename= FQ1data;
    
    clearvars procdata
    procdata=NAData.Q1;
elseif PlotModesn==2
    FQ2data=figure('Position', [100 100 1600*1 1000*1])
    figtitle=('FQ2 data')
    subplot(2,1,1);
    figurename= FQ2data;
    
    clearvars procdata
    procdata=NAData.Q2;
elseif PlotModesn==3
    FQ3data=figure('Position', [100 100 1600*1 1000*1])
    figtitle=('FQ3 data')
    subplot(2,1,1);
    figurename= FQ3data;
    
    clearvars procdata
    procdata=NAData.Q3;
end

figure(figurename);
title(figtitle);
legend show
%legend('Location','northeastoutside')
mS21N1=size(procdata);
mS21N=mS21N1(1,2);
%xaxi=zeros(mS21N,1);
yaxi=zeros(mS21N,1);
for i=1:mS21N
    yaxi(i)=procdata(i).data(find(procdata(i).data(:,2)==max(procdata(i).data(:,2)),1),1);
    xaxi(i)=procdata(i).date;
end
hold on
figure(figurename)
plot(xaxi,yaxi,'DisplayName','Max F from S_2_1 data','Color','[0.451 0.6784 0.8235]');
hold off

yaxi=zeros(mS21N,1);
for i=1:mS21N
    yaxi(i)=procdata(i).SensB;
end
hold on
yyaxis right
figure(figurename)
plot(xaxi,yaxi,'DisplayName','Temperature','LineWidth',1);
hold off

% yaxi=zeros(mS21N,1);
% for i=1:mS21N
%     yaxi(i)=procdata(i).CenterF;
% end
% hold on
% yyaxis left
% figure(figurename)
% plot(xaxi,yaxi,'DisplayName','Center F from resonance curve fit','Color','k','LineWidth',1);
% hold off
% 
% legend show

end

%% FITTING RESONANCE CURVE
OutPlots = 1; %create resonance fit plots for control 0 or 1
Plotdens=50; %make plot every N points
FunctionControls=[OutPlots,Plotdens];

TNum=10; %field Number from NAData to take Center freq for fit parameters 
CenterF1=NAData.Q1(TNum).data(find(NAData.Q1(TNum).data(:,2)==max(NAData.Q1(TNum).data(:,2))),1);
CenterF2=NAData.Q2(TNum).data(find(NAData.Q2(TNum).data(:,2)==max(NAData.Q2(TNum).data(:,2))),1);
CenterF3=NAData.Q3(TNum).data(find(NAData.Q3(TNum).data(:,2)==max(NAData.Q3(TNum).data(:,2))),1);

startPoints1=[4e-6 CenterF1 5e-6 0];
startPoints2=[4e-6 CenterF2 5e-6 0];
startPoints3=[4e-6 CenterF3 5e-6 0];

%  startPoints1=[1 1e7 CenterF1];
%  startPoints2=[1 1e7 CenterF2];
%  startPoints3=[1 1e7 CenterF3];

lowSP=[1e-20 100 0 0];
%lowSP=[1e-20 0 1e5];

MyfitOptions1 = fitoptions('Method','NonlinearLeastSquares','Lower',lowSP,'Startpoint',startPoints1,'MaxIter',200,'MaxFunEvals',200);
MyfitOptions2 = fitoptions('Method','NonlinearLeastSquares','Lower',lowSP,'Startpoint',startPoints2,'MaxIter',200,'MaxFunEvals',200);
MyfitOptions3 = fitoptions('Method','NonlinearLeastSquares','Lower',lowSP,'Startpoint',startPoints3,'MaxIter',200,'MaxFunEvals',200);


[NAData.Q1,elapsedTime]=NA_f2_Resonancefit_v1_2(NAData.Q1,MyfitOptions1,FunctionControls);
    disp(['status: <strong>operation Q1 finished</strong>']);
    disp(['Elapsed time <strong>',num2str(elapsedTime),'</strong> sec']);
[NAData.Q2,elapsedTime]=NA_f2_Resonancefit_v1_2(NAData.Q2,MyfitOptions2,FunctionControls);
    disp(['status: <strong>operation Q2 finished</strong>']);
    disp(['Elapsed time <strong>',num2str(elapsedTime),'</strong> sec']);
[NAData.Q3,elapsedTime]=NA_f2_Resonancefit_v1_2(NAData.Q3,MyfitOptions3,FunctionControls);
    disp(['status: <strong>operation Q3 finished</strong>']);
    disp(['Elapsed time <strong>',num2str(elapsedTime),'</strong> sec']);

    save([archname,'_RF_fit.mat'],'NAData')

Shieftf21=mean([NAData.Q1(1:9).ShiftF]);
Shieftf22=mean([NAData.Q2(1:9).ShiftF]);
Shieftf23=mean([NAData.Q3(1:9).ShiftF]);

mS21Ns=size(NAData.Q1)
for ik=1:mS21Ns(1,2)
NAData.Q1(ik).ShiftF=NAData.Q1(ik).ShiftF+abs(Shieftf21);
end

mS21Ns=size(NAData.Q2)
for ik=1:mS21Ns(1,2)
NAData.Q2(ik).ShiftF=NAData.Q2(ik).ShiftF+abs(Shieftf22);
end

mS21Ns=size(NAData.Q3)
for ik=1:mS21Ns(1,2)
NAData.Q3(ik).ShiftF=NAData.Q3(ik).ShiftF+abs(Shieftf23);
end

save([archname,'_RF_fit2.mat'],'NAData')
%%
clearvars yaxi xaxi
for PlotModesn=PlotModes
if PlotModesn==1
    subplot(2,1,1);
    figurename= FQ1data;
    
    clearvars procdata
    procdata=NAData.Q1;
elseif PlotModesn==2
    subplot(2,1,1);
    figurename= FQ2data;
    
    clearvars procdata
    procdata=NAData.Q2;
elseif PlotModesn==3
    subplot(2,1,1);
    figurename= FQ3data;
    
    clearvars procdata
    procdata=NAData.Q3;
end
mS21N1=size(procdata);
mS21N=mS21N1(1,2);
yaxi=zeros(mS21N,1);
for i=1:mS21N
    yaxi(i)=procdata(i).CenterF;
    xaxi(i)=procdata(i).date;
end
figure(figurename)
hold on
yyaxis left
plot(xaxi,yaxi,'DisplayName','Center F from resonance curve fit','Color','k','LineWidth',1);
hold off

legend show

end
%% He level correction p1

%FileIDdiagnost='..\vts_log\*.txt'
logfolder=['D:\nextcloud\QPR tests & Operation\2022-04-04 - test #36 - ARIES B-3.19 Siegen SIS\VTS_log\']
logname=dir(strcat(logfolder,'*.txt'))
logfilename=logname.name

HeLevelGen = importdata([logfolder,logname.name],'\t', 2);
diagnSize=size(HeLevelGen.data)

%speed: ~30 sec/30000 points
timerVal = tic;
for i=1:diagnSize(1,1)
HeLevelGen.date(i,1)=datetime([char(HeLevelGen.textdata(i+2,1)),' ',char(HeLevelGen.textdata(i+2,2))],'InputFormat','yyyy/MM/dd HH:mm:ss');
end
elapsedTime = toc(timerVal);
disp(['Elapsed time <strong>',num2str(elapsedTime),'</strong> sec']);


figure(FQ1data)
% figure
% subplot(2,1,1)
% scatter([NAData.Q1.date],[NAData.Q1.ShiftF]*1e3,'x')

Begin_time_index=find(HeLevelGen.date(:,1)>NAData.Q1(1).date,1,'first');
End_time_index=find(HeLevelGen.date(:,1)<NAData.Q1(end).date,1,'last');

% hold on
% yyaxis right
% scatter([NAData.Q1.date],[NAData.Q1.SensA],'.');
% hold off
save([archname,'_He_corr_p1.mat'],'NAData')
subplot(2,1,2)

plot(HeLevelGen.date(Begin_time_index:End_time_index),HeLevelGen.data(Begin_time_index:End_time_index,4),...
    'DisplayName','VTS pressure, mBar')

hold on
yyaxis right
plot(HeLevelGen.date(Begin_time_index:End_time_index),HeLevelGen.data(Begin_time_index:End_time_index,3),...
    'DisplayName','He Level, %','LineWidth',1)
hold off
legend show
%%

HeLevelGenFitDate=HeLevelGen.date(Begin_time_index:End_time_index);
HeLevelGenFit=HeLevelGen.data(Begin_time_index:End_time_index,3);

datefit1= datetime('27-Aug-2021 13:40:59')
datefit2= datetime('27-Aug-2021 15:08:02')

datefit1_index=find(HeLevelGenFitDate(:)<datefit1,1,'last');
datefit2_index=find(HeLevelGenFitDate(:)>datefit2,1,'first');

HeLevelGenFitDate=[HeLevelGenFitDate(1:datefit1_index);HeLevelGenFitDate(datefit2_index:end)]
HeLevelGenFit=[HeLevelGenFit(1:datefit1_index);HeLevelGenFit(datefit2_index:end)]

figure
plot(HeLevelGenFitDate,HeLevelGenFit);
cdsf=size(HeLevelGenFit)
%x=[1:cdsf(1)]'
x = datenum(HeLevelGenFitDate)

fitf=polyfit(x,HeLevelGenFit,3)
yfit = fitf(1)*x.^3+fitf(2)*x.^2+fitf(3)*x+fitf(4)
figure
plot (HeLevelGenFitDate,HeLevelGenFit)
hold on
plot (HeLevelGenFitDate,yfit)

%legend('Location','northeastoutside')
%%
x=datenum(HeLevelGen.date(:))
HeLevelGen.data(:,3)=fitf(1)*x.^3+fitf(2)*x.^2+fitf(3)*x+fitf(4)
%HeLevelGen.date(:)

%% He level correction p2
%F_start_time='2021/02/09 19:56:05'%NAData.Q1(1).date; %119

start_timeT=2;%NAData.Q1(1).SensA;

F_start_timeN=find([NAData.Q1(:).SensB]>start_timeT,1,'first');
F_start_time=NAData.Q1(F_start_timeN).date;
end_timeN=find([NAData.Q1(:).SensB]>start_timeT,1,'last');
F_end_time=NAData.Q1(end_timeN).date;%'2021/02/09 19:56:05'; %'2020/01/10 22:14:35';

StartF=[NAData.Q1(find([NAData.Q1(:).date]==F_start_time,1)).CenterF];


figure(FQ1data)
subplot(2,1,1);
legend hide
%legend('Location','northeastoutside')
yyaxis left
hold on
plot([F_start_time F_start_time],[min(ylim) max(ylim)],'-r','LineWidth',1);
plot([F_end_time F_end_time],[min(ylim) max(ylim)],'-r','LineWidth',1);
plot([min(xlim) max(xlim)],[StartF StartF],'-r','LineWidth',1);
hold off

yyaxis right
hold on
plot([min(xlim) max(xlim)],[NAData.Q1(end_timeN).SensB NAData.Q1(end_timeN).SensB],'--r','LineWidth',1);
hold off
% find([NAData.Q1.SensA]>=8.492,1,'first')
% NAData.Q1(3).SensA


F_end_time=datetime(F_end_time,'InputFormat','yyyy/MM/dd HH:mm:ss');

%he correction to data:
for nmods=1:3
if nmods==1
    NAprocdata=NAData.Q1;
elseif nmods==2
    NAprocdata=NAData.Q2;
elseif nmods==3
    NAprocdata=NAData.Q3;
end
F_start_index=find([NAprocdata.date]>=F_start_time,1,'first');
F_end_index=find([NAprocdata.date]<=F_end_time,1,'last');

Begin_corrHe_index=find(HeLevelGen.date(:,1)>NAprocdata(1).date,1,'first');
End_corrHe_index=find(HeLevelGen.date(:,1)<NAprocdata(end).date,1,'last');

Shift_per_proc=abs(NAprocdata(F_start_index).ShiftF-NAprocdata(F_end_index).ShiftF)/...
    abs(HeLevelGen.data(End_corrHe_index,3)-HeLevelGen.data(Begin_corrHe_index,3)); %Hz/He%
He_level_start_index=find(abs(HeLevelGen.date(:,1)-NAprocdata(1).date)==min(abs((HeLevelGen.date(:,1)-NAprocdata(1).date))),1,'first');

NAdataS=size(NAprocdata);

for i=1:NAdataS(1,2)
He_level_index=find(abs(HeLevelGen.date(:,1)-NAprocdata(i).date)==min(abs((HeLevelGen.date(:,1)-NAprocdata(i).date))),1,'first');
NAprocdata(i).ShiftF_HeCorr=NAprocdata(i).ShiftF+(HeLevelGen.data(He_level_start_index,3)-HeLevelGen.data(He_level_index,3))*Shift_per_proc;  
end


if nmods==1
    NAData.Q1=NAprocdata;
elseif nmods==2
    NAData.Q2=NAprocdata;
elseif nmods==3
    NAData.Q3=NAprocdata;
end


figure
hold on
scatter([NAprocdata.date],[NAprocdata.ShiftF_HeCorr]*1e3,'x')
scatter([NAprocdata.date],[NAprocdata.ShiftF]*1e3,'xr')
hold off
end

save([archname,'_He_corr.mat'],'NAData')
%% Plot first data
figure('Position', [100 100 1350 900])

% for kk=1:3
% 
% if kk==1
% clearvars procdata psize
% procdata=NAData.Q1;
% psize=size(procdata);
% for i=1:psize(1,2)
% 
% FshiftplotQ1(i,1)=NAData.Q1(i).dataline(1,25); %measured T
% FshiftplotQ1(i,2)=NAData.Q1(i).CenterF; %CenterF
% FshiftplotQ1(i,3)=NAData.Q1(i).ShiftF_HeCorr*1000; %ShiftF
% 
% end
% 
% elseif kk==2
% clearvars procdata psize
% procdata=NAData.Q2;
% psize=size(procdata);
% for i=1:psize(1,2)
% 
% FshiftplotQ2(i,1)=procdata(i).dataline(1,25); %measured T
% FshiftplotQ2(i,2)=procdata(i).CenterF; %CenterF
% FshiftplotQ2(i,3)=procdata(i).ShiftF_HeCorr*1000; %ShiftF
% 
% end
% 
% elseif kk==3
% clearvars procdata psize
% procdata=NAData.Q3;
% psize=size(procdata);
% for i=1:psize(1,2)
% 
% FshiftplotQ3(i,1)=procdata(i).dataline(1,25); %measured T
% FshiftplotQ3(i,2)=procdata(i).CenterF; %CenterF
% FshiftplotQ3(i,3)=procdata(i).ShiftF_HeCorr*1000; %ShiftF
% end
% 
% end
% 
% end


hold on
plot([NAData.Q1.SensB],[NAData.Q1.ShiftF_HeCorr]*1e3,'.-','LineWidth',1.0,'DisplayName','416 MHz'); %NAData.Q1.ShiftF_HeCorr
plot([NAData.Q2.SensB],[NAData.Q2.ShiftF_HeCorr]*1e3,'.-','LineWidth',1.0,'DisplayName','849 MHz');
plot([NAData.Q3.SensB],[NAData.Q3.ShiftF_HeCorr]*1e3,'.-','LineWidth',1.0,'DisplayName','1290 MHz');
% plot([NAData.Q1.SensB],[NAData.Q1.ShiftF]*1e3,'x-','LineWidth',1.0,'DisplayName','416 MHz, B-5.11');
% plot([NAData.Q2.SensB],[NAData.Q2.ShiftF]*1e3,'x-','LineWidth',1.0,'DisplayName','849 MHz, B-5.11');
% plot([NAData.Q3.SensB],[NAData.Q3.ShiftF]*1e3,'x-','LineWidth',1.0,'DisplayName','1290 MHz, B-5.11');

hold off


title('Measured resonance frequency shift  as a function temperature for the thin film sample');
xlabel('Sample emperature [K]');
ylabel('Frequency shift [kHz]');
grid on
legend('show','Location','northeast')
set(gca,'FontSize',20)
%legend({'Initial test','Dism. coil'},'Location','northwest');
hold off

%% Lambda Fit

clearvars x y FvsT procdata2 procdata

procdata=NAData.Q1;
psize=size(procdata); 


Tmax=9.38;
Tmin=1.8;
mu0 = 1.25664E-06;

for fn=1:psize(1,2)
procdata2(fn,1) = procdata(fn).dataline(1,25);
procdata2(fn,2) = procdata(fn).ShiftF_HeCorr*1e6;
end

FvsT = procdata2;

x=FvsT(and(Tmin<FvsT(:,1),FvsT(:,1)<Tmax),1)%-0.2;
y=FvsT(and(Tmin<FvsT(:,1),FvsT(:,1)<Tmax),2);

%scatter(x,y);


startPointsL=[9.00E-08]; %Lambda0 [m], Tc [k]

upSP1=[9.00E-08*10]
lowSP1=[9.00E-08*1]


LambdafitOpt1 = fitoptions('Method','NonlinearLeastSquares','Upper',upSP1,'Lower',lowSP1,'Startpoint',startPointsL,'MaxIter',1000,'MaxFunEvals',1000);

EQ = '-(lam0/84.46)*3.1416*1.25664E-06*((417e6)^2)*(1/sqrt(1-(x/9.41)^4)-1)';

%y=y/1000;
f1=fit(x,y,EQ,LambdafitOpt1);

figure('Position', [100 100 900 600])
%figure
plot1name='Data, 415 MHz'
hold on
plot(f1,x,y)
plot(x,y,'x','DisplayName',plot1name,'LineWidth',1.0,'MarkerSize',8)
hold off

title('Measured resonance F shift  as a function temperature, 415 MHz');
xlabel('Temperature T, [K]');
ylabel('Frequency shift [kHz]');
grid on
legend('hide','Location','northwest');
set(gca,'FontSize',20);

f1
