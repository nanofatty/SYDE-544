clear all;
load('data_arduino.mat');
%%
load('data_iworx.mat');
%%
sampleFreq = 1350;
sampleFreqiW = 5000;
cutoffFreq2 = [5 500];
Wn3 = cutoffFreq2/sampleFreq;
Wn4= cutoffFreq2/sampleFreqiW;
[F2,E2] = butter (4,Wn3,'bandpass');
[F3,E3] = butter(4,Wn4,'bandpass');

%%
        %Setup Control (Arduino) 
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
mvc1arduino_control_EMG_working = (mvc1arduino_control_EMG_working + mvc1arduino_control_DCoffset) *(5/512);

%MVC 1 trial 2
mvc1t2arduino_control_time_working = mvc1t2arduino_control_time_working / 1000;
mvc1t2arduino_control_DCoffset = nanmean(mvc1t2arduino_control_EMG_working);
mvc1t2arduino_control_EMG_working = (mvc1t2arduino_control_EMG_working + mvc1t2arduino_control_DCoffset) *(5/512);

%MVC 2
mvc2arduino_control_time_working = mvc2arduino_control_time_working / 1000;
mvc2arduino_control_DCoffset = nanmean(mvc2arduino_control_EMG_working);
mvc2arduino_control_EMG_working = (mvc2arduino_control_EMG_working + mvc2arduino_control_DCoffset) *(5/512);

%MVC 3, remove outlier point 
mvc3arduino_control_time_working = mvc3arduino_control_time_working / 1000;
mvc3arduino_control_DCoffset = nanmean(mvc3arduino_control_EMG_working);
mvc3arduino_control_EMG_working = (mvc3arduino_control_EMG_working + mvc3arduino_control_DCoffset) *(5/512);
mvc3arduino_control_time_working(535:540)=[];
mvc3arduino_control_EMG_working(535:540)=[];



%Plot raw EMG MVC trials
figure(1);
subplot(4,1,1);
plot(mvc1arduino_control_time_working,mvc1arduino_control_EMG_working);
title("Arduino EMG - Control Group - MVC 1");
xlabel('Time (s)');
ylabel('Voltage (V)');
subplot(4,1,2);
plot(mvc1t2arduino_control_time_working,mvc1t2arduino_control_EMG_working);
title("Arduino EMG - Control Group - MVC 1 trial 2");
xlabel('Time (s)');
ylabel('Voltage (V)');
subplot(4,1,3);
plot(mvc2arduino_control_time_working,mvc2arduino_control_EMG_working);
title("Arduino EMG - Control Group - MVC 2");
xlabel('Time (s)');
ylabel('Voltage (V)');
subplot(4,1,4);
plot(mvc3arduino_control_time_working,mvc3arduino_control_EMG_working);
title("Arduino EMG - Control Group - MVC 3");
xlabel('Time (s)');
ylabel('Voltage (V)');
%%
%Full-wave rectification of arduino Data
for i=1:12772
     emgFWR1(i) = abs(mvc1arduino_control_EMG_working(i));
    end  

%Low-pass Butterworth filter
sampleFreq = 1350;
sampleFreqiW = 5000;
cutoffFreq = 5;
Wn = cutoffFreq/sampleFreq;
Wn2= cutoffFreq/sampleFreqiW;
[F,E] = butter (4,Wn,'low');
[F1,E1] = butter(4,Wn2,'low');

    emgFR1(:) = filtfilt(F,E,emgFWR1(:));  

%Full-wave rectify
for i=1:size(mvc1t2arduino_control_EMG_working)
     emgFWR2(i) = abs(mvc1t2arduino_control_EMG_working(i));
    end  

%Low-pass Butterworth filter
emgFR2(:) = filtfilt(F,E,emgFWR2(:))./max(emgFR1);

%Full-wave rectify
for i=1:11123
     emgFWR3(i) = abs(mvc2arduino_control_EMG_working(i));
    end  

%Low-pass Butterworth filter
emgFR3(:) = filtfilt(F,E,emgFWR3(:))./max(emgFR1);

%Full-wave rectify
for i=1:13184
     emgFWR4(i) = abs(mvc3arduino_control_EMG_working(i));
    end  

%Low-pass Butterworth filter
    emgFR4(:) = filtfilt(F,E,emgFWR4(:))./max(emgFR1);
figure(2);
subplot(4,1,1);
plot(mvc1arduino_control_time_working,emgFR1);
title("Arduino EMG - Control Group - Processed - MVC 1");
xlabel('Time (s)');
ylabel('Voltage (V)');
subplot(4,1,2);
plot(mvc1t2arduino_control_time_working,emgFR2);
title("Arduino EMG - Control GroupGroup - Processed - MVC 1 trial 2");
xlabel('Time (s)');
ylabel('%MVC');
subplot(4,1,3);
plot(mvc2arduino_control_time_working,emgFR3);
title("Arduino EMG - Control Group - Processed - MVC 2");
xlabel('Time (s)');
ylabel('%MVC');
subplot(4,1,4);
plot(mvc3arduino_control_time_working,emgFR4);
title("Arduino EMG - Control Group - Processed - MVC 3");
xlabel('Time (s)');
ylabel('%MVC');



    

%%
%Get power spectrum during MVC
%MVC 1
[mvc1arduino_control_POWER,mvc1arduino_control_FREQUENCY]=pspectrum(mvc1arduino_control_EMG_working,sampleFreq);

%MVC 1 trial 2
[mvc1t2arduino_control_POWER,mvc1t2arduino_control_FREQUENCY]=pspectrum(mvc1t2arduino_control_EMG_working,sampleFreq);

%MVC 2
[mvc2arduino_control_POWER,mvc2arduino_control_FREQUENCY]=pspectrum(mvc2arduino_control_EMG_working,sampleFreq);

%MVC 3
[mvc3arduino_control_POWER,mvc3arduino_control_FREQUENCY]=pspectrum(mvc3arduino_control_EMG_working,sampleFreq);

%Plot power spectrums
figure(3);
subplot(2,2,1)
plot(mvc1arduino_control_FREQUENCY,pow2db(mvc1arduino_control_POWER));
title("Arduino EMG - Control Group - MVC 1 Power Spectrum");
xlabel('Frequency (Hz)');
ylabel('Power Density (dB)');

subplot(2,2,2)
plot(mvc1t2arduino_control_FREQUENCY,pow2db(mvc1t2arduino_control_POWER));
title("Arduino EMG - Control Group - MVC 1 trial 2 Power Spectrum");
xlabel('Frequency (Hz)');
ylabel('Power Density (dB)');

subplot(2,2,3)
plot(mvc2arduino_control_FREQUENCY,pow2db(mvc2arduino_control_POWER));
title("Arduino EMG - Control Group - MVC 2 Power Spectrum");
xlabel('Frequency (Hz)');
ylabel('Power Density (dB)');

subplot(2,2,4)
plot(mvc3arduino_control_FREQUENCY,pow2db(mvc3arduino_control_POWER));
title("Arduino EMG - Control Group - MVC 3 Power Spectrum");
xlabel('Frequency (Hz)');
ylabel('Power Density (dB)');







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
mvc1arduino_treatment_EMG_working = (mvc1arduino_treatment_EMG_working + mvc1arduino_control_DCoffset) *(5/512);

%MVC 1 trial 2
mvc1t2arduino_treatment_time_working = mvc1t2arduino_treatment_time_working / 1000;
mvc1t2arduino_treatment_DCoffset = nanmean(mvc1t2arduino_treatment_EMG_working);
mvc1t2arduino_treatment_EMG_working = (mvc1t2arduino_treatment_EMG_working + mvc1t2arduino_control_DCoffset) *(5/512);

%MVC 2
mvc2arduino_treatment_time_working = mvc2arduino_treatment_time_working / 1000;
mvc2arduino_treatment_DCoffset = nanmean(mvc2arduino_treatment_EMG_working);
mvc2arduino_treatment_EMG_working = (mvc2arduino_treatment_EMG_working - mvc2arduino_control_DCoffset) *(5/512);

%MVC 3, remove outlier point 
mvc3arduino_treatment_time_working = mvc3arduino_treatment_time_working / 1000;
mvc3arduino_treatment_DCoffset = nanmean(mvc3arduino_treatment_EMG_working);
mvc3arduino_treatment_EMG_working = (mvc3arduino_treatment_EMG_working - mvc3arduino_control_DCoffset) *(5/512);

%Plot raw EMG MVC trials
figure(4);
subplot(4,1,1);
plot(mvc1arduino_treatment_time_working,mvc1arduino_treatment_EMG_working);
title("Arduino EMG - Treatment Group - MVC 1");
xlabel('Time (s)');
ylabel('Voltage (V)');
subplot(4,1,2);
plot(mvc1t2arduino_treatment_time_working,mvc1t2arduino_treatment_EMG_working);
title("Arduino EMG - Treatment Group - MVC 1 trial 2");
xlabel('Time (s)');
ylabel('Voltage (V)');
subplot(4,1,3);
plot(mvc2arduino_treatment_time_working,mvc2arduino_treatment_EMG_working);
title("Arduino EMG - Treatment Group - MVC 2");
xlabel('Time (s)');
ylabel('Voltage (V)');
subplot(4,1,4);
plot(mvc3arduino_treatment_time_working,mvc3arduino_treatment_EMG_working);
title("Arduino EMG - Treatment Group - MVC 3");
xlabel('Time (s)');
ylabel('Voltage (V)');
%%
%Full-wave rectify mvc1Arduino
for i=1:14437
     emgFWR5(i) = abs(mvc1arduino_treatment_EMG_working(i));
end  
%Low-pass Butterworth filter
    emgFR5(:) = filtfilt(F,E,emgFWR5(:));  

%Full-wave rectify
for i=1:15268
     emgFWR6(i) = abs(mvc1t2arduino_treatment_EMG_working(i));
    end  

%Low-pass Butterworth filter
    emgFR6(:) = filtfilt(F,E,emgFWR6(:))./max(emgFR5);

%Full-wave rectify
for i=1:14685
     emgFWR7(i) = abs(mvc2arduino_treatment_EMG_working(i));
    end  

%Low-pass Butterworth filter
    emgFR7(:) = filtfilt(F,E,emgFWR7(:))./max(emgFR5);

%Full-wave rectify
for i=1:14951
     emgFWR8(i) = abs(mvc3arduino_treatment_EMG_working(i));
    end  

%Low-pass Butterworth filter
    emgFR8(:) = filtfilt(F,E,emgFWR8(:))./max(emgFR5);


figure(5);
subplot(4,1,1);
plot(mvc1arduino_treatment_time_working,emgFR5);
title("Arduino EMG - Treatment Group - Processed - MVC 1");
xlabel('Time (s)');
ylabel('Voltage (V)');

subplot(4,1,2);
plot(mvc1t2arduino_treatment_time_working,emgFR6);
title("Arduino EMG - Treatment Group - Processed - MVC 1 trial 2");
xlabel('Time (s)');
ylabel('%MVC');

subplot(4,1,3);
plot(mvc2arduino_treatment_time_working,emgFR7);
title("Arduino EMG - Treatment Group - Processed - MVC 2");
xlabel('Time (s)');
ylabel('%MVC');

subplot(4,1,4);
plot(mvc3arduino_treatment_time_working,emgFR8);
title("Arduino EMG - Treatment Group - Processed - MVC 3");
xlabel('Time (s)');
ylabel('%MVC');





%%
%Get power spectrum during MVC
%MVC 1
[mvc1arduino_treatment_POWER,mvc1arduino_treatment_FREQUENCY]=pspectrum(mvc1arduino_treatment_EMG_working,sampleFreq);

%MVC 1 trial 2
[mvc1t2arduino_treatment_POWER,mvc1t2arduino_treatment_FREQUENCY]=pspectrum(mvc1t2arduino_treatment_EMG_working,sampleFreq);

%MVC 2
[mvc2arduino_treatment_POWER,mvc2arduino_treatment_FREQUENCY]=pspectrum(mvc2arduino_treatment_EMG_working,sampleFreq);

%MVC 3
[mvc3arduino_treatment_POWER,mvc3arduino_treatment_FREQUENCY]=pspectrum(mvc3arduino_treatment_EMG_working,sampleFreq);

%Plot power spectrums
figure(6);
subplot(2,2,1)
plot(mvc1arduino_treatment_FREQUENCY,pow2db(mvc1arduino_treatment_POWER));
title("Arduino EMG - Treatment Group - MVC 1 Power Spectrum");
xlabel('Frequency (Hz)');
ylabel('Power Density (dB)');


subplot(2,2,2)
plot(mvc1t2arduino_treatment_FREQUENCY,pow2db(mvc1t2arduino_treatment_POWER));
title("Arduino EMG - Treatment Group - MVC 1 trial 2 Power Spectrum");
xlabel('Frequency (Hz)');
ylabel('Power Density (dB)');


subplot(2,2,3)
plot(mvc2arduino_treatment_FREQUENCY,pow2db(mvc2arduino_treatment_POWER));
title("Arduino EMG - Treatment Group - MVC 2 Power Spectrum");
xlabel('Frequency (Hz)');
ylabel('Power Density (dB)');


subplot(2,2,4)
plot(mvc3arduino_treatment_FREQUENCY,pow2db(mvc3arduino_treatment_POWER));
title("Arduino EMG - Treatment Group - MVC 3 Power Spectrum");
xlabel('Frequency (Hz)');
ylabel('Power Density (dB)');
%%

%%
    %Setup Control (iWorx) 
%Extract MVC 1 data
mvc1iWorx_control_time = mvc1iWorx_control_raw.Time;
mvc1iWorx_control_EMG = mvc1iWorx_control_raw.EMG./25;
mvc1iWorx_control_ECG = mvc1iWorx_control_raw.ECG;

%Extract MVC 1 trial 2 data
mvc1t2iWorx_control_time = mvc1t2iWorx_control_raw.Time;
mvc1t2iWorx_control_EMG = mvc1t2iWorx_control_raw.EMG./25;
mvc1t2iWorx_control_ECG = mvc1t2iWorx_control_raw.ECG;

%Extract MVC 2
mvc2iWorx_control_time = mvc2iWorx_control_raw.Time;
mvc2iWorx_control_EMG = mvc2iWorx_control_raw.EMG./25;
mvc2iWorx_control_ECG = mvc2iWorx_control_raw.ECG;

%Extract MVC 3
mvc3iWorx_control_time = mvc3iWorx_control_raw.Time;
mvc3iWorx_control_EMG = mvc3iWorx_control_raw.EMG./25;
mvc3iWorx_control_ECG = mvc3iWorx_control_raw.ECG;

%Plot raw EMG MVC trials
figure(7);
subplot(4,1,1);
plot(mvc1iWorx_control_time,mvc1iWorx_control_EMG);
title("iWorx EMG - Control Group - MVC 1");
xlabel('Time (s)');
ylabel('Voltage (V)');
subplot(4,1,2);
plot(mvc1t2iWorx_control_time,mvc1t2iWorx_control_EMG);
title("iWorx EMG - Control Group - MVC 1 trial 2");
xlabel('Time (s)');
ylabel('Voltage (V)');
subplot(4,1,3);
plot(mvc2iWorx_control_time,mvc2iWorx_control_EMG);
title("iWorx EMG - Control Group - MVC 2");
xlabel('Time (s)');
ylabel('Voltage (V)');
subplot(4,1,4);
plot(mvc3iWorx_control_time,mvc3iWorx_control_EMG);
title("iWorx EMG - Control Group - MVC 3");
xlabel('Time (s)');
ylabel('Voltage (V)');
%%
%Full-wave rectify
for i=1:74282
     emgFWR9(i) = abs(mvc1iWorx_control_EMG(i));
    end  

%Low-pass Butterworth filter
    emgFR9(:) = filtfilt(F1,E1,emgFWR9(:));

%Full-wave rectify
for i=1:76885
     emgFWR10(i) = abs(mvc1t2iWorx_control_EMG(i));
    end  

%Low-pass Butterworth filter
    emgFR10(:) = filtfilt(F1,E1,emgFWR10(:))./max(emgFR9);

%Full-wave rectify
for i=1:83072
     emgFWR11(i) = abs(mvc2iWorx_control_EMG(i));
    end  

%Low-pass Butterworth filter
    emgFR11(:) = filtfilt(F1,E1,emgFWR11(:))./max(emgFR9);

%Full-wave rectify
for i=1:75946
     emgFWR12(i) = abs(mvc3iWorx_control_EMG(i));
    end  

%Low-pass Butterworth filter
    emgFR12(:) = filtfilt(F1,E1,emgFWR12(:))./max(emgFR9);

figure(8);
subplot(4,1,1);
plot(mvc1iWorx_control_time,emgFR9);
title("iWorx EMG - Control Group - Processed - MVC 1");
xlabel('Time (s)');
ylabel('Voltage (V)');
subplot(4,1,2);
plot(mvc1t2iWorx_control_time,emgFR10);
title("iWorx EMG - Control Group - Processed - MVC 1 trial 2");
xlabel('Time (s)');
ylabel('%MVC');
subplot(4,1,3);
plot(mvc2iWorx_control_time,emgFR11);
title("iWorx EMG - Control Group - Processed - MVC 2");
xlabel('Time (s)');
ylabel('%MVC');
subplot(4,1,4);
plot(mvc3iWorx_control_time,emgFR12);
title("iWorx EMG - Control Group - Processed - MVC 3");
xlabel('Time (s)');
ylabel('%MVC');

%%
%Get power spectrum during MVC
%MVC 1
[mvc1iWorx_control_POWER,mvc1iWorx_control_FREQUENCY]=pspectrum(mvc1iWorx_control_EMG,5000);

%MVC 1 trial 2
[mvc1t2iWorx_control_POWER,mvc1t2iWorx_control_FREQUENCY]=pspectrum(mvc1t2iWorx_control_EMG,5000);

%MVC 2
[mvc2iWorx_control_POWER,mvc2iWorx_control_FREQUENCY]=pspectrum(mvc2iWorx_control_EMG,5000);

%MVC 3
[mvc3iWorx_control_POWER,mvc3iWorx_control_FREQUENCY]=pspectrum(mvc3iWorx_control_EMG,5000);

%Plot power spectrums
figure(9);
subplot(2,2,1)
plot(mvc1iWorx_control_FREQUENCY,(mvc1iWorx_control_POWER));
title("iWorx EMG - Control Group - MVC 1 Power Spectrum");
xlabel('Frequency (Hz)');
ylabel('Power Density (dB)');

subplot(2,2,2)
plot(mvc1t2iWorx_control_FREQUENCY,(mvc1t2iWorx_control_POWER));
title("iWorx EMG - Control Group - MVC 1 trial 2 Power Spectrum");
xlabel('Frequency (Hz)');
ylabel('Power Density (dB)');

subplot(2,2,3)
plot(mvc2iWorx_control_FREQUENCY,(mvc2iWorx_control_POWER));
title("iWorx EMG - Control Group - MVC 2 Power Spectrum");
xlabel('Frequency (Hz)');
ylabel('Power Density (dB)');

subplot(2,2,4)
plot(mvc3iWorx_control_FREQUENCY,(mvc3iWorx_control_POWER));
title("iWorx EMG - Control Group - MVC 3 Power Spectrum");
xlabel('Frequency (Hz)');
ylabel('Power Density (dB)');






    %Setup Treatment (iWorx) 
%Extract MVC 1 data
mvc1iWorx_treatment_time = mvc1iWorx_treatment_raw.Time;
mvc1iWorx_treatment_EMG = mvc1iWorx_treatment_raw.EMG/25;
mvc1iWorx_treatment_ECG = mvc1iWorx_treatment_raw.ECG;

%Extract MVC 1 trial 2 data
mvc1t2iWorx_treatment_time = mvc1t2iWorx_treatment_raw.Time;
mvc1t2iWorx_treatment_EMG = mvc1t2iWorx_treatment_raw.EMG/25;
mvc1t2iWorx_treatment_ECG = mvc1t2iWorx_treatment_raw.ECG;

%Extract MVC 2
mvc2iWorx_treatment_time = mvc2iWorx_treatment_raw.Time;
mvc2iWorx_treatment_EMG = mvc2iWorx_treatment_raw.EMG/25;
mvc2iWorx_treatment_ECG = mvc2iWorx_treatment_raw.ECG;

%Extract MVC 3
mvc3iWorx_treatment_time = mvc3iWorx_treatment_raw.Time;
mvc3iWorx_treatment_EMG = mvc3iWorx_treatment_raw.EMG/25;
mvc3iWorx_treatment_ECG = mvc3iWorx_treatment_raw.ECG;

%Plot raw EMG MVC trials
figure(10);
subplot(4,1,1);
plot(mvc1iWorx_treatment_time,mvc1iWorx_treatment_EMG);
title("iWorx EMG - Treatment Group - MVC 1");
xlabel('Time (s)');
ylabel('Voltage (V)');

subplot(4,1,2);
plot(mvc1t2iWorx_treatment_time,mvc1t2iWorx_treatment_EMG);
title("iWorx EMG - Treatment Group - MVC 1 trial 2");
xlabel('Time (s)');
ylabel('Voltage (V)');

subplot(4,1,3);
plot(mvc2iWorx_treatment_time,mvc2iWorx_treatment_EMG);
title("iWorx EMG - Treatment Group - MVC 2");
xlabel('Time (s)');
ylabel('Voltage (V)');
subplot(4,1,4);

plot(mvc3iWorx_treatment_time,mvc3iWorx_treatment_EMG);
title("iWorx EMG - Treatment Group - MVC 3");
xlabel('Time (s)');
ylabel('Voltage (V)');
%%
%Full-wave rectify
for i=1:76458
     emgFWR13(i) = abs(mvc1iWorx_treatment_EMG(i));
    end  

%Low-pass Butterworth filter
    emgFR13(:) = filtfilt(F1,E1,emgFWR13(:));

%Full-wave rectify
for i=1:79616
     emgFWR14(i) = abs(mvc1t2iWorx_treatment_EMG(i));
    end  

%Low-pass Butterworth filter
    emgFR14(:) = filtfilt(F1,E1,emgFWR14(:))./max(emgFR13);

%Full-wave rectify
for i=1:72746
     emgFWR15(i) = abs(mvc2iWorx_treatment_EMG(i));
    end  

%Low-pass Butterworth filter
    emgFR15(:) = filtfilt(F1,E1,emgFWR15(:))./max(emgFR13);

%Full-wave rectify
for i=1:72405
     emgFWR16(i) = abs(mvc3iWorx_treatment_EMG(i));
    end  

%Low-pass Butterworth filter
    emgFR16(:) = filtfilt(F1,E1,emgFWR16(:))./max(emgFR13);

%Plot Fullwave Rectified and Filtered 
figure(11);
subplot(4,1,1);
plot(mvc1iWorx_treatment_time,emgFR13);
title("iWorx EMG - Treatment Group - Processed - MVC 1");
xlabel('Time (s)');
ylabel('Voltage (V)');
subplot(4,1,2);
plot(mvc1t2iWorx_treatment_time,emgFR14);
title("iWorx EMG - Treatment Group - Processed - MVC 1 trial 2");
xlabel('Time (s)');
ylabel('%MVC');
subplot(4,1,3);
plot(mvc2iWorx_treatment_time,emgFR15);
title("iWorx EMG - Treatment Group - Processed - MVC 2");
xlabel('Time (s)');
ylabel('%MVC');
subplot(4,1,4);
plot(mvc3iWorx_treatment_time,emgFR16);
title("iWorx EMG - Treatment Group - Processed - MVC 3");
xlabel('Time (s)');
ylabel('%MVC');

%%
%Get power spectrum during MVC
%MVC 1
[mvc1iWorx_treatment_POWER,mvc1iWorx_treatment_FREQUENCY]=pspectrum(mvc1iWorx_treatment_EMG, 5000);

%MVC 1 trial 2
[mvc1t2iWorx_treatment_POWER,mvc1t2iWorx_treatment_FREQUENCY]=pspectrum(mvc1t2iWorx_treatment_EMG,5000);

%MVC 2
[mvc2iWorx_treatment_POWER,mvc2iWorx_treatment_FREQUENCY]=pspectrum(mvc2iWorx_treatment_EMG,5000);

%MVC 3
[mvc3iWorx_treatment_POWER,mvc3iWorx_treatment_FREQUENCY]=pspectrum(mvc3iWorx_treatment_EMG,5000);

%Plot power spectrums
figure(12);
subplot(2,2,1)
plot(mvc1iWorx_control_FREQUENCY,(mvc1iWorx_control_POWER));
hold on
plot(mvc1iWorx_treatment_FREQUENCY,(mvc1iWorx_treatment_POWER));
title("iWorx EMG - Treatment Group - MVC 1 Power Spectrum");
xlabel('Frequency (Hz)');
ylabel('Power Density');
legend(["Control","Treatment"]);
xlim([0,500])
subplot(2,2,2)
plot(mvc1t2iWorx_control_FREQUENCY,(mvc1t2iWorx_control_POWER));
hold on
plot(mvc1t2iWorx_treatment_FREQUENCY,(mvc1t2iWorx_treatment_POWER));
title("iWorx EMG - Treatment Group - MVC 1 trial 2 Power Spectrum");
xlabel('Frequency (Hz)');
ylabel('Power Density');
legend(["Control","Treatment"]);
xlim([0,500])
subplot(2,2,3)
plot(mvc2iWorx_control_FREQUENCY,(mvc2iWorx_control_POWER));
hold on
plot(mvc2iWorx_treatment_FREQUENCY,(mvc2iWorx_treatment_POWER));
title("iWorx EMG - Treatment Group - MVC 2 Power Spectrum");
xlabel('Frequency (Hz)');
ylabel('Power Density');
legend(["Control","Treatment"]);
xlim([0,500])
subplot(2,2,4)
plot(mvc3iWorx_control_FREQUENCY,(mvc3iWorx_control_POWER));
hold on
plot(mvc3iWorx_treatment_FREQUENCY,(mvc3iWorx_treatment_POWER));
title("iWorx EMG - Treatment Group - MVC 3 Power Spectrum");
xlabel('Frequency (Hz)');
ylabel('Power Density');
legend(["Control","Treatment"]);
xlim([0,500])
%%




%Plot power spectrums
figure(13);
plot(mvc1iWorx_treatment_FREQUENCY,(mvc1iWorx_treatment_POWER));
hold on
plot(mvc1t2iWorx_treatment_FREQUENCY,(mvc1t2iWorx_treatment_POWER));
hold on
plot(mvc2iWorx_treatment_FREQUENCY,(mvc2iWorx_treatment_POWER));
hold on
plot(mvc3iWorx_treatment_FREQUENCY,(mvc3iWorx_treatment_POWER));
title("iWorx EMG - Treatment Group - MVC 3 Power Spectrum");
xlabel('Frequency (Hz)');
ylabel('Power Density (dB)');
legend(["mvc1" "mvc1t2" "mvc2" "mvc3"])

%%

% Perform the Mann-Whitney U test using ranksum
[p_value, h, stats] = ranksum(mvc1iWorx_treatment_POWER, mvc3iWorx_treatment_POWER);

% Display the results
if h == 1
    fprintf('There is a significant difference between the two groups (p = %f)\n', p_value);
else
    fprintf('There is no significant difference between the two groups (p = %f)\n', p_value);
end
figure(14)
plot(mvc1arduino_control_FREQUENCY,pow2db(mvc1arduino_control_POWER));
hold on
plot(mvc1t2arduino_control_FREQUENCY,pow2db(mvc1t2arduino_control_POWER));
hold on
plot(mvc2arduino_control_FREQUENCY,pow2db(mvc2arduino_control_POWER));
hold on
plot(mvc3arduino_control_FREQUENCY,pow2db(mvc3arduino_control_POWER));
title("Arduino EMG - Control Group - MVC 3 Power Spectrum");
xlabel('Frequency (Hz)');
ylabel('Power Density (dB)');
legend(["mvc1" "mvc1t2" "mvc2" "mvc3"])


fs=sampleFreq;
epoch_len = fs; % Epoch length in samples
num_epochs = floor(length(emgFR1) / epoch_len);
data_epochs = reshape(emgFR1(1:num_epochs*epoch_len), epoch_len, num_epochs);

% Calculate power spectrum for each epoch
power_epochs = zeros(epoch_len/2+1, num_epochs);
for i = 1:num_epochs
    fft_data = fft(data_epochs(:,i));
    power_epochs(:,i) = abs(fft_data(1:epoch_len/2+1)).^2;
end

% Average power spectra across all epochs
power_avg = mean(power_epochs, 2);
% Plot power spectrum
freq = linspace(0, fs/2, epoch_len/2+1);
figure(15)
plot(freq, power_avg);
xlim([0,500])
xlabel('Frequency (Hz)');
ylabel('Power');
title('EMG Power Spectrum');
%****************************************************************************%
%%
% Store the data in a cell array
data = {mvc1arduino_control_POWER,mvc1t2arduino_control_POWER, mvc2arduino_control_POWER, mvc3arduino_control_POWER,mvc1arduino_treatment_POWER,mvc1t2arduino_treatment_POWER,mvc2arduino_treatment_POWER,mvc3arduino_treatment_POWER};
data2 = {mvc1iWorx_control_POWER,mvc1t2iWorx_control_POWER,mvc2iWorx_control_POWER,mvc3iWorx_control_POWER,mvc1iWorx_treatment_POWER,mvc1t2iWorx_treatment_POWER,mvc2iWorx_treatment_POWER,mvc3iWorx_treatment_POWER};
% Initialize a table to store the results
result_table = table();

% Loop over all pairs of samples
for i = 1:length(data)
    for j = i:length(data)
        % Perform the Mann-Whitney U test for each pair
        [p_value, h, stats] = ranksum(data{i}, data{j});
        
        % Calculate the median power frequency difference between the two samples
        median_diff = medfreq(data{i},sampleFreq) - medfreq(data{j},sampleFreq);
        
        % Add the results to the table
        result_table = [result_table; table(i, j, median_diff, p_value, h)];
    end
end
% Initialize a table to store the results
result_table2 = table();

% Loop over all pairs of samples
for i = 1:length(data2)
    for j = i:length(data2)
        % Perform the Mann-Whitney U test for each pair
        [p_value1, h1, stats] = ranksum(data2{i}, data2{j});
        
        % Calculate the median power frequency difference between the two samples
        median_diff = medfreq(data2{i},sampleFreqiW) - medfreq(data2{j},sampleFreqiW);
        
        % Add the results to the table
        result_table2 = [result_table2; table(i, j, median_diff, p_value1, h1)];
    end
end

% Rename the table columns
result_table.Properties.VariableNames = {'Sample1', 'Sample2', 'MedianPowerFrequencyDiff', 'PValue', 'Significance'};
result_table2.Properties.VariableNames = {'Sample1', 'Sample2', 'MedianPowerFrequencyDiff', 'PValue', 'Significance'};
% Display the table
disp(result_table);
writetable(result_table, 'result_table.csv');
disp(result_table2);
writetable(result_table2, 'result_table2.csv');


%%
% Load the data from the tabular file
data = readtable('result_table.csv');

% Create a matrix of significance values
n = max(data{:,1:2});
N = zeros(n);
for i = 1:size(data,1)
    if data.Significance(i) == 1
        N(data.Sample1(i), data.Sample2(i)) = 1;
    else
        N(data.Sample1(i), data.Sample2(i)) = 0;
    end
end

% Plot the heatmap
figure(16);
imagesc(N);
colormap([1 1 1; 0 0 1; 1 0 0]);
colorbar;
title('Mann-Whitney U Test Results');
xlabel('Sample 2');
ylabel('Sample 1');
%%
% Load the data from the tabular file
data = readtable('result_table2.csv');

% Create a matrix of significance values
n1 = max(data{:,1:2});
M = zeros(n1);
for i = 1:size(data,1)
    if data.Significance(i) == 1
        M(data.Sample1(i), data.Sample2(i)) = 1;
    else
        M(data.Sample1(i), data.Sample2(i)) = 0;
    end
end

% Plot the heatmap
figure(17);
imagesc(M);
colormap([1 1 1; 0 0 1; 1 0 0]);
colorbar;
title('Mann-Whitney U Test Results');
xlabel('Sample 2');
ylabel('Sample 1');
%%
data = {mvc1arduino_control_POWER,mvc1t2arduino_control_POWER, mvc2arduino_control_POWER, mvc3arduino_control_POWER,mvc1arduino_treatment_POWER,mvc1t2arduino_treatment_POWER,mvc2arduino_treatment_POWER,mvc3arduino_treatment_POWER};
data2 = {mvc1iWorx_control_POWER,mvc1t2iWorx_control_POWER,mvc2iWorx_control_POWER,mvc3iWorx_control_POWER,mvc1iWorx_treatment_POWER,mvc1t2iWorx_treatment_POWER,mvc2iWorx_treatment_POWER,mvc3iWorx_treatment_POWER};

% Initialize tables for mean and median power frequencies
mean_freq_table = table();
median_freq_table = table();

% Loop through each data set
for i = 1:length(data)
    % Calculate mean power frequency
    mean_freq = meanfreq(data{i}, sampleFreq, [0 500]);
    mean_freq_table = [mean_freq_table; table(mean_freq)];
    
    % Calculate median power frequency
    median_freq = medfreq(data{i}, sampleFreq, [0 500]);
    median_freq_table = [median_freq_table; table(median_freq)];
end

for i = 1:length(data2)
    % Calculate mean power frequency
    mean_freq = meanfreq(data2{i}, 3.15*sampleFreqiW, [0 1000]);
    mean_freq_table = [mean_freq_table; table(mean_freq)];
    
    % Calculate median power frequency
    median_freq = medfreq(data2{i}, 4.5*sampleFreqiW, [0 1000]);
    median_freq_table = [median_freq_table; table(median_freq)];
end

% Add row names
mean_freq_table.Properties.RowNames = cellstr(strcat('data', num2str((1:length(data)+length(data2))')));
median_freq_table.Properties.RowNames = cellstr(strcat('data', num2str((1:length(data)+length(data2))')));

% Write tables to csv files
writetable(mean_freq_table, 'mean_freq_table.csv');
writetable(median_freq_table, 'median_freq_table.csv');
%%
MVCs_arduino_control = {emgFR1,emgFR2, emgFR3, emgFR4};
MVCs_arduino_treatment = {emgFR5,emgFR6, emgFR7, emgFR8};
MVCs_iWorx_control = {emgFR9,emgFR10, emgFR11, emgFR12};
MVCs_iWorx_treatment = {emgFR13,emgFR14, emgFR15, emgFR16};

mean_emg_table = table();

for i = 1:length(MVCs_arduino_control)
    % Calculate mean and peak
    mean_emg_arduino_control = mean(MVCs_arduino_control{i});
    mean_emg_arduino_treatment = mean(MVCs_arduino_treatment{i});
    mean_emg_iWorx_control = mean(MVCs_iWorx_control{i});
    mean_emg_iWorx_treatment = mean(MVCs_iWorx_treatment{i});
    peak_emg = max(MVCs_arduino_control{i});
    peak_emg_arduino_treatment = max(MVCs_arduino_treatment{i});
    peak_emg_iWorx_control = max(MVCs_iWorx_control{i});
    peak_emg_iWorx_treatment = max(MVCs_iWorx_treatment{i});
    mean_emg_table = [mean_emg_table; table(mean_emg_arduino_control,peak_emg,mean_emg_arduino_treatment,peak_emg_arduino_treatment,mean_emg_iWorx_control,peak_emg_iWorx_control,mean_emg_iWorx_treatment,peak_emg_iWorx_treatment)];
end
mean_emg_table.Properties.VariableNames = {'Mean AC EMG','Peak AC EMG','Mean AT EMG','Peak AT EMG','Mean iC EMG','Peak iC EMG','Mean iT EMG','Peak iT EMG'};
writetable(mean_emg_table, 'mean_emg_table.csv');
