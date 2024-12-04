function [procdata5,BData]=fm3_1_RsvTData(procdata,Bfield,Bstep,Tstep,SensN,CW_sort,File_sort,Run_sort,Runs2comb)
NoData=0;
clearvars procdata2
clearvars procdata3
clearvars procdata4
clearvars procdata5

disp(CW_sort)
disp(File_sort)
disp(Run_sort)
%procdata=inputdata

%===================== body===================
FieldN=1;
nd=1;
nd1=1;
for bf=Bfield
Bmin=bf-Bstep;
Bmax=bf+Bstep;


lineN2=1; %line number in array RsvT. .. .data(LineN,..)

procdata2=procdata(and(Bmin<procdata(:,23),procdata(:,23)<Bmax),:);

figure
scatter(procdata2(:,SensN),procdata2(:,24),'DisplayName',[num2str(bf),' mT'])


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
    stepp=Tstep*100;
      for Tset=unique(round(procdata31(:,SensN)./stepp,2)*stepp)'
          disp(Tset)
          Tmin=Tset-Tstep/2;
          Tmax=Tset+Tstep/2;
       procdata4.data(lineN2,1)=mean(procdata31(and(Tmin<procdata31(:,SensN),procdata31(:,SensN)<Tmax),SensN)); %T
       procdata4.data(lineN2,3)=mean(procdata31(and(Tmin<procdata31(:,SensN),procdata31(:,SensN)<Tmax),24)); %Rs
       procdata4.data(lineN2,4)=std(procdata31(and(Tmin<procdata31(:,SensN),procdata31(:,SensN)<Tmax),24)); %STD RS
       procdata4.data(lineN2,5)=k; %Run N
       procdata4.data(lineN2,6)=100;
       procdata4.data(lineN2,7)=n;
       procdata4.dataline(lineN2,:)=procdata31(find(and(Tmin<procdata31(:,SensN),procdata31(:,SensN)<Tmax),1),:);
       lineN2=lineN2+1;
      end
      procdata32=procdata3f(procdata3f(:,3)<100,:);
      for Tset=unique(round(procdata32(:,SensN)./5,2)*5)'
          Tmin=Tset-Tstep/2;
          Tmax=Tset+Tstep/2;
       procdata4.data(lineN2,1)=mean(procdata32(and(Tmin<procdata32(:,SensN),procdata32(:,SensN)<Tmax),SensN)); %T
       procdata4.data(lineN2,3)=mean(procdata32(and(Tmin<procdata32(:,SensN),procdata32(:,SensN)<Tmax),24)); %Rs
       procdata4.data(lineN2,4)=std(procdata32(and(Tmin<procdata32(:,SensN),procdata32(:,SensN)<Tmax),24)); %STD RS
       procdata4.data(lineN2,5)=k; %Run N
       procdata4.data(lineN2,6)=mean(procdata32(and(Tmin<procdata32(:,SensN),procdata32(:,SensN)<Tmax),3)); %DC
       procdata4.data(lineN2,7)=n;
       procdata4.dataline(lineN2,:)=procdata32(find(and(Tmin<procdata32(:,SensN),procdata32(:,SensN)<Tmax),1),:);
       lineN2=lineN2+1;
      end
      %clearvars procdata31;
      %clearvars procdata32;
    end
    end
    
        
    if lineN2>1
    procdata5(FieldN).data=procdata4.data;
    procdata5(FieldN).dataline=procdata4.dataline;
    procdata5(FieldN).Bfield=bf;
    hold on
    errorbar(procdata5(FieldN).data(:,1),procdata5(FieldN).data(:,3),1*procdata5(FieldN).data(:,4),1*procdata5(FieldN).data(:,4),...
    1*procdata5(FieldN).data(:,2),1*procdata5(FieldN).data(:,2),'x','DisplayName','comb. points',...
    'LineWidth',0.8,'Color','r','MarkerEdgeColor','r',... 
    'MarkerFaceColor','r',...
    'MarkerSize',10);
    legend('show','Location','northwest');
    hold off
    FieldN=FieldN+1;
        BData(2,nd1)=bf;
        nd1=nd1+1;
    else
        BData(1,nd)=bf;
        nd=nd+1;
    end
    clearvars procdata4 procdata2;
end


clearvars procdata
%==============/body================

end