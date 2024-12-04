
ylabelNew='Surface resistance \itR_s\rm (n\Omega)';


xlabelNew='Sample temperature \itT\rm (K)'
%Peak field on sample \itB\rm (mT)
%'Sample temperature \itT\rm (K)'

xlabel(xlabelNew);
ylabel(ylabelNew);

%% Legend formatting
%1: open figure in active window
hf = gcf;

%2: find all plots on the figure

errorbars = findobj(hf, 'Type','errorbar') %find 'errorbars' plots
lines = findobj(hf, 'Type','line') %find 'line' plots


%legend([errorbar(2) errorbar(3) errorbar(1)]) %list all found plots that you want to appear on the legend
%legend([errorbars(2) errorbars(1)]) 
[lgd, icons, plots, txt] = legend([lines(8),lines(7),lines(2),lines(6)]);
lgd.FontSize=19

%% style formatting
FontS=22;
set(gca,'FontSize',FontS+1);
xlabel(xlabelNew, 'FontSize', FontS);
ylabel(ylabelNew, 'FontSize', FontS);
legend('FontSize', 19)

%% Recacalculation

hf = gcf;
%herr = findobj(hf, 'Type','errorbar')

lineORerr=2; %1=line 2=err

if lineORerr==1
    hplot = findobj(hf,'Type','line')
xax1=get(hplot,'Xdata')'; %get x data
yax1=get(hplot,'Ydata')'; %get y data
else
    hplot = findobj(hf, 'Type','errorbar')
xax1=get(hplot,'Xdata')'; %get x data
yax1=get(hplot,'Ydata')'; %get y data
yerr=get(hplot,'YPositiveDelta')'; %get error data
end

%yerr=get(h,'YNegativeDelta')'; %get error data

PlotN=2;
Xaxfplotraw =xax1{PlotN}';
Yaxfplotraw =yax1{PlotN}';
if lineORerr==2
Errdataraw =yerr{PlotN}';
end
disp([Xaxfplotraw,Yaxfplotraw]);

Xaxfplot =   Xaxfplotraw; %%%%%=======RECALCULATION Place!============%%%%%
Yaxfplot =   Yaxfplotraw;
if lineORerr==2
Errdata = Errdataraw;
end

%[=============Getting Formatting========================]
MarkSize_cell=get(hplot,'MarkerSize');
LineW_cell=get(hplot,'LineWidth');
MarkShape_cell=get(hplot,'Marker');
MarkColor_cell=get(hplot,'MarkerFaceColor');
Lcol_cell=get(hplot,'MarkerEdgeColor');
LineSty_cell=get(hplot,'LineStyle');
plotname_cell=get(hplot,'DisplayName');
%[=============/Getting Formatting========================]

figure('Position', [100 100 900*sc1 600*sc1]);
[mshape1,Pal1,Pal3]=Pall;

plotname=plotname_cell{PlotN};%'YourPlot';
MarkSize=MarkSize_cell{PlotN}+2;
LineW=1%LineW_cell{PlotN};
MarkShape=MarkShape_cell{PlotN};
FontS=20;
MarkColor=MarkColor_cell{PlotN};
Lcol=Lcol_cell{PlotN};
LineSty=LineSty_cell{PlotN};


if lineORerr==1
plot(Xaxfplot,Yaxfplot,...
    'Marker',MarkShape,'LineStyle',LineSty,'DisplayName',plotname,...
    'LineWidth',LineW,'Color',Lcol,'Marker',MarkShape,'MarkerEdgeColor',Lcol,... 
    'MarkerFaceColor',MarkColor,...
    'MarkerSize',MarkSize);
else
errorbar(Xaxfplot,Yaxfplot,Errdata,...
    'Marker',MarkShape,'LineStyle',LineSty,'DisplayName',plotname,...
    'LineWidth',LineW,'Color',Lcol,'MarkerEdgeColor',Lcol,... 
    'MarkerFaceColor',MarkColor,...
    'MarkerSize',MarkSize);
end
%legend show
[lgd, icons, plots, txt] = legend('show');
%legend([errorbar(1) errorbar(2) errorbar(1)])
%legend(hplot(1))
%% saving plots LATEX!!!==============================================

plotFilename='RsvT_ALLSUBU&EP'; %RsvB_B3p6vsCERN2Substracted2
folder='D:\Dropbox\Apps\Overleaf\PhD\Figures\Nb-Cu\'; %D:\Dropbox\Apps\Overleaf\PhD\Figures\Nb-Cu\'; D:\Dropbox\Apps\Overleaf\PhD\Figures\QPR_Flange_DTplots\
folderS=['D:\nextcloud\PhD\SourceFigures',folder(37:end)]; %'D:\nextcloud\PhD\SourceFigures\';

mkdir(folderS)
saveas(gcf,[folderS,plotFilename],'fig')
orient(gcf,'landscape')
saveas(gcf,[folder,plotFilename],'pdf')
orient(gcf,'portrait')
mkdir(folderS,'lower_res')
print(gcf,[folderS,'lower_res\',plotFilename],'-dpng','-r100')
mkdir(folderS,'PNG')
saveas(gcf,[folderS,'PNG\',plotFilename],'png')