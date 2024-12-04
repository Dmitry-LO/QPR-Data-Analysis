function [procdata5,TData]=fm3_2_RsvBData(procdata,Temp,Tstep,Bstep,SensN,CW_sort,File_sort,Run_sort,Runs2comb)
NoData=0;
clearvars procdata2
clearvars procdata3
clearvars procdata4
clearvars procdata5

%function input
% Temp = [2.5,4.5]; %mT, define magnetic field for this plot
% Tstep=0.05; %mT, field range to find data close to the defined value (has to be > 0.1)
% Bstep=0.5;
% procdata = alldata; %define data from which the RsvT data set is created
% SensN = 25; %define Temp sensor 25 - Sensor A (default), 26 - B, 27 - C, 28 - D.
% 
% CW_sort=1 %Do you need to separate points by CW/Pulse?
% File_sort=0 %Do you need to separate points from diferrent files?
% Run_sort=1 %Do you need to separate points by Run Numbers?
% Runs2comb=[0]; %ONLY works if Run_sort=0. Combines only runs spec in one dataset; of 0 - takes all data
%/func input
%===================== body===================
FieldN=1;
nd=1;
nd1=1;
for tt=Temp
Tmin=tt-Tstep;
Tmax=tt+Tstep;


lineN2=1; %line number in array RsvT. .. .data(LineN,..)

procdata2=procdata(and(Tmin<procdata(:,SensN),procdata(:,SensN)<Tmax),:);
figure
scatter(procdata2(:,23),procdata2(:,24),'DisplayName',[num2str(tt),' K'])

if CW_sort==0
    procdata2(:,3)=100;
end

if File_sort==0
    procdata2(:,39)=1;
end

procdatas=size(procdata2(:,38));

if Run_sort==0
    if Runs2comb(1,1)>0
    PIndexRun=procdata2(:,38)==Runs2comb;
    PIndexRunCOL=logical(sum(PIndexRun,2));
    elseif Runs2comb(1,1)==0
    PIndexRunCOL=true(procdatas(1,1),1);
    end
    
procdata2(:,38)=0;
else
PIndexRunCOL=true(procdatas(1,1),1);
end

procdata2=procdata2(PIndexRunCOL,:);
RunNv=unique(procdata2(:,38))';

    for k=RunNv
    procdata3=procdata2(procdata2(:,38)==k,:);
    
    FileNv=unique(procdata3(:,39))';
    %disp('FileNv:')
    %disp(FileNv) %debug
    %disp(k) %debug
    for n=FileNv
      clearvars procdata31;
      clearvars procdata32;
    procdata3f=procdata3(procdata3(:,39)==n,:);
    procdata31=procdata3f(procdata3f(:,3)==100,:);
    stepp=Bstep*100;
    Bset1=unique(round(procdata31(:,23)./stepp,2)*stepp)';
      for Bset=Bset1(~isnan(Bset1))
          disp(Bset)
          Bmin=Bset-Bstep/2;
          Bmax=Bset+Bstep/2;
       procdata4.data(lineN2,1)=mean(procdata31(and(Bmin<procdata31(:,23),procdata31(:,23)<Bmax),23)); %B
       procdata4.data(lineN2,2)=std(procdata31(and(Bmin<procdata31(:,23),procdata31(:,23)<Bmax),23)); %Std B
       procdata4.data(lineN2,3)=mean(procdata31(and(Bmin<procdata31(:,23),procdata31(:,23)<Bmax),24)); %Rs
       procdata4.data(lineN2,4)=std(procdata31(and(Bmin<procdata31(:,23),procdata31(:,23)<Bmax),24)); %STD RS
       procdata4.data(lineN2,5)=k; %Run N
       procdata4.data(lineN2,6)=100;
       procdata4.data(lineN2,7)=n;
       procdata4.dataline(lineN2,:)=procdata31(find(and(Bmin<procdata31(:,23),procdata31(:,23)<Bmax),1),:);
       lineN2=lineN2+1;
      end
      procdata32=procdata3f(procdata3f(:,3)<100,:);
       Bset2=unique(round(procdata32(:,23)./stepp,2)*stepp)';
      for Bset=Bset2(~isnan(Bset2))
          Bmin=Bset-Bstep/2;
          Bmax=Bset+Bstep/2;
       procdata4.data(lineN2,1)=mean(procdata32(and(Bmin<procdata32(:,23),procdata32(:,23)<Bmax),23)); %B
       procdata4.data(lineN2,2)=std(procdata32(and(Bmin<procdata32(:,23),procdata32(:,23)<Bmax),23)); %Std B
       procdata4.data(lineN2,3)=mean(procdata32(and(Bmin<procdata32(:,23),procdata32(:,23)<Bmax),24)); %Rs
       procdata4.data(lineN2,4)=std(procdata32(and(Bmin<procdata32(:,23),procdata32(:,23)<Bmax),24)); %STD RS
       procdata4.data(lineN2,5)=k; %Run N
       procdata4.data(lineN2,6)=mean(procdata32(and(Bmin<procdata32(:,23),procdata32(:,23)<Bmax),3)); %DC
       procdata4.data(lineN2,7)=n;
       procdata4.dataline(lineN2,:)=procdata32(find(and(Bmin<procdata32(:,23),procdata32(:,23)<Bmax),1),:);
       lineN2=lineN2+1;
      end
      %clearvars procdata31;
      %clearvars procdata32;
    end
    end
    
        
    if lineN2>1
    procdata5(FieldN).data=procdata4.data;
    procdata5(FieldN).dataline=procdata4.dataline;
    procdata5(FieldN).Temp=tt;
    hold on
    errorbar(procdata5(FieldN).data(:,1),procdata5(FieldN).data(:,3),1*procdata5(FieldN).data(:,4),1*procdata5(FieldN).data(:,4),...
    1*procdata5(FieldN).data(:,2),1*procdata5(FieldN).data(:,2),'x','DisplayName','comb. points',...
    'LineWidth',0.8,'Color','r','MarkerEdgeColor','r',... 
    'MarkerFaceColor','r',...
    'MarkerSize',10);
    legend on
    hold off
    FieldN=FieldN+1;
        TData(2,nd1)=tt;
        nd1=nd1+1;
    else
        TData(1,nd)=tt;
        nd=nd+1;
    end
    clearvars procdata4 procdata2;
end


clearvars procdata
%==============/body================

end