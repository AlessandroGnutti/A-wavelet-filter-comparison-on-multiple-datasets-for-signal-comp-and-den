% Utilizzo pacchetto 'wcompress'

clear
close all
clc

%%%%% Parameters %%%%%
% v_wname = {'bior1.1', 'bior1.3', 'bior1.5', 'bior2.2', 'bior2.4', 'bior2.6', 'bior2.8',...
%     'bior3.1', 'bior3.3', 'bior3.5', 'bior3.7', 'bior3.9', 'bior4.4', 'bior5.5', 'bior6.8',...
%     'db1', 'db2', 'db3', 'db4', 'db5', 'db10',...
%     'coif1', 'coif2', 'coif3', 'coif4', 'coif5'};
v_wname = {'bior3.1'};

% Dataset
dim = 1024;
% D = strcat('SD images/misc/', num2str(dim), 'x', num2str(dim), '/');
D = strcat('HD images/gray16bit/');
frm = '*.pgm';
folder_dataset = strcat('Dataset/', D);
listing = dir(strcat(folder_dataset, frm));

var_gauss = 0.03:0.01:0.05;
psnr_tab = zeros(length(var_gauss), length(listing), length(v_wname));
ssim_tab = zeros(length(var_gauss), length(listing), length(v_wname));
for i = 3%length(listing)
    str_img = listing(i).name;
    x = imread(strcat(folder_dataset, str_img));
    if length(size(x))==3
        x = rgb2gray(x);
    end
%     x = x(1:dim,1:dim); % Aggiunto per tagliare immagine in maniera da ridurre computazione e fissare dimensione
    [thr,sorh,keepapp] = ddencmp('den','wv',double(x));
    for w = 1:length(v_wname)
        L_max = wmaxlev([dim, dim], v_wname{w});
        for q = 1:length(var_gauss)
            fprintf('Image = %d - w_filter = %s - q = %d\n', i, v_wname{w}, q)
            y = imnoise(x,'gaussian',0,var_gauss(q));
            xden = wdencmp('gbl', double(y), v_wname{w}, L_max+2, thr, sorh, keepapp);
            mse_ = sum((double(x(:))-xden(:)).^2)/numel(x);
            psnr_tab(q, i, w) = 20*log10((2^16-1)/sqrt(mse_));
            ssim_tab(q, i, w) = ssim(xden, double(x));
            fprintf('psnr = %f - ssim = %f\n', psnr_tab(q, i, w), ssim_tab(q, i, w));
        end
    end
end
% my_plot_den_2(psnr_tab, ssim_tab, var_gauss, v_wname, D)
% save(strcat('Out/', D, 'Den_2.mat'), 'psnr_tab', 'ssim_tab', 'var_gauss', 'v_wname')