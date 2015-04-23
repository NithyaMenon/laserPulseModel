%%

clear
clc
load('FinalResultSet_ForTesting3.mat')



N = [FinalResultSet(1:end-2).N];
T = [FinalResultSet(1:end-2).T]*1e9;
Tim = [FinalResultSet(1:end-2).TimingStatistics];
TimMean = [Tim(:).Mean];
TimDev = [Tim(:).StdDevation];
Pwr = [FinalResultSet(1:end-2).PowerStatistics];
PwrMean = [Pwr(:).Mean];
PwrDev = [Pwr(:).StdDevation];

TimMeanFFSheet = cell(length(unique(N))+1,length(unique(T))+1);
TimDevFFSheet = cell(length(unique(N))+1,length(unique(T))+1);
TimMeanRMSESheet = cell(length(unique(N))+1,length(unique(T))+1);
TimDevRMSESheet = cell(length(unique(N))+1,length(unique(T))+1);
PwrMeanSheet = cell(length(unique(N))+1,length(unique(T))+1);
PwrDevSheet = cell(length(unique(N))+1,length(unique(T))+1);


TimMeanFFSheet{1,1} = 'N/T';
TimDevFFSheet{1,1} = 'N/T';
TimMeanRMSESheet{1,1} = 'N/T';
TimDevRMSESheet{1,1} = 'N/T';
PwrMeanSheet{1,1} = 'N/T';
PwrDevSheet{1,1} = 'N/T';

i = 2;
for n = unique(N)
    TimMeanFFSheet{i,1} = n;
    TimDevFFSheet{i,1} = n;
    TimMeanRMSESheet{i,1} = n;
    TimDevRMSESheet{i,1} = n;
    PwrMeanSheet{i,1} = n;
    PwrDevSheet{i,1} = n;
    i = i+1;
end

i = 2;
for t = unique(T)
    TimMeanFFSheet{1,i} = t;
    TimDevFFSheet{1,i} = t;
    TimMeanRMSESheet{1,i} = t;
    TimDevRMSESheet{1,i} = t;
    PwrMeanSheet{1,i} = t;
    PwrDevSheet{1,i} = t;
    i = i+1;
end

for k = 1:length(N)
    i = find([TimMeanFFSheet{2:end,1}] == N(k),1,'first')+1;
    j = find([TimMeanFFSheet{1,2:end}] == T(k),1,'first')+1;
    TimMeanFFSheet{i,j} = TimMean(1,k);
    TimDevFFSheet{i,j} = TimDev(1,k);
    TimMeanRMSESheet{i,j} = TimMean(2,k);
    TimDevRMSESheet{i,j} = TimDev(2,k);
    PwrMeanSheet{i,j} = PwrMean(k);
    PwrDevSheet{i,j} = PwrDev(k);    
end

xlswrite('FinalResultSet_ForTesting.xlsx',TimMeanFFSheet,1);
xlswrite('FinalResultSet_ForTesting.xlsx',TimDevFFSheet,2);
xlswrite('FinalResultSet_ForTesting.xlsx',TimMeanRMSESheet,3);
xlswrite('FinalResultSet_ForTesting.xlsx',TimDevRMSESheet,4);
xlswrite('FinalResultSet_ForTesting.xlsx',PwrMeanSheet,5);
xlswrite('FinalResultSet_ForTesting.xlsx',PwrDevSheet,6);
