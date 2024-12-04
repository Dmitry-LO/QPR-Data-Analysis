%% 1.0 Loading EXPERIMENT DATA CERN
clc,clear
%===========INPUT================
Datapath1 = 'D:\nextcloud\QPR tests & Operation\2022-04-04 - test #36 - ARIES B-3.19 Siegen SIS\monitoring'
FluxData = '..\*2022-04-08 1282MHz Heat_cycle2_slow_back 1.00K*.txt'
%==========/INPUT================

%---------------struct of the database:-----------------------------------
    %ExperimentData
        %ExperimentData.QX(i)*
           %ExperimentData.QX(i).data(:,23)  B - Field
           %ExperimentData.QX(i).data(:,24)  Rs - surf R
           %ExperimentData.QX(i).data(:,25)  Sens A - real temperature
           %ExperimentData.QX(i).data(:,1)  Set temperature
           %ExperimentData.QX(i).FName - filename
           
           %20 - Heater Voltage
           %26 - Sens B - real temperature
%--------------------end of struct----------------------------------------

procdata = fm1_LoadingData_HZB(Datapath1,FluxData,'-','-',1);

ExperimentFluxData = procdata; %define archive namesave
%save(ArchName,'ExperimentData')

disp('<strong>Import operation finished!</strong>');

clearvars -except ExperimentFluxData;

%%
Q1='[.0 0.45 .74]'
Q2='[.85 0.33 .10]'
Q3='[.93 0.69 .13]'
FontS=16

xlabelN='Time'
ylabelN1='Flux gate \itB\rm field data (\muT)'
ylabelN2='Sample temperature \itT\rm (K)'
ylabelN3='DC Heater current \itI\rm (mA)'

Fluxmeasurements1=figure('Position', [200 50 1600*1 1000*1])
figurename= Fluxmeasurements1;


%hold on
subplot(2,1,1);

%exelimpor=heatcycle1BfluxvsTTccrossbackfast;
xaxi=datetime(strcat(ExperimentFluxData.Q1.textdata(2:end,1),{' '},ExperimentFluxData.Q1.textdata(2:end,2)),...
    'InputFormat', 'yyyy/MM/dd HH:mm:ss');

% xaxi=(exelimpor(:,1)-min(exelimpor(:,1))+1)*0.3;

yaxi=ExperimentFluxData.Q1(1).data(:,20)*100;

% yaxi=exelimpor(:,4);

hold on
kkk=plot(xaxi,yaxi,'DisplayName','Flux-gate B field','LineWidth',1,'Color',Q1);
uistack(kkk,'top')
ylabel(ylabelN1)%,'interpreter','latex');


yyaxis right
figure(figurename)

yaxi=ExperimentFluxData.Q1(1).data(:,26)
% yaxi=exelimpor(:,2);

plot(xaxi,yaxi,'--','DisplayName','Temperature','LineWidth',1.5);
hold off

legend('show','Location','northwest');
xlabel(xlabelN)%,'interpreter','latex');
ylabel(ylabelN2)%,'interpreter','latex');

txt = ['\bullet \leftarrow B = ',num2str(yaxi(find(yaxi<9.27,1)))];
text(xaxi(find(yaxi<9.27,1)),yaxi(find(yaxi<9.27,1)),txt,'FontSize',14,'FontName','times')
%text(100,100,txt,'FontSize',14,'FontName','times')

set(gca,'FontSize',FontS);
%set(gca,'fontname','mathematica')
set(gca,'fontname','times')
hold on
plot([min(xaxi),max(xaxi)],[yaxi(find(yaxi<9.27,1)),yaxi(find(yaxi<9.27,1))])
hold off
%title('My Title')
%% second plot
subplot(2,1,2)
yaxi=ExperimentFluxData.Q1(1).data(:,35)

yyaxis right
plot(xaxi,yaxi,'-','DisplayName','Heater current','LineWidth',1,'Color',Q2);
legend('show','Location','northwest');
xlabel(xlabelN)%,'interpreter','latex');
ylabel(ylabelN3)%,'interpreter','latex');


set(gca,'FontSize',FontS);
%set(gca,'fontname','mathematica')
set(gca,'fontname','times')

yyaxis left

%% find date in VTS monitoring
%Sensors 14-18

logfolder=['D:\nextcloud\QPR tests & Operation\2022-04-04 - test #36 - ARIES B-3.19 Siegen SIS\VTS_log\']
logname=dir(strcat(logfolder,'*.txt'))
logfilename=logname.name

VTSData = importdata([logfolder,logname.name],'\t', 2);
diagnSize=size(VTSData.data)

%speed: ~30 sec/30000 points
timerVal = tic;
for i=1:diagnSize(1,1)
VTSData.date(i,1)=datetime([char(VTSData.textdata(i+2,1)),' ',char(VTSData.textdata(i+2,2))],'InputFormat','yyyy/MM/dd HH:mm:ss');
end
elapsedTime = toc(timerVal);
disp(['Elapsed time <strong>',num2str(elapsedTime),'</strong> sec']);



% figure
% subplot(2,1,1)
% scatter([NAData.Q1.date],[NAData.Q1.ShiftF]*1e3,'x')

Begin_time_index=find(VTSData.date(:,1)>'09-Apr-2022 00:02:38',1,'first');%'09-Apr-2022 13:18:54';
End_time_index=find(VTSData.date(:,1)<'09-Apr-2022 03:38:52',1,'last');%'09-Apr-2022 19:54:11';


figure
plot(VTSData.date(Begin_time_index:End_time_index),VTSData.data(Begin_time_index:End_time_index,14),...
    'DisplayName','VTS pressure, mBar')
hold on
plot(VTSData.date(Begin_time_index:End_time_index),VTSData.data(Begin_time_index:End_time_index,15),...
    'DisplayName','Sensor X, K')
plot(VTSData.date(Begin_time_index:End_time_index),VTSData.data(Begin_time_index:End_time_index,16),...
    'DisplayName','Sensor X, K')
plot(VTSData.date(Begin_time_index:End_time_index),VTSData.data(Begin_time_index:End_time_index,17),...
    'DisplayName','Sensor X, K')
plot(VTSData.date(Begin_time_index:End_time_index),VTSData.data(Begin_time_index:End_time_index,18),...
    'DisplayName','Sensor X, K')

yyaxis right
plot(VTSData.date(Begin_time_index:End_time_index),VTSData.data(Begin_time_index:End_time_index,3),...
    'DisplayName','He Level, %','LineWidth',1)
hold off
legend show
yyaxis left