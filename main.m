% Utilizzo pacchetto 'wcompress'

clear
close all
clc

%%%%% Parameters %%%%%
v_compressionMethods = {'ezw'};
v_numberStepsCompression = 2:2:20;
% v_numberStepsCompression = 2:8;
% v_cr = 1:5:50;
% v_bpp = 0.2:0.2:2;
v_wname = {'bior1.1', 'bior1.3', 'bior1.5', 'bior2.2', 'bior2.4', 'bior2.6', 'bior2.8',...
    'bior3.1', 'bior3.3', 'bior3.5', 'bior3.7', 'bior3.9', 'bior4.4', 'bior5.5', 'bior6.8',...
    'db1', 'db2', 'db3', 'db4', 'db5', 'db10',...
    'coif1', 'coif2', 'coif3', 'coif4', 'coif5'};
dim = 2048;
L_max =0;
for w = 1:length(v_wname)
    L_max = max(L_max, wmaxlev([dim, dim], v_wname{w}));
end

% Dataset
% D = strcat('SD images/misc/', num2str(dim), 'x', num2str(dim), '/');
D = strcat('HD images/gray16bit/');
frm = '*.pgm';
folder_dataset = strcat('Dataset/', D);
listing = dir(strcat(folder_dataset, frm));

psnr_tab = zeros(L_max, length(v_numberStepsCompression), length(listing), length(v_wname));
ssim_tab = zeros(L_max, length(v_numberStepsCompression), length(listing), length(v_wname));
bpp_tab = zeros(L_max, length(v_numberStepsCompression), length(listing), length(v_wname));
cr_tab = zeros(L_max, length(v_numberStepsCompression), length(listing), length(v_wname));
count = 0;
for i = 1:1%length(listing)
    str_img = listing(i).name;
    x = imread(strcat(folder_dataset, str_img));
    if length(size(x))==3
        x = rgb2gray(x);
    end
    x = x(end-dim+1:end,end-dim+1:end); % Aggiunto per tagliare immagine in maniera da ridurre computazione e fissare dimensione
    for w = 1:length(v_wname)
        L_max = wmaxlev([dim, dim], v_wname{w});
        v_levels = 1:L_max;
        for q = 1:length(v_numberStepsCompression)
            for l = 1:length(v_levels)
                fprintf('Image = %d - w_filter = %s - q = %d - lev = %d\n', i, v_wname{w}, q, l)
                count = count + 1;
                [cr, bpp] = wcompress('c', x, strcat(num2str(count), '.wtc'),...
                    v_compressionMethods{1}, 'wname', v_wname{w}, 'level', v_levels(l),...
                    'maxloop', v_numberStepsCompression(q));
                
                s = dir(strcat(num2str(count), '.wtc'));
                my_bpp = s.bytes*8/numel(x);
                my_cr = numel(x)/s.bytes;
%                 fprintf('bpp di wcompress = %.2f - bpp mio = %.2f\ncr di wcompress = %.2f - cr mio = %.2f\n',...
%                     bpp, my_bpp, cr, my_cr)
                bpp_tab(l, q, i, w) = my_bpp;
                cr_tab(l, q, i, w) = my_cr;
                
                xc = wcompress('u', strcat(num2str(count), '.wtc'));
                
                mse_val = sum((double(x(:))-double(xc(:))).^2)/numel(x);
                psnr_tab(l, q, i, w) = 20*log10((2^16-1)/sqrt(mse_val));
                ssim_tab(l, q, i, w) = ssim(xc, double(x));
                clear xc bpp cr mse_val
            end
        end
        delete('*.wtc')
    end
end
% my_plot(psnr_tab, ssim_tab, bpp_tab, cr_tab, v_wname, D)
% save(strcat('Out/', D, 'Ris.mat'), 'psnr_tab', 'ssim_tab', 'bpp_tab', 'cr_tab', 'v_wname')