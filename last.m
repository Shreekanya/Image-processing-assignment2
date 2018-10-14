clc;
clear all;
close all;
a=imread('E:\ip codes\assignment2\use.jpg');
img= im2double(a);
%sharpening the image
imagepadding = padarray(img,[1,1],0,'both');
[m, n, p]= size(imagepadding);
disp(n);
hpf=[1 1 1 ; 1 -8 1; 1 1 1];
A=imagepadding*255;
for i=2:m-1
    for j=2:n-1
         o= A(i-1:i+1, j-1: j+1).*hpf;
        d = sum(o(:));
      out(i-1,j-1)=d;
    end
end
out=out/255;
sharpened=out+img;
figure,imshow(sharpened),title('sharpened image');
%separating the three RGB channels into im1,im2,im3 resp
im1 = sharpened(:,:,1);
im2 = sharpened(:,:,2);
im3 = sharpened(:,:,3);
[r, c] = size(im1);

F1 = fft2(im1);
F111=fftshift(F1);
magF1=100*log(1+abs(F111));
F2 = fft2(im2);
F222=fftshift(F2);
magF2=100*log(1+abs(F222));
F3 = fft2(im3);
F333=fftshift(F3);
magF3=100*log(1+abs(F333));

Do=10;
order=5;
H=zeros(r,c);%creating a low pass filter of image dimensions
D=zeros(r,c);%distance matrix
for u=0: r-1
    for v=0:c-1
        D(u+1,v+1) = ((u-r/2)^2 + (v-c/2)^2)^0.5;
        H(u+1,v+1)=1/(1+(D(u+1,v+1)/Do)^(2*order));
    end
end
figure;imshow(H);

%conjugate of the kernel
KW = conj(H);
%taking value of C
b=inputdlg('Enter the value of gamma');%asking for cut-off frequencies
C=str2num(b{1});
C1=C.*ones(r,c);
%taking magnitude of the kernel
mag = abs(H).*abs(H);
%defining the laplacian operator
p = [0 -1 0 0; -1 4 -1 0; 0 -1  0 0; 0 0 0 0];
[rp, cp] = size(p);
p_padding=padarray(p,[((r-rp)/2),((c-cp)/2)],0,'both');    %padding the image
[rp, cp]= size(p_padding);
P = fft2(p_padding);
Puv=fftshift(P);
magP=abs(Puv);
magp=magP.*magP;
%design of constrained least squares filter
const=(C1.*magp);
den=mag+const;
A1 = (KW./den).*F111;
A2 = (KW./den).*F222;
A3 = (KW./den).*F333;

out(:,:,1) = ifft2(A1);
out(:,:,1)=abs(out(:,:,1));
out1=out(:,:,1);

out(:,:,2) = ifft2(A2) ;
out(:,:,2)=abs(out(:,:,2));
out2=out(:,:,2);

out(:,:,3) = ifft2(A3);
out(:,:,3)=abs(out(:,:,3));
out3=out(:,:,3);

figure;subplot(1,2,1);imshow(a);title('Original image');
subplot(1,2,2);imshow(out);title('Restored output');