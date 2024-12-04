%~~~~~~~~~~~~~~~~~~~~~~~~function fm2_Data_prep_HZB~~~~~~~~~~~~~~~~
function [alldata0,alldata]=fm2_alldata_HZB(Fnumbers,procdata,mode,...
c1_Q1,...
c2_Q1,...
Gs_Q1,...
c1_Q2,...
c2_Q2,...
Gs_Q2,...
c1_Q3,...
c2_Q3,...
Gs_Q3,...
Pf_corr_Q1,...
Pr_corr_Q1,...
Pt_corr_Q1,...
Pf_corr_Q2,...
Pr_corr_Q2,...
Pt_corr_Q2,...
Pf_corr_Q3,...
Pr_corr_Q3,...
Pt_corr_Q3,...
QprobQ1,...
QprobQ2,...
QprobQ3)

%corrdata
corrdata(1,1) = c1_Q1;
corrdata(1,2) = c2_Q1;
corrdata(1,3) = Gs_Q1;

corrdata(2,1) = c1_Q2;
corrdata(2,2) = c2_Q2;
corrdata(2,3) = Gs_Q2;

corrdata(3,1) = c1_Q3;
corrdata(3,2) = c2_Q3;
corrdata(3,3) = Gs_Q3;

corrdata(1,1) = c1_Q1;
corrdata(1,2) = c2_Q1;
corrdata(1,3) = Gs_Q1;

corrdata(1,4) = Pf_corr_Q1;
corrdata(1,5) = Pr_corr_Q1;
corrdata(1,6) = Pt_corr_Q1;

corrdata(2,4) = Pf_corr_Q2;
corrdata(2,5) = Pr_corr_Q2;
corrdata(2,6) = Pt_corr_Q2;

corrdata(3,4) = Pf_corr_Q3;
corrdata(3,5) = Pr_corr_Q3;
corrdata(3,6) = Pt_corr_Q3;

corrdata(1,7) = QprobQ1;
corrdata(2,7) = QprobQ2;
corrdata(3,7) = QprobQ3;

c1 = corrdata(mode,1);
c2 = corrdata(mode,2);
Gs = corrdata(mode,3);

Pf_corr = corrdata(mode,4);
Pr_corr = corrdata(mode,5);
Pt_corr = corrdata(mode,6);

Qp = corrdata(mode,7);
mu0=1.25664E-06;

ps=Fnumbers; %size(procdata); %add opp to select files

 alldata=zeros(1,40);
for i=1:ps(1,2)
procdata1=procdata(i).data;
procdata1(:,38)=procdata(i).RunN;
procdata1(:,39)=i;

procdata1(:,40)=0;
alldata=[alldata;procdata1];
clearvars procdata1;
end
alldata(1,:)=[];
alldata0=alldata; 

alldatas=size(alldata);
for k=1:alldatas(1,1)
 
if isnan(c1)==1
    c1=alldata(k,16);
end

if isnan(c2)==1
    c2=alldata(k,17);
end

if isnan(Qp)==1
    Qp=alldata(k,15);
end

if isnan(Pt_corr)==1
     Pt=alldata(k,34);
else
     Pt=alldata(k,34)+Pt_corr;
end

PtW=10^((Pt-30)/10);
Bsamp=1000*sqrt(c2*Qp*PtW/(2*pi*alldata(k,2)));
Rs=2e15*c1*mu0^2*(alldata(k,22)/1000)*100/(alldata(k,3)*Bsamp^2);

alldata(k,24)=Rs;
alldata(k,23)=Bsamp;
end

 end