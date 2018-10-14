function CLSFout = CLSFfunct(K1,C,magK1,m,n,G)
%conjugate of the kernel
K_conjugate = conj(K1);
C1=C.*ones(m,n);
%taking magnitude of the kernel
mag = magK1.*magK1;
%defining the laplacian operator
p = [0 -1 0 0; -1 4 -1 0; 0 -1  0 0; 0 0 0 0];
[rp, cp] = size(p);
p_padding=padarray(p,[((m-rp)/2),((n-cp)/2)],0,'both');    %padding the image
[rp, cp]= size(p_padding);
%dft of P
P = fft2(p_padding);
Puv=fftshift(P);
magP=abs(Puv);
magp=magP.*magP;
%design of constrained least squares filter
const=(C1.*magp);
den=mag+const;
CLSFout = (K_conjugate./den).*G;