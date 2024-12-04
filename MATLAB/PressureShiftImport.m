
%===========INPUT================
Datapath1 = 'D:\nextcloud\QPR tests & Operation\2021-08-21 - test #31 - ARIES-QPR-HZB-B5.11 (INFN with Nb flange)'
%Datapath1 = 'D:\nextcloud\QPR tests & Operation\2022-02-25 - test #35 - ARIES B-2.13 Siegen SIS'
ArchName='CoolDown31HZB.mat' %
% ArchName='CoolDown17HZB.mat' %

modes=[1] %1,2,3

Set1Data = '..\*2021-09-01 413MHz ThermometricPressure_Test_Run6_3E-5mBar 1.00K*.txt'%'..\*41*MHz*Measurements*.txt' %411
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

PressureTest = fm1_LoadingData_HZB(Datapath1,Set1Data,Set2Data,Set3Data,modes);


dayandtime=datetime(strcat(PressureTest.Q1.textdata(2:end,2),{' '},PressureTest.Q1.textdata(2:end,1)),'InputFormat','HH:mm:ss yyyy/MM/dd');

Xaxfplot1=dayandtime;
Yaxfplot1=PressureTest.Q1.data(:,21);

%% pressyre

PressureTest2=importdata('D:\nextcloud\QPR tests & Operation\2021-08-21 - test #31 - ARIES-QPR-HZB-B5.11 (INFN with Nb flange)\VTS_log\2021-08-04 17_04_35v3.txt', '\t', 2);

dayandtime2=datetime(strcat(PressureTest2.textdata(3:end,2),{' '},PressureTest2.textdata(3:end,1)),'InputFormat','HH:mm:ss dd/MM/yyyy');

Xaxfplot2=dayandtime2;
Yaxfplot2=PressureTest2.data(:,24);
