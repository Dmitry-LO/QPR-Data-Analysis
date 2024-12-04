%% 0. START
clc,clear

%% 1.0 Loading EXPERIMENT DATA

%===========INPUT================
ArchName='CoolDown1CERN2_A2.mat' %

Set1Data = '..\Rs_measurment_2019_07_30 18_21_48.539.h5'
Set2Data = '..\Rs_measurment_2019_07_29 19_45_11.625.h5'
Set3Data = '..\Rs_measurment_2019_07_26 20_12_00.952.h5'
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

ExperimentData=fm1_LoadingH5Data_CERN(Set1Data,Set1Data,Set1Data); %name of the main Data archive 
save(ArchName,'ExperimentData')
disp('<strong>Import operation finished!</strong>');

%% 2.0 SORTING (Preparation) - function
clearvars procdata outdata alldata;
%==========INPUT===================

mode = 1; %define mode

c1_Q1 = 1676.4;
c2_Q1 = 0.169;
Gs_Q1 = 78.3;

c1_Q2 = 1748;
c2_Q2 = 0.163;
Gs_Q2 = 170.1;

c1_Q3 = 1913.1;
c2_Q3 = 0.198;
Gs_Q3 = 234.4;

% attenuation corrections for RF system and cables in dB

Pf_corr_Q1 = 39.8349;
Pr_corr_Q1 = 34.6951;
Pt_corr_Q1 = 8.9188; %dB

Pf_corr_Q2 = 39.8649;
Pr_corr_Q2 = 35.204;
Pt_corr_Q2 = 5.1588;

Pf_corr_Q3 = 41.026;
Pr_corr_Q3 = 36.134;
Pt_corr_Q3 = 8.9188;

% Q probe for 3 freq
QprobQ1=6.7951e+07%1.20E+09;
QprobQ2=3.6424e+8; %2E+9; %1.20E+10;
QprobQ3=9.8811e+07 %1.97E+09; 



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
[alldata0,alldata]=fm2_alldata_CERN(Fnumbers,procdata,mode,c1_Q1,c2_Q1,Gs_Q1,...
c1_Q2,c2_Q2,Gs_Q2,...
c1_Q3,c2_Q3,Gs_Q3,...
Pf_corr_Q1,Pr_corr_Q1,Pt_corr_Q1,...
Pf_corr_Q2,Pr_corr_Q2,Pt_corr_Q2,...
Pf_corr_Q3,Pr_corr_Q3,Pt_corr_Q3,...
QprobQ1,QprobQ2,QprobQ3);


figure
prcent_diff=100*abs(alldata0(:,24)- alldata(:,24))./alldata0(:,24);
plot(prcent_diff);
figure
scatter3(alldata(:,1),alldata(:,23),alldata(:,24))
figure
scatter(alldata(:,1),alldata(:,23));
grid on

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~/func~~~~~~~~~~~~~~~~~~~~
%% 3.1 Rs vs T > go next p2
%.
%.