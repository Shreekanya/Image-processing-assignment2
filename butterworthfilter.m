function butterworth_out = butterworthfilter(F,m,n,Do,order)

H=zeros(m,n);%creating a low pass filter of image dimensions
D=zeros(m,n);%distance matrix
for u=0: m-1
    for v=0:n-1
        D(u+1,v+1) = ((u-m/2)^2 + (v-n/2)^2)^0.5;
        H(u+1,v+1)=1/(1+(D(u+1,v+1)/Do)^(2*order));
    end
end
figure;imshow(H);title('Butterworth mask function');
butterworth_out=F.*H;% multiplying dft by filter functon lpf