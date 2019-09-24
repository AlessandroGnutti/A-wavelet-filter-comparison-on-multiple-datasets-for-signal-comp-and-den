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
dim = 3600;

% Dataset
D = strcat('Set ECG/');
frm = '*.dat';
folder_dataset = strcat('Dataset/', D);
listing = dir(strcat(folder_dataset, frm));

Er_tab = zeros(numberThresholds, length(listing), length(v_wname));
perc_tab = zeros(numberThresholds, length(listing), length(v_wname));
for i = 1:length(listing)
    str_ecg = listing(i).name;
    fprintf('Image = %s\n', str_ecg)
    x = Open_dat(strcat(folder_dataset, str_ecg));
    x = transpose(x);
    [thr,sorh,keepapp] = ddencmp('cmp','wv',x);  
    v_thresholds = linspace(thr, thr*10, numberThresholds);
    for w = 1:length(v_wname)
        L_max = wmaxlev(dim, v_wname{w});
        v_levels = 1:L_max;
        for q = 1:length(v_thresholds)
            [xc,cxc,~,PERF0,PERFL2] = wdencmp('gbl', x, v_wname{w}, L_max, v_thresholds(q), sorh, keepapp);
            Er_tab(q, i, w) = PERFL2;
            perc_tab(q, i, w) = PERF0;
        end
    end
end
temp = Er_tab(Er_tab>0);
min_temp = min(Er_tab(:));
temp2 = (Er_tab-min_temp)*1000;
ciao = temp2 + 100 -max(temp2(:));
my_plot_1D_2(ciao, perc_tab, v_wname, D)
save(strcat('Out/', D, 'Ris_2.mat'), 'Er_tab', 'perc_tab', 'v_wname')