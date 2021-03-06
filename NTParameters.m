clear
clc
close all

parpool(2);


repRate = 13;
riseTime = 8;


T=299:13:2990;
N=6:2:6;

inputs = [];
k = 0;
for n = N
    for t = T
        k = k+1;
        inputs(k).N = n;
        inputs(k).T = t;
    end
end


Params = [];

parfor i = 1:length(inputs)
        display(i);
        n = inputs(i).N;
        t = inputs(i).T;
        [~, delTimes, bestDelays, ~] = delOp(t,n,0);
        Params(i).N = n;
        Params(i).T = t;
        Params(i).delTimes = delTimes;
        %err is given by the function in automate now,which
        %is currently a (1+RMS/WT)*SFE
        [PC2on, PC2off, PC1on, PC1off ,seqFail,err,ffResult]= automate(t,n,delTimes,bestDelays);
        Params(i).PC2on = PC2on;
        Params(i).PC2off = PC2off;
        Params(i).PC1on = PC1on;
        Params(i).PC1off = PC1off;
        if seqFail==0
            Params(i).seqFail = seqFail;
        end
end

