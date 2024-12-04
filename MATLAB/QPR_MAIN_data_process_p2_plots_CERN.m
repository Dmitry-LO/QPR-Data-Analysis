%% 0. START > perform first part p1
%from this point data- unique
Q1='[.0 0.45 .74]';
Q2='[.85 0.33 .10]';
Q3='[.93 0.69 .13]';

%Pal0 = distinguishable_colors(5);


Pal1(1,:)=  [89	188	206]/255;
Pal1(2,:)=  [0	115	189]/255;
Pal1(3,:)=  [217 83  25]/255;
Pal1(4,:)=  [225 122 0]/255;
Pal1(5,:)=  [255 215  0]/255;

Pal3(1,:)=  [254, 239, 229]/255;
Pal3(2,:)=  [0, 145, 110]/255;
Pal3(3,:)=  [0	115	189]/255;
Pal3(4,:)=  [217 83  25]/255;
Pal3(5,:)=  [255, 207, 0]/255;

mshape1(1)='^';
mshape1(2)='d';
mshape1(3)='v';
mshape1(4)='x';
mshape1(5)='o';
%% palette
Pal=Pal3;
figure
hold on
for plaN=1:5
area([plaN-1,plaN], [2,2],'FaceColor',Pal(plaN,:),'LineStyle','none')
end
axis off
hold off
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~/func~~~~~~~~~~~~~~~~~~~~
%% 3.1 Rs vs T
%clearvars RsvT
clearvars outdata

Bfield = [18]; %mT, define magnetic field for this plot [2.7,4.5,9.2,13.75]
Bstep=2.0; %mT, field range to find data close to the defined value (has to be > 0.1)
Tstep=0.25;
inputdata(:,23) = ExperimentData(:,12); %B field
inputdata(:,24) = ExperimentData(:,21); %Rs
inputdata(:,26) = ExperimentData(:,16); %T

SensN = 26; %define Temp sensor 25 - Sensor A (default), 26 - B, 27 - C, 28 - D.

CW_sort=1; %Do you need to separate points by CW/Pulse?
File_sort=0; %Do you need to separate points from diferrent files?
Run_sort=1; %Do you need to separate points by Run Numbers?
Runs2comb=[0]; %ONLY works if Run_sort=0. Combines ONLY runs spec in Runs2comb to one dataset; of 0 - takes all runs

[outdata,BData]=fm3_1_RsvTData_v1(inputdata,Bfield,Bstep,Tstep,SensN,CW_sort,File_sort,Run_sort,Runs2comb);


disp('=================================');
disp(['Data Found for B field values ',num2str(BData(2,BData(2,:)>0)),' [mT]']);
disp('=================================');
if mean(BData(1,:))>0
disp('=================================');
disp('<strong>WARNING!</strong>');
disp(['NO data Found for B field values ',num2str(BData(1,BData(1,:)>0)),' [mT]']);
disp('=================================');
end
%% errors calc
mu0=1.25664E-06
ss1=size(outdata.data);
dRF=0.05;

modes=3;
% PATH TO Qfp pulses
%FPath='D:\nextcloud\QPR tests & Operation\2022-02-25 - test #35 - ARIES B-2.13 Siegen SIS\pulsesQ1\';
FPath='D:\nextcloud\QPR tests & Operation\2022-04-04 - test #36 - ARIES B-3.19 Siegen SIS\Qfp3_day5\';

[Qfp,sigQfp]=QPR_Qfp_calc_HZB_func(modes,FPath);

for kx=1:ss1(1,1)

Pt=outdata.dataline(kx,34);
PtW=10^((Pt-30)/10);
Qp=outdata.dataline(kx,15);
c2=outdata.dataline(kx,17);
c1=outdata.dataline(kx,16);
fQ=outdata.dataline(kx,2);
%kx
%dBRF=500*0.05*WR0*1/sqrt((c2*PtW*WR0)/Pt0)*(c2*PtW/Pt0)
%B=1000*sqrt(c2*Qp*PtW/(2*pi*fQ))
%dBRF=Qp*0.08*500*c2*PtW/(2*pi*fQ)/sqrt(c2*Qp*PtW/(2*pi*fQ))

dBRF=dRF*outdata.data(kx,1)/2;
 outdata.data(kx,8)=dBRF;
 outdata.data(kx,9)=sqrt((outdata.data(kx,2)*3)^2+(dBRF)^2);
 
  deltaBfull=outdata.data(kx,1)*sqrt((3*sigQfp/(2*Qfp*sqrt(Qfp)))^2+(dRF/2)^2);
  
% dRsRF=2*outdata.data(kx,9)*2e15*c1*mu0^2*(outdata.dataline(kx,22)/1000)*100/(outdata.dataline(kx,3)*outdata.data(kx,1)^3);
 dRsRFsyst=deltaBfull*2*outdata.data(kx,3)/outdata.data(kx,1);%outdata.data(kx,1)
 outdata.data(kx,10)=dRsRFsyst;
 outdata.data(kx,11)=sqrt((outdata.data(kx,4)*3)^2+(dRsRFsyst)^2);
 
 
 %dB(Qfpnoise) & dBCal
end
%%
if mode==1
    RsvT.Q1=outdata;
    RsvT=rmfield(RsvT,'Q1');
    RsvT.Q1=outdata;
elseif mode==2
    RsvT.Q2=outdata;
    RsvT=rmfield(RsvT,'Q2');
    RsvT.Q2=outdata;
elseif mode==3
    RsvT.Q3=outdata;
    RsvT=rmfield(RsvT,'Q3');
    RsvT.Q3=outdata;
end

 %/errors calc

%---------------struct of the database:-----------------------------------
%RsvT.QX(:).data - measured data
    %RsvT.QX(:).data(:,1) - mean Sensor temp
    %RsvT.QX(:).data(:,2) - 1 sigma Sensor temp
    %RsvT.QX(:).data(:,3) - Rs [nOhm]
    %RsvT.QX(:).data(:,4) - 1 sigma of Rs points
    %RsvT.QX(:).data(:,5) - Run Number, if 0 - Not spec
    %RsvT.QX(:).data(:,6) - CW (100) (or duty factor if CW sort=1)
    %RsvT.QX(:).data(:,7) - File number if File_sort=1, corr. to num. in ExperimentData
%RsvT.QX(:).Bfield - B field value (average) corr to the dataset
%RsvT.QX(:).dataline(:) - full dataline from the .txt file of the firs point
%of averaged point set.
%--------------------end of struct----------------------------------------

%% 4.1 Plots RsvT
%previous param! CW_sort
Q1='[.0 0.45 .74]';
Q2='[.85 0.33 .10]';
Q3='[.93 0.69 .13]';
Q0='none';
Pal=Pal3;
%===========INPUT=================================%
NEW_FIGURE=1;
err_or_plt='err';

nsig = 1;
BFieldVal = 18; %field level to plot
Tmin = 1;
Tmax = 6.0;

RunN=[0];%1,4,6 %starting from min 1; 0 - plot all runs in one line
CW_mode=1; %toggle CW mode plot (all data CW=100 if not sorted CW_sort=0)
Pulse_mode=1; %all if not sorted CW_sort=0

PlotModeData=outdata;
%===========INPUT=================================%

%=======[PLOT FORMAT SET]==========================%
colN=2;
% figtitle = 'Rs as a function of T, x MHz';
sc1=1; %scaling
xlabelN='Sample temperature \itT\rm (K)'; %"RunN" %
ylabelN='Surface resistance \itR_s\rm (nOhm)';
freq=num2str(round(PlotModeData(1).dataline(1,2)/1e6,0));
plot1name=[freq,' MHz, B ',num2str(BFieldVal),' mT Run ',num2str(RunN)]% mT Run ',num2str(RunN),', 3 µm Nb/Cu B5.4'];  %define plot 1 name
MarkSize=6*sc1;
LineW=1.0*sc1;
FontS=20*sc1;
MarkShape=mshape1(colN);
%MarkColor=num2str(Pal(3,:));
MarkColor=num2str(Pal3(colN,:));
Lcol='k';

%=======[/PLOT FORMAT SET]=========================%

[PlXax,PlYax,PlXer,PlYer]=fpost1_plotRs_sort2(CW_sort,RunN,Tmin,Tmax,BFieldVal,CW_mode,Pulse_mode,PlotModeData);

% PlYax=RsvT.Q1(1).data(55,3) %25
% PlXax=RsvT.Q1(1).data(55,5)

% PlXax=RsvsRun.Q2(:,5)
% PlYax=RsvsRun.Q2(:,3)

if NEW_FIGURE==1
figure('Position', [100 100 900*sc1 600*sc1])
end

hold on
%yyaxis right
if err_or_plt=='err'
errorbar(PlXax,PlYax,nsig*PlYer,...
    MarkShape,'DisplayName',plot1name,...
    'LineWidth',LineW,'Color',Lcol,'MarkerEdgeColor',Lcol,... 
    'MarkerFaceColor',MarkColor,...
    'MarkerSize',MarkSize);
elseif err_or_plt=='plt'
plot(PlXax,PlYax,...
    MarkShape,'DisplayName',plot1name,...
    'LineWidth',LineW,'Color',Lcol,'MarkerEdgeColor',Lcol,... 
    'MarkerFaceColor',MarkColor,...
    'MarkerSize',MarkSize);
end
hold off

%title(figtitle);
xlabel(xlabelN);
ylabel(ylabelN);
grid off
box on
set(gca,'LineWidth',1);
legend('show','Location','northwest');
set(gca,'FontSize',FontS);
set(gca,'fontname','times')

xlim([Tmin Tmax])
ylim('auto')

%% 3.2 Rs vs B
%from this point data- unique
clearvars outdata

Temp = [4.5]; %mT, define magnetic field for this plot
Tstep=0.05; %mT, field range to find data close to the defined value (has to be > 0.1)
Bstep=0.8;
inputdata(:,23) = ExperimentData(:,12); %B field
inputdata(:,24) = ExperimentData(:,21); %Rs
inputdata(:,26) = ExperimentData(:,16); %T

SensN = 26; %define Temp sensor 25 - Sensor A (default), 26 - B, 27 - C, 28 - D.

CW_sort=0; %Do you need to separate points by CW/Pulse?
File_sort=0; %Do you need to separate points from diferrent files?
Run_sort=1; %Do you need to separate points by Run Numbers?
Runs2comb=[0]; %ONLY works if Run_sort=0. Combines only runs spec in one dataset; of 0 - takes all data

[outdata,TData]=fm3_2_RsvBData_v2(inputdata,Temp,Tstep,Bstep,SensN,CW_sort,File_sort,Run_sort,Runs2comb);

disp('=================================');
disp(['Data Found for T values ',num2str(TData(2,TData(2,:)>0)),' [K]']);
disp('=================================');
if mean(TData(1,:))>0
disp('=================================');
disp('<strong>WARNING!</strong>');
disp(['NO data Found for B field values ',num2str(TData(1,TData(1,:)>0)),' [K]']);
disp('=================================');
end

%% =============================== ERRORCALC
mu0=1.25664E-06
ss1=size(outdata.data);
dRF=0.05

for kx=1:ss1(1,1)

Pt=outdata.dataline(kx,34);
PtW=10^((Pt-30)/10)
Qp=outdata.dataline(kx,15);
c2=outdata.dataline(kx,17);
c1=outdata.dataline(kx,16);
WR0=0.00246098705223023;
Pt0=0.0059110554607161;
% Pt0=0.00011229837110247;
% WR0=3.12E-03;
fQ=outdata.dataline(kx,2)
%kx
%dBRF=500*0.05*WR0*1/sqrt((c2*PtW*WR0)/Pt0)*(c2*PtW/Pt0)
%B=1000*sqrt(c2*Qp*PtW/(2*pi*fQ))
%dBRF=Qp*0.08*500*c2*PtW/(2*pi*fQ)/sqrt(c2*Qp*PtW/(2*pi*fQ))

dBRF=dRF*outdata.data(kx,1)/2;%dRF*500*sqrt(c2*WR0*PtW/Pt0)
 outdata.data(kx,8)=dBRF;
 outdata.data(kx,9)=sqrt((outdata.data(kx,2)*3)^2+(dBRF)^2);
 
% dRsRF=2*outdata.data(kx,9)*2e15*c1*mu0^2*(outdata.dataline(kx,22)/1000)*100/(outdata.dataline(kx,3)*outdata.data(kx,1)^3);
 dRsRFsyst=outdata.data(kx,3)*2*dBRF/outdata.data(kx,1)
 outdata.data(kx,10)=dRsRFsyst;
 outdata.data(kx,11)=sqrt((outdata.data(kx,4)*3)^2+(dRsRFsyst)^2);
end
%% =====================================

if mode==1
    RsvB.Q1=outdata;
    RsvB=rmfield(RsvB,'Q1');
    RsvB.Q1=outdata;
elseif mode==2
    RsvB.Q2=outdata;
    RsvB=rmfield(RsvB,'Q2');
    RsvB.Q2=outdata;
elseif mode==3
    RsvB.Q3=outdata;
    RsvB=rmfield(RsvB,'Q3');
    RsvB.Q3=outdata;
end

%---------------struct of the database:-----------------------------------
%RsvB.QX(:).data - measured data
    %RsvB.QX(:).data(:,1) - mean B field [mT]
    %RsvB.QX(:).data(:,2) - 1 sigma B field [mT] (statistical)
    %RsvB.QX(:).data(:,3) - Rs [nOhm]
    %RsvB.QX(:).data(:,4) - 1 sigma of Rs points
    %RsvB.QX(:).data(:,5) - Run Number, if 0 - Not spec
    %RsvB.QX(:).data(:,6) - CW (100) (or duty factor if CW sort=1)
    %RsvB.QX(:).data(:,7) - File number if File_sort=1, corr. to num. in ExperimentData
    %RsvB.QX(:).data(:,8) - dB - Analytical
    %RsvB.QX(:).data(:,8) - dRs - Analytical
%RsvB.QX(:).Temp - temperature value corr. to the dataset
%RsvB.QX(:).dataline(:) - full dataline from the .txt file of the firs point
%of averaged point set.
%--------------------end of struct----------------------------------------
   % Qcolor = distinguishable_colors(5);
%% 4.2 Plots RsvB
%previous param! CW_sort
Q1='[.0 0.45 .74]';
Q2='[.85 0.33 .10]';
Q3='[.93 0.69 .13]';
Pal=Pal3;%distinguishable_colors(5);

%===========INPUT=================================%
NEW_FIGURE=1;
colN=2;
err_or_plt='err';

nsig = 3;
TempVal = [4.5]; %field level to plot
Bmin = 0;
Bmax = 50;

RunN=[0,8];%starting from min 1; 0 - plot all runs in one line
CW_mode=1; %toggle CW mode plot (all data CW=100 if not sorted CW_sort=0)
Pulse_mode=1; %all if not sorted CW_sort=0
PlotModeData=outdata;


for TT=TempVal

%===========INPUT=================================%
TempVal=TT;

%=======[PLOT FORMAT SET]==========================%

% figtitle = 'Rs as a function of T, 415 MHz'
sc1=1; %scaling

xlabelN='Peak field on sample \itB\rm [mT]';
ylabelN='Surface resistance \itR_s\rm (nOhm)';
freq=num2str(round(PlotModeData(1).dataline(1,2)/1e6,0));
plot1name=[freq,' MHz, ',num2str(TempVal),' K'];  %define plot 1 name [freq,' MHz, ',num2str(TempVal),' K Run ',num2str(RunN),', B2 Nb/Cu CERN']
%plot1name=['800 MHz, B ',num2str(TempVal),' mT Run ',num2str(RunN)];  %define plot 1 name
MarkSize=6*sc1;
LineW=1.0*sc1;
FontS=20*sc1;
MarkShape=mshape1(colN);
MarkColor=num2str(Pal(colN,:));
%MarkColor='none';
Lcol='k';
%Lcol=num2str(Pal(colN,:));
%=======[/PLOT FORMAT SET]=========================%


[PlXax,PlYax,PlXer,PlYer]=fpost1_plotRs_sort2(CW_sort,RunN,Bmin,Bmax,TempVal,CW_mode,Pulse_mode,PlotModeData); % _sort2 original, _sort if errors calac used


if NEW_FIGURE==1
figure('Position', [100 100 900*sc1 600*sc1])
end
hold on

% x = PlXax%(1:end);
% y = PlYax%(1:end);
% dy = PlYer%(1:end);  % made-up error values
% 
% ff1(2)=fill([x;flipud(x)],[y-dy;flipud(y+dy)],[.9 .9 .9],'linestyle','none');
% ff1(3)=line(x,y)

%[PlXax,PlYax,PlXer,PlYer]=fpost1_plotRs_sort2(CW_sort,RunN,Bmin,Bmax,TempVal,CW_mode,Pulse_mode,PlotModeData);
clear errorbar


if err_or_plt=='err'
%     area(PlXax,PlYax+PlYer)
%     area(PlXax,PlYax-PlYer)
ff1(1)=errorbar(PlXax,PlYax,nsig*PlYer,...
    MarkShape,'DisplayName',plot1name,...
    'LineWidth',LineW,'Color',Lcol,'MarkerEdgeColor',Lcol,... 
    'MarkerFaceColor',MarkColor,...
    'MarkerSize',MarkSize);
elseif err_or_plt=='plt'
ff1(1)=plot(PlXax,PlYax,...
    MarkShape,'DisplayName',plot1name,...
    'LineWidth',LineW,'Color',Lcol,'MarkerEdgeColor',Lcol,... 
    'MarkerFaceColor',MarkColor,...
    'MarkerSize',MarkSize);
end
hold off

colN=colN+1;
if colN>5
colN=1;
end
NEW_FIGURE=0;
end
% title(figtitle);
xlabel(xlabelN);
ylabel(ylabelN);
grid off
box on
set(gca,'LineWidth',1);
legend('show','Location','northwest');
set(gca,'FontSize',FontS);
set(gca,'fontname','times')

xlim([Bmin Bmax])
xlim('auto')
ylim('auto')

%% saving plots
% 
% plotFilename='RsvsB_errors2_combined'%'RsvT_test18v25_Q2_lowField_ForBCS' %'pulses_Qfp_test#17vs18'
% 
% 
% saveas(gcf,['pictures and plots\',plotFilename],'fig')
% orient(gcf,'landscape')
% mkdir 'pictures and plots' PDF_format
% saveas(gcf,['pictures and plots\PDF_format\',plotFilename],'pdf')
% orient(gcf,'portrait')
% print(gcf,['pictures and plots\',plotFilename],'-dtiff','-r300')
% mkdir 'pictures and plots' lower_res
% print(gcf,['pictures and plots\lower_res\',plotFilename],'-dtiff','-r150')
% mkdir 'pictures and plots' JEPEGE
% print(gcf,['pictures and plots\JEPEGE\',plotFilename],'-djpeg','-r300')

%% saving plots

plotFilename='SetTvsheaterPower_test21';%'RsvT_test18v25_Q2_lowField_ForBCS' %'pulses_Qfp_test#17vs18'


saveas(gcf,['pictures\',plotFilename],'fig')
orient(gcf,'landscape')
mkdir 'pictures' PDF_format
saveas(gcf,['pictures\PDF_format\',plotFilename],'pdf')
orient(gcf,'portrait')
print(gcf,['pictures\',plotFilename],'-dtiff','-r300')
mkdir 'pictures' lower_res
print(gcf,['pictures\lower_res\',plotFilename],'-dtiff','-r100')
mkdir 'pictures' JEPEGE
print(gcf,['pictures\JEPEGE\',plotFilename],'-djpeg','-r300')
mkdir 'pictures' SVG
saveas(gcf,['pictures\SVG\',plotFilename],'svg')
mkdir 'pictures' PNG
saveas(gcf,['pictures\PNG\',plotFilename],'png')

%% saving plots LATEX!!!==============================================

plotFilename='B2-13&3-19_Hc1vsT_Q1_fit_v1'; %RsvB_Q1_allT_n1 B2-13_Hc1vsT_Q1_fit_v1
folder='D:\nextcloud\PhD\LatexFormat\Figures\SIS-QPR\';

saveas(gcf,[folder,plotFilename],'fig')
orient(gcf,'landscape')
saveas(gcf,[folder,plotFilename],'pdf')
orient(gcf,'portrait')
print(gcf,[folder,plotFilename],'-dtiff','-r300')
mkdir(folder,'lower_res')
print(gcf,[folder,'lower_res\',plotFilename],'-dtiff','-r100')
print(gcf,[folder,'lower_res\',plotFilename],'-dpng','-r100')
mkdir(folder,'PNG')
saveas(gcf,[folder,'PNG\',plotFilename],'png')
