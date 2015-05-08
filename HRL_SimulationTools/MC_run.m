% MC_run.m - Script to initialize and run the Monte Carlo model, to the run
% the simulation, specify a range of N and T and number of Monte Carlo
% models below and press the "run" button in the above MATLAB toolbar. The
% simulation will use the .slx file listed in the below for loop. This
% script is currently configured to perform Monte Carlo simulations of the
% Digitizing Design drawn in MC_DigitizingDesign.slx

% Clear the workspace to prepare for simulation
paths;
clearAll;

% Use MC_specifyerrors to specify the global component errors to be sampled
% for each Monte Carlo run for every component error listed in MC_specifyerrors 
MC_specifyerrors;

% For digitizing designs, we can likely neglect timing errors constructed
% from retroreflectors on the optical table
ErrorSpecs.Delay.Amount = 0;

%==========================================================
% CHANGE THE FOLLOWING PARAMETERS TO CONTROL THE SIMULATION
% Specify a range of N and T to simulate
Ns = [6,10,16,24,30];
Ts = [299, 1001, 1300, 2002, 2600, 3003]*1e-9;
%Ts = [2002:13:3003]*1e-9;
% Specify the number of Monte Carlo simulations to run
montecarloruns = 40;
% Specify the Simulink model to simulate
model = 'MC_DigitizingDesign.slx';
%=========================================================


% Ns = 6;
% Ts = [299, 390:130:3003,3003]*1e-9;
% 
% Ns = 6;
% Ts = (1690:13:2050)*1e-9;

% Ns = [6, 10 ,16, 24, 30];
% Ts = [299, 1001, 1300, 2002, 2600, 3003]*1e-9;

% Ns = [16, 24];
% Ts = [1001,1300]*1e-9;

w = warning ('off','all');

% Specify the structure to store output data
FinalResultSet = repmat(struct('N',-1,'T',-1,'TimingPerformances',[-1],...
            'PowerPerformances',[-1],'TimingStatistics',-1,'PowerStatistics',-1,...
            'OptimizationTarget',-1,'IdealPulse',-1,'IdealTimingPerformance',-1,...
            'AllOutputData',-1,'SimParams',-1,'seqFail',-1),length(Ns)*length(Ts),1);


tic

ctr = 1;

% Run the simulation for each N and T specified above
for N = Ns
    for T = Ts
        % Skip values of N where sequence creation is not possible given
        % the repetition rate of the laser
        if((N+2)*13e-9 >= T)
            continue
        end
        
        display(sprintf('N: %i, T: %i', N, T*1e9))

        % Compute the ideal UDD times for the given N and T
        idealPulseTimes = uddTimes(T,N);
        FinalResultSet(ctr).N = N;
        FinalResultSet(ctr).T = T;

        % Use runExperiment to calculate PC control timings and powers and
        % specify delays for digitizing design. optVal is the best overlap
        % integral value using the delays specified in runExperiment, if
        % the design requires an impossible EOM configuration, return a
        % seqFail flag. 
        [PCTimings1,CP1,PCTimings2,CP2,DelayLeft,DelayMiddle,DelayBottom,optVal,seqFail] = ...
            runExperiment(T*1e9,N);
        FinalResultSet(ctr).seqFail = seqFail;
        SimParams = repmat(struct('DelayLeft',-1,'DelayBottom',-1,'DelayMiddle',-1,...
            'PCTimings1',-1,'PCTimings2',-1),1,1);

        % Save the delays into the output structure
        SimParams.DelayLeft = DelayLeft;
        SimParams.DelayBottom = DelayBottom;
        SimParams.DelayMiddle = DelayMiddle;
        SimParams.PCTimings1 = PCTimings1;
        SimParams.PCTimings2 = PCTimings2;

        FinalResultSet(ctr).SimParams = SimParams;
        FinalResultSet(ctr).OptimizationTarget = optVal;
        
        % If the seqFail flag is set, do not save any output data for this
        % run
        if(seqFail ~= 0)
            AllOutputData = [];
            TimingPerformancesFF = [];
            TimingPerformancesRMSE = [];
            PowerPerformances = [];
        else

            TimingPerformancesFF = zeros(1,montecarloruns);
            TimingPerformancesRMSE = zeros(1,montecarloruns);
            PowerPerformances = zeros(1,montecarloruns);

            % Initialize output data structure and prepare to run Monte
            % Carlo model
            AllOutputData = repmat(struct('ImportantPulse_times',-1,'ImportantPulse_Is',-1,...
                'ResidualPulses_times',-1,'ResidualPulses_Is',-1,'DiffImpRes',-1),1,montecarloruns);
            for l = 1:montecarloruns
                display(sprintf('N: %i, T: %i, MC: %i',N,int16(T*1e9),l));


                % Initialize the Monte Carlo model, and simulate the .slx
                % design specified in "model"
                MC_initialize;
                sim(model,(T/13e-9)+50);
                
                % Use ProcessSimout to separate the data into arrays
                % storing the pulses' properties 
                [ Pulses, Is, Qs, Us, Vs, widths, times, IDs] = ProcessSimout(simout);

                % Pick out the N+2 largest pulses which will form our sequence
                % of pi and pi/2 pulses, all other pulses will be referred
                % to as residual pulses
                NthLargestPulse = sort(Is);
                NthLargestPulse = NthLargestPulse(end-N-1); % N+2 for Pi/2 pulses, actually.

                ImportantPulses_Is = Is(Is>=NthLargestPulse-eps);
                ResidualPulses_Is = Is(Is<NthLargestPulse-eps);
                ImportantPulses_times = times(Is>=NthLargestPulse-eps);
                ResidualPulses_times = times(Is<NthLargestPulse-eps);
                
                % Save pulse data to the output structure
                AllOutputData(l).ImportantPulse_times = ImportantPulses_times*10^9;
                AllOutputData(l).ImportantPulse_Is = ImportantPulses_Is;
                AllOutputData(l).ResidualPulses_times = ResidualPulses_times;
                AllOutputData(l).ResidualPulses_Is = ResidualPulses_Is;
                AllOutputData(l).DiffImpRes = log10(min(ImportantPulses_Is)/max(ResidualPulses_Is));
                AllOutputData(l).SampledErrors = SampledErrors;
                
                % Calcualte the overlap integral and RMSE timing
                % performance metrics and save these parameters 
                [TimingPerformance, RMSE] = calculateTimingPerformance(ImportantPulses_Is,...
                    ImportantPulses_times,ResidualPulses_Is,ResidualPulses_times,N,T);

                TimingPerformancesFF(l) = TimingPerformance;
                TimingPerformancesRMSE(l) = RMSE;
            end
        end

        % Compute the averaged performance metrics over all Monte Carlo
        % runs, and store the data in the output structure
        FinalResultSet(ctr).TimingPerformances = [TimingPerformancesFF;TimingPerformancesRMSE];
        FinalResultSet(ctr).PowerPerformances = calculatePowerPerformance(AllOutputData,N);
        FinalResultSet(ctr).TimingStatistics = struct('Mean',mean([TimingPerformancesFF;TimingPerformancesRMSE],2),...
            'StdDevation', std([TimingPerformancesFF;TimingPerformancesRMSE],0,2));
        FinalResultSet(ctr).PowerStatistics = struct('Mean',mean(FinalResultSet(ctr).PowerPerformances),...
            'StdDevation', std(FinalResultSet(ctr).PowerPerformances));
        FinalResultSet(ctr).IdealPulse = idealPulseTimes*10^9;
        FinalResultSet(ctr).AllOutputData = AllOutputData;
        FinalResultSet(ctr).IdealTimingPerformance = calculateIdealTimingPerformance(N,T);
        
        ctr = ctr + 1;
        
    end
end



% save('FinalResultSet_1Runs_NoDelayError_N6_Subset.mat','FinalResultSet');




toc