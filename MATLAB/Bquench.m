
%% Input parameters
clc,clear

modes=[1]; %[1,2,3]
MakePlot=1;


%FPath1='D:\CERNbox\QPR tests & Operation\2019-09-10 - test #17 - ARIES-QPR-HZB-B2 (3µm Nb on Cu frim UniSiegen)\trace for Qpickup Q1 ALL\'%'..\trace_testQ1\'
FPath1='D:\CERNbox\QPR tests & Operation\2022-02-25 - test #35 - ARIES B-2.13 Siegen SIS\Bmax_Q1_All\'%'..\trace_testQ1\'

%FPath2='D:\CERNbox\QPR tests & Operation\2020-06-11 - test #21 - ARIES-QPR-HZB-B3.7 (SIS UniSiegen)\Quench_Q2\'%'..\Qfp2_ALL\';
FPath2='D:\CERNbox\QPR tests & Operation\2022-02-25 - test #35 - ARIES B-2.13 Siegen SIS\Bmax_Q2_All\';

FPath3='D:\CERNbox\QPR tests & Operation\2022-02-25 - test #35 - ARIES B-2.13 Siegen SIS\Bmax_Q3_All\'%'..\trace_testQ1\'

%% Trace data archive creation (not needed if already exists)

disp('=================================');
disp('<strong>STATUS:</strong>');

%TraceDataX.QX.Transmitted(i).data - trace!
    %TraceDataX.QX.Transmitted(i).data(:,1) - time, ms
    %TraceDataX.QX.Transmitted(i).data(:,2) - power, dBm
    %TraceDataX.QX.Transmitted(i).data(:,3) - power, W

%TraceDataX.QX.Transmitted(i).dataline(1,23) - pick field
%TraceDataX.QX.Transmitted(i).dataline(1,25) - sensor temp
%TraceDataX.QX.Transmitted(i).dataline(1,1) - set temp
%TraceDataX.QX.Transmitted(i).PowerData(2,1) - max power dBm
%TraceDataX.QX.Transmitted(i).PowerData(2,2) - max power W
%TraceDataX.QX.Transmitted(i).RealBm - calculated pick field

if isempty(find(modes(:)==1, 1))==0
TracePulse.Q1=fQfp1_PulseTraceImport_HZB(FPath1); %Set the name of the Archive Q1 mode
disp(['Import operation <strong>for Q1</strong> finished']);
end

if isempty(find(modes(:)==2, 1))==0
TracePulse.Q2=fQfp1_PulseTraceImport_HZB(FPath2); %Set the name of the Archive Q1 mode
disp(['Import operation <strong>for Q2</strong> finished']);
end

if isempty(find(modes(:)==3, 1))==0
TracePulse.Q3=fQfp1_PulseTraceImport_HZB(FPath3); %Set the name of the Archive Q1 mode
disp(['Import operation <strong>for Q3</strong> finished']);
end

%save('TraceData19Q1_1.mat','TraceData')

disp('=================================');
%%

RealBm=[TracePulse.Q1.Transmitted(:).RealBm]'
SetTemp=[TracePulse.Q1.Transmitted(:).SetTemp]'
Xaxfplot=[TracePulse.Q1.Transmitted(:).SetTemp]'
Yaxfplot=[TracePulse.Q1.Transmitted(:).RealBm]'

%Xaxfplot=[BQenchdata(:).SetTemp]'
%Yaxfplot=[BQenchdata(:).RealBm]'

Xaxfplot=Xaxfplot([TracePulse.Q1.Transmitted(:).RealBm]'>1)
Yaxfplot=Yaxfplot([TracePulse.Q1.Transmitted(:).RealBm]'>1)
NEW_FIGURE=1;
err_or_plt='plt'

nsig = 3;
Xmin = 1;
Xmax = 10;


sc1=1;
plotname='RealBm';
xaxtitle='Sample temperature T, [K]';
yaxtitle='RealBm, [mT]'
MarkSize=6*sc1;
LineW=1.5*sc1;
MarkShape='x';
FontS=20*sc1;
MarkColor='auto'; %Q1[.0 0.45 .74] Q2[.85 0.33 .10] Q3[.93 0.69 .13]
Lcol='k';

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

xlim([Xmin Xmax])
ylim('auto')




%% finding max field =f(T)
TT=7.5
Temps=unique([TracePulse.Q1.Transmitted(:).SetTemp]);
%clearvars SelectedData

    hold on
    t3=1
for TT=7.5
        clearvars TT1 PmaxpDbm Bmaxp PmaxpW
    index=[TracePulse.Q1.Transmitted(:).SetTemp]'==TT; 
    RefTdata=TracePulse.Q1.Transmitted(index);
    RefPdata=TracePulse.Q1.Forward(index);
    datasize=size(RefTdata); 
    TT2=1;
    figure('Position', [0 0 900*2 600*2])

    for TT1=[1:1:datasize(1,2)];
        if mean(RefPdata(TT1).data(50:150,2))>0
        PmaxpDbm(TT2)=mean(RefPdata(TT1).data(50:150,2));
        PmaxpW(TT2)=mean(RefPdata(TT1).data(50:150,3));
        Bmaxp(TT2)=RefTdata(TT1).RealBm;
        TT2=TT2+1;
        end
if TT1<=25
        subplot(5,5,TT1)
end
        PmaxpW1(TT1)=mean(RefPdata(TT1).data(50:150,3))
        plot(RefTdata(TT1).data(1:350,1),RefTdata(TT1).data(1:350,2))
        title([num2str(TT),'--Ntrace: ',num2str(TT1),'--PW ',num2str(PmaxpW1(TT1))])
        ylim([-10 10])
    end

    % figure
% 
     %scatter(PmaxpW,Bmaxp,'x','b')
     %title(num2str(TT))
    
    Tempdata(t3)=TT;
    Fielddata(t3)=mean(Bmaxp(:));
    Fielderrdata(t3)=std(Bmaxp(:));
    
    
    NtraceConsiderstr=inputdlg('prompt')
    NtraceConsider = str2num(NtraceConsiderstr{1})
    
    SelectedData(t3,1)=TT
    SelectedData(t3,2)=mean(Bmaxp(NtraceConsider));
    SelectedData(t3,3)=std(Bmaxp(NtraceConsider));
    
    t3=t3+1
end
    hold off

%     for kk=1:104
%         figure
% hold on
% subplot(2,1,1)
% plot(TracePulse.Q1.Forward(kk).data(:,1),TracePulse.Q1.Forward(kk).data(:,2))
% subplot(2,1,2)
% plot(TracePulse.Q1.Transmitted(kk).data(:,1),TracePulse.Q1.Transmitted(kk).data(:,2))
% hold off
%     end
%% trace2

              
Temps=unique([TracePulse.Q1.Transmitted(:).SetTemp]);
ii=1;

for k=8.5
TTs=find([TracePulse.Q1.Transmitted(:).SetTemp]==k)


figure
for i=TTs
xax=TracePulse.Q1.Transmitted(i).data(:,1);
yax=TracePulse.Q1.Transmitted(i).data(:,3);
plot(xax,yax);
title([num2str(k),'--Ntrace: ',num2str(i),'--PW ']);


opts.Interpreter = 'tex';
opts.Default = 'No';
quest = 'Qench?';
answer = questdlg(quest,'Boundary Condition',...
                  'Yes','No',opts)
switch answer
    case 'Yes'
        dessert = 1;
    case 'No'
        dessert = 0;
end

    if dessert==1
        BQenchdata(ii)=TracePulse.Q1.Transmitted(i);
        ii=ii+1;
    end
end
end
%% fit functon


clearvars x y

%Tc=14;
 Tc=9.4;
Tempdata=[BQenchdata(:).SetTemp]'%SelectedData(:,1)
Fielddata=[BQenchdata(:).RealBm]'%SelectedData(:,2)
Fielderrdata=[BQenchdata(:).RealBm]'*0.1%SelectedData(:,3)
figure('Position', [100 100 900 600])
errorbar(Tempdata,Fielddata,Fielderrdata*3)
%xlabel('Sample relative temperature ${(\frac{T}{T_c})}^2$','Interpreter','latex','FontName','Helvetica')
xlabel('Sample rtemperature $T$ (K)','Interpreter','latex','FontName','Helvetica')
ylabel('Max field on sample $B_{max}$ (mT)','Interpreter','latex','FontName','Helvetica')
set(gca,'FontSize',20)
%ylabel('Max field on sample $B_{max}$ (mT)','Interpreter','latex','FontName','Helvetica')
Tmin=7.5;
Tmax=10.25;
mu0 = 1.25664E-06;


% x=Xaxfplot(and(Xaxfplot(:)>Tmin,Xaxfplot(:)<Tmax))
% x=(x/Tc).^2
% y=Yaxfplot(and(Xaxfplot(:)>Tmin,Xaxfplot(:)<Tmax))
%scatter(x,y);
x=Tempdata(and(Tempdata(:)>Tmin,Tempdata(:)<Tmax))
x=(x/Tc).^2
y=Fielddata(and(Tempdata(:)>Tmin,Tempdata(:)<Tmax))

startPointsL=[80]; %Lambda0 [m], Tc [k]

upSP1=[300]
lowSP1=[10]


LambdafitOpt1 = fitoptions('Method','NonlinearLeastSquares','Upper',upSP1,'Lower',lowSP1,'Startpoint',startPointsL,'MaxIter',1000,'MaxFunEvals',1000);

EQ = 'B0*(1-x)';
%EQ = 'B0*(1-(x/9.43)^2)';

%y=y/1000;
f1=fit(x,y,EQ,LambdafitOpt1);

figure('Position', [100 100 900 600])

%figure
plot1name='Data, 415 MHz'
hold on

%plot(f1,x,y)
plot(x,y,'x','DisplayName',plot1name,'LineWidth',1.0,'MarkerSize',8)

x=[0.0:0.01:0.99]
%x=[1:0.1:9.4]
plot(x,f1(x))


hold off

xlabel('Sample relative temperature ${(\frac{T}{T_c})}^2$','Interpreter','latex','FontName','Helvetica')
ylabel('Max field on sample $B_{max}$ (mT)','Interpreter','latex','FontName','Helvetica')
%title('Measured resonance F shift  as a function temperature, 415 MHz');
grid off
legend('hide','Location','northwest');
set(gca,'FontSize',18);
xticks([0:0.1:1])
f1
%%
coeffvalues(f1)
err1c=confint(f1,0.95)'

str = {['T_c = ',num2str(Tc),' K'],['B_m = ',num2str(round(coeffvalues(f1))),' ( ',num2str(round(err1c(1,1),2)),' ',num2str(round(err1c(1,1),2)),' )',' mT']}

txt1=[str];
yL=get(gca,'YLim'); 
xL=get(gca,'XLim');   
  text((xL(1)+xL(2))/2,yL(2),txt1,...
      'HorizontalAlignment','left',...
      'VerticalAlignment','top',...
      'BackgroundColor',[1 1 1],...
      'FontSize',12);
  
 %% plot real
Xbmreal=[0:0.1:Tc]
Bmaxreal=105*(1-(Xbmreal./Tc).^2)
%figure
hold on
plot(Xbmreal,Bmaxreal)
%% second x
ax1 = gca; % current axes
ax1_pos = ax1.Position; % position of first axes
ax2 = axes('Position',ax1_pos,'XAxisLocation','top','YAxisLocation','right','Color','none','YTick',[]);
xlabel(ax2,'Sample temperature $T$ (K)','Interpreter','latex','FontName','Helvetica');
set(gca,'FontSize',14);

xl=round(([0:0.1:1].^0.5)*Tc,1)

xticklabels({num2str(xl(1)),num2str(xl(2)),num2str(xl(3)),num2str(xl(4)),num2str(xl(5)),...
    num2str(xl(6)),num2str(xl(7)),num2str(xl(8)),num2str(xl(9)),num2str(xl(10)),num2str(xl(11))})