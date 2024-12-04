alldata(:,23)

stepp=1;
maxiter=ceil(max(alldata(:,23))/stepp);
minF=min(alldata(:,23));

for i=1:10%maxiter
b(i)=mean(alldata(and(alldata(:,23)<(minF+stepp),alldata(:,23)>=(minF)),23));

minF=min(alldata(alldata(:,23)>=(minF+stepp),23));
end

figure
plot(alldata(:,23))