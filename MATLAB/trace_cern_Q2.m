clc, clear
%% Loading data from matlab struct file 
load ('CoolDownCERN1.mat') %specify correct dataset to be loaded!
%% Preparation: Preparation of PR, PT, PF arrays

% PT(:,1) - time
% PT(:,2) - Power in W

PT = h5read('../Trace_20190729_120546_PT800MHz_Pinp=-32dBm_BW10kHz.h5','/Trace');
PR = h5read('../Trace_20190729_120731_PR800MHz_Pinp=-32dBm_BW10kHz.h5','/Trace');
%%
PT = h5read('../Trace_20190726_175636_PT800MHz_Pinp=-33dBm_BW10kHz.h5','/Trace');
PR = h5read('../Trace_20190726_175558_PR800MHz_Pinp=-33dBm_BW10kHz.h5','/Trace');
%% Evaluation: Qe eval part1

figure
%figure
hold on

scatter(PR(:,1),PR(:,2),'.')

%% Evaluation: Qe eval part2

%parameters
avgP_t1=.02; %average level of power during the pulse starn and end
avgP_t2=.04; %average level of power during the pulse starn and end
T_pulse_end=.0537; %time of end of the pulse

%MaxX

fQ2 = ExperimentData.Q2.F0_Hz(1);

Xstart = min(find(PR(:,1)>T_pulse_end)); %.05374
Xend = max(find(PR(:,1)>T_pulse_end));
X=PR(Xstart:Xend,1);
Y=PR(Xstart:Xend,2);


scatter(X,Y)
WR=trapz(X,Y)
%scatter(PT(:,1)+0.0372,PT(:,2)*0.15,'.')
scatter(PT(:,1),PT(:,2),'.');

PR1=mean(PR(and(PR(:,1)>avgP_t1,PR(:,1)<avgP_t2),2))
%PR1=mean(PR(and(PR(:,1)>0.008,PR(:,1)<0.012),2))

QeQ2=WR*2*pi*fQ2/PR1

%% Evaluation: Qp eval part3

Pf_corr_Q2 = 39.8649+3;
Pr_corr_Q2 = 35.204+3;
Pt_corr_Q2 = 5.1588+3;

WR=trapz(X,Y)*10^(Pr_corr_Q2/10);

PR1=mean(PR(and(PR(:,1)>avgP_t1,PR(:,1)<avgP_t2),2));

PR1corrected=PR1*10^(Pr_corr_Q2/10);

PT1=mean(PT(and(PT(:,1)>0,PT(:,1)<0.01),2));

PT1corrected=PT1*10^(Pt_corr_Q2/10);


QeQ2=WR*2*pi*fQ2/PR1corrected
Qp2 = WR*2*pi*fQ2/PT1corrected

%%
figure
%figure
hold on

scatter(PR(:,1),PR(:,2)*10^(Pr_corr_Q2/10),'.')
scatter((PT(:,1)+0.0372),PT(:,2)*10^(Pt_corr_Q2/10),'.');
%%
Pf_corr_Q2 = 39.8649;
Pr_corr_Q2 = 35.204;
Pt_corr_Q2 = 5.1588;

PF_raw_dBm=ExperimentData.Q2.PF_raw_dBm
PR_raw_dBm=ExperimentData.Q2.PR_raw_dBm
PT_raw_dBm=ExperimentData.Q2.PT_raw_dBm


PF_real=PF_raw_dBm+Pf_corr_Q2;
PR_real=PR_raw_dBm+Pr_corr_Q2;
PT_real=PT_raw_dBm+Pt_corr_Q2;

PF_real_W=10.^(((PF_real)-30)/10);
PR_real_W=10.^(((PR_real)-30)/10);
PT_real_W=10.^(((PT_real)-30)/10);


for ii=1:698
Kp(ii)=PR_real_W(ii)/PT_real_W(ii);

Kr(ii)=PR_real_W(ii)/PF_real_W(ii);
Kt(ii)=PT_real_W(ii)/PF_real_W(ii);

jj(ii)=ii;

end

figure
scatter(jj,Kp)
figure
scatter(jj,Kr)
figure
scatter(jj,Kt)

Qp2=WR*2*pi*fQ2/(PR1/Kp(1))

%% plot settings
title('Pr-real-W / Pt-real-W for 2 modes 810 and 1230 MHz ');
xlabel('Measured Point Number');
ylabel('Pr [W]/Pt [W] ratio');
grid on
legend('show','Location','northwest')
set(gca,'FontSize',16)
