
close all
horvat_colors

figure(3)

num_cutoff = 23; 
time_cutoff = 180; 

subplot(321)

sub_SP = A_SP(lat_SP > num_cutoff & N_SP > num_cutoff & time_SP < time_cutoff,:); 
sub_NN = A_NN(lat_NN > num_cutoff & N_NN > num_cutoff & time_NN < time_cutoff,:); 
sub_SP_1 = A_SP_1(lat_SP_1 > num_cutoff & N_SP_1 > num_cutoff & time_SP_1 < time_cutoff, :); 

% iqr_SP_NN = iqr(sub_SP-sub_NN); 
% iqr_SP_SP_1 = iqr(sub_SP - sub_SP_1); 
bottom = prctile(sub_SP,25,1); 
top = prctile(sub_SP,75,1);  

semilogx(rcent,median(sub_SP,1),'color','k','linewidth',1)
hold on; 

semilogx(rcent,median(sub_NN,1),'color',clabs(2,:),'linewidth',1)
semilogx(rcent,median(sub_SP_1,1),'-.','color','k','linewidth',1)
semilogx(rcent,top,'--k','linewidth',0.5); 
semilogx(rcent,bottom,'--k','linewidth',0.5); 
hold off
grid on; box on; 
xlim([rcent(1) rcent(end)]); 

legend('SP-WIFF','NN-WIFF','SP-WIFF-1');

subplot(322)

sub_SP = A_SP(lat_SP < 0 & N_SP > num_cutoff & time_SP < time_cutoff,:); 
sub_NN = A_NN(lat_NN < 0 & N_NN > num_cutoff & time_NN < time_cutoff,:); 
sub_SP_1 = A_SP_1(lat_SP_1 < 0 & N_SP_1 > num_cutoff & time_SP_1 < time_cutoff, :); 

% iqr_SP_NN = iqr(sub_SP-sub_NN); 
% iqr_SP_SP_1 = iqr(sub_SP - sub_SP_1); 
bottom = prctile(sub_SP,25,1); 
top = prctile(sub_SP,75,1);  


semilogx(rcent,median(sub_SP,1),'color','k','linewidth',1)
hold on; 
semilogx(rcent,median(sub_NN,1),'color',clabs(2,:),'linewidth',1)
semilogx(rcent,median(sub_SP_1,1),'--','color','k','linewidth',1)
semilogx(rcent,top,'--k','linewidth',0.5); 
semilogx(rcent,bottom,'--k','linewidth',0.5); 

hold off
grid on; box on; 
xlim([rcent(1) rcent(end)]); 

legend('SP-WIFF','NN-WIFF','SP-WIFF-1');

subplot(323)



