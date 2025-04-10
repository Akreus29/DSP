% LORA modulation(Frequency Shift Chirp Modulation (FSCM)).

SF = 7;
B = 125e3;
T = 1 / B;
Ts = 2^SF * T;
% binary vector w of length SF
w = randi([0, 1], 1, SF);
s_nTs = sum(w .* 2.^(0:SF-1)); %number in the range [0, 2^SF - 1]
fprintf('Spreading Factor (SF): %d\n', SF);
fprintf('Binary Vector (w): ');
disp(w);
fprintf('Generated Symbol (s_nTs): %d\n', s_nTs);
k = 0:(2^SF - 1); % Time index K (0 to 2^SF-1)
chirp_waveform = (1/sqrt(2^SF)) * exp(1j * 2 * pi * ((s_nTs + k) .* k) / (2^SF));
% Plot the real part of the chirp waveform to visualize
figure;
plot(k * T, real(chirp_waveform));
xlabel('Time (s)');
ylabel('Amplitude');
title('Real Part of the Chirp Waveform for the Generated Symbol');
grid on;
numSymbols = 10;
symbols = randi([0, 2^SF - 1], 1, numSymbols);
disp(symbols);
modulated_signal = [];
k = 0:(2^SF - 1);
for i = 1:numSymbols
% Current symbol
s_nTs = symbols(i);
% chirp is shifted in frequency by s_nTs
chirp_waveform = (1/sqrt(2^SF)) * exp(1j * 2 * pi * ((s_nTs + k) .* k) / (2^SF));
%append chirp wavieform to the modulated signal
modulated_signal = [modulated_signal, chirp_waveform];
end
time_vector = (0:length(modulated_signal) - 1) * T;
figure;
plot(time_vector, real(modulated_signal));
xlabel('Time (s)');
ylabel('Amplitude');
title('Real Part of the LoRa Modulated Signal');
grid on;
figure;
spectrogram(modulated_signal, 64, 32, 128, B, 'yaxis');
title('Spectrogram of the LoRa Modulated Signal');
time_vector = (0:length(modulated_signal) - 1) * T;

% AWGN channel 
SNR_dB = 10;
awgn_signal = awgn(modulated_signal, SNR_dB, 'measured');
figure;
plot(time_vector, real(awgn_signal));
xlabel('Time (s)');
ylabel('Amplitude');
title('Received Signal in AWGN Channel');
grid on;
figure;
spectrogram(awgn_signal, 64, 32, 128, B, 'yaxis');
title('Spectrogram of the Received Signal in AWGN Channel');

% Frequency - Selectivity Channel
h = [sqrt(0.8), sqrt(0.2)]; % Channel impulse response
faded_signal = filter(h, 1, modulated_signal); % Apply channel effect
faded_awgn_signal = awgn(faded_signal, SNR_dB, 'measured');
figure;
plot(time_vector, real(faded_awgn_signal));
xlabel('Time (s)');
ylabel('Amplitude');
title('Received Signal in Frequency-Selective Channel');
grid on;
figure;
spectrogram(faded_awgn_signal, 64, 32, 128, B, 'yaxis');
title('Spectrogram of the Received Signal in Frequency-Selective Channel');
SNR_dB = 10;
received_signal = awgn(modulated_signal, SNR_dB, 'measured'); % received signal with AWGN
k = 0:(2^SF - 1);
% down-chirp signal
down_chirp = exp(-1j * 2 * pi * (k .* k) / (2^SF));
detected_symbols = zeros(1, numSymbols);
% Demodulation process
for i = 1:numSymbols
symbol_start = (i-1) * 2^SF + 1;
symbol_end = i * 2^SF;
symbol_segment = received_signal(symbol_start:symbol_end);
dechirped_signal = symbol_segment .* down_chirp;
fft_result = fft(dechirped_signal);
%the ~ supresses one of the outputs which we dont need and the one
%which we do is appended on to detected symbols.
[~, detected_symbol] = max(abs(fft_result));
detected_symbols(i) = detected_symbol - 1;
end
fprintf('Detected Symbols:\n');
disp(detected_symbols);
fprintf('Transmitted Symbols:\n');
disp(symbols);
