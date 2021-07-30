clearvars -except *_path

load([gcm_data_path 'comp_data']); 
load([repo_path '/Misc/NN_params.mat']);
load([repo_path '/Misc/CESM2_grid.mat']); 

%%
%
horvat_colors
figure(5)
clf; clear Ax; 

unusable = (A_geo_NN <= .1 | A_geo_SP <= .1 | H_geo_NN < .1 | H_geo_SP < .1 ...
    | R_geo_NN == 0 | R_geo_SP == 0); 

A_geo_NN(unusable) = nan; 
A_geo_SP(unusable) = nan; 

H_geo_NN(unusable) = nan; 
H_geo_SP(unusable) = nan; 

R_geo_NN(unusable) = nan; 
R_geo_SP(unusable) = nan; 



NN_SD_A = (A_geo_SP - A_geo_NN);% ./(A_geo_NN + A_geo_SP); 
NN_SD_H = (H_geo_SP - H_geo_NN);% ./(H_geo_NN + H_geo_SP); 
NN_SD_V = (A_geo_SP.*H_geo_SP - A_geo_NN.*H_geo_SP); 
NN_SD_R = log10(R_geo_SP./R_geo_NN);% ./(R_geo_NN + R_geo_SP); 
% SP_1_SD = 2*abs(A_geo_SP_1 - A_geo_SP)./(A_geo_SP_1 + A_geo_SP); 

climmer = [-1 1];
cmapper = cmocean('curl',50);
cmapper(round(size(cmapper,1)/2):round(size(cmapper,1)/2)+1,:) = 1; 

% cmapper(1,:) = 1; 
mo1 = 3; 
mo2 = 9;
arc_lat = [55 90]; 
arc_lon = [-90 100]; 

ant_lat = [-90 -50]; 
ant_lon = [-90 100]; 


%% How large are R discrepancy regions


% WW3_path = [gcm_data_path 'WW3-Forcing/ww3.2005_efreq_daymean.nc'];
% f = ncread(WW3_path,'freq');
% df = f * (sqrt(1.1) - sqrt(1/1.1));
% E = ncread(WW3_path,'efreq');
% E = squeeze(sum(bsxfun(@times,E,permute(df,[2 3 1 4])),3));

%%
% dayvec = datenum(2005,1,1) + (0:364);
% moval = month(dayvec);
% 
% for i = 1:12
%     E_mon(:,:,i) = squeeze(mean(E(:,:,moval==i),3)); 
% end
% 
% inds = find(R_disc); 
R_disc = abs(NN_SD_R) > log10(2); 
Tot_R_disc = squeeze(nansum(nansum(bsxfun(@times,R_disc.*A_geo_SP,grid_area),1),2)); 
% E_disc = E_mon(inds); 

%
Tot_A = squeeze(nansum(nansum(bsxfun(@times,A_geo_SP,grid_area),1),2)); 
Tot_A_diff = squeeze(nansum(nansum(bsxfun(@times,NN_SD_A,grid_area),1),2)); 

Tot_V = squeeze(nansum(nansum(bsxfun(@times,A_geo_SP.*H_geo_SP,grid_area),1),2)); 
Tot_V_diff = squeeze(nansum(nansum(bsxfun(@times,NN_SD_V,grid_area),1),2)); 

%%
latback = -90:90;
lonback = -180:180;

%
Ax{1} = subplot('position',[.035 .665 .2 .3]);
plotter = nanmean(NN_SD_A(:,:,mo1),3); 
worldmap(arc_lat,arc_lon);
h1 = pcolorm(latback,lonback,ones(length(latback),length(lonback)));
set(h1, 'facecolor',[198,219,239]/256)
setm(gca,'parallellabel','off','meridianlabel','off');
setm(gca,'plinevisible','off','mlinevisible','off'); 
pcolorm(lat,lon,plotter); 
hold on
colormap(gca,cmapper); 
plot_coastlines; 
set(gca,'clim',climmer); 
title('March','interpreter','latex'); 
% OO = annotation(gcf,'textbox',[.0125 .675 .0125 .3],...
%         'String','H_{SP} - H_{NN}','LineStyle','none','FontName','Helvetica', ...
%         'FontSize',10,'Tag','legtag','TextRotation',90);
    
annotation(gcf,'textarrow',[.015 .015], [.875 .875],'string','A$_{SP}$ - A$_{NN}$', ...
    'HeadStyle','none','LineStyle', '--', 'TextRotation',90, ...
    'FontName','Helvetica','FontSize',10,'interpreter','latex');

Ax{2} = subplot('position',[.26 .665 .2 .3]);
plotter = nanmean(NN_SD_A(:,:,mo2),3); 
worldmap(arc_lat,arc_lon);
h1 = pcolorm(latback,lonback,ones(length(latback),length(lonback)));
set(h1, 'facecolor',[198,219,239]/256)
setm(gca,'parallellabel','off','meridianlabel','off');
setm(gca,'plinevisible','off','mlinevisible','off'); 
pcolorm(lat,lon,plotter); 
plot_coastlines; 
colormap(gca,cmapper); 
plot_coastlines; 
set(gca,'clim',climmer); 
title('September','interpreter','latex'); 

Ax{3} = subplot('position',[.485 .665 .2 .3]);

plotter = nanmean(NN_SD_A(:,:,mo1),3); 
worldmap(ant_lat,ant_lon);
h1 = pcolorm(latback,lonback,ones(length(latback),length(lonback)));
set(h1, 'facecolor',[198,219,239]/256)
setm(gca,'parallellabel','off','meridianlabel','off');
setm(gca,'plinevisible','off','mlinevisible','off'); 
pcolorm(lat,lon,plotter); 
hold on
colormap(gca,cmapper); 
plot_coastlines; 
set(gca,'clim',climmer); 
title('March','interpreter','latex'); 

Ax{4} = subplot('position',[.71 .665 .2 .3]);

plotter = nanmean(NN_SD_A(:,:,mo2),3); 
worldmap(ant_lat,ant_lon);
h1 = pcolorm(latback,lonback,ones(length(latback),length(lonback)));
set(h1, 'facecolor',[198,219,239]/256)
setm(gca,'parallellabel','off','meridianlabel','off');
setm(gca,'plinevisible','off','mlinevisible','off'); 
pcolorm(lat,lon,plotter); 
plot_coastlines; 
colormap(gca,cmapper); 
plot_coastlines; 
set(gca,'clim',climmer); 
title('September','interpreter','latex'); 

 
Ax{5} = subplot('position',[.035 .34 .2 .3]);

plotter = mean(NN_SD_V(:,:,mo1),3); 
worldmap(arc_lat,arc_lon);
h1 = pcolorm(latback,lonback,ones(length(latback),length(lonback)));
set(h1, 'facecolor',[198,219,239]/256)
setm(gca,'parallellabel','off','meridianlabel','off');
setm(gca,'plinevisible','off','mlinevisible','off'); 
pcolorm(lat,lon,plotter); 
plot_coastlines; 
colormap(gca,cmapper); 
plot_coastlines; 
set(gca,'clim',climmer); 

annotation(gcf,'textarrow',[.015 .015], [.6 .6],'string','V$_{SP}$ - V$_{NN}$ (m)', ...
    'HeadStyle','none','LineStyle', '--', 'TextRotation',90, ...
    'FontName','Helvetica','FontSize',10,'interpreter','latex');

Ax{6} = subplot('position',[.26 .34 .2 .3]);
plotter = mean(NN_SD_V(:,:,mo2),3); 
worldmap(arc_lat,arc_lon);
h1 = pcolorm(latback,lonback,ones(length(latback),length(lonback)));
set(h1, 'facecolor',[198,219,239]/256)
setm(gca,'parallellabel','off','meridianlabel','off');
setm(gca,'plinevisible','off','mlinevisible','off'); 
pcolorm(lat,lon,plotter); 
plot_coastlines; 
colormap(gca,cmapper); 
plot_coastlines; 
set(gca,'clim',climmer); 

Ax{7} = subplot('position',[.485 .34 .2 .3]);
plotter = mean(NN_SD_V(:,:,mo1),3); 
worldmap(ant_lat,ant_lon);
h1 = pcolorm(latback,lonback,ones(length(latback),length(lonback)));
set(h1, 'facecolor',[198,219,239]/256)
setm(gca,'parallellabel','off','meridianlabel','off');
setm(gca,'plinevisible','off','mlinevisible','off'); 
pcolorm(lat,lon,plotter); 
plot_coastlines; 
colormap(gca,cmapper); 
plot_coastlines; 
set(gca,'clim',climmer); 

moplot = 9; 

Ax{8} = subplot('position',[.71 .34 .2 .3]);
plotter = mean(NN_SD_V(:,:,mo2),3); 
worldmap(ant_lat,ant_lon);
h1 = pcolorm(latback,lonback,ones(length(latback),length(lonback)));
set(h1, 'facecolor',[198,219,239]/256)
setm(gca,'parallellabel','off','meridianlabel','off');
setm(gca,'plinevisible','off','mlinevisible','off'); 
pcolorm(lat,lon,plotter); 
plot_coastlines; 
colormap(gca,cmapper); 
plot_coastlines; 
set(gca,'clim',climmer); 





Ax{9} = subplot('position',[.035 .015 .2 .3]);

plotter = mean(NN_SD_R(:,:,mo1),3); 
worldmap(arc_lat,arc_lon);
h1 = pcolorm(latback,lonback,ones(length(latback),length(lonback)));
set(h1, 'facecolor',[198,219,239]/256)
setm(gca,'parallellabel','off','meridianlabel','off');
setm(gca,'plinevisible','off','mlinevisible','off'); 
pcolorm(lat,lon,plotter); 
plot_coastlines; 
colormap(gca,cmapper); 
plot_coastlines; 
set(gca,'clim',climmer); 

annotation(gcf,'textarrow',[.015 .015], [.275 .275],'string','$\log_{10}$(R$_{SP}$/R$_{NN}$)', ...
    'HeadStyle','none','LineStyle', '--', 'TextRotation',90, ...
    'FontName','Helvetica','FontSize',10,'interpreter','latex');

Ax{10} = subplot('position',[.26 .015 .2 .3]);
plotter = mean(NN_SD_R(:,:,mo2),3); 
worldmap(arc_lat,arc_lon);
h1 = pcolorm(latback,lonback,ones(length(latback),length(lonback)));
set(h1, 'facecolor',[198,219,239]/256)
setm(gca,'parallellabel','off','meridianlabel','off');
setm(gca,'plinevisible','off','mlinevisible','off'); 
pcolorm(lat,lon,plotter); 
plot_coastlines; 
colormap(gca,cmapper); 
plot_coastlines; 
set(gca,'clim',climmer); 

Ax{11} = subplot('position',[.485 .015 .2 .3]);
plotter = mean(NN_SD_R(:,:,mo1),3); 
worldmap(ant_lat,ant_lon);
h1 = pcolorm(latback,lonback,ones(length(latback),length(lonback)));
set(h1, 'facecolor',[198,219,239]/256)
setm(gca,'parallellabel','off','meridianlabel','off');
setm(gca,'plinevisible','off','mlinevisible','off'); 
pcolorm(lat,lon,plotter); 
plot_coastlines; 
colormap(gca,cmapper); 
plot_coastlines; 
set(gca,'clim',climmer); 

Ax{12} = subplot('position',[.71 .015 .2 .3]);
plotter = mean(NN_SD_R(:,:,mo2),3); 
worldmap(ant_lat,ant_lon);
h1 = pcolorm(latback,lonback,ones(length(latback),length(lonback)));
set(h1, 'facecolor',[198,219,239]/256)
setm(gca,'parallellabel','off','meridianlabel','off');
setm(gca,'plinevisible','off','mlinevisible','off'); 
pcolorm(lat,lon,plotter); 
plot_coastlines; 
colormap(gca,cmapper); 
plot_coastlines; 
set(gca,'clim',climmer); 


colorbar('position',[.925 .1 .025 .8]); 



pos = [6.5 4.5]; 
set(gcf,'windowstyle','normal','position',[0 0 pos],'paperposition',[0 0 pos],'papersize',pos,'units','inches','paperunits','inches');
set(gcf,'windowstyle','normal','position',[0 0 pos],'paperposition',[0 0 pos],'papersize',pos,'units','inches','paperunits','inches');

print([figure_save_path 'Fig-5/Fig-5'],'-dpdf','-r1200');