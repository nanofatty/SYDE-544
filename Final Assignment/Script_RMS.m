clear all;
close all;
% Load the EMG signal into MATLAB
load('data_iworx.mat');
load('data_arduino.mat');

%Setup Control (iWorx) 
%Extract MVC 1 data
mvc1iWorx_control_time = mvc1iWorx_control_raw.Time;
mvc1iWorx_control_EMG = mvc1iWorx_control_raw.EMG;   

%Extract MVC 1 trial 2 data
mvc1t2iWorx_control_time = mvc1t2iWorx_control_raw.Time;
mvc1t2iWorx_control_EMG = mvc1t2iWorx_control_raw.EMG;

%Extract MVC 2
mvc2iWorx_control_time = mvc2iWorx_control_raw.Time;
mvc2iWorx_control_EMG = mvc2iWorx_control_raw.EMG;

%Extract MVC 3
mvc3iWorx_control_time = mvc3iWorx_control_raw.Time;
mvc3iWorx_control_EMG = mvc3iWorx_control_raw.EMG;

  %Setup Treatment (iWorx) 
%Extract MVC 1 data
mvc1iWorx_treatment_time = mvc1iWorx_treatment_raw.Time;
mvc1iWorx_treatment_EMG = mvc1iWorx_treatment_raw.EMG;   

%Extract MVC 1 trial 2 data
mvc1t2iWorx_treatment_time = mvc1t2iWorx_treatment_raw.Time;
mvc1t2iWorx_treatment_EMG = mvc1t2iWorx_treatment_raw.EMG;

%Extract MVC 2
mvc2iWorx_treatment_time = mvc2iWorx_treatment_raw.Time;
mvc2iWorx_treatment_EMG = mvc2iWorx_treatment_raw.EMG;

%Extract MVC 3
mvc3iWorx_treatment_time = mvc3iWorx_treatment_raw.Time;
mvc3iWorx_treatment_EMG = mvc3iWorx_treatment_raw.EMG;


%Extract MVC 1 data
mvc1arduino_control_time = mvc1arduino_control_raw.PuTTYLog20230314151140;
mvc1arduino_control_EMG = mvc1arduino_control_raw.VarName2;   

%Extract MVC 1 trial 2 data
mvc1t2arduino_control_time = mvc1t2arduino_control_raw.PuTTYLog20230314151343;
mvc1t2arduino_control_EMG = mvc1t2arduino_control_raw.VarName2;

%Extract MVC 2
mvc2arduino_control_time = mvc2arduino_control_raw.PuTTYLog20230314151931;
mvc2arduino_control_EMG = mvc2arduino_control_raw.VarName2;

%Extract MVC 3
mvc3arduino_control_time = mvc3arduino_control_raw.PuTTYLog20230314164311;
mvc3arduino_control_EMG = mvc3arduino_control_raw.VarName2;

%Remove data stored before recording starts
%MVC 1
mvc1arduino_control_time = mvc1arduino_control_time(40:end);
mvc1arduino_control_EMG = mvc1arduino_control_EMG(40:end);

%MVC 1 trial 2
mvc1t2arduino_control_time = mvc1t2arduino_control_time(29:end);
mvc1t2arduino_control_EMG = mvc1t2arduino_control_EMG(29:end);

%MVC 2
mvc2arduino_control_time = mvc2arduino_control_time(15:end);
mvc2arduino_control_EMG = mvc2arduino_control_EMG(15:end);

%MVC 3
mvc3arduino_control_time = mvc3arduino_control_time(27:end);
mvc3arduino_control_EMG = mvc3arduino_control_EMG(27:end);

%Sample period -0.5s to +0.5s of MVC
%MVC 1 
mvc1arduino_control_time_working = mvc1arduino_control_time(3901:16672);
mvc1arduino_control_EMG_working = mvc1arduino_control_EMG(3901:16672);

%MVC 1 trial 2 
mvc1t2arduino_control_time_working = mvc1t2arduino_control_time(747:14184);
mvc1t2arduino_control_EMG_working = mvc1t2arduino_control_EMG(747:14184);

%MVC 2
mvc2arduino_control_time_working = mvc2arduino_control_time(22971:34093);
mvc2arduino_control_EMG_working = mvc2arduino_control_EMG(22971:34093);

%MVC 3 
mvc3arduino_control_time_working = mvc3arduino_control_time(2933:16122);
mvc3arduino_control_EMG_working = mvc3arduino_control_EMG(2933:16122);

%Convert time (ms) to (s), convert voltage (8bit) to V, remove DC offset
%MVC 1
mvc1arduino_control_time_working = mvc1arduino_control_time_working / 1000;
mvc1arduino_control_DCoffset = nanmean(mvc1arduino_control_EMG_working);
mvc1arduino_control_EMG_working = (mvc1arduino_control_EMG_working - mvc1arduino_control_DCoffset) *(5/512);

%MVC 1 trial 2
mvc1t2arduino_control_time_working = mvc1t2arduino_control_time_working / 1000;
mvc1t2arduino_control_DCoffset = nanmean(mvc1t2arduino_control_EMG_working);
mvc1t2arduino_control_EMG_working = (mvc1t2arduino_control_EMG_working - mvc1t2arduino_control_DCoffset) *(5/512);

%MVC 2
mvc2arduino_control_time_working = mvc2arduino_control_time_working / 1000;
mvc2arduino_control_DCoffset = nanmean(mvc2arduino_control_EMG_working);
mvc2arduino_control_EMG_working = (mvc2arduino_control_EMG_working - mvc2arduino_control_DCoffset) *(5/512);

%MVC 3, remove outlier point 
mvc3arduino_control_time_working = mvc3arduino_control_time_working / 1000;
mvc3arduino_control_DCoffset = nanmean(mvc3arduino_control_EMG_working);
mvc3arduino_control_EMG_working = (mvc3arduino_control_EMG_working - mvc3arduino_control_DCoffset) *(5/512);
mvc3arduino_control_time_working(535:540)=[];
mvc3arduino_control_EMG_working(535:540)=[];


    %Setup Treatment (Arduino) 
%Extract MVC 1 data
mvc1arduino_treatment_time = mvc1arduino_treatment_raw.PuTTYLog20230314153421;
mvc1arduino_treatment_EMG = mvc1arduino_treatment_raw.VarName2;   

%Extract MVC 1 trial 2 data
mvc1t2arduino_treatment_time = mvc1t2arduino_treatment_raw.VarName1;
mvc1t2arduino_treatment_EMG = mvc1t2arduino_treatment_raw.PuTTY;

%Extract MVC 2
mvc2arduino_treatment_time = mvc2arduino_treatment_raw.PuTTYLog20230314154106;
mvc2arduino_treatment_EMG = mvc2arduino_treatment_raw.VarName2;

%Extract MVC 3
mvc3arduino_treatment_time = mvc3arduino_treatment_raw.PuTTYLog20230314154536;
mvc3arduino_treatment_EMG = mvc3arduino_treatment_raw.VarName2;

%Remove data stored before recording starts
%MVC 1
mvc1arduino_treatment_time = mvc1arduino_treatment_time(44:end);
mvc1arduino_treatment_EMG =  mvc1arduino_treatment_EMG(44:end);

%MVC 1 trial 2
mvc1t2arduino_treatment_time = mvc1t2arduino_treatment_time(34:end);
mvc1t2arduino_treatment_EMG =  mvc1t2arduino_treatment_EMG(34:end);

%MVC 2
mvc2arduino_treatment_time = mvc2arduino_treatment_time(43:end);
mvc2arduino_treatment_EMG =  mvc2arduino_treatment_EMG(43:end);

%MVC 3
mvc3arduino_treatment_time = mvc3arduino_treatment_time(41:end);
mvc3arduino_treatment_EMG =  mvc3arduino_treatment_EMG(41:end);

%Sample period -0.5s to +0.5s of MVC
%MVC 1 
mvc1arduino_treatment_time_working = mvc1arduino_treatment_time(1257:15693);
mvc1arduino_treatment_EMG_working = mvc1arduino_treatment_EMG(1257:15693);

%MVC 1 trial 2 
mvc1t2arduino_treatment_time_working = mvc1t2arduino_treatment_time(1367:16634);
mvc1t2arduino_treatment_EMG_working = mvc1t2arduino_treatment_EMG(1367:16634);

%MVC 2 
mvc2arduino_treatment_time_working = mvc2arduino_treatment_time(2633:17317);
mvc2arduino_treatment_EMG_working = mvc2arduino_treatment_EMG(2633:17317);

%MVC 3 
mvc3arduino_treatment_time_working = mvc3arduino_treatment_time(1364:16314);
mvc3arduino_treatment_EMG_working = mvc3arduino_treatment_EMG(1364:16314);

%Convert time (ms) to (s), convert voltage (8bit) to V, remove DC offset
%MVC 1
mvc1arduino_treatment_time_working = mvc1arduino_treatment_time_working / 1000;
mvc1arduino_treatment_DCoffset = nanmean(mvc1arduino_treatment_EMG_working);
mvc1arduino_treatment_EMG_working = (mvc1arduino_treatment_EMG_working - mvc1arduino_control_DCoffset) *(5/512);

%MVC 1 trial 2
mvc1t2arduino_treatment_time_working = mvc1t2arduino_treatment_time_working / 1000;
mvc1t2arduino_treatment_DCoffset = nanmean(mvc1t2arduino_treatment_EMG_working);
mvc1t2arduino_treatment_EMG_working = (mvc1t2arduino_treatment_EMG_working - mvc1t2arduino_control_DCoffset) *(5/512);

%MVC 2
mvc2arduino_treatment_time_working = mvc2arduino_treatment_time_working / 1000;
mvc2arduino_treatment_DCoffset = nanmean(mvc2arduino_treatment_EMG_working);
mvc2arduino_treatment_EMG_working = (mvc2arduino_treatment_EMG_working + mvc2arduino_control_DCoffset) *(5/512);

%MVC 3, remove outlier point 
mvc3arduino_treatment_time_working = mvc3arduino_treatment_time_working / 1000;
mvc3arduino_treatment_DCoffset = nanmean(mvc3arduino_treatment_EMG_working);
mvc3arduino_treatment_EMG_working = (mvc3arduino_treatment_EMG_working + mvc3arduino_control_DCoffset) *(5/512);

% Apply a high-pass filter with a cutoff frequency of 20 Hz
fs = 5000; % Sampling rate in Hz
fc = 15; % Cutoff frequency in Hz
[b, a] = butter(4, fc/(fs/2));
emg_filt = filtfilt(b, a, (mvc3iWorx_control_raw.EMG/25));
emg_filt_treat = filtfilt(b,a,(mvc3iWorx_treatment_EMG/25));


% Square the filtered signal to obtain the instantaneous power
emg_squared = emg_filt .^ 2;
emg_squared_treat = emg_filt_treat.^2

% Compute a moving average of the squared signal over a window of 200 samples
window_size = 200;
emg_avg = movmean(emg_squared, window_size);
emg_avg_treat = movmean(emg_squared_treat, window_size);

% Take the square root of the moving average signal to obtain the RMS amplitude
emg_rms = sqrt(emg_avg);
emg_rms_treat = sqrt(emg_avg_treat);

% Paired t-test
[h, p, ci, stats] = ttest(emg_rms(1:72405,1), emg_rms_treat, "Tail","both");

% Display results
format long
fprintf('t = %f\n', stats.tstat);
fprintf('p = %f\n', p + eps);

figure()
%subplot(2,1,1)
plot(mvc3iWorx_control_time,emg_rms);
axis tight
xlabel('Time (s)');
ylabel('RMS Amplitude (mV)');
title('RMS Amplitude of Control vs Treatment Final MVC iWorx'); hold on;

%subplot(2,1,2)
plot(mvc3iWorx_treatment_time,emg_rms_treat);
%xlabel('Time (s)');
%ylabel('RMS Amplitude');
%ylim([0,2500])
%title('EMG Signal RMS Amplitude Treatment'); 
legend('Control', 'Treatment')



% Apply a high-pass filter with a cutoff frequency of 20 Hz
fs = 900; % Sampling rate in Hz
fc = 15; % Cutoff frequency in Hz
[b, a] = butter(4, fc/(fs/2), 'high');
emg_filt = filtfilt(b, a, mvc3arduino_control_EMG_working);
emg_filt_treat = filtfilt(b,a, mvc3arduino_treatment_EMG_working);

% Square the filtered signal to obtain the instantaneous power
emg_squared = emg_filt .^ 2;
emg_squared_treat = emg_filt_treat.^2;

% Compute a moving average of the squared signal over a window of 200 samples
window_size = 200;
emg_avg = movmean(emg_squared, window_size);
emg_avg_treat = movmean(emg_squared_treat, window_size);

% Take the square root of the moving average signal to obtain the RMS amplitude
emg_rms = sqrt(emg_avg);
emg_rms_treat = sqrt(emg_avg_treat);

% Paired t-test
[h, p, ci, stats] = ttest(emg_rms, emg_rms_treat(1:13184), "Tail","both");

% Display results
format long
fprintf('t = %f\n', stats.tstat);
fprintf('p = %f\n', p + eps);

figure()
plot(mvc3arduino_control_time_working,emg_rms);
axis tight
xlabel('Time (s)');
ylabel('RMS Amplitude (mV)');
title('RMS Amplitude of Control vs Treatment Final MVC Arduino'); hold on;


plot(mvc3arduino_treatment_time_working,emg_rms_treat);
%xlabel('Time (s)');
%ylabel('RMS Amplitude');
%ylim([0,2500])
%title('EMG Signal RMS Amplitude Treatment'); 
legend('Control', 'Treatment')