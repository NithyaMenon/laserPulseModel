function data = autoplot(T, N, idealTimes, actualTimes, err, passes, eomOnTimes, eomOffTimes)
%   Inputs: inputPulse [ N x 3] matrix containing time, value_vert, and value_horiz in each row
%   Outputs: plots  time vs. value 


tVector = linspace(0,T,3000);
idealTimes = idealTimes(idealTimes>0);
actualTimes = actualTimes(actualTimes>0);
firstPasses = passes(passes(:,1)>0,1);
secondPasses = passes(passes(:,2)>0,2);
eomOnTimes = eomOnTimes(eomOnTimes>0);
temp = eomOnTimes;
eomOffTimes = eomOffTimes(eomOffTimes>0);
eomOnTimes = [eomOnTimes ; (eomOffTimes+6)]; 
eomOffTimes = [eomOffTimes ; (temp+6)]; 

[idealTimesPlot,actualTimesPlot,firstPassesPlot,secondPassesPlot,eomTimesPlot] = deal(zeros(3000,1));

idealTimesPlot(round(idealTimes*3000/T))=1;
actualTimesPlot(round(actualTimes*3000/T))=1;
firstPassesPlot(round(firstPasses*3000/T))=1;
secondPassesPlot(round(secondPasses*3000/T))=1;
eomTimesPlot(round(eomOnTimes*3000/T))=1.2;
eomTimesPlot(round(eomOffTimes*3000/T))=1.5;


fixfonts = @(h) set(h,'FontName','Arial',...
                      'FontSize',10,...
                      'FontWeight','bold');

% Here we go, final figure.  Declare the figure
%figure(n);
% Set the axes
axis([tVector(1) tVector(end) 0.2 2]);
% set the y-axis to log
set(gca,'YScale','log');
% Turn "hold on" to tell it that we're going to add a couple patches
hold on
% Choose the pulse colors, both the lines and the fill
% Let's do blue and dark red
linecolors = [0   0 1;   % blue 
              0.7 0 0    % dark red
              0 0.8 0];    % green
% Let's fill with a lighter color; how light is set by "shading"
shading = 0.1;
fillcolors = ones(size(linecolors))*(1-shading)+shading*linecolors;
% fill in the boxes.  Save the handles h1, h2, for further manipulation.
h1=fill(tVector,firstPassesPlot,fillcolors(1,:));
h2=fill(tVector,secondPassesPlot,fillcolors(2,:));
h3=fill(tVector,eomTimesPlot,fillcolors(3,:));

% Make the lines around them thicker and colored
set(h1,'EdgeColor',linecolors(1,:),'LineWidth',2,'LineStyle', '-','Marker', '+', 'MarkerSize', 10);
set(h2,'EdgeColor',linecolors(2,:),'LineWidth',2,'LineStyle', '-','Marker', '+', 'MarkerSize', 10);
set(h3,'EdgeColor',linecolors(3,:),'LineWidth',2,'LineStyle', '-','Marker', '+', 'MarkerSize', 10);

% label with big fonts
fixfonts(xlabel('Time (ns)'));
fixfonts(ylabel('Log of Relative Pulse power'));
%fixfonts(title('Final plot'))
% It may also be nice to have a legend in the NorthEast corner.
% Note for this we need a vector of handles and a cell-array of strings.
%fixfonts(legend([h1,h2],{'Vertical','Horizontal'},'Location','NorthEast'));
%data = [h1,h2];
data = 0;

% big font labels
fixfonts(gca);
% make sure there is a box around the figure
box on

% That looks much better, doesn't it?  Compare figure(1) to figure(5) to
% see how far we've come.

% the final trick is that to export it to a presentation, it is best 
% to first "print" it to a .png.  You can use the "Export Setup" submenu
% for this, but we've already fixed the fonts.  All we need is to 
% fix the size and print it.  Let's say we want it to be 4x3 inches.
% First we set the PaperPosition of the figure, whose handle is either 
% the figure number or "gcf" for the "current figure"
% set(5,'units','inches',...         % units could also be pixels, or normalized to the paper size
%       'PaperPosition',[0.1 0.1 4 3]);  % means put the figure 1 inch from the lower left corner, and make it 2x3
% % Then we print
% print(5,'-dpng',... % png format
%         '-r300',... % resolution 300 dpi
%         'sample_pulse_plot');  % filename
    
% This should generate the file sample_pulse_plot.png, which you can drop
% directly into PowerPoint, Word, or Acrobat.  



end