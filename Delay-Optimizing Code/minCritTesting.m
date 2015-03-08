function [ result ] = minCritTesting(T,N,X,relWT)
% Compare how various errors relate to filter function intercepts

% Inputs:   T, sequence length in ns (ex: T=300)
%           N, number of pi pulses (ex: N=6)
%           X, number of trials (ex: X=50)
%           relWT, factor by which switching function is weighted greater
%                  than msd
% Output:   result, value of filter function at w=10^-2 for each trial



% Following commented-out stuff is for plotting filter functions

%figure(1);
%fix_fonts = @(h) set(h,'FontSize',14,...
%                       'FontWeight','bold',...
%                       'FontName','Arial');
%line_array = colormap('lines');
omegaT = logspace(-2,2,300)';
%set(figure(1),'Units','normalized','Position',[0.1 0.3 0.6 0.5]);clf;
%axis([omegaT(1) omegaT(end) 1e-20 100]);
%set(gca,'Xscale','log','Yscale','log');

%hold on
%fix_fonts(xlabel('\omega{T}'));
%fix_fonts(ylabel('Filter Function'));
%fix_fonts(gca);


%Initializing vectors of various errors and filter function result
result = zeros(X,1);
msds = zeros(X,1);
maxErrs = zeros(X,1);
altSums = zeros(X,1);
combos = zeros(X,1);

%running X trials
for i = 1:X
    n=1:N;
    
    idealTimes = uddTimes(T,N,0)';
    % Randomly generate some error and some times with error
    %error = (rand(N,1)*sqrt(X))-(sqrt(X)/2);
    %UDD_timings = (idealTimes + error')/T;
    
    
    % Or generate some times that are not at all a UDD sequence, but
    % have a near-zero switching function
    UDD_timings = [T/10; 2*T/10; 5*T/10; 7*T/10; 7.5*T/10; 9.5*T/10]'+ ...
        (rand(N,1)'*sqrt(X))-(sqrt(X)/2);
    error = UDD_timings'-idealTimes';
    
    % Calculate various errors
    msd = sum(error.*error)/N;
    altSum = abs(sum(((-1).^([0:length(error)-1])*error)));
    maxErr = max(abs(error));
    combo = sum(error.*error)/relWT + abs(sum(((-1).^([0:length(error)-1])*error)));    
    
    % Calculate filter function result
    filter_function = @(timings) abs(1+(-1)^(N+1)*exp(1i*omegaT) + ...
        sum(2*exp(1i*bsxfun(@plus,n*pi,omegaT*timings)),2)).^2;
    F = filter_function(UDD_timings);
    result(i)=F(1);
    
    %put errors in vectors of all trial results
    msds(i)=msd;
    maxErrs(i)=maxErr;
    altSums(i)=altSum;
    combos(i)=combo;
    %plot(omegaT,F,'Color',line_array(j,:));

end

%call minCritPlot to plot results
minCritPlot( result,msds,maxErrs,altSums,combos );

