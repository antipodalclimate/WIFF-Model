
%%

[NC,~,bX] = histcounts(conc,Cbins);  

TP_C = accumarray(bX,truepos,[nbins_C 1],@sum); 
FP_C = accumarray(bX,falsepos,[nbins_C 1],@sum); 
TN_C = accumarray(bX,trueneg,[nbins_C 1],@sum); 
FN_C = accumarray(bX,falseneg,[nbins_C 1],@sum); 

acc_C = (TP_C + TN_C)./(TP_C + FP_C + TN_C + FN_C); 
FNR_C = (FN_C)./(TN_C + FN_C); 
FPR_C = (FP_C)./(TP_C + FP_C); 
runrate_C = (TP_C + FP_C)./(TP_C + FP_C + TN_C + FN_C); 

[NH,~,bX] = histcounts(thick,Hbins);  
TP_H = accumarray(bX,truepos,[nbins_H 1],@sum); 
FP_H = accumarray(bX,falsepos,[nbins_H 1],@sum); 
TN_H = accumarray(bX,trueneg,[nbins_H 1],@sum); 
FN_H = accumarray(bX,falseneg,[nbins_H 1],@sum); 
acc_H = (TP_H + TN_H)./(TP_H + FP_H + TN_H + FN_H); 
FNR_H = (FN_H)./(TN_H + FN_H); 
FPR_H = (FP_H)./(TP_H + FP_H); 
runrate_H = (TP_H + FP_H)./(TP_H + FP_H + TN_H + FN_H); 

[NE,~,bX] = histcounts(E,Ebins);  
TP_E = accumarray(bX,truepos,[nbins_E 1],@sum); 
FP_E = accumarray(bX,falsepos,[nbins_E 1],@sum); 
TN_E = accumarray(bX,trueneg,[nbins_E 1],@sum); 
FN_E = accumarray(bX,falseneg,[nbins_E 1],@sum); 
acc_E = (TP_E + TN_E)./(TP_E + FP_E + TN_E + FN_E); 
FNR_E = (FN_E)./(TN_E + FN_E); 
FPR_E = (FP_E)./(TP_E + FP_E); 
runrate_E = (TP_E + FP_E)./(TP_E + FP_E + TN_E + FN_E); 

%%
[NCH,~,~,bX,bY] = histcounts2(conc,thick,Cbins,Hbins); 
indCH = sub2ind([nbins_C nbins_H],bX,bY); 

[NCE,~,~,bX,bY] = histcounts2(conc,E,Cbins,Ebins); 
indCE = sub2ind([nbins_C nbins_E],bX,bY); 

[NHE,~,~,bX,bY] = histcounts2(thick,E,Hbins,Ebins); 
indHE = sub2ind([nbins_H nbins_E],bX,bY); 


%%
TPCH = reshape(accumarray(indCH,truepos,[nbins_C*nbins_H 1],@mean),[nbins_C nbins_H]); 
FPCH = reshape(accumarray(indCH,falsepos,[nbins_C*nbins_H 1],@mean),[nbins_C nbins_H]); 
TNCH = reshape(accumarray(indCH,trueneg,[nbins_C*nbins_H 1],@mean),[nbins_C nbins_H]);
FNCH = reshape(accumarray(indCH,falseneg,[nbins_C*nbins_H 1],@mean),[nbins_C nbins_H]);

TPCE = reshape(accumarray(indCE,truepos,[nbins_C*nbins_E 1],@mean),[nbins_C nbins_E]); 
FPCE = reshape(accumarray(indCE,falsepos,[nbins_C*nbins_E 1],@mean),[nbins_C nbins_E]); 
TNCE = reshape(accumarray(indCE,trueneg,[nbins_C*nbins_E 1],@mean),[nbins_C nbins_E]);
FNCE = reshape(accumarray(indCE,falseneg,[nbins_C*nbins_E 1],@mean),[nbins_C nbins_E]);

TPHE = reshape(accumarray(indHE,truepos,[nbins_H*nbins_E 1],@mean),[nbins_H nbins_E]); 
FPHE = reshape(accumarray(indHE,falsepos,[nbins_H*nbins_E 1],@mean),[nbins_H nbins_E]); 
TNHE = reshape(accumarray(indHE,trueneg,[nbins_H*nbins_E 1],@mean),[nbins_H nbins_E]);
FNHE = reshape(accumarray(indHE,falseneg,[nbins_H*nbins_E 1],@mean),[nbins_H nbins_E]);

accCH = (TPCH + TNCH)./(TNCH + FNCH + TPCH + TNCH); 
accCE = (TPCE + TNCE)./(TNCE + FNCE + TPCE + TNCE); 
accHE = (TPHE + TNHE)./(TNHE + FNHE + TPHE + TNHE); 

num_tot = length(indCH); 
num_cutoff = num_tot / (2*100*100); % .01 % cutoff

accHE(NHE < num_cutoff) = nan; 
accCE(NCE < num_cutoff) = nan; 
accCH(NCH < num_cutoff) = nan; 

%%
figure(1)
clf; clear Ax; 

horvat_colors; 

Ax{1} = subplot('position',[.075 .55 .25 .35]);

plot(Cbins(1:end-1),runrate_C,'--k','linewidth',1); 
hold on
plot(Cbins(1:end-1),FPR_C,'-','color',clabs(2,:),'linewidth',1); 
plot(Cbins(1:end-1),FNR_C,'-','color',clabs(3,:),'linewidth',1); 
plot(Cbins(1:end-1),acc_C,'k','linewidth',1); 
hold off
xlim(Clims); 
ylim([0 1]);
ylabel('\%','interpreter','latex'); 
grid on; box on; 
xlabel('Ice Concentration','interpreter','latex'); 

Ax{2} = subplot('position',[.375 .55 .25 .35]);
plot(Hbins(1:end-1),runrate_H,'--k','linewidth',1); 
hold on
plot(Hbins(1:end-1),FPR_H,'-','color',clabs(2,:),'linewidth',1); 
plot(Hbins(1:end-1),FNR_H,'-','color',clabs(3,:),'linewidth',1); 
plot(Hbins(1:end-1),acc_H,'k','linewidth',1); 
hold off
xlim(Hlims); 
ylim([0 1]);
% ylabel('\%','interpreter','latex'); 
grid on; box on; 
xlabel('Ice Thickness','interpreter','latex'); 

Ax{3} = subplot('position',[.675 .55 .25 .35]);
plot(Ebins(1:end-1),runrate_E,'--k','linewidth',1); 
hold on
plot(Ebins(1:end-1),FPR_E,'-','color',clabs(2,:),'linewidth',1); 
plot(Ebins(1:end-1),FNR_E,'-','color',clabs(3,:),'linewidth',1); 
plot(Ebins(1:end-1),acc_E,'k','linewidth',1); 
hold off
xlim(Elims); 
ylim([0 1]);
% ylabel('\%','interpreter','latex'); 
grid on; box on; 
xlabel('Log$_{10}$ Wave Energy','interpreter','latex'); 


legend('Run Rate','False Positive Rate','False Negative Rate','Accuracy', ...
    'interpreter','latex','position',[.15 .925 .7 .05],'orientation','horizontal'); 

climmer = [0 1]; 

Ax{4} = subplot('position',[.075 .1 .25 .35]);
pcolor(Cbins(1:end-1),Ebins(1:end-1),accCE'); shading flat; grid on; box on;  
set(gca,'clim',climmer);
xlim(Clims); ylim(Elims); 
xlabel('Ice Concentration','interpreter','latex'); 
ylabel('$\log_{10}$ Wave Energy','interpreter','latex'); 

Ax{5} = subplot('position',[.375 .1 .25 .35]); 
pcolor(Cbins(1:end-1),Hbins(1:end-1),accCH'); shading flat; grid on; box on; 
set(gca,'clim',climmer); 
xlim(Clims); ylim(Hlims); 
xlabel('Ice Concentration','interpreter','latex'); 
ylabel('Ice Thickness (m)','interpreter','latex'); 

Ax{6} = subplot('position',[.675 .1 .25 .35]);
pcolor(Hbins(1:end-1),Ebins(1:end-1),accHE'); shading flat; grid on; box on; 
set(gca,'clim',climmer);
xlim(Hlims); ylim(Elims); 
xlabel('Ice Thickness','interpreter','latex'); 
ylabel('$\log_{10}$ Wave Energy','interpreter','latex'); 

colormap(flipud(cmocean('thermal',100))); 

colorbar('position',[.95 .1 .01 .35]); 

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
print('/Users/chorvat/Dropbox (Brown)/Apps/Overleaf/Light-under-Antarctic-Ice/Figures/Fig-0/Fig-0b','-dpdf','-r1200');

print([figure_save_path 'Fig-1/Fig-1.pdf'],'-dpdf','-r1200');
