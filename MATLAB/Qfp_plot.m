%Qfp plots

sc1=1;
figure('Position', [100 100 900*sc1 600*sc1])
xtitle='TraceN';
ytitle='Qfp, estimated from the pulse';
MarkSize=10*sc1;
LineW=1.0*sc1;
MarkShape='s';
FontS=20*sc1;
MarkColor='none'; %Q2[.85 0.33 .10] Q1[.0 0.45 .74]
Lcol='k';
plot1name='Qfp2'

fieldNx=12;
cond=Qfp1(:,3)<25;
%12 - REAL T
%10 - TraceN
%3 - Field
%hold on
% errorbar(Qfp1(3*Qfp1(:,2)<Qfp1(:,1),fieldNx),Qfp1(3*Qfp1(:,2)<Qfp1(:,1),1),3*Qfp1(3*Qfp1(:,2)<Qfp1(:,1),2),...
%     MarkShape,...
%     'LineWidth',LineW,'Color',Lcol,'MarkerEdgeColor',Lcol,... 
%     'MarkerFaceColor',MarkColor,'MarkerSize',MarkSize,...
%     'DisplayName',plot1name);

errorbar(QfpT(:,3),QfpT(:,1),3*QfpT(:,2),...
    MarkShape,...
    'LineWidth',LineW,'Color',Lcol,'MarkerEdgeColor',Lcol,... 
    'MarkerFaceColor',MarkColor,'MarkerSize',MarkSize,...
    'DisplayName',plot1name);

xlabel(xtitle);
ylabel(ytitle);
grid off
box on
set(gca,'LineWidth',1);
legend('show','Location','northwest');
set(gca,'FontSize',FontS);
set(gca,'fontname','calibri')

xlim('auto')
ylim('auto')

%scatter(Qfp1(:,10),Qfp1(:,1))
% figure
% errorbar(Qfp1(:,3),Qfp1(:,1),3*Qfp1(:,2),'o')
% 
% figure
% scatter(Qfp1(:,3),Qfp1(:,2))