%% Plotting Rs vs T
%Field number - dataset from db file
%figure('Name','Rs(T) plots 2 Tests comparation')

figtitle = 'Rs as a function of T, 1289 MHz'
nsig = 1;
BFieldVal = 5 %field level to plot
sc1=1;
figure('Position', [100 100 900*sc1 600*sc1])
plot1=RsvT.Q1; %define a dataset for plot 1

%=======[PLOT FORMAT SET]==========================%

xlabelN='Sample temperature T, [K]';
ylabelN='Surface resistance Rs, [nOhm]';
MarkShape='^';
MarkSize=8*sc1;
LineW=0.8*sc1;
FontS=20*sc1;
MarkColor='b'%[.85 0.33 .10]; %Q1[.0 0.45 .74] Q2[.85 0.33 .10] Q3[.93 0.69 .13]
Lcol='k'

%=======[/PLOT FORMAT SET]=========================%

Tmin = 1;
Tmax = 8;

for NRun=0%[1,4,6];

%----------------------------------------------
%========PLOT1=================================
ss1=size(plot1)
fn1=NaN
for i = 1:ss1(1,2)
if (plot1(i).Bfield==BFieldVal)
fn1=i %Field number for plot 1
end
end

hold on
%plot1=RsvT.InitTest.MHz415(fn1) %define a dataset for plot 1
plot1name=strcat('415 MHz, B',num2str(plot1(fn1).Bfield),' mT Run ',num2str(NRun));  %define plot 1 name
if NRun>0

errorbar(plot1(fn1).data((plot1(fn1).data(:,4)==NRun),1),plot1(fn1).data((plot1(fn1).data(:,4)==NRun),2),nsig*plot1(fn1).data((plot1(fn1).data(:,4)==NRun),3),MarkShape,'DisplayName',plot1name,'LineWidth',LineW,'MarkerSize',MarkSize);

else
%kk=[1:13];
errorbar(plot1(fn1).data(:,1),plot1(fn1).data(:,2),nsig*plot1(fn1).data(:,3),...
    MarkShape,'DisplayName',plot1name,...
    'LineWidth',LineW,'Color',Lcol,'MarkerEdgeColor',Lcol,... 
    'MarkerFaceColor',MarkColor,...
    'MarkerSize',MarkSize);
%errorbar(plot1(fn1).data(kk,1),plot1(fn1).data(kk,2),nsig*plot1(fn1).data(kk,3),'x','DisplayName',plot1name,'LineWidth',2.0,'MarkerSize',14);

end
hold off
%clearvars plot1;
end

%
%title(figtitle);
xlabel(xlabelN);
ylabel(ylabelN);
grid off
box on
set(gca,'LineWidth',1);
legend('show','Location','northwest');
set(gca,'FontSize',FontS);
set(gca,'fontname','times')

xlim([Tmin Tmax])
ylim('auto')

%% RsvT fit
clearvars x y FvsT procdata2 procdata

f=plot1(fn1).dataline(1,2);
Tmax=4.8;
Tmin=1;
mu0 = 1.25664E-06;
Kb = 1.38064852E-23;
hplanck = 6.62607004E-34;

x=plot1(fn1).data(and(plot1(fn1).data(:,1)>Tmin,plot1(fn1).data(:,1)<Tmax),1)
y=plot1(fn1).data(and(plot1(fn1).data(:,1)>Tmin,plot1(fn1).data(:,1)<Tmax),2)

startPoints=[124 2.1E-14 2.3626e-22];

upSP1=[+inf 100 100]%[1000 1 1];
lowSP1=[-inf -inf 0];

fitOpt1 = fitoptions('Method','NonlinearLeastSquares','Upper',upSP1,'Lower',lowSP1,'Startpoint',startPoints,'MaxIter',1e10,'MaxFunEvals',1e10);


EQ = strcat('a+1e9*1.1438e+11*(2*3.1416*',num2str(f),')^2*b*c/x*log(4.6799e+10*x/(2*3.1416*',num2str(f),'))*exp(-c/(x*1.3806e-23))')

%y=y/1000;
f1=fit(x,y,EQ,fitOpt1)

%figure
x1=0:0.1:5
hold on
plot(f1,x1,f1(x1))

%
%title(figtitle);
xlabel(xlabelN);
ylabel(ylabelN);
grid off
box on
set(gca,'LineWidth',1);
legend('show','Location','northwest');
set(gca,'FontSize',FontS);
set(gca,'fontname','times')

xlim([Tmin 6])
ylim('auto')
