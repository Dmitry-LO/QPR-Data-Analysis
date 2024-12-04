clc, clear
%% Loading data from matlab struct file 
load ('CoolDownCERN1.mat') %specify correct dataset to be loaded!

PT = h5read('../Trace_20190729_153832_PT1200MHz_Pinp=-38dBm_BW10kHz.h5','/Trace');
PR = h5read('../Trace_20190729_154030_PR1200MHz_Pinp=-38dBm_BW10kHz.h5','/Trace');
%%
figure
hold on
%scatter(PT(:,1),PT(:,2),'.')
scatter(PR(:,1),PR(:,2),'.')

fQ3 = ExperimentData.Q3.F0_Hz(1);
Xstart = min(find(PR(:,1)>.04725))
Xend = max(find(PR(:,1)>.04725))

X=PR(Xstart:Xend,1);
Y=PR(Xstart:Xend,2);

scatter(X,Y)

WR=trapz(X,Y)



PR1=mean(PR(and(PR(:,1)>0.02,PR(:,1)<0.04),2));

Qe3=WR*2*pi*fQ3/PR1

%% Q of the 3ed mode

Pt_corr_Q3 = 8.9188;
Pf_corr_Q3 = 41.026;
Pr_corr_Q3 = 36.134;


PR_raw_dBm=ExperimentData.Q3.PR_raw_dBm%-26.087033887385253;
PT_raw_dBm=ExperimentData.Q3.PT_raw_dBm%-7.994377662906146;

PR_real=PR_raw_dBm+Pr_corr_Q3;
PT_real=PT_raw_dBm+Pt_corr_Q3;

PR_real_W=10.^(((PR_real)-30)/10)
PT_real_W=10.^(((PT_real)-30)/10)
for ii=1:394
Kp(ii)=PR_real_W(ii)/PT_real_W(ii);
jj(ii)=ii;
end

figure
scatter(jj,Kp)

Qp3=WR*2*pi*fQ3/(PR1/Kp(1))
%% plot settings
title('P reflected 1230 MHz ');
xlabel('time');
ylabel('Pr');
grid on
legend('show','Location','northwest')
set(gca,'FontSize',16)

