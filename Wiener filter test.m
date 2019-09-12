clc
clear all
% form PSF as a disk of radius 3 pixels
h = fspecial('disk',4);
% read image and convert to double for FFT
RAW_Image = imread('img1.JPG');
RAW_Image=im2double(RAW_Image);
figure; imshow(RAW_Image)
xlabel('Original Image')

hf = psf2otf(h,size(RAW_Image));
Image_blur = real(ifft2(hf.*fft2(RAW_Image)));
figure;imshow(Image_blur)
xlabel('blurred image(PSF as a disk of radius 3 pixels)')


%add noise to get a 40 dB PSNR:
sigma_u = 10^(-40/20)*abs(1-0);
Image_blur_noise = Image_blur + sigma_u*randn(size(Image_blur));
imshow(Image_blur_noise)
xlabel('blurred and noisy image(a 40 dB PSNR)')

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%  a smaller alpha results in a noisier and sharper image 

alpha = 0.0005;
image_reg = deconvreg(Image_blur_noise,h,0,alpha);
figure();subplot(311);imshow(image_reg)
title('\alpha = 0.0005 ')
xlabel('a smaller alpha results in a noisier and sharper image')
alpha = 0.01;
image_reg = deconvreg(Image_blur_noise,h,0,alpha);
subplot(312);imshow(image_reg)
title('\alpha = 0.01')

%larger alpha results in a cleaner but blurrier image
alpha = 0.2;
image_reg = deconvreg(Image_blur_noise,h,0,alpha);
subplot(313);imshow(image_reg)
title('\alpha = 0.2; ')
xlabel('larger alpha results in a cleaner but blurried image')
%====================================================================

% The regularization operator to constrain the deconvolution. 
% To retain the image smoothness, the Laplacian regularization operator is used by default.
alpha = 0.01;
regop = 1;
image_reg = deconvreg(Image_blur_noise,h,0,alpha,regop);
%subplot(312);
figure;imshow(image_reg)
xlabel('l(m,n) = no filtering ; alpha = 0.01')

alpha = 0.01;
lf = fft2([0 1 0; 1 -4 1; 0 1 0],256,256);
image_reg = deconvreg(Image_blur_noise,h,0,alpha);
%subplot(313);
figure;imshow(image_reg)
xlabel('l(m,n) = discrete Laplacian; alpha = 0.01')


image_reg2 = real(ifft2(fft2(Image_blur_noise).*conj(hf)./(abs(hf).^2 + alpha)));
imshow(image_reg2)
xlabel('alternative pseudo-inverse restoration')