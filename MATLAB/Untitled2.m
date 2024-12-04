%% optimisation

figure('Position', [50 50 1500 1000])
subplot(2,2,1)
tmodel=createpde('thermal','steadystate')
importGeometry(tmodel,'sample.stl')
pdegplot(tmodel,'FaceLabels','on','FaceAlpha',0.5)
msh=generateMesh(tmodel,'Hmax',0.01) 
subplot(2,2,2)
pdemesh(tmodel)

kappa=3;
for k=1:623
GOALT=heatdatatest21(k,2)
kappa=3;
for i=1:5
dEpsK=0.01*kappa;


%kappa=8.5;
%hf=0.123;
hf=heatdatatest21(k,1)/0.00441786467;

 % W/m/k
thermalProperties(tmodel,'ThermalConductivity',kappa);
thermalProperties(thermalModel,'Cell',1,'ThermalConductivity',0.4)

%thermalBC(tmodel, 'face', [1,2,3,5], 'ConvectionCoefficient', 30, 'ambientTemperature', 1.8);
thermalBC(tmodel, 'face', [1,2,3,5], 'Temperature', 1.8);
thermalBC(tmodel, 'face', [13:17], 'HeatFlux',hf);

Rt=solve(tmodel);

maxT=max(Rt.Temperature);

thermalProperties(tmodel,'ThermalConductivity',kappa+dEpsK);

Rt1=solve(tmodel);
dmaxT=max(Rt1.Temperature);

dkappa=kappa+dEpsK;

%(x-x1)/(x2-x1)=(y-y1)/(y2-y1)
%dT=((dkappa-x1)/(x2-x1))*(y2-y1)+y1

kappa=abs((dkappa-kappa)*(GOALT-maxT)/(dmaxT-maxT)+kappa);


end
heatdatatest21(k,3)=kappa;
heatdatatest21(k,4)=maxT;

subplot(2,2,3)
pdeplot3D(tmodel,'ColorMapData',Rt.Temperature)
end

%% single
tmodel = createpde('thermal');
gm = multicylinder([20,25,35],60,'Void',[1,0,0]);

AlNh=35e-9*10e3
NbNh=180e-9*10e3
Nbh=4e-3

gm = [multicylinder(7.5e-2/2,[Nbh AlNh NbNh],'ZOffset',[0 Nbh Nbh+AlNh]),multicuboid(1,1,1)]
%gm2 = multicylinder([35],60,'ZOffset',[70]);


tmodel.Geometry = gm;
pdegplot(tmodel,'CellLabels','on','FaceLabels','on','FaceAlpha',0.5)
msh=generateMesh(tmodel,'Hmax',0.005) ;
%  hold on
%  pdemesh(tmodel);
%  hold off

kappa=3;
hf=heatdatatest21(30,1)/0.00441786467;

 % W/m/k
thermalProperties(tmodel,'Cell',1,'ThermalConductivity',5)
thermalProperties(tmodel,'Cell',2,'ThermalConductivity',0.001)
thermalProperties(tmodel,'Cell',3,'ThermalConductivity',5)

%thermalBC(tmodel, 'face', [1,2,3,5], 'ConvectionCoefficient', 30, 'ambientTemperature', 1.8);
thermalBC(tmodel, 'face', [3], 'Temperature', 1.8);
thermalBC(tmodel, 'face', [6], 'HeatFlux',hf*0.5);
thermalBC(tmodel, 'face', [1], 'HeatFlux',hf);

Rt=solve(tmodel);

maxT=max(Rt.Temperature);

figure
pdegplot(tmodel,'FaceAlpha',0.0)
hold on
pdeplot3D(tmodel,'ColorMapData',Rt.Temperature)
hold off

%%
figure('Position', [50 50 1500 1000])
subplot(2,2,1)
tmodel=createpde('thermal','steadystate')
importGeometry(tmodel,'cubesaws.stl')
pdegplot(tmodel,'FaceLabels','on','FaceAlpha',0.5)
msh=generateMesh(tmodel,'Hmax',0.01) 
subplot(2,2,2)
pdemesh(tmodel)

kappa=3;
hf=heatdatatest21(k,1)/0.00441786467;

 % W/m/k
thermalProperties(tmodel,'ThermalConductivity',kappa);
thermalProperties(thermalModel,'Cell',1,'ThermalConductivity',0.4)

%thermalBC(tmodel, 'face', [1,2,3,5], 'ConvectionCoefficient', 30, 'ambientTemperature', 1.8);
thermalBC(tmodel, 'face', [1,2,3,5], 'Temperature', 1.8);
thermalBC(tmodel, 'face', [13:17], 'HeatFlux',hf);

Rt=solve(tmodel);

maxT=max(Rt.Temperature);

subplot(2,2,3)
pdeplot3D(tmodel,'ColorMapData',Rt.Temperature)
%% find kappa of ALN

clearvars AlNKa
tmodel = createpde('thermal');
gm = multicylinder([20,25,35],60,'Void',[1,0,0]);

%=====================dimentions======
AlNh=35e-9*1e3;
NbNh=180e-9*1e3;
Nbh=4e-6*1e3;
%=================////dimentions======

%=====================parameters======
AlNKa=0.01; %kappa
NbNKa=3;
%NbKa=heatdatatest21reduced;
%=================////dimentions======



gm = multicylinder(7.5e-2/2,[Nbh AlNh NbNh],'ZOffset',[0 Nbh Nbh+AlNh]);
%gm2 = multicylinder([35],60,'ZOffset',[70]);


tmodel.Geometry = gm;
figure
pdegplot(tmodel,'CellLabels','on','FaceLabels','on','FaceAlpha',0.5);
msh=generateMesh(tmodel,'Hmax',0.0025); %,'Hmax',0.0025
 hold on
 pdemesh(tmodel);
 hold off

AlNKaOPT=0.000001;

maxiter=10
for k=1:49 %Temperature cycle 49
    AREA=0.00441786467; %m2
    hf=heatdatatest21reduced(k,1)/AREA*0.8;
    hfRF=heatdatatest21reduced(k,1)/AREA*0.2;
    NbNKa=heatdatatest21reduced(k,3);
    xt=heatdatatest21reduced(k,2);
    xh=heatdatatest21reduced(k,1);
    Tmax3GOAL=xt+1.0*(87.194*(xh)^3 - 45.629*(xh)^2 - 14.111*(xh) + 10.567)-5.5;
    
    maxT=0;
    count=1;
 while abs(Tmax3GOAL-maxT)>0.05
 
     %tic
        dEpsK=0.05*AlNKaOPT;
        
         % W/m/k
    thermalProperties(tmodel,'Cell',1,'ThermalConductivity',5);
    thermalProperties(tmodel,'Cell',2,'ThermalConductivity',AlNKaOPT);
    thermalProperties(tmodel,'Cell',3,'ThermalConductivity',NbNKa);

    
    thermalBC(tmodel, 'face', [3], 'Temperature', 1.8);
    thermalBC(tmodel, 'face', [6], 'HeatFlux',hfRF);
    thermalBC(tmodel, 'face', [1], 'HeatFlux',hf);

        Rt=solve(tmodel);
    %toc
        maxT=max(Rt.Temperature);

        thermalProperties(tmodel,'Cell',2,'ThermalConductivity',AlNKaOPT+dEpsK);

        Rt1=solve(tmodel);
        dmaxT=max(Rt1.Temperature);

        dkappa=AlNKaOPT+dEpsK;

        AlNKaOPT=abs((dkappa-AlNKaOPT)*(Tmax3GOAL-maxT)/(dmaxT-maxT)+AlNKaOPT);
         count = count + 1;
         
         if count>10
            disp('<strong>WARNING!</strong>');
            disp(['Exeeded convergance limit! last deltaT',num2str(Tmax3GOAL-maxT)]) 
            disp(['Loop stopped at k=',num2str(k),' T=',num2str(xt)]);
            disp('=================================');
         return
         end
 end
            disp(['count=',num2str(count)]);

        
AlNKa(k,1)=AlNKaOPT;
AlNKa(k,2)=maxT;
AlNKa(k,3)=Tmax3GOAL-maxT;
AlNKa(k,4)=(hf+hfRF)*AREA;
AlNKa(k,5)=hfRF*AREA;
AlNKa(k,1:3)

end


figure
pdegplot(tmodel,'FaceAlpha',0.0)
hold on
pdeplot3D(tmodel,'ColorMapData',Rt.Temperature)
hold off

figure
plot(AlNKa(:,4),AlNKa(:,1))
figure
plot(AlNKa(:,4),AlNKa(:,2))
hold on
plot(AlNKa(:,4),heatdatatest21reduced(:,2))
hold off
%% find kappa of ALN (Temperature boundary fix)

clearvars AlNKa
tmodel = createpde('thermal');
gm = multicylinder([20,25,35],60,'Void',[1,0,0]);

%=====================dimentions======
AlNh=35e-9;%*1e3;
NbNh=180e-9;%*1e3;
Nbh=4e-6;%*1e3;
%=================////dimentions======

%=====================parameters======
AlNKa=0.01; %kappa
NbNKa=3;
%NbKa=heatdatatest21reduced;
%=================////dimentions======


sampleD=7.5e-2*1e-3;
gm = multicylinder(sampleD/2,[Nbh AlNh NbNh],'ZOffset',[0 Nbh Nbh+AlNh]);
%gm2 = multicylinder([35],60,'ZOffset',[70]);


tmodel.Geometry = gm;
figure
pdegplot(tmodel,'CellLabels','on','FaceLabels','on','FaceAlpha',0.5);
msh=generateMesh(tmodel,'Hmax',0.0025*1e-3); %,'Hmax',0.0025
 hold on
 pdemesh(tmodel);
 hold off

AlNKaOPT=0.00000001;

maxiter=10
for k=1:50 %Temperature cycle 49
    disp(['>>>>>>>>>>  k = ',num2str(k),' <<<<<<<<<<<<<'])
    AREA=pi*(sampleD/2)^2; %m2
    hf=test21HeaterP(k)*1e-3/(pi*(7.5e-2/2)^2);
    hfRF=test21PRF(k)*1e-3/(pi*(7.5e-2/2)^2);
    NbNKa=10;%heatdatatest21reduced(k,3);
    %xt=heatdatatest21reduced(k,2);
    %xh=heatdatatest21reduced(k,1);
    Tmax3GOAL=NbNT(k);
    
    maxT=0;
    count=1;
 while abs(Tmax3GOAL-maxT)>0.05
 
     %tic
        dEpsK=0.05*AlNKaOPT;
        
         % W/m/k
    thermalProperties(tmodel,'Cell',1,'ThermalConductivity',5);
    thermalProperties(tmodel,'Cell',2,'ThermalConductivity',AlNKaOPT);
    thermalProperties(tmodel,'Cell',3,'ThermalConductivity',NbNKa);

    
    %thermalBC(tmodel, 'face', [3], 'Temperature', 1.8);
    thermalBC(tmodel, 'face', [6], 'HeatFlux',hfRF);
    thermalBC(tmodel, 'face', [1], 'Temperature',NbT(k));

        Rt=solve(tmodel);
    %toc
        maxT=max(Rt.Temperature);

        thermalProperties(tmodel,'Cell',2,'ThermalConductivity',AlNKaOPT+dEpsK);

        Rt1=solve(tmodel);
        dmaxT=max(Rt1.Temperature);

        dkappa=AlNKaOPT+dEpsK;

        AlNKaOPT=abs((dkappa-AlNKaOPT)*(Tmax3GOAL-maxT)/(dmaxT-maxT)+AlNKaOPT);
         count = count + 1;
         disp(['deltaT = ',num2str(Tmax3GOAL-maxT)])
         if count>maxiter
            disp('<strong>WARNING!</strong>');
            disp(['Exeeded convergance limit! last deltaT:',num2str(Tmax3GOAL-maxT)]) 
            disp(['Loop stopped at k=',num2str(k),' T=',num2str(NbT(k))]);
            disp('=================================');
            figure
            pdegplot(tmodel,'FaceAlpha',0.0)
            hold on
            pdeplot3D(tmodel,'ColorMapData',Rt.Temperature)
            hold off
         return
         end
 end
            disp(['count=',num2str(count)]);

        
AlNKa(k,1)=AlNKaOPT;
AlNKa(k,2)=maxT;
AlNKa(k,3)=Tmax3GOAL-maxT;
AlNKa(k,4)=(hf)*AREA;
AlNKa(k,5)=hfRF*AREA;
AlNKa(k,1:3)

end


figure
pdegplot(tmodel,'FaceAlpha',0.0)
hold on
pdeplot3D(tmodel,'ColorMapData',Rt.Temperature)
hold off

figure
hold on
plot(NbT(:),AlNKa(:,2))
plot(NbT(:),NbT(:))
yyaxis right
plot(NbT(:),AlNKa(:,1))
hold off
%% import
tmodel = createpde('thermal');
gm = importGeometry(tmodel,'samplelastbig.stl');
tmodel.Geometry = gm;
figure
pdegplot(tmodel,'CellLabels','on','FaceLabels','on','EdgeLabels','off','FaceAlpha',0.5);
msh=generateMesh(tmodel); %,'Hmax',0.0025
 hold on
 pdemesh(tmodel);
 hold off
%heatRF 35,36,37,37
%heatheater 22:28
%%
     k=8;
    AlNKa=0.01; %kappa
    NbNKa=3;
    AREARF=0.00441786467; %m2
    AREAh=0.003959192; %m2
    heatdatatest21reduced(8,:)=[0.133155791000000,5.03030000000000,7.37410253592287,5.03044779267277];
    hf=heatdatatest21reduced(k,1)/AREAh*0.8;
    hfRF=heatdatatest21reduced(k,1)/AREARF*0.2;
    NbNKa=heatdatatest21reduced(k,3);
    xt=heatdatatest21reduced(k,2);
    xh=heatdatatest21reduced(k,1);
    Tmax3GOAL=xt+1.0*(87.194*(xh)^3 - 45.629*(xh)^2 - 14.111*(xh) + 10.567)-5.5;
   
    maxT=0;
    count=1;
 
    thermalProperties(tmodel,'Cell',1,'ThermalConductivity',5);
    thermalProperties(tmodel,'Cell',2,'ThermalConductivity',0.1);
    thermalProperties(tmodel,'Cell',3,'ThermalConductivity',NbNKa);

 
    thermalBC(tmodel, 'face', [1,2,3,5], 'Temperature', 1.8);
    thermalBC(tmodel, 'face', [35,36,37,37], 'HeatFlux',hfRF);
    thermalBC(tmodel, 'face', [22:28], 'HeatFlux',hf);

      Rt=solve(tmodel);
    %toc
        maxT=max(Rt.Temperature);
figure
pdegplot(tmodel,'FaceAlpha',0.0)
hold on
pdeplot3D(tmodel,'ColorMapData',Rt.Temperature)
hold off

%% T vs Power
clearvars sortdataline
linefield=4;

Xaxfplot=RsvT21.Q1(linefield).dataline(:,19).*RsvT21.Q1(linefield).dataline(:,36);
Yaxfplot=RsvT21.Q1(linefield).dataline(:,1);

for i=1:50
    index=find(abs(RsvT21.Q1(linefield).dataline(1:50,1)-NbT(i))==min(abs(RsvT21.Q1(linefield).dataline(1:50,1)-NbT(i))),1);
    %RefP=RsvT21.Q1(linefield).dataline(:,19).*RsvT21.Q1(linefield).dataline(:,36);
    
    sortdataline(i,:)=RsvT21.Q1(linefield).dataline(index,:);
end

% figure;
% plot(NbT,sortdataline(:,1));

test21HeaterP=sortdataline(:,19).*sortdataline(:,36);
test21PRF=sortdataline(:,22);

 figure;
 plot(NbT,test21PRF);

%% p = polyfit(x,y,n)
linefield=4;
Xax=RsvT21.Q1(linefield).data(:,1);
Yax=RsvT21.Q1(linefield).data(:,3);
Xax=Xax(Xax(1:50)<7.26);
Yax=Yax(Xax(1:50)<7.26);
p = polyfit(Xax,Yax,7);
pf=polyval(p,sort(Xax));
figure
plot(Xax,Yax,'.');
hold on
plot(sort(Xax),pf);
hold off

figure
plot(sort(Xax),0.62*sort(Xax)+pf/90.*2.2./sort(Xax)-5./sort(Xax).^2)
hold on
plot(sort(Xax),sort(Xax))
hold off

NbT=sort(Xax);
NbNT=0.62*sort(Xax)+pf/90.*2.2./sort(Xax)-5./sort(Xax).^2;

Xaxfplot=sort(Xax);
Yaxfplot=0.62*sort(Xax)+pf/90.*2.2./sort(Xax)-5./sort(Xax).^2;
