%% Make_Fig_2.m
% Creates the first figure in Horvat and Roach (2021). 
% This code starts as if drive_plotting and training_preamble have both
% been called previously. 
figure(2) 
clf

%%

[NCH,~,~,bX,bY] = histcounts2(conc,thick,Cbins,Hbins); 
indCH = sub2ind([nbins_C nbins_H],bX,bY); 

[NCE,~,~,bX,bY] = histcounts2(conc,E,Cbins,Ebins); 
indCE = sub2ind([nbins_C nbins_E],bX,bY); 

[NHE,~,~,bX,bY] = histcounts2(thick,E,Hbins,Ebins); 
indHE = sub2ind([nbins_H nbins_E],bX,bY); 

[NRE,~,~,bX,bY] = histcounts2(mean_FS_true,E,Rbins,Ebins); 
indRE = sub2ind([nbins_R nbins_E],bX,bY); 

[NHR,~,~,bX,bY] = histcounts2(thick,mean_FS_true,Hbins,Rbins); 
indHR = sub2ind([nbins_H nbins_R],bX,bY); 

[NRC,~,~,bX,bY] = histcounts2(mean_FS_true,conc,Rbins,Cbins); 
indRC = sub2ind([nbins_R nbins_C],bX,bY); 

errCH = reshape(accumarray(indCH,perc_error,[nbins_C*nbins_H 1],@mean),[nbins_C nbins_H]); 
errCE = reshape(accumarray(indCE,perc_error,[nbins_C*nbins_E 1],@mean),[nbins_C nbins_E]); 
errHE = reshape(accumarray(indHE,perc_error,[nbins_H*nbins_E 1],@mean),[nbins_H nbins_E]); 
errRE = reshape(accumarray(indRE,perc_error,[nbins_R*nbins_E 1],@mean),[nbins_R nbins_E]); 
errHR = reshape(accumarray(indHR,perc_error,[nbins_R*nbins_H 1],@mean),[nbins_H nbins_R]); 
errRC = reshape(accumarray(indRC,perc_error,[nbins_R*nbins_C 1],@mean),[nbins_R nbins_C]); 

num_tot = length(mean_FS_true); 
num_cutoff = num_tot / (2*100*100); % .01 % cutoff

errRC(NRC < num_cutoff) = nan; 
errHR(NHR < num_cutoff) = nan; 
errRE(NRE < num_cutoff) = nan; 
errHE(NHE < num_cutoff) = nan; 
errCE(NCE < num_cutoff) = nan; 
errCH(NCH < num_cutoff) = nan; 

%% Geographic plots

% latvec = linspace(-90,90,360); 
% lonvec = linspace(0,360,365); 
% 
% [LAT,LON] = meshgrid(latvec,lonvec);
% earthellipsoid = referenceSphere('earth','km');
% lldist = @(x,y) distance(x,y,earthellipsoid);
% 
% M = createns([LAT(:) LON(:)],'Distance',lldist);
% 
% ID = knnsearch(M,[latsave(1:1000),lonsave(1:1000)],'K',1,'Distance',lldist);
% 
% 
% 
% %%
% 
% err_geo = accumarray(ID,perc_error,[length(latvec)*length(lonvec) 1],@mean); 
% 

%%
climmer = [0 50]; 


Ax{1} = subplot('position',[.05 .55 .25 .4]);
pcolor(Cbins(1:end-1),Ebins(1:end-1),errCE'); shading flat; grid on; box on;  
set(gca,'clim',climmer,'xticklabel','');
xlim(Clims); ylim(Elims); 
% xlabel('Ice Concentration','interpreter','latex'); 
ylabel('$\log_{10}$ Wave Energy','interpreter','latex'); 

Ax{2} = subplot('position',[.365 .55 .25 .4]);
pcolor(Hbins(1:end-1),Ebins(1:end-1),errHE'); shading flat; grid on; box on; 
set(gca,'clim',climmer,'xticklabel','');
xlim(Hlims); ylim(Elims); 
% xlabel('$\log_{10}$ Wave Energy','interpreter','latex'); 
%ylabel('Ice Thickness','interpreter','latex'); 

Ax{3} =  subplot('position',[.68 .55 .25 .4]);
pcolor(Rbins(1:end-1),Ebins(1:end-1),errRE'); shading flat; grid on; box on; 
set(gca,'clim',climmer); 
set(gca,'xscale','log','xticklabel','');
set(gca,'clim',climmer); 
xlim(Rlims); ylim(Elims); 
% xlabel('Rep Radius','interpreter','latex'); 
% ylabel('Ice Thickness','interpreter','latex'); 


Ax{4} = subplot('position',[.05 .1 .25 .4]); 
pcolor(Cbins(1:end-1),Hbins(1:end-1),errCH'); shading flat; grid on; box on; 
set(gca,'clim',climmer); 
xlim(Clims); ylim(Hlims); 
xlabel('Ice Concentration','interpreter','latex'); 
ylabel('Ice Thickness (m)','interpreter','latex'); 

Ax{5} = subplot('position',[.365 .1 .25 .4]); 
pcolor(Hbins(1:end-1),Rbins(1:end-1),errHR'); shading flat; grid on; box on; 
set(gca,'clim',climmer); 
set(gca,'yscale','log'); 
xlim(Hlims); ylim(Rlims); 
xlabel('Ice Thickness','interpreter','latex'); 
ylabel('R (m)','interpreter','latex'); 

Ax{6} = subplot('position',[.68 .1 .25 .4]); 
pcolor(Rbins(1:end-1),Cbins(1:end-1),errRC'); shading flat; grid on; box on; 
set(gca,'xscale','log');
set(gca,'clim',climmer); 
xlim(Rlims); ylim(Clims); 
xlabel('R (m)','interpreter','latex'); 
ylabel('Ice Concentration','interpreter','latex'); 


colormap(cmocean('balance','pivot',10,25)); 




colorbar('position',[.95 .125 .01 .8]); 

for i = 1:length(Ax)
    
    posy = get(Ax{i},'position');

    set(Ax{i},'fontname','helvetica','fontsize',8,'xminortick','on','yminortick','on')
    
    
end

pos = [6.5 4]; 
set(gcf,'windowstyle','normal','position',[0 0 pos],'paperposition',[0 0 pos],'papersize',pos,'units','inches','paperunits','inches');
set(gcf,'windowstyle','normal','position',[0 0 pos],'paperposition',[0 0 pos],'papersize',pos,'units','inches','paperunits','inches');
saveas(gcf,[figure_save_path '/Fig-2/Fig-2.pdf']); 