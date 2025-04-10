I = imread('image_2d.jpg');


a=size(I,1);
b=size(I,2);
c=size(I,3);



r = zeros(a,b,3);
g = zeros(a,b,3);
b = zeros(a,b,3);

r(:,:,1) = I(:,:,1);
g(:,:,2) = I(:,:,2);
b(:,:,3) = I(:,:,3);

subplot(2,3,1);
imshow(uint8(r));
subplot(2,3,2);
imshow(uint8(g));
subplot(2,3,3);
imshow(uint8(b));

j = rgb2gray(I);

h = reshape(j,[510,330]);
subplot(2,3,4);
imshow(h);

k = imresize(j,[500,500]);
subplot(2,3,5);
imshow(k);

