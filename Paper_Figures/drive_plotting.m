clear
close all

% Set these paths before creating figures. 
repo_path = '/Users/chorvat/Dropbox (Brown)/Research Projects/Active/WIFF-Model/';

% Location of parameters for the Neural net. 
% Contains f, redge,rcent
classifier_path = '/Users/chorvat/Dropbox (Brown)/Research Projects/Active/Data/Neural_Net_Data/6-hourly-2009/Classifier-results.mat'; 
validation_path = '/Users/chorvat/Dropbox (Brown)/Research Projects/Active/Data/Neural_Net_Data/6-hourly-2009/NN-results.mat'; 
gcm_data_path = '/Users/chorvat/Dropbox (Brown)/Research Projects/Active/Data/Neural_Net_Data/GCM_Data_2005/'; 
plot_path = [repo_path '/Paper_Figures/Plot_Tools/']; 
misc_path = [repo_path '/Paper_Figures/Misc/']; 


figure_path = [repo_path '/Paper_Figures/']; 
figure_save_path = '/Users/chorvat/Dropbox (Brown)/Apps/Overleaf/Machine Learning Waves/Figures/';

addpath(plot_path); 
addpath(misc_path); 

%%
close all

class_preamble; 

addpath([figure_path '/Fig-1/']); 

make_fig_1; 

%%


training_preamble; 

addpath([figure_path '/Fig-2/']); 

make_fig_2; 

addpath([figure_path '/Fig-3/']); 

training_preamble; 

make_fig_3; 

%%
recreate_gcm_data = 0;

gcm_preamble; 

addpath([figure_path '/Fig-4/']); 

make_fig_4; 

addpath([figure_path '/Fig-5/']); 

make_fig_5; 




