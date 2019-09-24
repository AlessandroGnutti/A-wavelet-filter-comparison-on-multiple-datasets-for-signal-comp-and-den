function [] = my_plot_2(psnr_tab, ssim_tab, bpp_tab, cr_tab, v_wname, D, v_winner)

addpath('altmany-export_fig-a0f8ec3\');

% tratteggio = {'-o', '-+', '-*', '-x', '-s'};
colore = distinguishable_colors(30); % 10x3 color list
tratteggio = {'-','--','-.',':'};

folder_out = strcat('Out/', D);

% Plotta la curva bpp-PSNR per ogni livello per ogni wavelet
figure
hold on
count = 1;
for k = [1 2 size(psnr_tab, 3)-1 size(psnr_tab, 3)]%1:size(psnr_tab, 3)
% for k = 1:size(psnr_tab, 3)
    
    
    a = squeeze(bpp_tab(:,1,v_winner(k)))';
    a(a==0) = [];
    b = squeeze(psnr_tab(:,1,v_winner(k)))';
    b(b==0) = [];
    plot(a, b, tratteggio{count},'linewidth', 1.2,...
        'DisplayName', [v_wname{v_winner(k)}])
    legend(gca,'show','location', 'southeast')
    count = count + 1;
    
end
grid on
xlabel('bpp'), ylabel('PSNR')
%         set(gcf, 'Color', 'None')
%         set(gca, 'Color', 'None')
set(gca,'fontsize', 14);

%     export_fig(strcat(folder_out,v_wname{k},'.pdf'))
%     close all