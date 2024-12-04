LHCRs4d5(:,1)=[3;5;7;9.5;11.5;13.5;15;...
17.5;20;23.5;25;27;29.5;32;35.5;39.5];

LHCRs4d5(:,2)=[75;77.5;80;85;87.5;92.5;97.5;105;...
110;120;127.5;137.5;150;160;185;212.5];

LHCRs2d5(:,1)=[3.5;7;10;14;19.5;26.5;34.5;43.5;49;54;57];
LHCRs2d5(:,2)=[32.5;35;37;37.5;40;42;45;54;65;82.5;97.5];

%% 4.1 Plots
%previous param! CW_sort

%===========INPUT=================================%
NEW_FIGURE=0;
err_or_plt='plt'

nsig = 1;
Bmin = 0;
Bmax = 50;
%===========INPUT=================================%

%=======[PLOT FORMAT SET]==========================%

figtitle = ' '
sc1=1; %scaling
xlabelN='B field, [mT]';
ylabelN='Surface resistance Rs, [nOhm]';
plot1name=['4.5 K LHC'];  %define plot 1 name
MarkSize=8*sc1;
LineW=0.8*sc1;
FontS=20*sc1;

MarkShape='s';
MarkColor='[0.2941 0 0.5098]';%'[0.8471 0.2706 0.8275]' '[0.2941 0 0.5098]'
Lcol='k'

%=======[/PLOT FORMAT SET]=========================%

PlXax=LHCRs2d5(:,1);
PlYax=LHCRs2d5(:,2);

PlXer=LHCRs2d5(:,1);
PlYer=LHCRs2d5(:,2);
PlXer(:)=0;
PlYer(:)=0;


if NEW_FIGURE==1
figure('Position', [100 100 900*sc1 600*sc1])
end

hold on
if err_or_plt=='err'
errorbar(PlXax,PlYax,nsig*PlYer,...
    MarkShape,'DisplayName',plot1name,...
    'LineWidth',LineW,'Color',Lcol,'MarkerEdgeColor',Lcol,... 
    'MarkerFaceColor',MarkColor,...
    'MarkerSize',MarkSize);
elseif err_or_plt=='plt'
plot(PlXax,PlYax,...
    MarkShape,'DisplayName',plot1name,...
    'LineWidth',LineW,'Color',Lcol,'MarkerEdgeColor',Lcol,... 
    'MarkerFaceColor',MarkColor,...
    'MarkerSize',MarkSize);
end
hold off

%title(figtitle);
xlabel(xlabelN);
ylabel(ylabelN);
grid off
box on
set(gca,'LineWidth',1);
legend('show','Location','northwest');
set(gca,'FontSize',FontS);
set(gca,'fontname','times')

xlim([Bmin Bmax])
ylim('auto')



