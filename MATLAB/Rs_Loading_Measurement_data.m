
clc,clear

%path to measured Data
uiwait(msgbox('Select folder with Measured Data!'));
Datapath1 = uigetdir('','Measured data');


%% Creating archives

Q1name = '\* 4*Measurements*.txt' %what measurements to process for mode Q1 ~415 MHz
Q2name = '\* 8*Measurements*.txt' %what measurements to process for mode Q2 ~850 MHz
Q3name = '\* 12*Measurements*.txt'%what measurements to process for mode Q3 ~1285 MHz

%---------------struct of the database:-----------------------------------
    %ExperimentData
        %ExperimentData.QX(i)*
           %ExperimentData.QX(i).data(:,23)  B - Field
           %ExperimentData.QX(i).data(:,24)  Rs - surf R
           %ExperimentData.QX(i).data(:,25)  Sens A - real temperature
           %ExperimentData.QX(i).data(:,1)  Set temperature
           %ExperimentData.QX(i).FName - filename
%--------------------end of struct----------------------------------------

ExperimentData=fm1_LoadingData(Datapath1,Q1name,Q2name,Q3name); %name of the main Data archive 

save('CoolDown17.mat','ExperimentData')


END='operation finished'

%% Find what fild values present (rounded)

%====[Param]======
verfields=ExperimentData.Q2; %Define Q1, Q2 or Q3 mode in CoolDown data (main Data archive)
%====[/Param]=====
display('fild values measure fore selected mode');
TT=fsub1_FieldValues(verfields,0.2); 
display(TT);



clearvars TT;
clearvars verfields;


%% Rs(T) database creation
Bfield = [5,10,15,25,0.1]; %mT, define magnetic field for this plot
Bstep = 0.1; %mT, field range to find data close to the defined value (has to be > 0.1)
DCommnt = 'CoolDown17.Q1'; %define comment from which data plot is created
procdata = ExperimentData.Q1; %define data from which data plot is created
SensN = 25 %define Temp sensor 25 - Sensor A (default), 26 - B, 27 - C, 28 - D.

[outdata,NoData]=RsvTData(procdata,Bfield,Bstep,DCommnt,SensN);

RsvT.Q1=outdata;

%save('RsvT17.mat','RsvT')
%---------------struct of the database:-----------------------------------
%RsvTX.QX(:).data - measured data
    %RsvTX.QX(:).data(:,1) - mean Sensor temp
    %RsvTX.QX(:).data(:,2) - mean Rs
    %RsvTX.QX(:).data(:,3) - 1 sigma of Rs points
    %RsvTX.QX(:).data(:,5) - Run Number, if 0 - Not spec
%RsvTX.QX(:).Bfield - B field value (average) corr to the dataset
%--------------------end of struct----------------------------------------

clearvars procdata;
clearvars outdata;


%% Rs(B) database creation

Bstep = 0.2; %mT, field range to find data close to the defined value (has to be > 0.1)
inputdata = ExperimentData.Q3; %define data from which data plot is created


outdata=RsvBData(inputdata,Bstep);

RsvB.Q3=outdata;

%save('RsvB17.mat','RsvB')

%---------------struct of the database:-----------------------------------
%RsvBX.QX(:).data - measured data
    %RsvBX.QX(:).data(:,1) - mean Sensor temp
    %RsvBX.QX(:).data(:,2) - mean Rs
    %RsvBX.QX(:).data(:,3) - 1 sigma of Rs points
    %RsvBX.QX(:).data(:,4) - Run Number, if 0 - Not spec
%RsvTX.QX(:).Bfield - B field value (average) corr to the dataset
%--------------------end of struct----------------------------------------

clearvars inputdata;
clearvars outdata;

