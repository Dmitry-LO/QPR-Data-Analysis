%% 0. START
clc,clear

%% 1.0 Loading EXPERIMENT DATA CERN
clc,clear
%===========INPUT================
Datapath1 = 'D:\nextcloud\QPR tests & Operation\2021-08-21 - test #31 - ARIES-QPR-HZB-B5.11 (INFN with Nb flange)'
%Datapath1 = 'D:\nextcloud\QPR tests & Operation\2022-02-25 - test #35 - ARIES B-2.13 Siegen SIS'
ArchName='CoolDown31HZB.mat' %
% ArchName='CoolDown17HZB.mat' %

modes=[1] %1,2,3

Set1Data = '..\*2021-09-01 413MHz ThermometricPressure_Test_Run7_1E-3mBar 1.00K*.txt'%'..\*41*MHz*Measurements*.txt' %411
Set2Data = '..\*84*MHz*Measurements*.txt' %842
Set3Data = '..\*128*Measurements*.txt'
%==========/INPUT================

%---------------struct of the database:-----------------------------------
    %ExperimentData
        %ExperimentData.QX(i)*
           %ExperimentData.QX(i).data(:,23)  B - Field
           %ExperimentData.QX(i).data(:,24)  Rs - surf R
           %ExperimentData.QX(i).data(:,25)  Sens A - real temperature
           %ExperimentData.QX(i).data(:,1)  Set temperature
           %ExperimentData.QX(i).FName - filename
%--------------------end of struct----------------------------------------

procdata = fm1_LoadingData_HZB(Datapath1,Set1Data,Set2Data,Set3Data,modes);

ExperimentData = procdata; %define archive namesave
%save(ArchName,'ExperimentData')

disp('<strong>Import operation finished!</strong>');

clearvars -except ExperimentData modes;
%% 2.0 SORTING (Preparation) - function CERN
clearvars procdata outdata alldata;
%==========INPUT===================

mode = modes(1); %define mode

c1_Q1 = NaN;
c2_Q1 = NaN;
Gs_Q1 = NaN;
               
c1_Q2 = NaN;
c2_Q2 = NaN;
Gs_Q2 = NaN;

c1_Q3 = NaN;
c2_Q3 = NaN;
Gs_Q3 = NaN;

% attenuation corrections for RF system and cables in dB

Pf_corr_Q1 = NaN;
Pr_corr_Q1 = NaN;
Pt_corr_Q1 = NaN; %dB

Pf_corr_Q2 = NaN;
Pr_corr_Q2 = NaN;
Pt_corr_Q2 = NaN;

Pf_corr_Q3 = NaN;
Pr_corr_Q3 = NaN;
Pt_corr_Q3 = NaN;

% Q probe for 3 freq
QprobQ1=NaN;%7.2E10;%6.05e10;%6.05e10; 4.15E10
QprobQ2=NaN;%1.7e10;%2e10; %1.28E10; %1.20E+10;
QprobQ3=NaN; %1.97E+09; 



if mode==1
    procdata=ExperimentData.Q1;
    Fnumbers=size(ExperimentData.Q1);
elseif mode==2
    procdata=ExperimentData.Q2;
    Fnumbers=size(ExperimentData.Q2);
elseif mode==3
    procdata=ExperimentData.Q3;
    Fnumbers=size(ExperimentData.Q3);
end

%Fnumbers=[1:71]; %size(ExperimentData.Q1); %File numbers to be used in the analyses

%=========================/INPUT================================
[alldata0,alldata]=fm2_alldata_HZB(Fnumbers,procdata,mode,c1_Q1,c2_Q1,Gs_Q1,...
c1_Q2,c2_Q2,Gs_Q2,...
c1_Q3,c2_Q3,Gs_Q3,...
Pf_corr_Q1,Pr_corr_Q1,Pt_corr_Q1,...
Pf_corr_Q2,Pr_corr_Q2,Pt_corr_Q2,...
Pf_corr_Q3,Pr_corr_Q3,Pt_corr_Q3,...
QprobQ1,QprobQ2,QprobQ3);


figure
prcent_diff=100*(alldata0(:,24)- alldata(:,24))./alldata0(:,24);
plot(prcent_diff);
figure
scatter3(alldata(:,26),alldata(:,23),alldata(:,24))
%plot3(alldata(:,1),alldata(:,23),alldata(:,24))
figure
scatter(alldata(:,1),alldata(:,23));
grid on

clearvars -except ExperimentData mode alldata0 alldata modes;
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~/func~~~~~~~~~~~~~~~~~~~~
%% 3.1 Rs vs T > go next p2
