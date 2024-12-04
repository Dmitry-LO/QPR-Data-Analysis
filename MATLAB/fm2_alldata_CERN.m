%~~~~~~~~~~~~~~~~~~~~~~~~function fm2_Data_prep_HZB~~~~~~~~~~~~~~~~
function [alldata0,alldata]=fm2_alldata_CERN(Fnumbers,procdata,mode,...
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


%=========from procdata to alldata==
ps=Fnumbers; %size(procdata); %add opp to select files

alldata(:,1)=procdata.Temp(:);
alldata(:,25)=procdata.Temp(:); 
alldata(:,2)=procdata.F0_Hz(:);
alldata(:,3)=100;
alldata(:,37)=procdata.F0_Hz(:);
alldata(:,22)=1000*(procdata.PDC1(:)-procdata.PDC2(:));

alldata(:,23)=procdata.Bpeak(:); %B peak
alldata(:,24)=procdata.Rs(:); %Rs 0

alldata(:,32)=procdata.PF_raw_dBm(:);
alldata(:,33)=procdata.PR_raw_dBm(:);
alldata(:,34)=procdata.PT_raw_dBm(:);

alldata(:,38)=0;
alldata(:,39)=1;
alldata(:,40)=0;

alldata0=alldata;
%=========/from procdata to alldata==


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
Pt=alldata(k,34)+Pt_corr;
PtW=10^((Pt-30)/10);
Bsamp=1000*sqrt(c2*Qp*PtW/(2*pi*alldata(k,2)));
Rs=2e15*c1*mu0^2*(alldata(k,22)/1000)*100/(alldata(k,3)*Bsamp^2);

%>>>>> FOR QPRv1 alternative formulas
%b	7.83E+00	
%a	79.15		10.338
%tau	0.000786782

%Bsamp=1000*sqrt(c2*PtW*10.338*0.000786782*(1+7.83));
%Rs=1e9*(c1*2*mu0^2*alldata(k,22)/1000)/(c2*0.000786782*(1+7.83)*PtW*10.338);


alldata(k,24)=Rs;
alldata(k,23)=Bsamp;
end

end