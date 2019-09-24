function [] = my_plot_den1D_2(Er_tab, v_SNR, v_wname, D)

addpath('altmany-export_fig-a0f8ec3\');

% tratteggio = {'-o', '-+', '-*', '-x', '-s'};
colore = distinguishable_colors(30); % 10x3 color list

folder_out = strcat('Out/', D);

% Plotta la curva bpp-PSNR per ogni livello per ogni wavelet
Er_tab = mean(Er_tab, 2); % Media sui dati
figure
hold on
for k = 1:size( Er_tab, 3)
    a = v_SNR;
    b = squeeze(Er_tab(:,1,k))';
    b(b==0) = [];
    if isempty(b)
        continue
    end
    plot(a, b, '-o', 'color', colore(k,:), 'linewidth', 1.3,...
        'DisplayName', [v_wname{k}])
    legend(gca,'show','location', 'northeast')
end
grid on
xlabel('SNR'), ylabel('MSE')
%         set(gcf, 'Color', 'None')
%         set(gca, 'Color', 'None')
set(gca,'fontsize', 14);
%     export_fig(strcat(folder_out,v_wname{k},'.pdf'))
%     close all