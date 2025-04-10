
Signal Analysis and Processing

%% PART A - Load and Analyze Signal
file = load("x(n)_.mat");
inp = file.sig;
N = length(inp);

% Perform DFT using custom function
[X_analysis, ~] = custom_dft_idft(inp');

% Shifted magnitude spectrum for plotting
Y_shifted = abs(fftshift(X_analysis));
f = linspace(-250, 250, N);

% Plot the magnitude spectrum
figure;
plot(f, Y_shifted);
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Magnitude Spectrum of Signal');

%% PART B - Identify and Display Peak Frequencies
[peak, loc] = findpeaks(abs(X_analysis), 'NPeaks', 6, 'SortStr', 'descend');
disp('Peak Magnitudes:');
disp(peak);
disp('Peak Locations:');
disp(loc);

%% PART C - Signal Synthesis and Noise Reduction
[~, x_synthesis] = custom_dft_idft(inp');
for m = 1:250
    if ismember(m, loc)
        continue;
    else
        x_synthesis(m,1) = 0;
    end
end

% Manual DFT for verification
D = zeros(N, N);
for n = 0:N-1
    for k = 0:N-1
        D(n+1, k+1) = exp(-1j * 2 * pi * n * k / N);
    end
end
X_hat = (1/sqrt(N)) * D' * x_synthesis;

% Display the new peaks after noise reduction
[peak, loc] = findpeaks(abs(X_hat));
disp('Updated Peak Magnitudes:');
disp(peak);
disp('Updated Peak Locations:');
disp(loc);

%% PART D - Error Calculation
error = abs(mean(X_hat' - inp));
disp(['Mean Squared Error between x̂(n) and x(n): ', num2str(error)]);

%% QUESTION 2 - Audio Signal Processing

%% PART A - Load and Split Audio into Blocks
[y, fs] = audioread('audio.wav');  % Load audio file
blockSize = 2048;  % Block size for processing
num_blocks = ceil(length(y) / blockSize);

% Initialize storage for the complete DFT spectrum
Y_final = [];

% Process each audio block
for i = 1:num_blocks
    % Define the block range
    start_idx = (i-1) * blockSize + 1;
    end_idx = min(i * blockSize, length(y));
    segment = y(start_idx:end_idx);
    N = length(segment);
    
    % Perform DFT manually for each block
    Y = zeros(N, 1);
    for K = 0:N-1
        for n = 0:N-1
            Y(K+1) = Y(K+1) + segment(n+1) * exp(-1j * 2 * pi * K * n / N);
        end
    end
    Y_final = [Y_final; abs(Y)];
end

% Prepare frequency vector for plotting
N = length(Y_final);
freq_axis = linspace(-fs/2, fs/2, N);

% Plot the magnitude spectrum of the full signal
Y_shifted = fftshift(Y_final);
Y = abs(Y_shifted);
figure;
plot(freq_axis, Y);
title('Magnitude Spectrum of the Original Signal Y(K)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');    

%% PART B - Frequency Extraction and Synthesis
y1 = [];  % Synthesized signal for 0-5 kHz
y2 = [];  % Synthesized signal for 10-20 kHz

Y_length = size(Y_final, 1);
block_start = 1;

% Process each block for frequency filtering
for i = 1:num_blocks
    if i == num_blocks
        actual_Size = length(y) - (i-1) * blockSize;
    else
        actual_Size = blockSize;
    end
    
    blockend = block_start + actual_Size - 1;
    if blockend > Y_length
        blockend = Y_length;
    end
    
    % Extract current block's DFT result
    Y = Y_final(block_start:blockend);
    f = (0:actual_Size-1) * (fs / actual_Size);
    
    if isempty(f)
        continue;
    end
    
    % Mask for 0-5 kHz and 10-20 kHz
    port1 = (f >= 0 & f <= 5000);
    Y1 = Y .* port1;  
    port2 = (f >= 10000 & f <= 20000);
    Y2 = Y .* port2;  
    
    if isempty(Y1) || isempty(Y2)
        continue;
    end
    
    % Inverse DFT for 0-5 kHz components
    y1_block = zeros(actual_Size, 1);
    for n = 0:actual_Size-1
        for K = 0:actual_Size-1
            y1_block(n+1) = y1_block(n+1) + Y1(K+1) * exp(1j * 2 * pi * K * n / actual_Size);
        end
    end
    y1_block = real(y1_block) / actual_Size;  
    y1 = [y1; y1_block];  
    
    % Inverse DFT for 10-20 kHz components
    y2_block = zeros(actual_Size, 1);
    for n = 0:actual_Size-1
        for K = 0:actual_Size-1
            y2_block(n+1) = y2_block(n+1) + Y2(K+1) * exp(1j * 2 * pi * K * n / actual_Size);
        end
    end
    y2_block = real(y2_block) / actual_Size;  
    y2 = [y2; y2_block];  

    block_start = blockend + 1;
end

%% PART C - Visualization of Processed Signals
figure;
subplot(2,1,1);
plot(f, abs(y1(1:length(f))));
title('Magnitude Spectrum of Y1(K) (0-5 kHz)');
xlim([0 5000])
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(2,1,2);
plot(f, abs(y2(1:length(f))));
title('Magnitude Spectrum of Y2(K) (10-20 kHz)');
xlim([10000 20000])
xlabel('Frequency (Hz)');
ylabel('Magnitude');

%% PART D - Playback of Synthesized Signals
sound(y1, fs);  % Play filtered 0-5 kHz signal
pause(length(y1)/fs);  

sound(y2, fs);  % Play filtered 10-20 kHz signal
pause(length(y2)/fs);



function [X, x_reconstructed] = custom_dft_idft(x)
    N = length(x);
    
    % Compute DFT
    X = zeros(N, 1);
    for k = 0:N-1
        for n = 0:N-1
            X(k+1) = X(k+1) + x(n+1) * exp(-1j * 2 * pi * k * n / N);
        end
    end
    
    % Compute IDFT
    x_reconstructed = zeros(N, 1);
    for n = 0:N-1
        for k = 0:N-1
            x_reconstructed(n+1) = x_reconstructed(n+1) + X(k+1) * exp(1j * 2 * pi * k * n / N);
        end
    end
    
    x_reconstructed = x_reconstructed / N;  % Normalize to complete the IDFT
end
