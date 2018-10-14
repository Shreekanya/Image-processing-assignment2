function IDFTofimage = IDFTfunct(image,m,n)
%calculating IDFT
wM1  = zeros(m, m);
wN1   = zeros(n, n);
for x1 = 0 : (m - 1)
    for u1 = 0 : (m - 1)
        wM1(x1+1, u1+1) = exp(2 * pi * 1i / m * x1 * u1);
    end    
end
for y1 = 0 : (n - 1)
    for v1 = 0 : (n - 1)
        wN1(v1+1, y1+1) = exp(2 * pi * 1i / n * y1 * v1);
    end    
end
IDFT = wM1 * image * wN1/(m*n);
mag_IDFT=abs(IDFT);
IDFTofimage = ifftshift(mag_IDFT);