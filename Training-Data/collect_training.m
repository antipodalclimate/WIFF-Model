clear

files_thick = dir('/Users/chorvat/Dropbox (Brown)/Research Projects/Active/Data/Neural_Net_Data/6-hourly-2009/6hourly/iceh_06h*.nc');
files_frac = dir('/Users/chorvat/Dropbox (Brown)/Research Projects/Active/Data/Neural_Net_Data/6-hourly-2009/6hourlyfrachist/frachist_*.nc');

lat = ncread('6hourly/iceh_06h.2009-01-01-21600.nc','TLAT');
lon = ncread('6hourly/iceh_06h.2009-01-01-21600.nc','TLON');

latuse = abs(lat) > 40;

nlats = sum(latuse(:));

time = nan(length(files_thick));

locstart = [1 1 1];

f = ncread('ww3.2009_efreq.nc','freq');
dF = f * (sqrt(1.1) - sqrt(1/1.1)); 
T_WW = ncread('ww3.2009_efreq.nc','time',1,length(time));

%%

Hs_min = 0.1; 
Thick_max = 10; 
Thick_min = 0; 
A_cut = 0.01; 

[frachist,conc,thick,spec,latsave,lonsave,hemi_flag,mon_id] = deal([]); 
  %  frachist_ARC,frachist_ANT, ...
  %  latsave_ARC,conc_ARC,conc_ANT,thick_ARC, ...
  %  latsave_ANT,thick_ANT,spec_ARC,spec_ANT, ...
    

%

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
    time_WW3(i) = ncread('ww3.2009_efreq.nc','time',i+1,1);
    
    tempH = reshape(ncread([files_thick(i).folder '/'  files_thick(i).name],'hi',[1 1 1],[Inf Inf Inf]),[numel(lat) 1]);
    tempA = reshape(ncread([files_thick(i).folder '/'  files_thick(i).name],'aice',[1 1 1],[Inf Inf Inf]),[numel(lat) 1]);
    
    for j = 1:12
        tempF(:,j) = reshape(ncread([files_frac(i).folder '/'  files_frac(i).name],['frachist' num2str(j,'%02.f')],[1 1 1],[Inf Inf Inf]),[numel(lat) 1]);
    end
       
    tempS = reshape(ncread('ww3.2009_efreq.nc','efreq',[1 1 1 i+1],[Inf Inf Inf 1]),[],25);

    SWH = 4*sqrt(sum(bsxfun(@times,tempS,dF'),2)); 
    
    touse_valid = (SWH > Hs_min) & (tempH > Thick_min) & (tempH < Thick_max) & (tempA > A_cut);
%     touse_ARC = (lat(:) > 0) & touse_valid; 
%     touse_ANT = (lat(:) < 0) & touse_valid; 
    
    hemisphere = lat(:) > 0; 
    
    %%
    
    thick = cat(1,thick,tempH(touse_valid)); 
    conc = cat(1,conc,tempA(touse_valid)); 
    spec = cat(1,spec,tempS(touse_valid,:)); 
    frachist = cat(1,frachist,tempF(touse_valid,:)); 
    latsave = cat(1,latsave,lat(touse_valid)); 
    lonsave = cat(1,lonsave,lon(touse_valid)); 
    
%     thick_ARC = cat(1,thick_ARC,tempH(touse_ARC)); 
%     conc_ARC = cat(1,conc_ARC,tempA(touse_ARC)); 
%     spec_ARC = cat(1,spec_ARC,tempS(touse_ARC,:)); 
%     frachist_ARC = cat(1,frachist_ARC,tempF(touse_ARC,:)); 
%    latsave_ARC = cat(1,latsave_ARC,lat(touse_ARC)); 

%     thick_ANT = cat(1,thick_ANT,tempH(touse_ANT)); 
%     conc_ANT = cat(1,conc_ANT,tempA(touse_ANT)); 
%     spec_ANT = cat(1,spec_ANT,tempS(touse_ANT,:)); 
%     frachist_ANT = cat(1,frachist_ANT,tempF(touse_ANT,:)); 
%    latsave_ANT = cat(1,latsave_ANT,lat(touse_ANT)); 
    
%     hemi_flag = cat(1,hemi_flag,hemisphere(touse_valid)); 
% 
%     mon_id = cat(1,mon_id,0*zeros(sum(touse_valid),1) + month_CICE(i)); 
%     
end

%%

in = cat(2,cat(2,spec,thick),conc); 
% in_special = cat(2,cat(2,in,hemi_flag),mon_id); 

out = frachist;

save('Training_converged','in','out','latsave','-append','-v7.3');
% save('Training_special','in_special','out','-v7.3');

%%
% in_ARC = cat(2,cat(2,spec_ARC,thick_ARC),conc_ARC); 
% in_ANT = cat(2,cat(2,spec_ANT,thick_ANT),conc_ANT); 
% out_ARC = frachist_ARC; 
% out_ANT = frachist_ANT; 
% 
% 
% save('Training_ARC','in_ARC','out_ARC','-append','-v7.3');
% save('Training_ANT','in_ANT','out_ANT','-append','-v7.3');