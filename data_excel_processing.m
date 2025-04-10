% We take from the each column from the 2nd row into each of the 3 variables.
x = xlsread('FinalData.xlsx', 1, 'A2:A748688');% Load data from column A of the first sheet into x
y = xlsread('FinalData.xlsx', 1, 'B2:B748688');% Load data from column B of the first sheet into y
z = xlsread('FinalData.xlsx', 1, 'C2:C748688');% Load data from column C of the first sheet into z
 
% Create linearly spaced vectors for the x and y dimensions
xx = linspace(max(x), min(x));
xy = linspace(max(y), min(y));
 
% Create a meshgrid based on xx and xy
[X,Y] = meshgrid(xx,xy);
 
% Interpolate the data z onto the meshgrid X and Y
Z = griddata(x,y,z,X,Y);
 
% Create a surface plot using the interpolated data
surf(X,Y,Z);
 
title('Accelerometer Data');    
xlabel('Xaxis movement');
ylabel('Yaxis movement');                    
zlabel('Zaxis movement');  
midterm1 = xlsread('MidTerm1Data.xlsx', 3, 'B2:B301');  % Load midterm 1 data
midterm2 = xlsread('MidTerm2Data.xlsx', 3, 'B2:B1291');  % Load midterm 2 data
finaldata = xlsread('FinalData.xlsx',3,'B2:B2169');  % Load final data
 
% Create vectors for the x-axis of each plot
midterm_length = 1:10:5400;
final_length = 1:10:(3*3600);
 
% Plot midterm 1 data
plot(midterm_length(1:length(midterm1)), midterm1);
hold on;  % Hold the current plot
 
% Plot midterm 2 data
plot(midterm_length, midterm2(1:length(midterm_length)));
hold on;  % Hold the current plot
 
% Plot final data
plot(final_length, finaldata(1:length(final_length)));
 
% Add a legend to distinguish the plots
legend('MidSem1','MidSem2','Final');

Final = xlsread("FinalData.xlsx", 2, 'A3:A93586');
 
Mid1 = xlsread("MidTerm1Data.xlsx", 2, 'A3:A44714');
 
Mid2 = xlsread("MidTerm2Data.xlsx", 2, 'A3:A44546');
 
timeMid = 0:10:(1.5 * 3600);
 
timeEnd = 0:10:(3 * 3600);
 
% Plot the mid-term 1 temperature data in the first subplot
 
subplot(3,1,1); plot(timeMid, Mid1(1:length(timeMid)));
 
xlabel("Time (secs)"); ylabel("Data"); title("Temperature - MidTerm1");
 
% Plot the mid-term 2 temperature data in the second subplot
 
subplot(3,1,2);
 
plot(timeMid, Mid2(1:length(timeMid)));
 
xlabel("Time (secs)"); ylabel("Data"); title("Temperature - MidTerm2");
 
 
% Plot the final term temperature data in the third subplot
 
subplot(3,1,3);
plot(timeEnd, Final(1:length(timeEnd)));
xlabel("Time (secs)"); ylabel("Data"); title("Temperature - EndTerm");

% Q3: Load and plot audio data
[a,fs] = audioread("Signal_Processing_Audio.mp3");  % Load audio data
 
% Plot the first 4 seconds of the audio data
plot(a(1:4*fs));
xlabel('Sample Number');
ylabel('Amplitude');
title('Initial 4 Seconds of Audio');
 
% Write the first 4 seconds of the audio data to a new WAV file
audiowrite('new_audio.wav', a(1:4*fs), fs);
% [a,fs] = audioread("Signal_Processing_Audio.mp3"); % Load audio data
 
% Plot the first 4 seconds of the audio data
plot(a(1:4*fs));
xlabel('Sample Number');
ylabel('Amplitude');
title('Initial 4 Seconds of Audio');
 
% Write the first 4 seconds of the audio data to a new WAV file
audiowrite('new_audio.wav', a(1:4*fs), fs);
 
% Play the audio using sound()
sound(a(1:4*fs), fs);
