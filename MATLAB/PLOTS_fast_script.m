tt=2;
Xaxfplot01run= RsvB.Q1(tt).data(RsvB.Q1(tt).data(:,5)>3,:);

Xaxfplot01run(Xaxfplot01run(:,5)==4,5)=47;
Xaxfplot01run(Xaxfplot01run(:,5)==5,5)=40;
Xaxfplot01run(Xaxfplot01run(:,5)==6,5)=30;
Xaxfplot01run(Xaxfplot01run(:,5)==7,5)=16;
bsortmin=0;
bsortmax=5;
Xaxfplot02field=Xaxfplot01run(Xaxfplot01run(:,1)>bsortmin,:);
Xaxfplot02field=Xaxfplot02field(Xaxfplot02field(:,1)<bsortmax,:);

%% Getting data from 2d plot

%1: open figure in active window

%2: find specific line of interest on the plot

h = findobj(gca,'Type','line') %find the data of the 'line' plot type you interested
%h = findobj(gca,'Type','scatter') %for 'scatter' type
%h = findobj(gca,'Marker','s') %find plot with specific marker shape such as 's' , 'd' etc
%h = findobj(gca,'Type','errorbar') %find data for all 'errorbars' plots type

%3: get data from found lines

xax1=get(h,'Xdata')' %get x data
yax1=get(h,'Ydata')' %get y data
%yerr=get(h,'YNegativeDelta')' %get error data


Xaxfplot =xax1{1}' %flip(cell2mat(xax1)') %xax1{2}'; %x data of 1st line (in case of multiple lines) 
Yaxfplot =yax1{1}' %cell2mat(yax1)'%yax1{1}'; %y data of 1st line (in case of multiple lines) 

%Xaxfplot=Xaxfplot(1740:2100)%Xaxfplot(1:1600) (1740:2100)
%Yaxfplot=Yaxfplot(1740:2100)
%%
%Errdata = yerr;
namep='RsvB_Q3_T2p5'
tocsv=[Xaxfplot,Yaxfplot]
csvwrite(['tov\',namep,'.csv'],tocsv)

plotFilename=namep%'RvsT_Q1_10mT_2_test'%'RsvT_test18v25_Q2_lowField_ForBCS' %'pulses_Qfp_test#17vs18'
folder_path='D:\CERNbox\QPR tests & Operation\2021-11-01 - test #33 - ARIES-QPR-HZB-B3.14 (SIS STFC)\analyses MATLAB v1.2.0\tov'

print(gcf,[folder_path,'\',plotFilename],'-djpeg','-r300')
print(gcf,['D:\CERNbox\Work\Publications\QPR_Nb_Flange_paper\git_folder\DT_folder\',plotFilename],'-djpeg','-r300')

%%
n=3
Xaxfplot = RsvT.Q1(n).dataline(:,26);
Yaxfplot = RsvT.Q1(n).dataline(:,22)./(RsvT.Q1(n).dataline(:,19).*RsvT.Q1(n).dataline(:,36))*100;


%% Legend formatting
%1: open figure in active window
hf = gcf;

%2: find all plots on the figure

%errorbar = findobj(hf, 'Type','errorbar') %find 'errorbars' plots
lines = findobj(hf, 'Type','line') %find 'line' plots


%legend([errorbar(2) errorbar(3) errorbar(1)]) %list all found plots that you want to appear on the legend
%legend([errorbar(2) errorbar(3) lines(1)]) 
legend([lines(3),lines(1)])

%% ============== FORMATTING ============================================
% h = findobj(gca,'Type','line') %find the data of the 'line' plot type you interested
% xax1=get(h,'Xdata')' %get x data
% yax1=get(h,'Ydata')' %get y data
% Xaxfplot =xax1{1}'; %flip(cell2mat(xax1)') %xax1{2}'; %x data of 1st line (in case of multiple lines) 
% Yaxfplot =yax1{1}'-24; %cell2mat(yax1)'%yax1{1}'; %y data of 1st line (in case of multiple lines) 

% Xaxfplot = datetime(strcat(ExperimentData.Q1.textdata(2:end,1),{' '},ExperimentData.Q1.textdata(2:end,2)),...
%     'InputFormat', 'yyyy/MM/dd HH:mm:ss');
% Yaxfplot = ExperimentData.Q1.data(:,26)*1; %20 26
%Yaxfplot=Yaxfplot/(max(Yaxfplot)-min(Yaxfplot))
%Yaxfplot = alldata0(:,26);%alldata0(:,1);
%Xaxfplot = alldata(:,21)/1000;%alldata(:,36).*alldata(:,19)/1000;


NEW_FIGURE=1;
err_or_plt='plt'

nsig = 1;
Xmin = 0;
Xmax = 8;

Q1='[.0 0.45 .74]'
Q2='[.85 0.33 .10]'
Q3='[.93 0.69 .13]'
sc1=1;
plotname='test 21'%'heatcycle 2, 0.5 K/min cooldown (sample heater \bfON\rm)';
xaxtitle='Real Temperature \itT\rm (K)'%'Sample temperature \itT\rm (K)';%'Sample temperature T, [K]'; \itP\rm (mW)
yaxtitle='Set Temperature \itT\rm (K)'%'normalized Flux gate \itB\rm field';%'Surface resistance Rs, [nOhm]';
MarkSize=8*sc1;
LineW=1.5*sc1;
MarkShape='x';
FontS=20*sc1;
MarkColor='none'; %Q1[.0 0.45 .74] Q2[.85 0.33 .10] Q3[.93 0.69 .13]
Lcol=Q1;

% ============== Plot: points ============================================
if NEW_FIGURE==1
figure('Position', [100 100 900*sc1 600*sc1]);
end

hold on
if err_or_plt=='err'
errorbar(Xaxfplot,Yaxfplot,nsig*Errdata,...
    MarkShape,'DisplayName',plotname,...
    'LineWidth',LineW,'Color',Lcol,'MarkerEdgeColor',Lcol,... 
    'MarkerFaceColor',MarkColor,...
    'MarkerSize',MarkSize);
elseif err_or_plt=='plt'
    %yyaxis left
plot(Xaxfplot,Yaxfplot,...
    MarkShape,'DisplayName',plotname,...
    'LineWidth',LineW,'Color',Lcol,'MarkerEdgeColor',Lcol,... 
    'MarkerFaceColor',MarkColor,...
    'MarkerSize',MarkSize);
end
hold off

xlabel(xaxtitle);
ylabel(yaxtitle);
grid off
box on
set(gca,'LineWidth',1);
legend('show','Location','northwest');
set(gca,'FontSize',FontS);
set(gca,'fontname','times')

xlim('auto')%([Xmin Xmax])
ylim('auto')

%legend([ff1 ff2])

%% fitting

startPointsL=[1]; %Lambda0 [m], Tc [k]

upSP1=[1E5]
lowSP1=[1E-5]


LambdafitOpt1 = fitoptions('Method','NonlinearLeastSquares','Upper',upSP1,'Lower',lowSP1,'Startpoint',startPointsL,'MaxIter',1000,'MaxFunEvals',1000);

EQ = 'a*x^2';

%y=y/1000;
f1=fit(Xaxfplot,Yaxfplot,EQ,LambdafitOpt1)
%xxx=[1:1
hold on
plot(f1)
hold off


%% plot line

figure('Position', [100 100 900 600]);
hold on

for fn=[1:3]
Xaxfplot=TraceData.Q1.Forward(fn).data(:,1); %Transmitted %Forward %Reflected
Yaxfplot=TraceData.Q1.Forward(fn).data(:,2);
plot(Xaxfplot,Yaxfplot);

end

hold off

ylabel('Pf (Q1) Open loop, [dBm]');
xlabel('t, [ms]');
grid off
box on
set(gca,'LineWidth',1);
legend('hide','Location','northwest');
set(gca,'FontSize',FontS);
set(gca,'fontname','calibri')

xlim('auto')
ylim('auto')

%% picture save

plotFilename='FvsT2' %'pulses_Qfp_test#17vs18'


saveas(gcf,['pictures and plots\',plotFilename],'fig')
print(gcf,['pictures and plots\',plotFilename],'-dtiff','-r300')
mkdir 'pictures and plots' JEPEGE
print(gcf,['pictures and plots\JEPEGE\',plotFilename],'-djpeg')


%% plots RsvTvB
%figure('Position', [100 100 900*sc1 600*sc1])
PlZax=PlXax;
PlZax(:)=4.5%Bfield(1);
hold on
plot3(PlZax,PlXax,PlYax,...
    MarkShape,'DisplayName',plot1name,...
    'LineWidth',LineW,'Color',Lcol,'MarkerEdgeColor',Lcol,... 
    'MarkerFaceColor',MarkColor,...
    'MarkerSize',MarkSize);
hold off

%% saving plots

plotFilename='ALN_Kappa_test21'

saveas(gcf,['pictures\',plotFilename],'fig')
orient(gcf,'landscape')
mkdir 'pictures' PDF_format
saveas(gcf,['pictures\PDF_format\',plotFilename],'pdf')
orient(gcf,'portrait')
print(gcf,['pictures\',plotFilename],'-dtiff','-r300')
mkdir 'pictures' lower_res
print(gcf,['pictures\lower_res\',plotFilename],'-dtiff','-r100')
mkdir 'pictures' JEPEGE
print(gcf,['pictures\JEPEGE\',plotFilename],'-djpeg','-r300')
mkdir 'pictures' SVG
saveas(gcf,['pictures\SVG\',plotFilename],'svg')
mkdir 'pictures' PNG
saveas(gcf,['pictures\PNG\',plotFilename],'png')
