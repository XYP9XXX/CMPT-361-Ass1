% Step1: Edit original pictures and save them.
HP = im2gray(im2double(imread('HP_colored.png')));
LP = im2gray(im2double(imread('LP_colored.png')));
imshow([HP LP]);
imwrite(HP,'HP.png');
imwrite(LP,'LP.png');

% Step2: Compute frequency representations
HP_freq = (fftshift(abs(fft2(HP))));  %fft2 function is used for fourier transform, abs function is used because it has complex number, fftshift function is used to display the results in the center of the image
LP_freq = (fftshift(abs(fft2(LP))));
imshow([HP_freq LP_freq]);
HP_freq = HP_freq / 50; %adjust the brightness
LP_freq = LP_freq / 50;
imshow([HP_freq LP_freq]);
imwrite(HP_freq, 'HP-freq.png'); %Save the result image to the folder.
imwrite(LP_freq, 'LP-freq.png');

% Step3: Visualize kernels
sobel_kernel = [-1 0 1; -2 0 2; -1 0 1]; %create sobel kernel
gaussian_kernel = fspecial('gaussian', 33, 2.5); %create gaussian kernel with sd = 2.5
surf(gaussian_kernel); %visualize the gaussian kernel
saveas(gcf, 'gaus-surf.png'); %save the visualize picture as png file. gcf means get current figure.
dog_kernel = conv2(gaussian_kernel, sobel_kernel); %compute the dog kernel using sobel/gaussian kernel.
surf(dog_kernel) %visualize the gaussian kernel
saveas(gcf, 'dog-surf.png'); %save the visualize picture as png file.
HP_filt = imfilter(HP, gaussian_kernel); %filter the high pass pic with gaussian kernel
LP_filt = imfilter(LP, gaussian_kernel); %filter the low pass pic with gaussian kernel
imshow([HP_filt HP, LP_filt LP]);
imwrite(HP_filt, 'HP-filt.png'); %save the result image to the folder
imwrite(LP_filt, 'LP-filt.png');
HP_filt_freq = fftshift(abs(fft2(HP_filt))) / 50; %compute the frequency domain of the high pass pic
LP_filt_freq = fftshift(abs(fft2(LP_filt))) / 50; %compute the frequency domain of the low pass pic
imshow([HP_filt_freq HP_freq, LP_filt_freq LP_freq]);
imwrite(HP_filt_freq, 'HP-filt-freq.png'); %save the result frequency domain image to the folder
imwrite(LP_filt_freq, 'LP-filt-freq.png');
dog_fou = fft2(dog_kernel, 500, 500); %Apply fourier transform of the DoG kernels using 500*500 size. This time do not need to use fftshift as it is only needed when visualizing.
HP_dogfit_filt_freq = dog_fou .* fft2(HP); %Filter the image
LP_dogfit_filt_freq = dog_fou .* fft2(LP); %Filter the image
HP_dogfilt_freq = abs(fftshift(HP_dogfit_filt_freq)) / 50; %compute the frequency domain using this filter and adjust brightness
LP_dogfilt_freq = abs(fftshift(LP_dogfit_filt_freq)) / 50;
imshow([HP_dogfilt_freq HP_freq, LP_dogfilt_freq LP_freq]);
imwrite(HP_dogfilt_freq, 'HP-dogfilt-freq.png'); %save the result frequency domain image to the folder
imwrite(LP_dogfilt_freq, 'LP-dogfilt-freq.png');
HP_dogfilt = ifft2(HP_dogfit_filt_freq); %convert frequency domain picture back to the spatial domain.
LP_dogfilt = ifft2(LP_dogfit_filt_freq);
imshow([HP_dogfilt HP, LP_dogfilt LP]);
imwrite(HP_dogfilt, 'HP-dogfilt.png'); %save the result spatial domain image to the folder
imwrite(LP_dogfilt, 'LP-dogfilt.png');


% Step4: Anti-aliasing
HP_sub2 = HP(1:2:end, 1:2:end); %take sample of the image, because this is the high pass image, so there will be some moire pattern for high frequency part.
LP_sub2 = LP(1:2:end, 1:2:end); 
imshow([HP_sub2 LP_sub2]);
imwrite(HP_sub2, 'HP-sub2.png'); %store the result images to the folder
imwrite(LP_sub2, 'LP-sub2.png');
LP_sub2_freq = abs(fftshift(fft2(LP_sub2, 500, 500))) / 50; %compute the frequency domain of the sample image
HP_sub2_freq = abs(fftshift(fft2(HP_sub2, 500, 500))) / 50;
imshow([HP_sub2_freq HP_freq, LP_sub2_freq LP_freq]);
imwrite(LP_sub2_freq, 'LP-sub2-freq.png'); %store the result domain images to the folder
imwrite(HP_sub2_freq, 'HP-sub2-freq.png');
HP_sub4 = HP(1:4:end, 1:4:end); %take smaller sample of the image
LP_sub4 = LP(1:4:end, 1:4:end); 
imshow([HP_sub4 LP_sub4]);
imwrite(HP_sub4, 'HP-sub4.png'); %store the result images to the folder
imwrite(LP_sub4, 'LP-sub4.png');
LP_sub4_freq = abs(fftshift(fft2(LP_sub4, 500, 500))) / 50; %compute the frequency domain of the sample image
HP_sub4_freq = abs(fftshift(fft2(HP_sub4, 500, 500))) / 50;
imshow([HP_sub4_freq HP_freq, LP_sub4_freq LP_freq]);
imwrite(LP_sub4_freq, 'LP-sub4-freq.png'); %store the result domain images to the folder
imwrite(HP_sub4_freq, 'HP-sub4-freq.png');
gaussian_kernel_sub2 = fspecial('gaussian', 30, 5); %create the gaussian kernel for sub2 image
gaussian_kernel_sub4 = fspecial('gaussian', 15, 2.5); %create the gaussian kernel for sub4 image
HP_gaus_sub2 = imfilter(HP, gaussian_kernel_sub2); %filter the image
HP_gaus_sub4 = imfilter(HP, gaussian_kernel_sub4); %filter the image
HP_sub2_aa = HP_gaus_sub2(1:2:end, 1:2:end); %take sample
HP_sub4_aa = HP_gaus_sub2(1:4:end, 1:4:end); %take sample
imshow([HP_sub2_aa HP_sub2]);
imshow([HP_sub4_aa HP_sub4]);
imwrite(HP_sub2_aa, 'HP-sub2-aa.png'); %store the result images to the folder
imwrite(HP_sub4_aa, 'HP-sub4-aa.png');
HP_sub2_aa_freq = abs(fftshift(fft2(HP_sub2_aa, 500, 500))) / 50; %compute the frequency domain of the sample image
HP_sub4_aa_freq = abs(fftshift(fft2(HP_sub4_aa, 500, 500))) / 50;
imshow([HP_sub2_aa_freq HP_sub2_freq, HP_sub4_aa_freq HP_sub4_freq]);
imwrite(HP_sub2_aa_freq, 'HP-sub2-aa-freq.png'); %store the result domain images to the folder
imwrite(HP_sub4_aa_freq, 'HP-sub4-aa-freq.png');

% Step5: Canny edge detection thresholding 
[HP_canny, HP_thresh] = edge(HP, 'canny'); %using canny edge detection function provided by matlab to get the edge and threshold for both pic
[LP_canny, LP_thresh] = edge(LP, 'canny');
imshow([HP_canny LP_canny]);
HP_thresh; %get the default parameters computed by Matlab  0.1063    0.2656
LP_thresh; % 0.0125    0.0312
HP_lowlow_low = 0.03; %define each low/high threshold
HP_lowlow_high = 0.25;
HP_highlow_low = 0.15;
HP_highlow_high = 0.25;
HP_lowhigh_low = 0.1;
HP_lowhigh_high = 0.15;
HP_highhigh_low = 0.1;
HP_highhigh_high = 0.4;
HP_optimal_low = 0.1;
HP_optimal_high = 0.25;
LP_lowlow_low = 0.001; %define each low/high threshold
LP_lowlow_high = 0.03;
LP_highlow_low = 0.02;
LP_highlow_high = 0.03;
LP_lowhigh_low = 0.012;
LP_lowhigh_high = 0.02;
LP_highhigh_low = 0.012;
LP_highhigh_high = 0.05;
LP_optimal_low = 0.012;
LP_optimal_high = 0.03;
HP_canny_lowlow = edge(HP, 'canny', [HP_lowlow_low HP_lowlow_high]); 
LP_canny_lowlow = edge(LP, 'canny', [LP_lowlow_low LP_lowlow_high]);
HP_canny_highlow = edge(HP, 'canny', [HP_highlow_low HP_highlow_high]);
LP_canny_highlow = edge(LP, 'canny', [LP_highlow_low LP_highlow_high]);
HP_canny_lowhigh = edge(HP, 'canny', [HP_lowhigh_low HP_lowhigh_high]);
LP_canny_lowhigh = edge(LP, 'canny', [LP_lowhigh_low LP_lowhigh_high]);
HP_canny_highhigh = edge(HP, 'canny', [HP_highhigh_low HP_highhigh_high]);
LP_canny_highhigh = edge(LP, 'canny', [LP_highhigh_low LP_highhigh_high]);
HP_canny_optimal = edge(HP, 'canny', [HP_optimal_low HP_optimal_high]);
LP_canny_optimal = edge(LP, 'canny', [LP_optimal_low LP_optimal_high]);
imshow([HP_canny_lowlow HP_canny]); 
imshow([HP_canny_lowhigh HP_canny]); 
imshow([HP_canny_highlow HP_canny]);
imshow([HP_canny_highhigh HP_canny]);
imshow([LP_canny_lowlow LP_canny]);
imshow([LP_canny_lowhigh LP_canny]);
imshow([LP_canny_highlow LP_canny]);
imshow([LP_canny_highhigh LP_canny]);
imwrite(HP_canny, 'HP-canny-optimal.png');
imwrite(HP_canny_lowlow, 'HP-canny-lowlow.png');
imwrite(HP_canny_highlow, 'HP-canny-highlow.png');
imwrite(HP_canny_lowhigh, 'HP-canny-lowhigh.png');
imwrite(HP_canny_highhigh, 'HP-canny-highhigh.png');
imwrite(LP_canny_optimal, 'LP-canny-optimal.png');
imwrite(LP_canny_lowlow, 'LP-canny-lowlow.png');
imwrite(LP_canny_highlow, 'LP-canny-highlow.png');
imwrite(LP_canny_lowhigh, 'LP-canny-lowhigh.png');
imwrite(LP_canny_highhigh, 'LP-canny-highhigh.png');