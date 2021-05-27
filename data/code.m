clc;
clear all;
load('cu01m.mat')
%The recording were digitized at 360 seconds per second with 11 bits
%resolution over mV range.
length(Orig_Sig) = 3600;
D = 1:3600;
t = D./360;
Fs = 360;
%plot noisy signal 
figure
subplot(211), plot(t,Orig_Sig);
title('Original ECG Signal')
%lowpass Butterworth filter
fNorm = 25 / (Fs/2);
[b,a] = butter(10, fNorm, 'low');
y =filtfilt(b, a, Orig_Sig);
subplot(212), plot(t,y);
title('Filtered ECG Signal')
[R1,TR1] = findpeaks(y,t,'MinPeakHeight',1000);
[Q1,TQS1] = findpeaks(-y,t,'MinPeakHeight',-850,'MinPeakDistance',0.5);
figure
plot(t,y)
hold on
plot(TR1,R1,'^r')
plot(TQS1(1:2:end), -Q1(1:2:end), 'vg')
plot(TQS1(2:2:end), -Q1(2:2:end), 'vb')
hold off