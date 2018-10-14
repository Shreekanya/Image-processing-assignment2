function Weinerfilter_output = Weinerfilter(K1,magK1,G,m,n,k)

%conjugate of the kernel
K_conjugate = conj(K1);
C1=k.*ones(m,n);
%taking magnitude of the kernel
magofkernel = magK1.*magK1;
%design of weiner filter
den=C1+magofkernel;
Weinerfilter_output = (K_conjugate./den).*G;