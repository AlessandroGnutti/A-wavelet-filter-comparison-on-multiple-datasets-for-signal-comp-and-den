function [] = my_plot_1D_2(Er_tab, perc_tab, v_wname, D)

addpath('altmany-export_fig-a0f8ec3\');

% tratteggio = {'-o', '-+', '-*', '-x', '-s'};
colore = distinguishable_colors(30); % 10x3 color list

folder_out = strcat('Out/', D);

% Plotta la curva bpp-PSNR per ogni livello per ogni wavelet
perc_tab = mean(perc_tab, 2); % Media sui dati
Er_tab = mean(Er_tab, 2); % Media sui dati
figure
hold on
for k = 1:size( Er_tab, 3)
    a = squeeze(perc_tab(:,1,k))';
    a(a==0) = [];
    b = squeeze(Er_tab(:,1,k))';
    b(b==0) = [];
    plot(a, b, '-o', 'color', colore(k,:), 'linewidth', 1.3,...
        'DisplayName', [v_wname{k}])
end
legend(gca,'show','location', 'southwest')
grid on
xlabel('C_s'), ylabel('E_r')
%         set(gcf, 'Color', 'None')
%         set(gca, 'Color', 'None')
set(gca,'fontsize', 14);
%     export_fig(strcat(folder_out,v_wname{k},'.pdf'))
%     close all