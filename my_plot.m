function [] = my_plot(psnr_tab, ssim_tab, bpp_tab, cr_tab, v_wname, D)

addpath('altmany-export_fig-a0f8ec3\');

% tratteggio = {'-o', '-+', '-*', '-x', '-s'};
colore = distinguishable_colors(20); % 10x3 color list

folder_out = strcat('Out/', D);

% Plotta la curva bpp-PSNR per ogni livello per ogni wavelet
for k = 1:size( psnr_tab, 4)
    figure
    hold on
    for i = 1:size(psnr_tab, 1)
        a = squeeze(bpp_tab(i,:,1,k))';
        a(a==0) = [];
        b = squeeze(ssim_tab(i,:,1,k))';
        b(b==0) = [];
        plot(a, b, '-o', 'color', colore(i,:), 'linewidth', 1.3,...
            'DisplayName', [num2str(i) ' dec. lev.'])
        legend(gca,'show','location', 'southeast')
        grid on
        xlabel('bpp'), ylabel('PSNR')
%         set(gcf, 'Color', 'None')
%         set(gca, 'Color', 'None')
        set(gca,'fontsize', 14);
    end
%     export_fig(strcat(folder_out,v_wname{k},'.pdf'))
%     close all
end