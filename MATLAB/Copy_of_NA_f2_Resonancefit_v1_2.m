
clearvars procdata x y f1array procd1 CenterF
Resonancefit=NAData.Q1;
psize=size(Resonancefit); 
timerVal = tic;
PlotN=1;
startPoints=startPoints1;
%============plots for control=======
    if FunctionControls(1,1)==1
    figure('Position', [100 100 1600*1 500*1])
    end
%/===========plots for control=======

for fn=1:psize(1,2)
clearvars procdata x y f1array

x1=Resonancefit(fn).data(:,1);
y1=Resonancefit(fn).data(:,2);

maxindex=find(Resonancefit(fn).data(:,2)==max(Resonancefit(fn).data(:,2)));
startPoints(1,2)=Resonancefit(fn).data(maxindex,1);
startPoints(1,1)=10^(Resonancefit(fn).data(maxindex,2)/10);
lowSP=[10^(Resonancefit(fn).data(maxindex,2)/10)*0.2 0 0];


MyfitOptions = fitoptions('Method','NonlinearLeastSquares','Lower',lowSP,'Startpoint',startPoints);

clearvars x y
xsize=size(x1);
windowprecent=0.2;
window=[1:1:round((1-windowprecent)*find(y1==max(y1))),round((1+windowprecent)*find(y1==max(y1))):xsize(1,1)];

y=y1(window);
x=x1(window);

%f1=fit(x,y,'20*log10((a/((b^2-x^2)^2+c*x^2)^0.5))-d',MyfitOptions);
f1=fit(x,y,'10*log10(a/(((x-b)/b)^2*c^2+1))',MyfitOptions);

f1array(:,1)=x;
f1array(:,2)=f1(x);

Coefs = coeffvalues(f1);
maxS21F=Coefs(1,2);

CenterF(fn,2)=maxS21F;
CenterF(fn,1)=Resonancefit(fn).dataline(1,25);


ftestArr(fn,1)=maxS21F - Coefs(1,2);

if FunctionControls(1,1)==1
    
%disp([fn PlotN])
if fn==1;
    hold on
    scatter(x1,y1,'.');
    plot(f1,x,y);
    title(['traceN:',num2str(fn)]); 
    hold off
    f1
    maxS21F
end
if PlotN==FunctionControls(1,2)

    scatter(x1,y1,'.');
        hold on
    plot(f1,x,y);
    title(['traceN:',num2str(fn)]);
    f1
    maxS21F
    hold off
    PlotN=1;
 else
     PlotN=PlotN+1;
 end


end

end

maxFilIDNA = size(CenterF);
maxk=maxFilIDNA(1,1);

for i=1:maxFilIDNA(1,1)
CenterF(i,3)=CenterF(i,2)-max(CenterF(:,2));
Resonancefit(i).CenterF=CenterF(i,2);
Resonancefit(i).ShiftF=CenterF(i,3);
end

elapsedTime = toc(timerVal);
%disp(['Elapsed time <strong>',num2str(elapsedTime),'</strong> sec']);
