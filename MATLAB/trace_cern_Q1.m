clc, clear
%% Loading data from matlab struct file 
load ('CoolDown1CERN2_A2.mat') %specify correct dataset to be loaded!
%% Preparation: Preparation of PR, PT, PF arrays

% PT(:,1) - time
% PT(:,2) - Power in W

PT = h5read('../Trace_20190730_115543_PT400MHz_Pinp=-46dBm_BW10kHz.h5','/Trace');
PR = h5read('../Trace_20190730_115621_PR400MHz_Pinp=-46dBm_Bw10kHz.h5','/Trace');

%% Evaluation: Qe eval part1
sc1=1;
figure('Position', [100 100 900*sc1 600*sc1])
%figure
hold on

%=======[PLOT FORMAT SET]==========================%
plot1name='Pr pulse'
xlabelN='Time [s]';
ylabelN='P [mW] / Ptrace max [mW]';
MarkShape='.';
MarkSize=8*sc1;
LineW=0.8*sc1;
FontS=20*sc1;
MarkColor='b'%[.85 0.33 .10]; %Q1[.0 0.45 .74] Q2[.85 0.33 .10] Q3[.93 0.69 .13]
Lcol='[.0 0.45 .74]'
%=======[/PLOT FORMAT SET]=========================%
%plot(PR(:,1),PR(:,2)/max(PR(:,2)),...
plot(PR(:,1),PR(:,2)/1,...
    MarkShape,'DisplayName',plot1name,...
    'LineWidth',LineW,'Color',Lcol,'MarkerEdgeColor',Lcol,... 
    'MarkerFaceColor',MarkColor,...
    'MarkerSize',MarkSize);

xlabel(xlabelN);
ylabel(ylabelN);
grid off
box on
set(gca,'LineWidth',1);
legend('show','Location','northwest');
set(gca,'FontSize',FontS);
set(gca,'fontname','times')

xlim('auto')
ylim('auto')

%% Evaluation: Qe eval part2

%parameters
avgP_t1=.03; %average level of power during the pulse starn and end
avgP_t2=.04; %average level of power during the pulse starn and end
T_pulse_end=.0541; %time of end of the pulse

%MaxX

fQ1 = ExperimentData.Q1.F0_Hz(1);

Xstart = min(find(PR(:,1)>T_pulse_end)); %.05374
Xend = max(find(PR(:,1)<0.062));%max(find(PR(:,1)>T_pulse_end));
X=PR(Xstart:Xend,1);
Y=PR(Xstart:Xend,2);

%scatter(X,Y/max(PR(:,2)))
scatter(X,Y/1)
WR=trapz(X,Y.^2)
%scatter(PT(:,1)+0.0372,PT(:,2)*0.15,'.')
%scatter(PT(:,1),PT(:,2),'.');

PR1=mean(PR(and(PR(:,1)>avgP_t1,PR(:,1)<avgP_t2),2))^2
%PR1=mean(PR(and(PR(:,1)>0.008,PR(:,1)<0.012),2))

QeQ1=WR*2*pi*fQ1/PR1

%% Evaluation: Qp eval part3

Pf_corr_Q1 = 39.8349+3;
Pr_corr_Q1 = 34.6951+3;
Pt_corr_Q1 = 8.9188+3;

WR=trapz(X,(Y*10^(Pr_corr_Q1/10)).^2);

PR1=mean(PR(and(PR(:,1)>avgP_t1,PR(:,1)<avgP_t2),2));

PR1corrected=PR1*10^(Pr_corr_Q1/10);

PT1=mean(PT(and(PT(:,1)>0,PT(:,1)<0.01),2));

PT1corrected=PT1*10^(Pt_corr_Q1/10);


QeQ1=WR*2*pi*fQ1/PR1corrected^2
QpQ1 = WR*2*pi*fQ1/PT1corrected^2

%%
figure
%figure
hold on

scatter(PR(:,1),PR(:,2)*10^(Pr_corr_Q2/10),'.')
scatter((PT(:,1)+0.0372),PT(:,2)*10^(Pt_corr_Q2/10),'.');
%%
Pf_corr_Q1 = 39.8349;
Pr_corr_Q1 = 34.6951;
Pt_corr_Q1 = 8.9188;

WR=trapz(X,Y)

PF_raw_dBm=ExperimentData.Q1.PF_raw_dBm
PR_raw_dBm=ExperimentData.Q1.PR_raw_dBm
PT_raw_dBm=ExperimentData.Q1.PT_raw_dBm


PF_real=PF_raw_dBm+Pf_corr_Q1;
PR_real=PR_raw_dBm+Pr_corr_Q1;
PT_real=PT_raw_dBm+Pt_corr_Q1;

PF_real_W=10.^(((PF_real)-30)/10);
PR_real_W=10.^(((PR_real)-30)/10);
PT_real_W=10.^(((PT_real)-30)/10);


for ii=1:480
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

QpQ1=WR*2*pi*fQ1/(PR1/Kp(1))

%% plot settings
title('Pr-real-W / Pt-real-W for 2 modes 810 and 1230 MHz ');
xlabel('Measured Point Number');
ylabel('Pr [W]/Pt [W] ratio');
grid on
legend('show','Location','northwest')
set(gca,'FontSize',16)
