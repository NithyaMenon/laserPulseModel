%%

clear
clc
load('FinalResultSet_40Runs_new.mat')

%%

% Find last valid entry
EndInd = find([FinalResultSet.N] ~= -1, 1, 'last');

%%

N = [FinalResultSet(1:EndInd).N];
T = [FinalResultSet(1:EndInd).T]*1e9;
seqFail = [FinalResultSet(1:EndInd).seqFail];
Tim = [FinalResultSet(1:EndInd).TimingStatistics];
TimMean = {Tim(:).Mean};
TimDev = {Tim(:).StdDevation};
Pwr = [FinalResultSet(1:EndInd).PowerStatistics];
PwrMean = {Pwr(:).Mean};
PwrDev = {Pwr(:).StdDevation};
OptVal = [FinalResultSet(1:EndInd).OptimizationTarget];
IdealVal = [FinalResultSet(1:EndInd).IdealTimingPerformance];

%%

TimMeanFFSheet = cell(length(unique(N))+1,length(unique(T))+1);
TimDevFFSheet = cell(length(unique(N))+1,length(unique(T))+1);
TimMeanRMSESheet = cell(length(unique(N))+1,length(unique(T))+1);
TimDevRMSESheet = cell(length(unique(N))+1,length(unique(T))+1);
PwrMeanSheet = cell(length(unique(N))+1,length(unique(T))+1);
PwrDevSheet = cell(length(unique(N))+1,length(unique(T))+1);
OptValSheet = cell(length(unique(N))+1,length(unique(T))+1);
IdealValSheet = cell(length(unique(N))+1,length(unique(T))+1);

%%

TimMeanFFSheet{1,1} = 'N/T';
TimDevFFSheet{1,1} = 'N/T';
TimMeanRMSESheet{1,1} = 'N/T';
TimDevRMSESheet{1,1} = 'N/T';
PwrMeanSheet{1,1} = 'N/T';
PwrDevSheet{1,1} = 'N/T';
OptValSheet{1,1} = 'N/T';
IdealValSheet{1,1} = 'N/T';


%%

i = 2;
for n = unique(N)
    TimMeanFFSheet{i,1} = n;
    TimDevFFSheet{i,1} = n;
    TimMeanRMSESheet{i,1} = n;
    TimDevRMSESheet{i,1} = n;
    PwrMeanSheet{i,1} = n;
    PwrDevSheet{i,1} = n;
    OptValSheet{i,1} = n;
    IdealValSheet{i,1} = n;
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
    OptValSheet{1,i} = t;
    IdealValSheet{1,i} = t;
    i = i+1;
end
%%

for k = 1:length(N)
    i = find([TimMeanFFSheet{2:end,1}] == N(k),1,'first')+1;
    j = find([TimMeanFFSheet{1,2:end}] == T(k),1,'first')+1;
    if(seqFail(k) == 1)
        TimMeanFFSheet{i,j} = NaN;
        TimDevFFSheet{i,j} = NaN;
        TimMeanRMSESheet{i,j} = NaN;
        TimDevRMSESheet{i,j} = NaN;
        PwrMeanSheet{i,j} = NaN;
        PwrDevSheet{i,j} = NaN;
    else
        Mean = TimMean(k);
        Mean = Mean{1,1};
        [MeanPP,RMSPP] = calculatePulsePickerPerformance(N(k),T(k)*1e-9);
        Dev = TimDev(k);
        Dev = Dev{1,1};
        PMean = PwrMean(k);
        PDev = PwrDev(k);
        TimMeanFFSheet{i,j} = Mean(1)*(Mean(1)<MeanPP) + MeanPP*(Mean(1)>=MeanPP);
        %TimMeanFFSheet{i,j} = Mean(1);
        TimDevFFSheet{i,j} = Dev(1); % Eh..
        TimMeanRMSESheet{i,j} = Mean(2)*(Mean(1)<MeanPP) + RMSPP*(Mean(1)>=MeanPP);
        %TimMeanRMSESheet{i,j} = Mean(2);
        TimDevRMSESheet{i,j} = Dev(2);
        PwrMeanSheet{i,j} = PMean{1,1};
        PwrDevSheet{i,j} = PDev{1,1};  
   end
   OptValSheet{i,j} = OptVal(k);
    IdealValSheet{i,j} = IdealVal(k);
end

%%
SizeArr = size(TimMeanFFSheet);
for i = 1:SizeArr(1)
    for j = 1:SizeArr(2)
        if(isempty(TimMeanFFSheet{i,j}))
            TimMeanFFSheet{i,j} = NaN;
            TimDevFFSheet{i,j} = NaN;
            TimMeanRMSESheet{i,j} = NaN;
            TimDevRMSESheet{i,j} = NaN;
            PwrMeanSheet{i,j} = NaN;
            PwrDevSheet{i,j} = NaN;
        end
    end
end

%%
TimMeanFFSheet = cellfun(@(s) sprintf('%-12s', s),TimMeanFFSheet, 'UniformOutput', false);
TimDevFFSheet = cellfun(@(s) sprintf('%-12s', s),TimDevFFSheet, 'UniformOutput', false);
TimMeanRMSESheet = cellfun(@(s) sprintf('%-12s', s),TimMeanRMSESheet, 'UniformOutput', false);
TimDevRMSESheet = cellfun(@(s) sprintf('%-12s', s),TimDevRMSESheet, 'UniformOutput', false);
PwrMeanSheet = cellfun(@(s) sprintf('%-12s', s),PwrMeanSheet, 'UniformOutput', false);
PwrDevSheet = cellfun(@(s) sprintf('%-12s', s),PwrDevSheet, 'UniformOutput', false);

%%

xlswrite('FinalResultSet_ForTesting.xlsx',TimMeanFFSheet,1);
xlswrite('FinalResultSet_ForTesting.xlsx',TimDevFFSheet,2);
xlswrite('FinalResultSet_ForTesting.xlsx',TimMeanRMSESheet,3);
xlswrite('FinalResultSet_ForTesting.xlsx',TimDevRMSESheet,4);
xlswrite('FinalResultSet_ForTesting.xlsx',PwrMeanSheet,5);
xlswrite('FinalResultSet_ForTesting.xlsx',PwrDevSheet,6);
xlswrite('FinalResultSet_ForTesting.xlsx',IdealValSheet,7);
