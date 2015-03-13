function [ errs, errs2] = errorPlots( placeholder )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
repRate = 13;
riseTime = 8;


T=3004:104:3004;
N=2:2:4;

errs = zeros(length(N),length(T));
errs2 = zeros(length(N),1);
i=0;
j=0;
for n=N
    i=i+1;
    j=0;
    for t=T
        j=j+1;
        [~, delTimes, bestDelays, ~] = delOp(t,n,0);
        %err is given by the function in automate now,which
        %is currently a (1+RMS/WT)*SFE
        [~, ~, ~, ~,seqFail,err,ffResult]= automate(t,n,delTimes,bestDelays);
        if seqFail==0
            errs(i,j)=log10(ffResult);
        end
        %if seqFail==1
        %    break
        %end
    end
    errs2(i) = sum(errs(i,:))/nnz(errs(i,:));
end


end

