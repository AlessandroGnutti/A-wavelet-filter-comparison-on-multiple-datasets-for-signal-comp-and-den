clear
close all
clc

load('Out/HD images/gray16bit/Ris_2.mat')

R = squeeze(bpp_tab(:,1,:))';
R(R==0) = [];
D = squeeze(psnr_tab(:,1,:))';
D(D==0) = [];

wh = 1:size(R,2);
BD = 'dsnr';
% if strcmp(BD,'dsnr')
%     min_int = max(min(log(R(:,wh)),[],2));
%     max_int = min(max(log(R(:,wh)),[],2));
% %     min_int = max(min(R(:,wh),[],2));
% %     max_int = min(max(R(:,wh),[],2));
% elseif strcmp(BD,'rate')
%     min_int = max(min(D(:,wh),[],2));
%     max_int = min(max(D(:,wh),[],2));
% end

v_bjo = zeros(1, size(D,1));
for i = 2:size(D,1)
    v_bjo(i) = bjontegaard2(R(1,wh),D(1,wh),R(i,wh),D(i,wh),BD);
end
[v_bjo_sorted, v_winner] = sort(v_bjo, 'descend');