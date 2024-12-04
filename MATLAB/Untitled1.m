thermalmodel = createpde('thermal','transient')
geometryFromEdges(thermalmodel,@squareg)
%geometryFromEdges(thermalmodel,@crackg)
pdegplot(thermalmodel,'EdgeLabels','on')
ylim([-1,1])
axis equal

thermalProperties(thermalmodel,'ThermalConductivity',1,...
                               'MassDensity',1,...
                               'SpecificHeat',1)
                           
%thermalBC(thermalmodel,'Edge',2,'Temperature',10)
thermalBC(thermalmodel,'Edge',4,'Temperature',1.8)
%thermalBC(thermalmodel,'Edge',4,'HeatFlux',-100)
thermalBC(thermalmodel,'Edge',2,'HeatFlux',10)

thermalIC(thermalmodel,0)

generateMesh(thermalmodel)
figure
pdemesh(thermalmodel)
title('Mesh with Quadratic Triangular Elements')

tlist = 0:0.5:50

thermalresults = solve(thermalmodel,tlist)

[qx,qy] = evaluateHeatFlux(thermalresults)

pdeplot(thermalmodel,'XYData',thermalresults.Temperature(:,end), ...
                     'Contour','on',...
                     'FlowData',[qx(:,end),qy(:,end)], ...
                     'ColorMap','hot')
                 
%% 2 materials

numberOfPDE = 1;
model =  createpde(numberOfPDE);
sc=1e3;
diam=75;
film=1;
film2=2;
wall=2; 
wall_h=90;

SQ1 = [3; 4; 0; 8/sc; 8/sc; 0;...
    -diam/2/sc; -diam/2/sc; diam/2/sc; diam/2/sc]; %Y

SQ2 = [3; 4; 8/sc; 8/sc+film/sc; 8/sc+film/sc; 8/sc;...
    -diam/2/sc; -diam/2/sc; diam/2/sc; diam/2/sc]; %Y

SQ3 = [3; 4; 8/sc; 8/sc+film/sc+film2/sc; 8/sc+film/sc+film2/sc; 8/sc;...
    -diam/2/sc; -diam/2/sc; diam/2/sc; diam/2/sc]; %Y

SQ4 = [3; 4; 0; -20/sc; -20/sc; 0;...
    -10/2/sc; -10/2/sc; 10/2/sc; 10/2/sc]; %Y

SQ5 = [3; 4; 0; -wall_h/sc; -wall_h/sc; 0;...
    diam/2/sc-wall/sc; diam/2/sc-wall/sc; diam/2/sc; diam/2/sc]; %Y

SQ6 = [3; 4; 0; -wall_h/sc; -wall_h/sc; 0;...
    -diam/2/sc+wall/sc; -diam/2/sc+wall/sc; -diam/2/sc; -diam/2/sc]; %Y

SQ7 = [3; 4; -wall_h/sc; -wall_h/sc-28/sc; -wall_h/sc-28/sc; -wall_h/sc;...  %FLANGE
    -150/2/sc; -150/2/sc; 150/2/sc; 150/2/sc]; %Y



%D1 = [2; 4; 0.5; 1.5; 2.5; 1.5; 1.5; 0.5; 1.5; 2.5];
gd = [SQ1,SQ2,SQ3,SQ4,SQ5,SQ6,SQ7];
sf = 'SQ1+SQ2+SQ3+SQ4+SQ5+SQ6+SQ7';
ns = char('SQ1','SQ2','SQ3','SQ4','SQ5','SQ6','SQ7');
ns = ns';
dl = decsg(gd,sf,ns);

geometryFromEdges(model,dl);

pdegplot(model,'EdgeLabels','on','FaceLabels','on')
xlim([-150/sc,20/sc])
ylim([-100/sc,100/sc])
axis equal

rho_sq = 2;
C_sq = 0.1;
k_sq = 100;
%Q_Heater = 0;
h_sq = 0;

rho_d = 1;
C_d = 0.1;
k_d = 100;
Q_d = 10;
h_d = 0;

QRF=1000
Q_Heater=25

rho_Nb=8.57;
C_Nb=2
k_Nb=32


C_AlN=2
rho_AlN=3.26;
k_AlN=285/10000;

%(model,'m',0,'d',rho_sq*C_sq,'c',k_sq,'a',h_sq,'f',Q_Heater,'Face',6);
                      
specifyCoefficients(model,'m',0,'d',rho_Nb*C_Nb, ...
                          'c',k_Nb,'a',0, ...
                          'f',Q_Heater,'Face',6);
                      
specifyCoefficients(model,'m',0,'d',rho_AlN*C_AlN, ...
                          'c',k_AlN,'a',0, ...
                          'f',QRF,'Face',1);
                      
specifyCoefficients(model,'m',0,'d',rho_Nb*C_Nb, ...
                          'c',k_Nb*100,'a',0, ...
                          'f',0,'Face',3);
                      
specifyCoefficients(model,'m',0,'d',rho_Nb*C_Nb, ...
                          'c',k_Nb,'a',0, ...
                          'f',0,'Face',2);
%---walls
specifyCoefficients(model,'m',0,'d',rho_Nb*C_Nb, ...
                          'c',k_Nb,'a',0, ...
                          'f',0,'Face',5);
specifyCoefficients(model,'m',0,'d',rho_Nb*C_Nb, ...
                          'c',k_Nb,'a',0, ...
                          'f',0,'Face',4);
%---flange
specifyCoefficients(model,'m',0,'d',rho_Nb*C_Nb, ...
                          'c',k_Nb*100,'a',0, ...
                          'f',0,'Face',7);
%---end


applyBoundaryCondition(model,'dirichlet','Edge',[10,8],'h',1,'r',1.8);

%thermalBC(model,'Edge',2,'HeatFlux',10)

setInitialConditions(model,1.8);

generateMesh(model);

%tlist = logspace(-2,-1,100);
tlist = 0:0.5:500

results = solvepde(model,tlist);
u = results.NodalSolution;

[cgradx,cgrady] = evaluateCGradient(results);

figure
pdeplot(model,'XYData',u(:,10),'Contour','on', ...
              'FlowData',[-cgradx(:,10),-cgrady(:,10)], ...
              'ColorMap','hot')
%% simple model with 3 layers
T=3
numberOfPDE = 1;
model =  createpde(numberOfPDE);
sc=1e7;
diam=1000;
film=35;
film2=180;
wall=2; 
wall_h=90;
filmbase=400

SQ1 = [3; 4; 0; filmbase/sc; filmbase/sc; 0;...
    -diam/2/sc; -diam/2/sc; diam/2/sc; diam/2/sc]; %Y

SQ2 = [3; 4; filmbase/sc; filmbase/sc+film/sc; filmbase/sc+film/sc; filmbase/sc;...
    -diam/2/sc; -diam/2/sc; diam/2/sc; diam/2/sc]; %Y

SQ3 = [3; 4; filmbase/sc; filmbase/sc+film/sc+film2/sc; filmbase/sc+film/sc+film2/sc; filmbase/sc;...
    -diam/2/sc; -diam/2/sc; diam/2/sc; diam/2/sc]; %Y




%D1 = [2; 4; 0.5; 1.5; 2.5; 1.5; 1.5; 0.5; 1.5; 2.5];
gd = [SQ1,SQ2,SQ3];
sf = 'SQ1+SQ2+SQ3';
ns = char('SQ1','SQ2','SQ3');
ns = ns';
dl = decsg(gd,sf,ns);

geometryFromEdges(model,dl);

pdegplot(model,'EdgeLabels','on','FaceLabels','on')
%xlim([-150/sc,20/sc])
%ylim([-100/sc,100/sc])
axis equal

rho_sq = 2;
C_sq = 0.1;
k_sq = 100;
%Q_Heater = 0;
h_sq = 0;

rho_d = 1;
C_d = 0.1;
k_d = 100;
Q_d = 10;
h_d = 0;

QRF=100
Q_Heater=25*1000/((film/sc)*(diam/sc))

rho_Nb=8.57;
C_Nb=260
k_Nb=32


C_AlN=260
rho_AlN=3.26;
%k_AlN=285/10000;

hold on
figure
karr=zeros(100);
T0=3;

scc=1
clearvars k_AlNold
k_AlN = (-0.0746*T0^3 + 4.5684*T0^2 - 7.5942*T0 + 21.524)*scc*2
T=T0;
for iter=1:100
k_AlNold=k_AlN;
    
k_AlN = (-0.0746*T^3 + 4.5684*T^2 - 7.5942*T + 21.524)*scc

%(model,'m',0,'d',rho_sq*C_sq,'c',k_sq,'a',h_sq,'f',Q_Heater,'Face',6);
                      
                      
specifyCoefficients(model,'m',0,'d',rho_AlN*C_AlN, ...
                          'c',k_AlN,'a',0, ...
                          'f',0,'Face',3);
                      
specifyCoefficients(model,'m',0,'d',rho_Nb*C_Nb, ...
                          'c',k_Nb*100,'a',0, ...
                          'f',0,'Face',2);
                      
specifyCoefficients(model,'m',0,'d',rho_Nb*C_Nb, ...
                          'c',k_Nb,'a',0, ...
                          'f',0,'Face',1); 


applyBoundaryCondition(model,'dirichlet','Edge',[1],'r',3,'h',1);
%applyBoundaryCondition(model,'dirichlet','Edge',[1],'r',3);
applyBoundaryCondition(model,'neumann','Edge',[3],'q',0,'g',QRF/0.00567450);

%thermalBC(model,'Edge',2,'HeatFlux',10)

setInitialConditions(model,T0);

generateMesh(model);

%tlist = logspace(-2,-1,100);
tlist = 0:0.05:5;

results = solvepde(model,tlist);
u = results.NodalSolution;

[cgradx,cgrady] = evaluateCGradient(results);




T=max(u(:));
if iter>10
if abs(k_AlNold-k_AlN)/k_AlNold<0.01
    maxi=iter-1
    break
end
end

karr(iter,2) = k_AlN;
karr(iter,1) = iter;

end

figure
pdeplot(model,'XYData',u(:,100),'Contour','on', ...
              'FlowData',[-cgradx(:,100),-cgrady(:,100)], ...
              'ColorMap','hot');
figure
plot(tlist,max(u,[],1))

figure
plot(karr(1:maxi,1),karr(1:maxi,2))


%% new combined
thermalmodel = createpde('thermal','transient')

SQ1 = [3; 4; 0; 2; 2; 0; 0; 0; 3; 3];
SQ2 = [3; 4; 2; 2.5; 2.5; 2; 0; 0; 3; 3];
SQ3 = [3; 4; 2.5; 3.5; 3.5; 2.5; 0; 0; 3; 3];
D1 = [2; 4; 0.5; 1.5; 2.5; 1.5; 1.5; 0.5; 1.5; 2.5];
gd = [SQ1,SQ2,SQ3];
sf = 'SQ1+SQ2+SQ3';
ns = char('SQ1','SQ2','SQ3');
ns = ns';
dl = decsg(gd,sf,ns);

geometryFromEdges(model,dl);

pdegplot(model,'EdgeLabels','on','FaceLabels','on')
xlim([-1.5,4.5])
ylim([-0.5,4.5])
axis equal


thermalProperties(thermalmodel,'ThermalConductivity',1,...
                               'MassDensity',1,...
                               'SpecificHeat',1)
                           
thermalBC(thermalmodel,'Edge',2,'Temperature',10)
thermalBC(thermalmodel,'Edge',4,'Temperature',1.8)
thermalBC(thermalmodel,'Edge',4,'HeatFlux',-100)
thermalBC(thermalmodel,'Edge',2,'HeatFlux',10)

thermalIC(thermalmodel,0)

generateMesh(thermalmodel)
figure
pdemesh(thermalmodel)
title('Mesh with Quadratic Triangular Elements')

tlist = 0:0.5:50

thermalresults = solve(thermalmodel,tlist)

[qx,qy] = evaluateHeatFlux(thermalresults)

pdeplot(thermalmodel,'XYData',thermalresults.Temperature(:,end), ...
                     'Contour','on',...
                     'FlowData',[qx(:,end),qy(:,end)], ...
                     'ColorMap','hot')
                 
%% rrr

thermalmodel = createpde('thermal','transient');

%geometryFromEdges(thermalmodel,@crackg);
%---
sc=1e3/100;
diam=1;
film=1;
film2=2;
wall=2; 
wall_h=90;

SQ1 = [3; 4; 0; 4/sc; 4/sc; 0;...
    -diam/2/sc; -diam/2/sc; diam/2/sc; diam/2/sc]; %Y

SQ2 = [3; 4; 4/sc; 4/sc+film/sc; 4/sc+film/sc; 4/sc;...
    -diam/2/sc; -diam/2/sc; diam/2/sc; diam/2/sc]; %Y

SQ3 = [3; 4; 4/sc; 4/sc+film/sc+film2/sc; 4/sc+film/sc+film2/sc; 4/sc;...
    -diam/2/sc; -diam/2/sc; diam/2/sc; diam/2/sc]; %Y




%D1 = [2; 4; 0.5; 1.5; 2.5; 1.5; 1.5; 0.5; 1.5; 2.5];
gd = [SQ1,SQ2,SQ3];
sf = 'SQ1+SQ2+SQ3';
ns = char('SQ1','SQ2','SQ3');
ns = ns';
dl = decsg(gd,sf,ns);

geometryFromEdges(model,dl);
%---

pdegplot(thermalmodel,'EdgeLabels','on')
ylim([-1,1])
axis equal

thermalProperties(thermalmodel,'ThermalConductivity',1,...
 'MassDensity',1,...
 'SpecificHeat',1);

thermalBC(thermalmodel,'Edge',6,'Temperature',100);
thermalBC(thermalmodel,'Edge',1,'HeatFlux',-10);
thermalIC(thermalmodel,0);
generateMesh(thermalmodel);
figure
tlist = 0:0.5:5;
thermalresults = solve(thermalmodel,tlist)
[qx,qy] = evaluateHeatFlux(thermalresults);
pdeplot(thermalmodel,'XYData',thermalresults.Temperature(:,end), ...
 'Contour','on',...
 'FlowData',[qx(:,end),qy(:,end)], ...
 'ColorMap','hot')