function [ result ] = minCritPlot( result,msds,maxErrs,altSums,combos)
%plots stuff for minCritTesting
fix_fonts = @(h) set(h,'FontSize',14,...
                       'FontWeight','bold',...
                       'FontName','Arial');


set(figure(2),'Units','normalized','Position',[0.1 0.3 0.6 0.5]);clf;
axis([0 300 1e-25 1e+5]);
set(gca,'Yscale','log');
fix_fonts(xlabel('error'));
fix_fonts(ylabel('Filter function intercept'));
hold on

%scatter(msds,result);
%scatter(maxErrs,result);
scatter(altSums,result);
%scatter(combos,result);

hold off
