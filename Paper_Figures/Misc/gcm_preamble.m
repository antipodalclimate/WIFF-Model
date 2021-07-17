clearvars -except *_path

load([repo_path '/Misc/NN_params.mat']);

conc_min = .01; 
thick_max = Inf; 
thick_min = 0;

%% 
WW3_path = [gcm_data_path 'WW3-Forcing/ww3.2005_efreq_daymean.nc']; 
f = ncread(WW3_path,'freq'); 
df = f * (sqrt(1.1) - sqrt(1/1.1));
E = ncread(WW3_path,'efreq'); 
E = squeeze(sum(bsxfun(@times,E,permute(df,[2 3 1 4])),3)); 

%%
disp('Loading NN-WIFF Data'); 
fileloc = [gcm_data_path 'NN_WIFF/iceh.cice_ml.2005.nc'];
[H_NN,C_NN,A_NN,N_NN,lat_NN,lon_NN,time_NN,inds_NN] = get_run_data(fileloc,[conc_min nan],[thick_min thick_max]); 
E_NN = E(inds_NN); 

%% Load in SP_WIFF_Data
disp('Loading SP-WIFF Data'); 

fileloc = [gcm_data_path 'SP_WIFF/iceh.cice_stdconv.2005.nc']; 
[H_SP,C_SP,A_SP,N_SP,lat_SP,lon_SP,time_SP,inds_SP] = get_run_data(fileloc,[conc_min nan],[thick_min thick_max]); 
E_SP = E(inds_SP); 

%% Load in SP_WIFF_Data
disp('Loading SP-WIFF-1 Data'); 

fileloc = [gcm_data_path 'SP_WIFF_1/iceh.cice_std1iter.2005.nc']; 
[H_SP_1,C_SP_1,A_SP_1,N_SP_1,lat_SP_1,lon_SP_1,time_SP_1,inds_SP_1] = get_run_data(fileloc,[conc_min nan],[thick_min thick_max]); 
E_SP_1 = E(inds_SP_1); 

%%
save([gcm_data_path 'comp_data'],'*_NN','*_SP','*_SP_1'); 

