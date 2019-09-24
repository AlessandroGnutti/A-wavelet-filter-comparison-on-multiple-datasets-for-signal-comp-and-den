function [] = my_plot_den1D(Er_tab, v_SNR, v_wname, D)

addpath('altmany-export_fig-a0f8ec3\');

% tratteggio = {'-o', '-+', '-*', '-x', '-s'};
colore = distinguishable_colors(20); % 10x3 color list

folder_out = strcat('Out/', D);

% Plotta la curva bpp-PSNR per ogni livello per ogni wavelet
Er_tab = mean(Er_tab, 3); % Media sui dati
for k = 1:size( Er_tab, 4)
    figure
    hold on
    for i = 1:size(Er_tab, 1)
        a = v_SNR;
        b = squeeze(Er_tab(i,:,1,k))';
        b(b==0) = [];
        if isempty(b)
            continue
        end
        plot(a, b, '-o', 'color', colore(i,:), 'linewidth', 1.3,...
            'DisplayName', [num2str(i) ' dec. lev.'])
        legend(gca,'show','location', 'northeast')
        grid on
        xlabel('SNR'), ylabel('MSE')
%         set(gcf, 'Color', 'None')
%         set(gca, 'Color', 'None')
        set(gca,'fontsize', 14);
    end
%     export_fig(strcat(folder_out,v_wname{k},'.pdf'))
%     close all
end