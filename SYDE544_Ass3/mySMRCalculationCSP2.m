function [ leftSMRCSPFirst, leftSMRCSPLast, rightSMRCSPFirst, rightSMRCSPLast ] = mySMRCalculationCSP2( filterB, filterA, EEG, leftEpochStartTime, rightEpochStartTime, trialTimeIdx, baselineIdx)

% filtering the signal 
eegFiltered = filtfilt(filterB, filterA, EEG.');
% disp(size(eegFiltered))

% extract epochs of left and right hand movements (including all channels)

% left
for epochID=1:length(leftEpochStartTime)
    leftEpoches(:,:,epochID) = eegFiltered(trialTimeIdx+leftEpochStartTime(epochID), :);
end

% right
for epochID=1:length(rightEpochStartTime)
    rightEpoches(:,:,epochID) = eegFiltered(trialTimeIdx+rightEpochStartTime(epochID), :);  
end

% disp(size(leftEpoches))
% disp(size(rightEpoches))
% calculating the covarinace matrix for both classes (note CSP works on the
% raw signal, not the power).
% left class
for epochID=1:length(leftEpochStartTime)
    covL(:,:,epochID) = cov(leftEpoches(:,:,epochID));
end
SigmaL = mean(covL,3);
%SigmaL = cov(mean(leftEpoches, 3));
% right class
for epochID=1:length(leftEpochStartTime)
    covR(:,:,epochID) = (cov(rightEpoches(:,:,epochID)));
end
SigmaR = mean(covR,3);

% solving the generalized eigenvalue problem
% Note here SigmaL is the first input argumen. Here for simplicity, we take 
% the first column of W as the corresponding component for Left hand movement;
% and the last column of W is the corresponding component for right hand movement

[W,~] = eig(SigmaL, SigmaL + SigmaR);
% disp(size(W))

% left class after CSP
for epochID = 1:size(leftEpoches,3)
    leftEpochesCSP(:,:,epochID) = W.'*leftEpoches(:, :, epochID).';
end
% right class after CSP
for epochID = 1:size(rightEpoches,3)
    rightEpochesCSP(:,:,epochID) = W.'*rightEpoches(:, :, epochID).';
end
% disp(size(leftEpochesCSP));
% disp(size(rightEpochesCSP));

% As noted above, we only take the first and the last component for left
% hand and right hand, respectively.
leftEpochesAvePowerCSPFirst = mean(power(leftEpochesCSP(1, :, :), 2), 3);
leftEpochesAvePowerCSPLast = mean(power(leftEpochesCSP(18, :, :), 2), 3);

rightEpochesAvePowerCSPFirst = mean(power(rightEpochesCSP(1, :, :), 2), 3);
rightEpochesAvePowerCSPLast = mean(power(rightEpochesCSP(18, :, :), 2), 3);

% find the power of the baseline range
leftBaselinePowerCSPFirst = mean(leftEpochesAvePowerCSPFirst(:, baselineIdx));
leftBaselinePowerCSPLast = mean(leftEpochesAvePowerCSPLast(:, baselineIdx));

rightBaselinePowerCSPFirst = mean(rightEpochesAvePowerCSPFirst(:, baselineIdx)); 
rightBaselinePowerCSPLast = mean(rightEpochesAvePowerCSPLast(:, baselineIdx));

% calculate the SMR of the trials (substract the baseline power, then
% normalized w.r.t. the baseline power). Express as a percentage.
leftSMRCSPFirst = ((leftEpochesAvePowerCSPFirst-leftBaselinePowerCSPFirst)/leftBaselinePowerCSPFirst)*100;
leftSMRCSPLast = ((leftEpochesAvePowerCSPLast-leftBaselinePowerCSPLast)/leftBaselinePowerCSPLast)*100;

rightSMRCSPFirst = ((rightEpochesAvePowerCSPFirst-rightBaselinePowerCSPFirst)/rightBaselinePowerCSPFirst)*100;
rightSMRCSPLast = ((rightEpochesAvePowerCSPLast-rightBaselinePowerCSPLast)/rightBaselinePowerCSPLast)*100;

end

