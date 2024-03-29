%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB test bench for the FIR filter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   Copyright 2011-2019 The MathWorks, Inc.
clear wmhdlc;
T = 2;
dt = 0.001;
N = T/dt+1;
sample_time = 0:dt:T;

df = 1/dt;
sample_freq = linspace(-1/2,1/2,N).*df;

% input signal with noise
%x_in = cos(2.*pi.*(sample_time).*(1+(sample_time).*75)).';
x_in = cos(2.*pi.*(sample_time)*1*75);

len = length(x_in);
y_out = zeros(1,len);

w = hann(N,'periodic');

for ii=1:len
    data = x_in(ii);
    % call to the design 'mlhdlc_sfir' that is targeted for hardware
    [y_out(ii)] = wmhdlc(data,w(ii));
end

figure('Name', [mfilename, '_plot']);
subplot(4,1,1);
plot(1:len,x_in,'-b');
xlabel('Time (ms)')
ylabel('Amplitude')
title('Input Signal (with noise)')

subplot(4,1,2);
plot(1:len,w,'-b');
xlabel('Time (ms)')
ylabel('Amplitude')
title('Output window')

subplot(4,1,3); 
plot(1:len,y_out,'-b');
xlabel('Time (ms)')
ylabel('Amplitude')
title('Output Signal (filtered)')

freq_fft = @(x) abs(fftshift(fft(x)));

subplot(4,1,4); semilogy(sample_freq,freq_fft(x_in),'-b');
hold on
semilogy(sample_freq,freq_fft(y_out),'-r')
hold off
xlabel('Frequency (Hz)')
ylabel('Amplitude (dB)')
title('Input and Output Signals (Frequency domain)')
legend({'input', 'output'}, 'Location','South')
axis([-500 500 1 100])

