function [ C3LeftSMR, C4LeftSMR, C3RightSMR, C4RightSMR ] = ...
    mySMRCalculation( filterB, filterA, C3, C4, leftEpochStartTime, rightEpochStartTime, trialTimeIdx, baselineIdx)


% filtering the signal 
C3Filtered = filtfilt(filterB,filterA, C3);
C4Filtered = filtfilt(filterB,filterA, C4);

% extract epochs of left and right hand movements
% power of the left epoches (how to get the power?)
% 
for epochID=1:length(leftEpochStartTime)
    
    C3LeftEpoches(epochID,:) = C3Filtered(leftEpochStartTime(epochID)+trialTimeIdx);
    C4LeftEpoches(epochID,:) = C4Filtered(leftEpochStartTime(epochID)+trialTimeIdx);
end
% power of the right epoches
for epochID=1:length(rightEpochStartTime)
    
    C3RightEpoches(epochID,:) = C3Filtered(rightEpochStartTime(epochID)+trialTimeIdx);
    C4RightEpoches(epochID,:) = C4Filtered(rightEpochStartTime(epochID)+trialTimeIdx);
end


% get the ave. power of all trials
C3LeftEpochesAvePower = mean(C3LeftEpoches.^2);
C4LeftEpochesAvePower = mean(C4LeftEpoches.^2);

C3RightEpochesAvePower = mean(C3RightEpoches.^2);
C4RightEpochesAvePower = mean(C4RightEpoches.^2);

% find the power of the baseline range
C3LeftBaselinePower =  mean(C3Filtered(leftEpochStartTime(epochID)+baselineIdx).^2);
C4LeftBaselinePower =  mean(C4Filtered(leftEpochStartTime(epochID)+baselineIdx).^2);

C3RightBaselinePower = mean(C3Filtered(rightEpochStartTime(epochID)+baselineIdx).^2) ;
C4RightBaselinePower = mean(C3Filtered(rightEpochStartTime(epochID)+baselineIdx).^2) ;

% calculate the SMR of the trials (substract the baseline, then normalized
% w.r.t. the baseline. Express as a percentage
C3LeftSMR = ((C3LeftEpochesAvePower-C3LeftBaselinePower)/C3LeftBaselinePower) * 100;
C4LeftSMR = ((C4LeftEpochesAvePower-C4LeftBaselinePower)/C4LeftBaselinePower) * 100;

C3RightSMR = ((C3RightEpochesAvePower-C3RightBaselinePower)/C3RightBaselinePower) * 100;
C4RightSMR = ((C4RightEpochesAvePower-C4RightBaselinePower)/C4RightBaselinePower) * 100;

end

