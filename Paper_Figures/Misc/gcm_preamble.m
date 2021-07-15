clearvars -except *_path

load([repo_path '/Misc/NN_params.mat']);

conc_min = .1; 
thick_max = 4; 
thick_min = 0.01;


%% Basic Setup

df = f' * (sqrt(1.1) - sqrt(1/1.1));

%%
disp('Loading NN-WIFF Data'); 
fileloc = [gcm_data_path 'NN_WIFF/iceh.cice_ml.2005.nc'];
[H_NN,C_NN,A_NN,N_NN,lat_NN,lon_NN,time_NN] = get_run_data(fileloc,[conc_min nan],[thick_min thick_max]); 

%% Load in SP_WIFF_Data
disp('Loading SP-WIFF Data'); 

fileloc = [gcm_data_path 'SP_WIFF/iceh.cice_stdconv.2005.incomplete.nc']; 
[H_SP,C_SP,A_SP,N_SP,lat_SP,lon_SP,time_SP] = get_run_data(fileloc,[conc_min nan],[thick_min thick_max]); 

%% Load in SP_WIFF_Data
disp('Loading SP-WIFF-1 Data'); 

fileloc = [gcm_data_path 'SP_WIFF_1/iceh.cice_std1iter.2005.nc']; 
[H_SP_1,C_SP_1,A_SP_1,N_SP_1,lat_SP_1,lon_SP_1,time_SP_1] = get_run_data(fileloc,[conc_min nan],[thick_min thick_max]); 


