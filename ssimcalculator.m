function ssimcalculated = ssimcalculator(original,out)

%calculating ssim
original=im2double(original);
out=im2double(out);
m_original = mean(original(:));
m_out = mean(out(:));
[m n]=size(original);
one= ones(m,n);
var_original= var(original(:));
var_out= var(out(:));
covariance =cov([original(:),out(:)]);
stddev_original = var_original ^ 0.5;
stddev_out = var_out ^ 0.5;
K(1) = 0.01;
K(2) = 0.03;
L = 1;
C1 =(K(1)*L)^2;
C2=(K(2)*L)^2;
C3=C2/2;
ssimcalculated= (2*m_original*m_out + C1)*(2*covariance(2)+C2)/((m_original^2 + m_out^2 +C1)*(var_original + var_out + C2));

ssimval = ssim(original,out);
disp('Value of ssim with builtin function : ');
disp(ssimval);