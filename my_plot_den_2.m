function [] = my_plot_den_2(psnr_tab, ssim_tab, var_gauss, v_wname, D)

addpath('altmany-export_fig-a0f8ec3\');

% tratteggio = {'-o', '-+', '-*', '-x', '-s'};
colore = distinguishable_colors(30); % 10x3 color list

folder_out = strcat('Out/', D);

% Plotta la curva bpp-PSNR per ogni livello per ogni wavelet
figure
hold on
for k = 1:size( psnr_tab, 3)
    
    
    a = var_gauss;
    b = squeeze(psnr_tab(:,1,k))';
    b(b==0) = [];
    plot(a, b, '-o', 'color', colore(k,:), 'linewidth', 1.3,...
        'DisplayName', [v_wname{k}])
    legend(gca,'show','location', 'southeast')
    
end
grid on
xlabel('Variance of Gaussian noise'), ylabel('PSNR')
%         set(gcf, 'Color', 'None')
%         set(gca, 'Color', 'None')
set(gca,'fontsize', 14);

%     export_fig(strcat(folder_out,v_wname{k},'.pdf'))
%     close all