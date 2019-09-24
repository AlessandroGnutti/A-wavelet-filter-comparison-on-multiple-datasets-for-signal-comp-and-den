% Utilizzo pacchetto 'wcompress'

clear
close all
clc

%%%%% Parameters %%%%%
numberThresholds = 9;
v_wname = {'bior1.1', 'bior1.3', 'bior1.5', 'bior2.2', 'bior2.4', 'bior2.6', 'bior2.8',...
    'bior3.1', 'bior3.3', 'bior3.5', 'bior3.7', 'bior3.9', 'bior4.4', 'bior5.5', 'bior6.8',...
    'db1', 'db2', 'db3', 'db4', 'db5', 'db10',...
    'coif1', 'coif2', 'coif3', 'coif4', 'coif5'};
dim = 2^14;
L_max = 0;
for w = 1:length(v_wname)
    L_max = max(L_max, wmaxlev(dim, v_wname{w}));
end

% Dataset
D = strcat('Set Audio/');
frm = '*.wav';
folder_dataset = strcat('Dataset/', D);
listing = dir(strcat(folder_dataset, frm));

Er_tab = zeros(L_max, numberThresholds, length(listing), length(v_wname));
perc_tab = zeros(L_max, numberThresholds, length(listing), length(v_wname));
for i = 1:length(listing)
    str_audio = listing(i).name;
    fprintf('Image = %s\n', str_audio)
    x = audioread(strcat(folder_dataset, str_audio));
    x = mean(x,2);
    x = transpose(x);
    x = x(1:dim);
%     x = x(1:dim); % Aggiunto per tagliare immagine in maniera da ridurre computazione e fissare dimensione
    [thr,sorh,keepapp] = ddencmp('cmp','wv',x);    
    v_thresholds = linspace(thr, thr*10, numberThresholds);
    for w = 1:length(v_wname)
        L_max = wmaxlev(dim, v_wname{w});
        v_levels = 1:L_max;
        for q = 1:length(v_thresholds)
            for l = 1:length(v_levels)
                [xc,cxc,~,PERF0,PERFL2] = wdencmp('gbl', x, v_wname{w}, v_levels(l), v_thresholds(q), sorh, keepapp);
                Er_tab(l, q, i, w) = PERFL2;
                perc_tab(l, q, i, w) = PERF0;
            end
        end
    end
end
% my_plot_1D(Er_tab, perc_tab, v_wname, D)
% save(strcat('Out/', D, 'Ris.mat'), 'Er_tab', 'perc_tab', 'v_wname')