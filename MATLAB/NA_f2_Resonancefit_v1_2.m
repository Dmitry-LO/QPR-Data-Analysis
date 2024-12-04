function [Resonancefit,elapsedTime]=NA_f2_Resonancefit_v1_2(NADataMode,MyfitOptions,FunctionControls)
clearvars procdata x y f1array procd1 CenterF
Resonancefit=NADataMode;
psize=size(Resonancefit); 
timerVal = tic;
PlotN=1;

%============plots for control=======
    if FunctionControls(1,1)==1
    figure('Position', [100 100 1600*1 500*1])
    end
%/===========plots for control=======

for fn=1:psize(1,2)
clearvars procdata x y f1array

x=Resonancefit(fn).data(:,1);
y=Resonancefit(fn).data(:,2);

f1=fit(x,y,'20*log10((a/((b^2-x^2)^2+c*x^2)^0.5))-d',MyfitOptions);
%f1=fit(x,y,'10*log10(abs(a/(1+b^2*((x-c)/c))))',MyfitOptions);

f1array(:,1)=x;
f1array(:,2)=f1(x);

Coefs = coeffvalues(f1);
% maxS21ID=f1array(:,2)==max(f1array(:,2));
% maxS21F=x(maxS21ID);
maxS21ID=find(f1array(:,2)==max(f1array(:,2)));
maxS21F=Coefs(1,2);%x(maxS21ID);
%Coefs(1,2)

CenterF(fn,2)=maxS21F;
CenterF(fn,1)=Resonancefit(fn).dataline(1,25);


ftestArr(fn,1)=maxS21F - Coefs(1,2);

if FunctionControls(1,1)==1
    
%disp([fn PlotN])
if fn==1;
    %hold on
    plot(f1,x,y);
    title(['traceN:',num2str(fn)]); 
    %hold off
end
if PlotN==FunctionControls(1,2)
    %hold on
    plot(f1,x,y);
    title(['traceN:',num2str(fn)]);
    f1
    Coefs(1,2)
    %hold off
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

end