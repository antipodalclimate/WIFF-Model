clearvars -except *_path

load([gcm_data_path 'comp_data']); 
load([repo_path '/Misc/NN_params.mat']);

%% Want the intersection of locations and times
% have inds_SP, inds_NN, inds_SP_1
% 

num_cutoff = 1; 
time_end = 365; % Ignore day 365
time_beg = 120; % Ignore day 1
e_cutoff = (.1/4)^2; 
c_cutoff = 0.1; 

[inds_dual,iA,iB] = intersect(inds_SP,inds_NN); 
[inds_trio,iC,iD] = intersect(inds_dual,inds_SP_1); 

C_SP_1_int = C_SP_1(iD,:); 
C_SP_int = C_SP(iA(iC),:); 
C_NN_int = C_NN(iB(iC),:); 

A_SP_1_int = A_SP_1(iD,:); 
A_SP_int = A_SP(iA(iC),:); 
A_NN_int = A_NN(iB(iC),:); 

N_SP_1_int = N_SP_1(iD); 
N_SP_int = N_SP(iA(iC)); 
N_NN_int = N_NN(iB(iC)); 

time_int = time_SP_1(iD); 
lat_int = lat_SP_1(iD); 
lon_int = lon_SP_1(iD); 
E_int = E_SP_1(iD); 

N_daily_NN = accumarray(time_NN(lat_NN < 0),1 + 0*N_NN(lat_NN < 0),[365 1],@sum); 
N_daily_SP = accumarray(time_SP(lat_SP < 0),1 + 0*N_SP(lat_SP < 0),[365 1],@sum); 
N_daily_SP_1 = accumarray(time_SP_1(lat_SP_1 < 0),1 + 0*N_SP_1(lat_SP_1 < 0),[365 1],@sum); 

use_int = ... %(N_SP_1_int > num_cutoff & N_NN_int > num_cutoff & N_SP_int > num_cutoff ...
    (C_SP_1_int > c_cutoff & C_NN_int > c_cutoff & C_SP_int > c_cutoff ...
    & E_int > e_cutoff & time_int < time_end & time_int > time_beg ); 



%
horvat_colors

figure(4)
clf; clear Ax; 

Ax{1} = subplot('position',[.075 .6 .4 .35]);

sub_SP = A_SP_int(use_int & lat_int > 0,:); 
sub_NN = A_NN_int(use_int & lat_int > 0,:); 
sub_SP_1 = A_SP_1_int(use_int & lat_int > 0,:);

% iqr_SP_NN = iqr(sub_SP-sub_NN); 
% iqr_SP_SP_1 = iqr(sub_SP - sub_SP_1); 
bottom = prctile(sub_SP,25,1); 
top = prctile(sub_SP,75,1);  

semilogx(rcent,mean(sub_SP,1),'color','k','linewidth',1)
hold on; 

semilogx(rcent,mean(sub_NN,1),'color',clabs(2,:),'linewidth',1)
semilogx(rcent,mean(sub_SP_1,1),'--','color',clabs(1,:),'linewidth',1)

semilogx(rcent,top,'--k','linewidth',0.5); 
semilogx(rcent,bottom,'--k','linewidth',0.5); 
% hold off
grid on; box on; 
xlim([rcent(1) rcent(end)]); 


xlabel('Floe Size (m)','interpreter','latex'); 
ylabel('A$_i$dr$_i$','interpreter','latex'); 
p = legend('SP-WIFF','NN-WIFF','SP-WIFF-1','interpreter','latex');
set(p,'ItemTokenSize',[25 25])
title('Mean Arctic Histogram','interpreter','latex'); 


%
Ax{2} = subplot('position',[.565 .6 .4 .35]);

sub_SP = A_SP_int(use_int & lat_int < 0,:); 
sub_NN = A_NN_int(use_int & lat_int < 0,:); 
sub_SP_1 = A_SP_1_int(use_int & lat_int < 0,:);

% iqr_SP_NN = iqr(sub_SP-sub_NN); 
% iqr_SP_SP_1 = iqr(sub_SP - sub_SP_1); 
bottom = prctile(sub_SP,25,1); 
top = prctile(sub_SP,75,1);  

semilogx(rcent,mean(sub_SP,1),'color','k','linewidth',1)
hold on; 
semilogx(rcent,mean(sub_NN,1),'color',clabs(2,:),'linewidth',1)
semilogx(rcent,mean(sub_SP_1,1),'--','color',clabs(1,:),'linewidth',1)
semilogx(rcent,top,'--k','linewidth',0.5); 
semilogx(rcent,bottom,'--k','linewidth',0.5); 

hold off
grid on; box on; 
xlim([rcent(1) rcent(end)]); 

p = legend('SP-WIFF','NN-WIFF','SP-WIFF-1','interpreter','latex');
set(p,'ItemTokenSize',[25 25])
xlabel('Floe Size (m)','interpreter','latex'); 
ylabel('A$_i$dr$_i$','interpreter','latex'); 
title('Mean Antarctic Histogram','interpreter','latex'); 

%%
Ax{3} = subplot('position',[.075 .15 .4 .35]);

xbins = [linspace(0,1,200) Inf]; 

SAE_NN = sum(abs(A_SP_int - A_NN_int),2);
RSE_NN = sum(rcent.*abs(A_SP_int - A_NN_int),2) ./ sum(rcent.*A_SP_int,2); 

SAE_SP_1 = sum(abs(A_SP_int - A_SP_1_int),2);
RSE_SP_1 = sum(rcent.*abs(A_SP_int - A_SP_1_int),2) ./ sum(rcent.*A_SP_int,2); 



NS_NN = histcounts(SAE_NN(use_int & lat_int < 0,:),xbins,'normalization','probability');
NR_NN = histcounts(RSE_NN(use_int & lat_int < 0,:),xbins,'normalization','probability');
NS_SP_1 = histcounts(SAE_SP_1(use_int & lat_int < 0,:),xbins,'normalization','probability');
NR_SP_1 = histcounts(RSE_SP_1(use_int & lat_int < 0,:),xbins,'normalization','probability');


semilogx(xbins(1:end-1),NS_NN./sum(NS_NN),'b'); 
hold on
semilogx(xbins(1:end-1),NR_NN./sum(NR_NN),'--b'); 

semilogx(xbins(1:end-1),NS_SP_1./sum(NS_SP_1),'r')
semilogx(xbins(1:end-1),NR_SP_1./sum(NR_SP_1),'--r'); 
hold off
ylabel('N(e)de','interpreter','latex'); 
grid on; box on; 
xlabel('Error from SP-WIFF','interpreter','latex'); 
set(gca,'xtick',[.001 .01 .1 1],'xticklabel',{'.1%','1%','10%','100%'}); 

%
Ax{4} = subplot('position',[.565 .15 .4 .35]);


NS_NN = histcounts(SAE_NN(use_int & lat_int < 0,:),xbins,'normalization','probability');
NR_NN = histcounts(RSE_NN(use_int & lat_int < 0,:),xbins,'normalization','probability');

NS_SP_1 = histcounts(SAE_SP_1(use_int & lat_int < 0,:),xbins,'normalization','probability');
NR_SP_1 = histcounts(RSE_SP_1(use_int & lat_int < 0,:),xbins,'normalization','probability');


semilogx(xbins(1:end-1),NS_NN,'b'); 
hold on
semilogx(xbins(1:end-1),NR_NN,'--b'); 

semilogx(xbins(1:end-1),NS_SP_1,'r')
semilogx(xbins(1:end-1),NR_SP_1,'--r'); 
hold off
legend('NN-WIFF (SAE)','NN-WIFF (RAE)'); 
ylabel('N(e)de','interpreter','latex'); 
xlabel('Error from SP-WIFF','interpreter','latex'); 
set(gca,'xtick',[.001 .01 .1 1],'xticklabel',{'.1%','1%','10%','100%'}); 

grid on; box on; 

p = legend('NN-WIFF (SAE)','NN-WIFF (RAE)','SP-WIFF-1 (SAE)','SP-WIFF-1 (RAE)', ...
    'interpreter','latex','position',[.085 .01 .825 .05],'orientation','horizontal'); 
set(p,'ItemTokenSize',[25 25])

letter = {'(a)','(b)','(c)','(d)','(e)','(f)','(g)','(e)','(c)'};

delete(findall(gcf,'Tag','legtag'))

for i = 1:length(Ax)
    
    posy = get(Ax{i},'position');

    set(Ax{i},'fontname','helvetica','fontsize',8,'xminortick','on','yminortick','on')
    
    annotation('textbox',[posy(1) posy(2)+posy(4) - .02 .025 .025], ...
        'String',letter{i},'LineStyle','none','FontName','Helvetica', ...
        'FontSize',8,'Tag','legtag');
    
end

pos = [6.5 4]; 
set(gcf,'windowstyle','normal','position',[0 0 pos],'paperposition',[0 0 pos],'papersize',pos,'units','inches','paperunits','inches');
set(gcf,'windowstyle','normal','position',[0 0 pos],'paperposition',[0 0 pos],'papersize',pos,'units','inches','paperunits','inches');

print([figure_save_path 'Fig-4/Fig-4'],'-dpdf','-r1200');