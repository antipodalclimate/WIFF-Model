function [thick,conc,frac_hist,N,lat,lon,timevec,inds]= get_run_data(fileloc,Cbnd,Hbnd)

Cmin = Cbnd(1); 
Hmin = Hbnd(1); 
Hmax = Hbnd(2); 

thick = ncread(fileloc,'hi'); 
conc = ncread(fileloc,'aice'); 
frac_hist = permute(ncread(fileloc,'frachist'),[1 2 4 3]);


lat = ncread(fileloc,'TLAT'); 
lon = ncread(fileloc,'TLON'); 
timevec = ncread(fileloc,'time'); 

lat = repmat(lat,[1 1 length(timevec)]); 
lon = repmat(lon,[1 1 length(timevec)]); 
timevec = repmat(permute(timevec,[3 2 1]),[size(lat,1),size(lat,2)]); 

use = (thick < Hmax & thick > Hmin & conc > Cmin & sum(frac_hist,4) > 1/25);

inds = find(use); 

thick = thick(use); 
conc = conc(use); 

frac_hist = reshape(frac_hist,[],12); 
frac_hist = frac_hist(use,:); 

N = round(24.*sum(frac_hist,2)); 
frac_hist = bsxfun(@rdivide,frac_hist,sum(frac_hist,2));

lat = lat(use); 
lon = lon(use); 
timevec = timevec(use); 