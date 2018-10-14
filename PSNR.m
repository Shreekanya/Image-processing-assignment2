function PSNRval = PSNR(original,out)
%calculating psnr   
mse = mean(mean((im2double(original) - im2double(out)).^2, 1), 2);
PSNRval = 10 * log10(1 ./ mean(mse,3));
