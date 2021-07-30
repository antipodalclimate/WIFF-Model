load coastlines
plotm(coastlat, coastlon,'k','linewidth',2)
hold on
geoshow(coastlat, coastlon, 'DisplayType','polygon','FaceColor',[217,217,217]/256,'Facealpha',1);

hold on
latback = -90:90;
lonback = -180:180;
set(gca,'color',[198,219,239]/256)
