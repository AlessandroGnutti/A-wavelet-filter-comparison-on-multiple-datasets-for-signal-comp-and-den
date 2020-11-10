% Utilizzo pacchetto 'wcompress'

clear
close all
clc

%%%%% Parameters %%%%%
v_wname = {'bior1.1', 'bior1.3', 'bior1.5', 'bior2.2', 'bior2.4', 'bior2.6', 'bior2.8',...
    'bior3.1', 'bior3.3', 'bior3.5', 'bior3.7', 'bior3.9', 'bior4.4', 'bior5.5', 'bior6.8',...
    'db1', 'db2', 'db3', 'db4', 'db5', 'db10',...
    'coif1', 'coif2', 'coif3', 'coif4', 'coif5', 'spf2', 'spf4', 'spf6'};

% Dataset
dim = 2048;
% D = strcat('SD images/misc/', num2str(dim), 'x', num2str(dim), '/');
D = strcat('HD images/gray16bit/');
frm = '*.pgm';
folder_dataset = strcat('Dataset/', D);
listing = dir(strcat(folder_dataset, frm));

L_max =0;
for w = 1:length(v_wname)
    L_max = max(L_max, wmaxlev([dim, dim], v_wname{w}));
end

var_gauss = 0.03:0.01:0.05;
psnr_tab = zeros(L_max, length(var_gauss), length(listing), length(v_wname));
ssim_tab = zeros(L_max, length(var_gauss), length(listing), length(v_wname));
num_realizations = 100;
for i = 1%length(listing)
    str_img = listing(i).name;
    x = imread(strcat(folder_dataset, str_img));
    if length(size(x))==3
        x = rgb2gray(x);
    end
%     x = x(1:dim,1:dim); % Aggiunto per tagliare immagine in maniera da ridurre computazione e fissare dimensione
    for w = 1:length(v_wname) 
        L_max = wmaxlev([dim, dim], v_wname{w});
        v_levels = 1:L_max;
        for q = 1:length(var_gauss)
            for l = 1:length(v_levels)
                fprintf('Image = %d - w_filter = %s - q = %d - lev = %d\n', i, v_wname{w}, q, l)
                my_mse = 0;
                my_ssim = 0;
                for realizations = 1:num_realizations
                    y = imnoise(x,'gaussian',0,var_gauss(q));
                    [C,S] = wavedec2(y,l,v_wname{w});
                    thr = wthrmngr('dw2ddenoLVL','penalhi',C,S,3);
                    xden = wdencmp('lvd', double(y), v_wname{w},  v_levels(l), thr, 's');
                    my_mse = my_mse + sum((double(x(:))-xden(:)).^2)/numel(x);
                    my_ssim = my_ssim + ssim(xden, double(x));
                end
                psnr_tab(l, q, i, w) = 20*log10((2^8-1)/sqrt(my_mse/num_realizations));
                ssim_tab(l, q, i, w) = my_ssim/num_realizations;
                fprintf('psnr = %f - ssim = %f\n', psnr_tab(l,q, i, w), ssim_tab(l,q, i, w));
            end
        end
    end
end
% my_plot_den(psnr_tab, ssim_tab, var_gauss, v_wname, D)
% save(strcat('Out/', D, 'Den_2.mat'), 'psnr_tab', 'ssim_tab', 'var_gauss', 'v_wname')