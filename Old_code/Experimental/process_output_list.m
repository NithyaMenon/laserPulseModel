function [ outputData ] = process_output_list( inputData )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[ times,I,Q,U,V,widths,IDs,StateHistoryArrays ] = IDtoPulseData_list( inputData );
zeropad = zeros(size(times));
timevec = [ times-widths/2-eps, times-widths/2, times+widths/2,times+widths/2+eps];
Ivec = [ zeropad, I, I, zeropad];
plotdata = transpose([timevec;Ivec]);
[Y,Inds] = sort(plotdata(:,1));
outputData = plotdata(Inds,:);

end

