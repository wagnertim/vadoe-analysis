clear all
close all


load zgrid;
load new_sonde_woedl_comps_with_new_z

cols=[0 33 71; 255 126 0; 245 189 31]./255;


%  Start with some quality control.

dl.u(abs(dl.u)>50)=NaN;
dl.v(abs(dl.v)>50)=NaN;

woedl.u(abs(woedl.u)>50)=NaN;
woedl.v(abs(woedl.v)>50)=NaN;

woedl.u(woedl.err.u>5)=NaN;
woedl.v(woedl.err.v>5)=NaN;


dl.u(1,:)=NaN;
dl.v(1,:)=NaN;

dif.dl.u = dl.u-sonde.u;
dif.dl.v = dl.v-sonde.v;

ud=dif.dl.u;
vd=dif.dl.v;

dif.woedl.u = woedl.u-sonde.u;
dif.woedl.v = woedl.v-sonde.v;

dif.dl.u=sdtrim(dif.dl.u,3);
dif.dl.v=sdtrim(dif.dl.v,3);

dif.woedl.u=sdtrim(dif.woedl.u,3);
dif.woedl.v=sdtrim(dif.woedl.v,3);

% woedl.u(isnan(dif.woedl.u))=NaN;
% woedl.v(isnan(dif.woedl.v))=NaN;
% 
% dl.u(isnan(dif.dl.u))=NaN;
% dl.v(isnan(dif.dl.v))=NaN;




[woedl.spd, woedl.dir]=uv2sd(woedl.u, woedl.v);
[sonde.spd, sonde.dir]=uv2sd(sonde.u, sonde.v);
[dl.spd, dl.dir]=uv2sd(dl.u, dl.v);

dif.dl.spd = dl.spd-sonde.spd;
dif.dl.dir = dl.dir-sonde.dir;

dif.woedl.spd = woedl.spd-sonde.spd;
dif.woedl.dir = woedl.dir-sonde.dir;

dif.dl.dir(dif.dl.dir>180)=dif.dl.dir(dif.dl.dir>180)-180;
dif.woedl.dir(dif.woedl.dir>180)=dif.woedl.dir(dif.woedl.dir>180)-180;

dif.dl.dir(dif.dl.dir<-180)=dif.dl.dir(dif.dl.dir<-180)+180;
dif.woedl.dir(dif.woedl.dir<-180)=dif.woedl.dir(dif.woedl.dir<-180)+180;

vd_


binEdge = [-20-.01/2:0.01:20+.01/2];
plotEdge = [-20:0.01:20];

wCountU = histcounts(woedl.u(:)-sonde.u(:),binEdge);
wCountV = histcounts(woedl.v(:)-sonde.v(:),binEdge);

dCountU = histcounts(dl.u(:)-sonde.u(:),binEdge);
dCountV = histcounts(dl.v(:)-sonde.v(:),binEdge);

wCountU1 = histcounts(woedl.u(~isnan(dl.u))-sonde.u(~isnan(dl.u)),binEdge);
wCountV1 = histcounts(woedl.v(~isnan(dl.v))-sonde.v(~isnan(dl.v)),binEdge);

f1=figure;
f1.Position = [1 1 1400 900];
f1.Visible='off';

subplot(1,2,1)
h1=plot(plotEdge, dCountU./sum(dCountU),'linewidth',3);
hold on
h2=plot(plotEdge, wCountU./sum(wCountU),'linewidth',3);
h3=plot(plotEdge, wCountU1./sum(wCountU1),'linewidth',3);
grid on
grid minor

xlabel('Lidar Minus Sonde [m s^{-1}]');
ylabel('Probabilitiy')
title('u Difference PDF')
legend([h1 h2 h3],{'DL','All OE','OE w/valid DL'})
set(gca,'fontsize',28)




subplot(1,2,2)
h1=plot(plotEdge, dCountV./sum(dCountV),'linewidth',3);
hold on
h2=plot(plotEdge, wCountV./sum(wCountV),'linewidth',3);
h3=plot(plotEdge, wCountV1./sum(wCountV1),'linewidth',3);
grid on
grid minor

xlabel('Lidar Minus Sonde [m s^{-1}]');
ylabel('Probabilitiy')
title('v Difference PDF')
legend([h1 h2 h3],{'DL','All OE','OE w/valid DL'})
set(gca,'fontsize',28)


% f1=figure;
% f1.Position = [1 1 1400 900];
% 
% 
% 
% subplot(1,2,1) 
% h1=plot(nanmean(dl.u - sonde.smooth.u,2),zgrid,'linewidth',3,'color',cols(1,:));
% grid on
% grid minor
% set(gca,'fontsize',28)
% hold on
% h2=plot(nanmean(woedl.u - sonde.smooth.u,2),zgrid,'linewidth',3,'color',cols(2,:));
% wu2=woedl.u;
% wu2(~isnan(dl.u))=NaN;
% 
% 
% plot(nanstd(dl.u - sonde.u,1,2),zgrid,'--','linewidth',3,'color',cols(1,:))
% plot(nanstd(woedl.u - sonde.u,1,2),zgrid,'--','linewidth',3,'color',cols(2,:))
% 
% 
% ylim([0 3000])
% 
% 
% subplot(1,2,2) 
% h1=plot(nanmean(dl.v - sonde.smooth.v,2),zgrid,'linewidth',3,'color',cols(1,:));
% grid on
% grid minor
% set(gca,'fontsize',28)
% hold on
% h2=plot(nanmean(woedl.v - sonde.smooth.v,2),zgrid,'linewidth',3,'color',cols(2,:));
% wv2=woedl.v;
% wv2(~isnan(dl.u))=NaN;
% 
% 
% plot(nanstd(dl.v - sonde.v,1,2),zgrid,'--','linewidth',3,'color',cols(1,:))
% plot(nanstd(woedl.v - sonde.v,1,2),zgrid,'--','linewidth',3,'color',cols(2,:))
% 
% ylim([0 3000])
% 
% 
% 
% 
% %  Let's create some wind speeds now.
% 
% [dl.ws,dl.wd] = uv2sd(dl.u, dl.v);
% [woedl.ws,woedl.wd] = uv2sd(woedl.u, woedl.v);
% [sonde.ws,sonde.wd] = uv2sd(sonde.u, sonde.v);
% 
% %  Now, find the number of observations as a function of height.
% 
% dl.ws(1,:)=NaN;
% 
% dlObsCount = sum(~isnan(dl.ws),2);
% woedlObsCount = sum(~isnan(woedl.ws),2);
% 
% dlObsCount(1) = NaN;
% 
% f1=figure;
% f1.Position = [1 1 800 900];
% 
% plot(dlObsCount,zgrid,'linewidth',4);
% hold on
% plot(woedlObsCount,zgrid,'linewidth',4);
% grid on
% grid minor
% set(gca,'fontsize',24)
% xlabel('Number of Valid Observations')
% ylabel('Height')
% ylim([0 3000])
% xlim([0 1800])
% title('Valid Observations by Height')
% 
% 
% save('numobs','dlObsCount','zgrid','woedlObsCount')
% 
% f1 = figure;
% f1.Position = [1 1 800 900];
% plot(nanmean(dl.ws - sonde.ws,2),zgrid,'linewidth',3);
% hold on
% grid on 
% grid minor
% plot(nanmean(woedl.ws - sonde.ws,2),zgrid,'linewidth',3);
% set(gca,'fontsize',28)




% f1=figure;
% f1.Position=[1 1 1400 800];
% 
% mn ={'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct',...
%     'Nov','Dec'};
% 
% b1=[1 121 229 347 493 712 938 1137 1247 1360 1484 1594];
% b2=[120 228 346 492 711 937 1136 1246 1359 1483 1593 1683];
% 
% 
% for i=1:12
%     
%     subplot(3,4,i)
%     plot(woedl.u(:,b1(i):b2(i)),zgrid)
%     grid on, grid minor
%     set(gca,'fontsize',20)
%     title(mn{i})
%     ylim([0 3000])
%     xlim([-70 70])
%     
% end




f1=figure;
f1.Position = [1 1 1400 900];

f1.Visible='off';

subplot(2,3,1)
scatter(sonde.u(:), dl.u(:),8,'ko','filled','markeredgealpha',0.2,'markerfacealpha',0.2)
grid on
grid minor
xlabel('Sonde u [m s^{-1}]')
ylabel('TRAD u [m s^{-1}]')
set(gca,'fontsize',24,'xtick',[-30:10:30],'ytick',[-30:10:30])
hold on
plot([-30 30],[-30 30],'r:','linewidth',2)
xlim([-30 30])
ylim([-30 30])

r=corrcoef([sonde.u(:), dl.u(:)],'rows','pairwise');
text(-25, 20, ['r = ',num2str(round(r(1,2),3))],'fontsize',26);
title('a) Sonde vs. TRAD: u')

subplot(2,3,2)
scatter(sonde.u(:), woedl.u(:),8,'ko','filled','markeredgealpha',0.2,'markerfacealpha',0.2)
grid on
grid minor
xlabel('Sonde u [m s^{-1}]')
ylabel('OE u [m s^{-1}]')
set(gca,'fontsize',24,'xtick',[-30:10:30],'ytick',[-30:10:30])
hold on
xlim([-30 30])
ylim([-30 30])

r=corrcoef([sonde.u(:), woedl.u(:)],'rows','pairwise');
text(-25, 25, ['r = ',num2str(round(r(1,2),3))],'fontsize',26);

wu2 = woedl.u;
wu2(isnan(dl.u))=NaN;

scatter(sonde.u(:), wu2(:),8,[ 255 126 0]./255,'o','filled','markeredgealpha',0.2,'markerfacealpha',0.2)
plot([-30 30],[-30 30],'r:','linewidth',2)

r=corrcoef([sonde.u(:), wu2(:)],'rows','pairwise');
text(-25, 19, ['r = ',num2str(round(r(1,2),3))],'fontsize',26,'color',[ 255 126 0]./255);


title('b) Sonde vs. OE: u')



subplot(2,3,3)
scatter(dl.u(:), woedl.u(:),8,'ko','filled','markeredgealpha',0.2,'markerfacealpha',0.2)
grid on
grid minor
xlabel('TRAD u [m s^{-1}]')
ylabel('OE u [m s^{-1}]')
set(gca,'fontsize',24,'xtick',[-30:10:30],'ytick',[-30:10:30])
hold on
plot([-30 30],[-30 30],'r:','linewidth',2)
xlim([-30 30])
ylim([-30 30])

r=corrcoef([woedl.u(:), dl.u(:)],'rows','pairwise');
text(-25, 20, ['r = ',num2str(round(r(1,2),3))],'fontsize',26);
title('c) TRAD vs. OE: u')












subplot(2,3,4)
scatter(sonde.v(:), dl.v(:),8,'ko','filled','markeredgealpha',0.2,'markerfacealpha',0.2)
grid on
grid minor
xlabel('Sonde v [m s^{-1}]')
ylabel('TRAD v [m s^{-1}]')
set(gca,'fontsize',24,'xtick',[-30:10:30],'ytick',[-30:10:30])
hold on
plot([-30 30],[-30 30],'r:','linewidth',2)
xlim([-30 30])
ylim([-30 30])

r=corrcoef([sonde.v(:), dl.v(:)],'rows','pairwise');
text(-25, 20, ['r = ',num2str(round(r(1,2),3))],'fontsize',26);
title('d) Sonde vs. TRAD: v')




subplot(2,3,5)
scatter(sonde.v(:), woedl.v(:),8,'ko','filled','markeredgealpha',0.2,'markerfacealpha',0.2)
grid on
grid minor
xlabel('Sonde v [m s^{-1}]')
ylabel('OE v [m s^{-1}]')
set(gca,'fontsize',24,'xtick',[-30:10:30],'ytick',[-30:10:30])
hold on
xlim([-30 30])
ylim([-30 30])

r=corrcoef([sonde.v(:), woedl.v(:)],'rows','pairwise');
text(-25, 25, ['r = ',num2str(round(r(1,2),3))],'fontsize',26);

wv2 = woedl.v;
wv2(isnan(dl.v))=NaN;

scatter(sonde.v(:), wv2(:),8,[ 255 126 0]./255,'o','filled','markeredgealpha',0.2,'markerfacealpha',0.2)
plot([-30 30],[-30 30],'r:','linewidth',2)

r=corrcoef([sonde.v(:), wv2(:)],'rows','pairwise');
text(-25, 19, ['r = ',num2str(round(r(1,2),3))],'fontsize',26,'color',[ 255 126 0]./255);


title('e) Sonde vs. OE: v')












subplot(2,3,6)
scatter(dl.v(:), woedl.v(:),8,'ko','filled','markeredgealpha',0.2,'markerfacealpha',0.2)
grid on
grid minor
xlabel('TRAD v [m s^{-1}]')
ylabel('OE v [m s^{-1}]')
set(gca,'fontsize',24,'xtick',[-30:10:30],'ytick',[-30:10:30])
hold on
plot([-30 30],[-30 30],'r:','linewidth',2)
xlim([-30 30])
ylim([-30 30])

r=corrcoef([woedl.v(:), dl.v(:)],'rows','pairwise');
text(-25, 20, ['r = ',num2str(round(r(1,2),3))],'fontsize',26);
title('f) TRAD vs. OE: v')


saveas(gcf,'six_panel_scatter_plots','png')