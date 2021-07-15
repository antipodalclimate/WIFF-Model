clear

training_data_loc = '/Users/chorvat/Dropbox (Brown)/Research Projects/Active/Data/Neural_Net_Data/6-hourly-2009/';


% Location of thickness/conc and histogram files
files_thick = dir([training_data_loc '/6hourly/iceh_06h*.nc']);
files_frac = dir([training_data_loc '/6hourlyfrachist/frachist_*.nc']);

ww3_data_loc = [training_data_loc 'ww3.2009_efreq.nc']; 

lat = ncread([training_data_loc '6hourly/iceh_06h.2009-01-01-21600.nc'],'TLAT');
lon = ncread(ptraining_data_loc '6hourly/iceh_06h.2009-01-01-21600.nc'],'TLON');

time = nan(length(files_thick));

locstart = [1 1 1];

% Location of wavewatch 3 files. 
f = ncread(ww3_data_loc,'freq');
dF = f * (sqrt(1.1) - sqrt(1/1.1)); 
T_WW = ncread(ww3_data_loc,'time',1,length(time));

%%

Hs_min = 0.1; 
Thick_max = 10; 
Thick_min = 0; 
A_cut = 0.01; 

[frachist,conc,thick,spec,latsave,lonsave,hemi_flag,mon_id] = deal([]);     

for i = 1:length(files_thick)-1
    % The WW3 data is offset by one from the CICE data. 
    % So CICE t(1) is equal to WW3 t(2)
    % Thus we don't read to the end, and take the next WW3 spectrum at each
    % time
    
    %%
    if mod(i,50) == 0
        fprintf('\n Number %d \n',i);
    else
        fprintf('.');
    end
    
 
   
    % Ice Thickness
    
    time_CICE(i) = ncread([files_thick(i).folder '/'  files_thick(i).name],'time');
    month_CICE(i) = str2num(files_thick(i).name(15:16)); 
    time_WW3(i) = ncread(ww3_data_loc,'time',i+1,1);
    
    tempH = reshape(ncread([files_thick(i).folder '/'  files_thick(i).name],'hi',[1 1 1],[Inf Inf Inf]),[numel(lat) 1]);
    tempA = reshape(ncread([files_thick(i).folder '/'  files_thick(i).name],'aice',[1 1 1],[Inf Inf Inf]),[numel(lat) 1]);
    
    for j = 1:12
        tempF(:,j) = reshape(ncread([files_frac(i).folder '/'  files_frac(i).name],['frachist' num2str(j,'%02.f')],[1 1 1],[Inf Inf Inf]),[numel(lat) 1]);
    end
       
    tempS = reshape(ncread(ww3_data_loc,'efreq',[1 1 1 i+1],[Inf Inf Inf 1]),[],25);
    
    touse_valid = (SWH > Hs_min) & (tempH > Thick_min) & (tempH < Thick_max) & (tempA > A_cut);
    
    %%
    
    thick = cat(1,thick,tempH(touse_valid)); 
    conc = cat(1,conc,tempA(touse_valid)); 
    spec = cat(1,spec,tempS(touse_valid,:)); 
    frachist = cat(1,frachist,tempF(touse_valid,:)); 
    
end

%%

in = cat(2,cat(2,spec,thick),conc); 
out = frachist;

save([training_data_path 'Training_converged'],'in','out','latsave','-append','-v7.3');

%%