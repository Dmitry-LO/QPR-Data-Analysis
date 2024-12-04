clc, clear

%%

csvname='D:\CERNbox\QPR tests & Operation\2021-02-08 - CERN QPRv1 test - ARIES-QPR-HZB-B2 (Nb film)\csv files\400 MHz\RsVsT_400#1_5.05mT_HZB2.2_20210205.csv'

T = readtable(csvname)
Rs=table2array(T(:,21))
Temp=table2array(T(:,16))
%%

alldata1(:,24)=table2array(T(:,21));
alldata1(:,25)=table2array(T(:,16));
alldata1(:,23)=table2array(T(:,12));

alldata1(:,40)=0;