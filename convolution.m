MATRIX-BASED CONVOLUTION OF SEQUENCES

% Define input sequence x(n) and impulse response h(n)
x = [1, -1, 1];  
h = [1, 1];     

% Get lengths of x and h
L = length(x);
M = length(h);

% Define the length of the output sequence y(n)
N = L + M - 1;
H_matrix = zeros(N, M);  % Initialize matrix for convolution

% Zero-pad x to match the output length
x_padded = [x(:); zeros(N - L, 1)]; 

% Populate the convolution matrix by shifting x_padded
for i = 1:M
    H_matrix(:, i) = circshift(x_padded, i-1); 
end

% Compute the convolution result by matrix multiplication
y_output = H_matrix * h(:); 

% Display the output
disp('The output y(n) is:');
disp(y_output');

% Compute y(n) after interchanging x(n) and h(n) using the helper function
y_swapped = linear_convolution(h, x);

% Display the swapped output
disp('The output vector y(n) after interchanging x(n) and h(n) is:');
disp(y_swapped);

% function for convolution

%% QUESTION 2: IMAGE BLURRING

% Load the image data from the .mat file
load('img_7.mat');  

% Convert to grayscale (if RGB) and resize to 64x64
x_grayscale = rgb2gray(imData1);  
x_resized = imresize(x_grayscale, [64, 64]);  

% Display the resized grayscale image
figure;
imshow(x_resized);
title('Original Grayscale Image (64x64)');

%% Apply Moving Average Filter for M = 4 and M = 10

% Define M = 4 Moving Average Filter
M4 = 4;
h_filter_4 = ones(M4, M4) / (M4^2);  % Create 4x4 filter kernel

% Apply the filter using convolution
filtered_img_M4 = conv2(x_resized, h_filter_4, 'same');

% Display the filtered image for M = 4
figure;
imshow(filtered_img_M4, []);
title('Filtered Image with Moving Average Filter (M = 4)');

% Define M = 10 Moving Average Filter
M10 = 10;
h_filter_10 = ones(M10, M10) / (M10^2);  % Create 10x10 filter kernel

% Apply the filter using convolution
filtered_img_M10 = conv2(x_resized, h_filter_10, 'same');

% Display the filtered image for M = 10
figure;
imshow(filtered_img_M10, []);
title('Filtered Image with Moving Average Filter (M = 10)');

%% QUESTION 3: AUDIO PROCESSING

% Load the audio signal and extract the first 3 seconds
[audioData, fs] = audioread('audio_7.wav');  
duration = 3;  
numSamples = duration * fs;  
audio_segment = audioData(1:numSamples);  

% Play the original audio segment
disp('Playing original audio (first 3 seconds):');
sound(audio_segment, fs);  
pause(duration + 1);  

% Load impulse responses h1 and h2 from the .mat files
load('h1(n)_7.mat');  
load('h2(n)_7.mat');  

% Rename impulse responses for clarity
h1_response = hL;  
h2_response = hH;

% Ensure impulse responses are column vectors for convolution
if isrow(h1_response)
    h1_response = h1_response';  
end
if isrow(h2_response)
    h2_response = h2_response';  
end

% Compute output signals y1(n) and y2(n) using custom linear_convolution
output_y1 = linear_convolution(audio_segment, h1_response);  
output_y2 = linear_convolution(audio_segment, h2_response);  

% Play the audio outputs
disp('Playing audio output y1(n) with impulse response h1:');
sound(output_y1, fs);
pause(duration + 1);  

disp('Playing audio output y2(n) with impulse response h2:');
sound(output_y2, fs);
pause(duration + 1);  

% Custom linear convolution function
function y = linear_convolution(x, h)
    L = length(x);
    M = length(h);
    N = L + M - 1;
    
    % Initialize the convolution matrix and pad x
    H_matrix = zeros(N, M);  
    x_padded = [x(:); zeros(N - L, 1)]; 

    % Populate the matrix with shifted versions of x_padded
    for i = 1:M
        H_matrix(:, i) = circshift(x_padded, i-1); 
    end

    % Compute the convolution
    y = H_matrix * h(:);  
    y = y';  % Transpose to match output format
end
subplot(1,2,1);
plot(output_y1);
subplot(1,2,2);
plot(output_y2);
