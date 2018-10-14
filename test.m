clc;
clear all;
close all;
%taking blurred image input from user
[filename,pathname]=uigetfile('*.*','Select the Blurred image'); 
a=imread(num2str(filename));
%coverting the image values to double
img= im2double(a);
%extracting the three channels into im1=R channel,im2=Green
%channel,im3=blue channel
im1 = img(:,:,1);
im2 = img(:,:,2);
im3 = img(:,:,3);
[m, n] = size(im1);

%calculating dft of the image for all three channels
DFTofimage = DFTfunct(im1,m,n);
G1 = DFTofimage;
magG1=100*log(1+abs(G1));
DFTofimage = DFTfunct(im2,m,n);
G2 = DFTofimage;
magG2=100*log(1+abs(G2));
DFTofimage = DFTfunct(im3,m,n);
G3 = DFTofimage;
magG3=100*log(1+abs(G3));

%taking the kernel of user's choice
[filename,pathname]=uigetfile('*.*','Select the kernel'); 
kernel=imread(num2str(filename));
k_double= im2double(kernel(1:64,1:64));     %this size is good for kernel 2
%figure,imshow(k_double);
avg=sum(sum(k_double));
ker = k_double/avg;      %dividing the kernel values with the average of all values in kernel
[r1, c1] = size(ker);     
kerpadding=padarray(ker,[(368),(368)],0,'both');    %padding the image with (800-64)/2
[r, c]= size(kerpadding);
% figure;imshow(imagepadding);
%dft of the kernel
DFTofimage = DFTfunct(kerpadding,r,c);
K1 = DFTofimage;
magK1=abs(K1);

%taking the ground truth input from user
[filename1,pathname]=uigetfile('*.*','Select the original image'); 
original=imread(num2str(filename1));

%Inverse filter
inverse_out = inversefilter(K1,G1);
F1inv = inverse_out;
inverse_out = inversefilter(K1,G2);
F2inv = inverse_out;
inverse_out = inversefilter(K1,G3);
F3inv = inverse_out;

%inverse dft of inverse filtered outputs
IDFTofimage = IDFTfunct(F1inv,m,n);
restored(:,:,1) = IDFTofimage;
restored1=restored(:,:,1);
IDFTofimage = IDFTfunct(F2inv,m,n);
restored(:,:,2) = IDFTofimage;
restored2=restored(:,:,2);
IDFTofimage = IDFTfunct(F3inv,m,n);
restored(:,:,3) = IDFTofimage;
restored3=restored(:,:,3);

%displaying the original and inverse filter restored images
figure(1);subplot(1,2,1);
imshow(original); title('Original image'); 
subplot(1,2,2);
imshow(restored); title('Inverse filtered Restored image');

%calculating psnr for inverse filter restored image  
PSNRval = PSNR(original,restored);
psnrinv = PSNRval;
disp('PSNR of inverse filtered restored image =');
disp(psnrinv);
%calculating ssim for inverse filter restored image 
ssimcalculated = ssimcalculator(original,restored);
ssiminv = ssimcalculated;
disp('SSIM of inverse filtered restored image =');
disp(ssiminv);

%passing inverse filtered output through butterworth filter
%designing the butterworth filter
b=inputdlg('Do');%asking for cut-off frequency
Do=str2num(b{1});
c=inputdlg('t');%t as a order of the filter
order=str2num(c{1});

butterworth_out = butterworthfilter(F1inv,m,n,Do,order);
F1_butter = butterworth_out;
butterworth_out = butterworthfilter(F2inv,m,n,Do,order);
F2_butter = butterworth_out;
butterworth_out = butterworthfilter(F3inv,m,n,Do,order);
F3_butter = butterworth_out;
%displaying the mask function for butterworth


%inverse dft of butterworth filtered outputs
IDFTofimage = IDFTfunct(F1_butter,m,n);
restored(:,:,1) = IDFTofimage;
restored1=restored(:,:,1);
IDFTofimage = IDFTfunct(F2_butter,m,n);
restored(:,:,2) = IDFTofimage;
restored2=restored(:,:,2);
IDFTofimage = IDFTfunct(F3_butter,m,n);
restored(:,:,3) = IDFTofimage;
restored3=restored(:,:,3);

%displaying the original and inverse butterworth filter restored images
figure(2);subplot(1,2,1);
imshow(original); title('Original image'); 
subplot(1,2,2);
imshow(restored); title('Butterworth filtered Restored image');

%calculating psnr for inverse butterworth filter restored image  
PSNRval = PSNR(original,restored);
psnrbutter = PSNRval;
disp('PSNR of inverse butterworth filtered restored image =');
disp(psnrbutter);
%calculating ssim for inverse butterworth filter restored image 
ssimcalculated = ssimcalculator(original,restored);
ssimbutter = ssimcalculated;
disp('SSIM of inverse butterworth filtered restored image =');
disp(ssimbutter);

%weiner filter
%taking value of k
b=inputdlg('Enter the value of K');%asking for cut-off frequencies
k=str2num(b{1});

Weinerfilter_output = Weinerfilter(K1,magK1,G1,m,n,k);
F1 = Weinerfilter_output ;
Weinerfilter_output = Weinerfilter(K1,magK1,G2,m,n,k);
F2=Weinerfilter_output;
Weinerfilter_output = Weinerfilter(K1,magK1,G3,m,n,k);
F3=Weinerfilter_output;

%inverse dft of weiner filtered outputs
IDFTofimage = IDFTfunct(F1,m,n);
restored(:,:,1) = IDFTofimage;
restored1=restored(:,:,1);
IDFTofimage = IDFTfunct(F2,m,n);
restored(:,:,2) = IDFTofimage;
restored2=restored(:,:,2);
IDFTofimage = IDFTfunct(F3,m,n);
restored(:,:,3) = IDFTofimage;
restored3=restored(:,:,3);

%displaying the original and restored images for weiner filter
figure(3);subplot(1,2,1);
imshow(original); title('Original image'); 
subplot(1,2,2);
imshow(restored); title('Weiner filtered Restored image');

%calculating psnr for weiner restored image
PSNRval = PSNR(original,restored);
psnrweiner = PSNRval;
disp('PSNR of weiner filtered restored image =');
disp(psnrweiner);
%calculating ssim for weiner restored image
ssimcalculated = ssimcalculator(original,restored);
ssimweiner = ssimcalculated;
disp('SSIM of weiner filtered output image =');
disp(ssimweiner);

%Constrained Least Square filter
%taking value of C
b=inputdlg('Enter the value of gamma');%asking for gamma value
C=str2num(b{1});

CLSFout = CLSFfunct(K1,C,magK1,m,n,G1);
F1CLSF = CLSFout;
CLSFout = CLSFfunct(K1,C,magK1,m,n,G2);
F2CLSF = CLSFout;
CLSFout = CLSFfunct(K1,C,magK1,m,n,G3);
F3CLSF = CLSFout;

%inverse dft of CLSF filtered outputs
IDFTofimage = IDFTfunct(F1CLSF,m,n);
restored(:,:,1) = IDFTofimage;
restored1=restored(:,:,1);
IDFTofimage = IDFTfunct(F2CLSF,m,n);
restored(:,:,2) = IDFTofimage;
restored2=restored(:,:,2);
IDFTofimage = IDFTfunct(F3CLSF,m,n);
restored(:,:,3) = IDFTofimage;
restored3=restored(:,:,3);

%displaying the original and restored images for weiner filter
figure(4);subplot(1,2,1);
imshow(original); title('Original image'); 
subplot(1,2,2);
imshow(restored); title('CLSF filtered Restored image');

%calculating psnr for constrained least square filtered restored image
PSNRval = PSNR(original,restored);
psnrCLSF = PSNRval;
disp('PSNR of CLSF filtered restored image =');
disp(psnrCLSF);
%calculating ssim for constrained least square filtered restored image
ssimcalculated = ssimcalculator(original,restored);
ssimCLSF = ssimcalculated;
disp('SSIM of CLSF filtered output image =');
disp(ssimCLSF);