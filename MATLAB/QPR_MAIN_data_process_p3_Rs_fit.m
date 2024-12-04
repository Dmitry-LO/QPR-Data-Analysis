%% BCS Nb fit
kb=1.38064852E-23;
%figure
%ABCS=0.0000000014
f=416E6
Tmin=0.1;
Tmax=4.5;
%Rres=28.0

%for i=1
%b=i*1.38064852E-23

Rstot=['Rres+ABCS*(1/x)*exp(-b/x)']
%Rstot=[num2str(Rres),'+ABCS*(1/x)*exp(-b/x)']
%Rs=Rres+(ABCS*f/T)*exp(-d/(1.38064852E-23*T))

startPoints=[1 30 16]
% upSP1=[inf 200 29.0] 
% lowSP1=[0 20 1];
upSP1=[inf 355 inf] 
lowSP1=[0 20 1];

MyfitOptions = fitoptions('Method','NonlinearLeastSquares','Lower',lowSP1,'upper',upSP1,'MaxIter',1000,'MaxFunEvals',1000);

%  h = findobj(gca,'Type','line')
%  xp1=get(h,'Xdata')'
%  yp1=get(h,'Ydata')'

% T=RsvT.Q3(1).data(1:15,1); % 1st plot x line in array
% T=T(T(:)<Tmax);
% Rs=RsvT.Q3(1).data(1:15,3);
% Rs=Rs(T(:)<Tmax);

T=Xaxfplot
T=T(T(:)<Tmax);
Rs=Yaxfplot
Rs=Rs(Xaxfplot(:)<Tmax);

f1=fit(T,Rs,Rstot,MyfitOptions)
%f1=fit(xax1,yax1,Rstot,MyfitOptions)

figure
hold on
x=[0.1:0.1:Tmax+0.5];
%plot(f1,T,Rs)
plot(x,f1(x));
%scatter(T,Rs);
scatter(T,Rs);
xlim([0 Tmax]);
hold off
%end

%% BCS fit

%EQ='8.9e4*(415586200/1e9)^2*exp(-17.67/x)/x+b'
%EQ='1e9*1.643e-5*(9.5/x)/*(415586200/1e9)^2*exp(-1.92*9.5/x)+b'
mu0 = 1.256637E-06;
Kb = 1.38064852E-23;
hplanck = 6.62607004E-34;

f=850e6; %415586200 %[Hz]
a=124; %Rres - [nOhm]
b=40; %lambda - [nm] 40e-9 for Nb
c=2.3626e-22; %energy gap - [J]  2.3626e-22 for Nb
d=3.3e8; %sigma1 - [S/m] 3.3e8 for Nb is the conductivity of the normal component (the same as the normal-state conductivity)

%EQ = strcat('a+1e9*1.1438e+11*(2*3.1416*',num2str(f),')^2*b*c/x*log(4.6799e+10*x/(2*3.1416*',num2str(f),'))*exp(-c/(x*1.3806e-23))')
%DO NOT DELETE!! EQ1 = '4.515422e12*(f^2)*(b^3)*d*c/x*log(7.4483e09*x/f)*exp(-c/(1.38065e-23*x))*1e9+a'[nOhm]
EQ = ['a+4.515422e12*(',num2str(f),'^2)*(','(b*1e-9)','^3)*',num2str(d),'*',num2str(c),'/x*log(7.4483e09*x/',num2str(f),')*exp(-',num2str(c),'/(1.38065e-23*x))*1e9']                                                                                                                                                                               ;
%EQ = ['a+4.515422e12*(',num2str(f),'^2)*b*',num2str(c),'/x*log(7.4483e09*x/',num2str(f),')*exp(-',num2str(c),'/(1.38065e-23*x))*1e9'];

Tmin=1.0;
Tmax=4.0;


startPoints=[70 40]; %[123 40];

upSP1=[293 inf] 
lowSP1=[60 0];

MyfitOptions = fitoptions('Method','NonlinearLeastSquares','Lower',lowSP1,'upper',upSP1,'Startpoint',startPoints,'MaxIter',1000,'MaxFunEvals',1000);

%Tindex=find(and(PlXax>=Tmin,PlXax<=Tmax));
T=RsvT.Q1(2).data(:,1)%PlXax(Tindex);
Rs=RsvT.Q1(2).data(:,3)%PlYax(Tindex);

f1=fit(T,Rs,EQ,MyfitOptions);

figure
hold on
x=[0.1:0.1:Tmax+0.5];
%plot(f1,T,Rs)
plot(x,f1(x))
scatter(T,Rs);
xlim([0 Tmax])
hold off
%% Frequency scaling


% RresQ1=59.94;
% RresQ2=87.77;
% RresQ3=355;

RresQ1=44.12;
RresQ2=76.87;
RresQ3=204;

T=4.5;

%h = findobj(gca,'Type','line')
h = findobj(gca,'Type','errorbar')

xax1=get(h,'Xdata')';
yax1=get(h,'Ydata')';

yax1err=get(h,'YPositiveDelta')';

nQ1=3;
nQ2=2;
nQ3=1;

PlotDataQ1=[xax1{nQ1}',yax1{nQ1}',yax1err{nQ1}'];
PlotDataQ2=[xax1{nQ2}',yax1{nQ2}',yax1err{nQ2}'];
PlotDataQ3=[xax1{nQ3}',yax1{nQ3}',yax1err{nQ3}'];





Tn1=find(PlotDataQ1(:,1)>(T-0.05),1);
Tn2=find(PlotDataQ2(:,1)>(T-0.05),1);
Tn3=find(PlotDataQ3(:,1)>(T-0.05),1);

Xaxfplot = [412 842 1282]';
Yaxfplot = [PlotDataQ1(Tn1,2)-RresQ1;PlotDataQ2(Tn2,2)-RresQ2;PlotDataQ3(Tn3,2)-RresQ3];
Errdata = [PlotDataQ1(Tn1,3);PlotDataQ2(Tn2,3);PlotDataQ3(Tn3,3)]
clearvars Tn1 Tn2 Tn3;
%figure
%plot(Xaxfplot,Yaxfplot,'o')

FEQ='(1/A)*x^2';

startPoints=[2.6497e+03]; %[123 40];
upSP1=[5.5497e+03] 
lowSP1=[0];

MyfitOptions = fitoptions('Method','NonlinearLeastSquares','Lower',lowSP1,'upper',upSP1,'Startpoint',startPoints,'MaxIter',1000,'MaxFunEvals',1000);
Xaxfplotfit = Xaxfplot(1:3);
Yaxfplotfit = Yaxfplot(1:3);
f1=fit(Xaxfplotfit,Yaxfplotfit,FEQ,MyfitOptions);

figure
hold on
x=[1:1:1500];
scatter(Xaxfplot,Yaxfplot);
plot(x,f1(x))
%xlim([0 Tmax])
hold off




%% ==================================== PLOT

NEW_FIGURE=1;
err_or_plt='err'

nsig = 1;
Xmin = 0;
Xmax = 1300;

Q1='[.0 0.45 .74]'
Q2='[.85 0.33 .10]'
Q3='[.93 0.69 .13]'
sc1=1;
plotname='35 nm AlN, VTS heat cycle'%'heatcycle 2, 0.5 K/min cooldown (sample heater \bfON\rm)';
xaxtitle='Frequency \itF\rm (MHz)'%'Sample temperature \itT\rm (K)';%'Sample temperature T, [K]';
yaxtitle='Surface resistance \itR_{BCS}\rm (nOhm)'%'normalized Flux gate \itB\rm field';%'Surface resistance Rs, [nOhm]';
MarkSize=6*sc1;
LineW=1.0*sc1;
MarkShape='d';
FontS=20*sc1;
MarkColor=Q1; %Q1[.0 0.45 .74] Q2[.85 0.33 .10] Q3[.93 0.69 .13]
Lcol='k';

% ============== Plot: points ============================================
if NEW_FIGURE==1
figure('Position', [100 100 900*sc1 600*sc1]);
end

hold on
plot(x,f1(x),'--')

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

xlim([Xmin Xmax])
ylim('auto')

%legend([ff1 ff2])

%%
hold on
plot(x,f1(x),'--',...
    'LineWidth',1.5,'Color',MarkColor);
hold off
%% Lambda Fit

clearvars procdata

%procdata=[Xaxfplot,Yaxfplot];%NAData.Q1;
%psize=size(procdata); 

procdata2=[Xaxfplot,(Yaxfplot+0.1)*1e3];%NAData.Q1;
Tmax=9.40;
Tmin=4.5;
mu0 = 1.25664E-06;
freq=417.4e6;

% for fn=1:psize(1,2)
% procdata2(fn,1) = procdata(fn).dataline(1,25);
% procdata2(fn,2) = procdata(fn).ShiftF*1e6;
% end

FvsT = procdata2;

x=FvsT(and(Tmin<FvsT(:,1),FvsT(:,1)<Tmax),1);%-0.2;
y=FvsT(and(Tmin<FvsT(:,1),FvsT(:,1)<Tmax),2);

%scatter(x,y);


startPointsL=[1E-7]; %Lambda0 [m], Tc [k]

upSP1=[0.000000135*10]
lowSP1=[0.000000135*0.01]


LambdafitOpt1 = fitoptions('Method','NonlinearLeastSquares','Upper',upSP1,'Lower',lowSP1,'Startpoint',startPointsL,'MaxIter',1000,'MaxFunEvals',1000);

EQ = ['-(lam0/84.17)*3.1416*1.25664E-06*((',num2str(freq),')^2)*(1/sqrt(1-(x/9.42)^4)-1)'];

%y=y/1000;
f1=fit(x,y,EQ,LambdafitOpt1)

figure('Position', [100 100 900 600])
%figure
plot1name='Data, 413 MHz'
hold on
plot(f1,x,y)
plot(x,y,'x','DisplayName',plot1name,'LineWidth',1.0,'MarkerSize',8)
hold off
%% freq scaling
h = findobj(gca,'Type','line') %find the data of the 'line' plot type you interested
%h = findobj(gca,'Type','scatter') %for 'scatter' type
%h = findobj(gca,'Marker','s') %find plot with specific marker shape such as 's' , 'd' etc
%h = findobj(gca,'Type','errorbar') %find data for all 'errorbars' plots type

%3: get data from found lines

xax1=get(h,'Xdata')'; %get x data
yax1=get(h,'Ydata')'; %get y data

figure
plot(xax1,yax1/1000)

%% lin fit
clearvars procdata

x=RsvB.Q1(2).data(RsvB.Q1(2).data(:,1)<30,1);
y1=RsvB.Q1(2).data(RsvB.Q1(2).data(:,1)<30,3);

Bmax=30;
Bmin=0;

P = polyfit(x,y1,1);
    x=[0:1:30]
    yfit = P(1)*x+P(2);
    hold on;
    plot(x,yfit,'k-.','DisplayName',[num2str(round(P(1),3)),'x+ ',num2str(round(P(2),3))]);
%% ========================= BMMax fit ==============================================

x=plotmatrix(2:6,1);
y=plotmatrix(2:6,2);

%scatter(x,y);


startPointsL=[45 15]; %Lambda0 [m], Tc [k]

upSP1=[45 18];
lowSP1=[30 10];


BmaxfitOpt1 = fitoptions('Method','NonlinearLeastSquares','Upper',upSP1,'Lower',lowSP1,'Startpoint',startPointsL,'MaxIter',1000,'MaxFunEvals',1000);

EQ = ['B0*(1-(x/Tc)^2)'];

%y=y/1000;
f1=fit(x,y,EQ,BmaxfitOpt1)
x1=0:0.1:15;
figure('Position', [100 100 900 600])
plot1name='Bmax';
hold on
plot(f1,x1,f1(x1))
plot(x,y,'x','DisplayName',plot1name,'LineWidth',1.0,'MarkerSize',8)
hold off

xlim([0 13])
ylim([0 50])