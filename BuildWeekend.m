%========D GUO, Wake Forest University School of Medicine========
%this functin is to create a network, including several communities.
%===input 1:[NumofCommunities] the number of communities
%zeros
%===input 2:[InfectiousID] infectious id in the matrix of communities
%===output 1:[InfectionMat] the infected id and the corresponding
%id of infectious source
%===output 2:[InfectedID] the infected id
%======================================================================
function [allshop, allhome]=BuildWeekend(rateofshop, rateofinfshop, InfectedId)
global NumPopulation
global PopuCompose
Infecttemp = [];

Infecttemp = randperm(length(InfectedId));
Infshop = round(rateofinfshop*length(InfectedId));
InfshopID = InfectedId(Infecttemp(1:Infshop));

PopuCompose = [216 519 1887 375];
inf1 = find(InfshopID<=PopuCompose(1));
inf2 = find((InfshopID>PopuCompose(1))&(InfshopID<=(PopuCompose(1)+PopuCompose(2))));
inf3 = find((InfshopID>(PopuCompose(1)+PopuCompose(2)))&(InfshopID<=(PopuCompose(1)+PopuCompose(2)+PopuCompose(3))));
inf4 = find(InfshopID>PopuCompose(3));

popkidshome= round(PopuCompose(1)*(1-rateofshop));
popkidsshop= PopuCompose(1)-popkidshome;

popyounghome= round(PopuCompose(2)*(1-rateofshop));
popyoungshop= PopuCompose(2)-popyounghome;

popadulthome= round(PopuCompose(3)*(1-rateofshop));
popadultshop= PopuCompose(3)-popadulthome;

popoldhome= round(PopuCompose(4)*(1-rateofshop));
popoldshop= PopuCompose(4)-popoldhome;

kidsall = randperm(PopuCompose(1));
youngall = PopuCompose(1) + randperm(PopuCompose(2));
adultall = PopuCompose(1) + PopuCompose(2) + randperm(PopuCompose(3));
oldall = PopuCompose(1) + PopuCompose(2) + PopuCompose(3) + randperm(PopuCompose(4));

kidshome = kidsall(1:popkidshome);
kidsshop = kidsall(popkidshome+1:end);

younghome = youngall(1:popyounghome);
youngshop = youngall(popyounghome+1:end);

adulthome = adultall(1:popadulthome);
adultshop = adultall(popadulthome+1:end);

oldhome = oldall(1:popoldhome);
oldshop = oldall(popoldhome+1:end);

allshop = [kidsshop youngshop adultshop oldshop];
allhome = [kidshome younghome adulthome oldhome];

end




















