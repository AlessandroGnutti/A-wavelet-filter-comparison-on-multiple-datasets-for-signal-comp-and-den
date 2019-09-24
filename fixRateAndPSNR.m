clear
close all
clc

load('Out/HD images/gray8bit/Ris_2.mat')

R = squeeze(bpp_tab(:,1,:))';
R(R==0) = [];
D = squeeze(psnr_tab(:,1,:))';
D(D==0) = [];

wh = 1:4;

R = R(:,wh);
D = D(:,wh);

minimo = min(R(:));
massimo = max(R(:));

points_to_evaluate = linspace(minimo, massimo,length(wh));

new_R = repmat(points_to_evaluate,size(R,1),1);
new_D = zeros(size(D));
for i = 1:size(R,1)
    p = polyfit(R(i,:),D(i,:),3);
    new_D(i,:) = polyval(p, points_to_evaluate);
end

% Bjontegard
R = new_R;
D = new_D;

BD = 'dsnr';
if strcmp(BD,'dsnr')
    min_int = max(min(log(R(:,wh)),[],2));
    max_int = min(max(log(R(:,wh)),[],2));
%     min_int = max(min(R(:,wh),[],2));
%     max_int = min(max(R(:,wh),[],2));
elseif strcmp(BD,'rate')
    min_int = max(min(D(:,wh),[],2));
    max_int = min(max(D(:,wh),[],2));
end

v_bjo = zeros(1, size(D,1));
for i = 2:size(D,1)
    v_bjo(i) = bjontegaard2_multipleRDcurves(R(1,wh),D(1,wh),R(i,wh),D(i,wh),...
        min_int,max_int,BD);
end
[v_bjo_sorted, v_winner] = sort(v_bjo, 'descend');