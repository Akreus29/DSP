img2d = imread('image_2D.jpg');
rows = size(img2d,1); % Number of rows (height of the image)
column = size(img2d,2); % Number of columns (width of the image)
channel = size(img2d,3); % Number of color channels (should be 3 for RGB)
R = zeros(rows, column, 3); % Red channel matrix
G = zeros(rows, column, 3); % Green channel matrix
B = zeros(rows, column, 3); % Blue channel matrix
R(:,:,1) = img2d(:,:,1); % Assign to the first plane of R
G(:,:,2) = img2d(:,:,2); % Assign to the second plane of G
B(:,:,3) = img2d(:,:,3); % Assign to the third plane of B
subplot(2,3,1); % Create a subplot in a 2x3 grid at position 1
imshow(uint8(R)); % Display the red channel image, converting to uint8 for proper display
subplot(2,3,2);
imshow(uint8(G)); % Display the green channel image, converting to uint8 for proper display
subplot(2,3,3);
imshow(uint8(B)); % Display the blue channel image, converting to uint8 for proper display
gray = rgb2gray(img2d);
figure; imshow(gray); title('GrayscaleConverstion');
redVec = reshape(R, [], 1); % Reshape the red channel into a column vector
greenVec = reshape(G, [], 1); % Reshape the green channel into a column vector
blueVec = reshape(B, [], 1); % Reshape the blue channel into a column vector
% Display the size of each vector
disp('Size of Red Vector:');
disp(size(redVec)); % Display the size of the red vector
disp('Size of Green Vector:');
disp(size(greenVec)); % Display the size of the green vector
disp('Size of Blue Vector:');
disp(size(blueVec)); % Display the size of the blue vector


p = niftiread('3dimage.nii');
volshow(p);

I_double = double(I);  
I_normalized = I_double / max(I_double(:));  

slice_number = 100; 

% Frontal view
frontal_view = I_normalized(:, :, slice_number);
subplot(1,3,1)
imshow(reshape(frontal_view, size(frontal_view, 1), size(frontal_view, 2)), []);
title('Frontal View');

% Horizontal view
horizontal_view = I_normalized(slice_number, :, :);
horizontal_view = reshape(horizontal_view, size(horizontal_view, 2), size(horizontal_view, 3));
subplot(1,3,2)
imshow(horizontal_view, []);
title('Horizontal View ');

% Sagittal view
sagittal_view = I_normalized(:, slice_number, :);
sagittal_view = reshape(sagittal_view, size(sagittal_view, 1), size(sagittal_view, 3));
subplot(1,3,3)
imshow(sagittal_view, []);
title('Sagittal View');
