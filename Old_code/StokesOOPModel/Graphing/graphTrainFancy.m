function data=graphTrainFancy(inputPulse, stagePulse, desiredPulse, n)
%   Inputs: inputPulse [ N x 3] matrix containing time, value_vert, and value_horiz in each row
%   Outputs: plots  time vs. value 


tVector = inputPulse(:,1)*10^9;

inVectorVert = inputPulse(:,2);
inVectorHoriz = inputPulse(:,3);
stageVectorVert = stagePulse(:,2);
stageVectorHoriz = stagePulse(:,3);
desiredVector = desiredPulse(:,2);


inVectorVert(inVectorVert <= 0) = 1e-12;
inVectorHoriz(inVectorHoriz <= 0) = 1e-12;
stageVectorVert(stageVectorVert <= 0) = 1e-12;
stageVectorHoriz(stageVectorHoriz <= 0) = 1e-12;
desiredVector(desiredVector <= 0) = 1e-12;

fixfonts = @(h) set(h,'FontName','Arial',...
                      'FontSize',10,...
                      'FontWeight','bold');

% Here we go, final figure.  Declare the figure
figure(n);
% Set the axes
axis([790 860 0.00001 2]);
% set the y-axis to log
set(gca,'YScale','log');
% Turn "hold on" to tell it that we're going to add a couple patches
hold on
% Choose the pulse colors, both the lines and the fill
% Let's do blue and dark red
linecolors = [0   0 1;   % blue 
              0.7 0 0; % dark red 
              0 1 0 ; % green
              0 0 0 ; % black
              1 0 1 ; % magenta
              0 1 1 ; % cyan
              1 1 1];  % white
          
% Let's fill with a lighter color; how light is set by "shading"
shading = 0.1;
fillcolors = ones(size(linecolors))*(1-shading)+shading*linecolors;
% fill in the boxes.  Save the handles h1, h2, for further manipulation.
h1=fill(tVector,inVectorVert,fillcolors(1,:));
h2=fill(tVector,inVectorHoriz,fillcolors(2,:));
%h3=fill(tVector,desiredVector,fillcolors(4,:));
h4=fill(tVector,stageVectorVert,fillcolors(6,:));
h5=fill(tVector,stageVectorHoriz,fillcolors(5,:));

%h4=fill(tVector,transVector,fillcolors(5,:));
%alpha(0.5);
% Make the lines around them thicker and colored
set(h1,'EdgeColor',linecolors(1,:),'LineWidth',2,'LineStyle', '-','Marker', '+', 'MarkerSize', 10);
set(h2,'EdgeColor',linecolors(2,:),'LineWidth',2,'LineStyle', '-','Marker', '+', 'MarkerSize', 10);
%set(h3,'EdgeColor',linecolors(4,:),'LineWidth',3,'LineStyle', '--');
set(h4,'EdgeColor',linecolors(6,:),'LineWidth',2,'LineStyle', '-','Marker', '+', 'MarkerSize', 10);
set(h5,'EdgeColor',linecolors(5,:),'LineWidth',2,'LineStyle', '-', 'Marker', '+', 'MarkerSize', 10);

h3 = stairs(tVector, desiredVector,'g','LineStyle', '--','LineWidth',2);

% label with big fonts
fixfonts(xlabel('Time (ns)'));
fixfonts(ylabel('Log of Relative Pulse Power'));
%fixfonts(title('Final plot'))
% It may also be nice to have a legend in the NorthEast corner.
% Note for this we need a vector of handles and a cell-array of strings.
fixfonts(legend([h1,h2,h4,h5,h3],{'Vertical Input','Horizontal Input','Vertical Intermediate','Horizontal Intermediate', 'Ideal Pulse'},'Location','NorthEast'));
data=[h1,h2,h4,h5,h3];

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