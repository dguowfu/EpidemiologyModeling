%========D GUO, Wake Forest University School of Medicine========
%this functin is to create a network, including several communities.
%===input 1:[NumofCommunities] the number of communities
%zeros
%===input 2:[InfectiousID] infectious id in the matrix of communities
%===output 1:[InfectionMat] the infected id and the corresponding
%id of infectious source
%===output 2:[InfectedID] the infected id
%======================================================================
function adjHouse=BuildHouse
global NumPopulation
global PopuCompose

kidspop = PopuCompose(1);
youngpop = PopuCompose(2);
adult = PopuCompose(3);
oldpop = PopuCompose(4);

popUnit = [334 435 196 163 68 22 12]; % 160*1/perhouse+746*2/perhouse+123*3/perhouse+113*4/perhouse+73*5/perhouse+27*6/perhouse

Home1 = zeros(7, popUnit(1));
Home2 = zeros(7, popUnit(2));
Home3 = zeros(7, popUnit(3));
Home4 = zeros(7, popUnit(4));
Home5 = zeros(7, popUnit(5));
Home6 = zeros(7, popUnit(6));
Home7 = zeros(7, popUnit(7));

Home1com = [19 315]; % 1e 1a
Home2com = [50 323 6 56]; % 2e 2a 1e1a 1a1k
Home3com = [94 28 65 9]; % 2a1k 1a2k 1a2e 2a1e
Home4com = [112 7 44]; % 2a2k 1a3k 2a2e
Home5com = [51 2 15]; % 2a3k 1a4k 3a2e
Home6com = [11 6 5]; % 2a4k 1e1a4k 4a2e
Home7com = [6 2 4]; % 2a5k 1e1a5k 5a2e

KidsId = [1:kidspop+youngpop];
KidsId = KidsId(randperm(length(KidsId)));
AdultId = [kidspop+youngpop+1:kidspop+youngpop+adult];
AdultId = AdultId(randperm(length(AdultId)));
OldId = [kidspop+youngpop+adult+1:kidspop+youngpop+adult+oldpop];
OldId = OldId(randperm(length(OldId)));

tempkids = KidsId;
tempadult = AdultId; 
tempold = OldId;

%%1. compose home1
Home1(1,1:Home1com(1)) = tempold(1:Home1com(1));
tempold(1:Home1com(1)) = [];
Home1(1,Home1com(1)+1:end) = tempadult(1:Home1com(2));
tempadult(1:Home1com(2)) = [];

%%2. compose home2
 for i=1:2
%2.1 two olds
  Home2(i,1:Home2com(1)) = tempold(1:Home2com(1));
  tempold(1:Home2com(1)) = [];
%2.2 two adults
  Home2(i,Home2com(1)+1:Home2com(1)+Home2com(2)) = tempadult(1:Home2com(2));
  tempadult(1:Home2com(2)) = [];
end

%2.3 one old one adult
Home2(1, Home2com(1)+Home2com(2)+1:Home2com(1)+Home2com(2)+Home2com(3)) = tempadult(1:Home2com(3));
tempadult(1:Home2com(3)) = [];
Home2(2, Home2com(1)+Home2com(2)+1:Home2com(1)+Home2com(2)+Home2com(3)) = tempold(1:Home2com(3));
tempold(1:Home2com(3)) = [];

%2.4 one adult one kid
Home2(1, Home2com(1)+Home2com(2)+Home2com(3)+1:end) = tempadult(1:Home2com(4));
tempadult(1:Home2com(4)) = [];
Home2(2, Home2com(1)+Home2com(2)+Home2com(3)+1:end) = tempkids(1:Home2com(4));
tempkids(1:Home2com(4)) = [];

%%3. compose home3
for i=1:2
%3.1 two adults
  Home3(i,1:Home3com(1)) = tempadult(1:Home3com(1));
  tempadult(1:Home3com(1)) = [];
%3.2 two kids
  Home3(i,Home3com(1)+1:Home3com(1)+Home3com(2))= tempkids(1:Home3com(2));
  tempkids(1:Home3com(2)) = [];
%3.3 two olds
  Home3(i,Home3com(1)+Home3com(2)+1:Home3com(1)+Home3com(2)+Home3com(3))= tempold(1:Home3com(3));
  tempold(1:Home3com(3)) = [];
%3.4 two adults
  Home3(i,Home3com(1)+Home3com(2)+Home3com(3)+1:end)= tempadult(1:Home3com(4));
  tempadult(1:Home3com(4)) = [];  
end

%3.1 one kid in two adults home
  Home3(3,1:Home3com(1))= tempkids(1:Home3com(1));
  tempkids(1:Home3com(1)) = [];
%3.2 one adult in two kids home
  Home3(3,Home3com(1)+1:Home3com(1)+Home3com(2))= tempadult(1:Home3com(2));
  tempadult(1:Home3com(2)) = [];
%3.3 one adult in two olds home
  Home3(3,Home3com(1)+Home3com(2)+1:Home3com(1)+Home3com(2)+Home3com(3))= tempadult(1:Home3com(3));
  tempadult(1:Home3com(3)) = [];
%3.4 one old in two old home
  Home3(3,Home3com(1)+Home3com(2)+Home3com(3)+1:end)= tempold(1:Home3com(4));
  tempold(1:Home3com(4)) = [];  

%%4. compose home4
%4.1 2A2C
  Home4(1,1:Home4com(1)) = tempadult(1:Home4com(1));
  tempadult(1:Home4com(1)) = [];
  Home4(2,1:Home4com(1)) = tempadult(1:Home4com(1));
  tempadult(1:Home4com(1)) = [];
  Home4(3,1:Home4com(1)) = tempkids(1:Home4com(1));
  tempkids(1:Home4com(1)) = [];
  Home4(4,1:Home4com(1)) = tempkids(1:Home4com(1));
  tempkids(1:Home4com(1)) = [];
%4.2 1A3C
  Home4(1,Home4com(1)+1:Home4com(1)+Home4com(2)) = tempadult(1:Home4com(2));
  tempadult(1:Home4com(2)) = [];
  Home4(2,Home4com(1)+1:Home4com(1)+Home4com(2)) = tempkids(1:Home4com(2));
  tempkids(1:Home4com(2)) = [];
  Home4(3,Home4com(1)+1:Home4com(1)+Home4com(2)) = tempkids(1:Home4com(2));
  tempkids(1:Home4com(2)) = [];
  Home4(4,Home4com(1)+1:Home4com(1)+Home4com(2)) = tempkids(1:Home4com(2));
  tempkids(1:Home4com(2)) = [];
%4.3 2A2S
  Home4(1,Home4com(1)+Home4com(2)+1:end) = tempadult(1:Home4com(3));
  tempadult(1:Home4com(3)) = [];
  Home4(2,Home4com(1)+Home4com(2)+1:end) = tempadult(1:Home4com(3));
  tempadult(1:Home4com(3)) = [];
  Home4(3,Home4com(1)+Home4com(2)+1:end) = tempold(1:Home4com(3));
  tempold(1:Home4com(3)) = [];
  Home4(4,Home4com(1)+Home4com(2)+1:end) = tempold(1:Home4com(3));
  tempold(1:Home4com(3)) = [];
  
%%5. compose home5
%5.1 2A3C
  Home5(1,1:Home5com(1)) = tempadult(1:Home5com(1));
  tempadult(1:Home5com(1)) = [];
  Home5(2,1:Home5com(1)) = tempadult(1:Home5com(1));
  tempadult(1:Home5com(1)) = [];
  Home5(3,1:Home5com(1)) = tempkids(1:Home5com(1));
  tempkids(1:Home5com(1)) = [];
  Home5(4,1:Home5com(1)) = tempkids(1:Home5com(1));
  tempkids(1:Home5com(1)) = [];
  Home5(5,1:Home5com(1)) = tempkids(1:Home5com(1));
  tempkids(1:Home5com(1)) = [];
%5.2 1A4C
  Home5(1,Home5com(1)+1:Home5com(1)+Home5com(2)) = tempadult(1:Home5com(2));
  tempadult(1:Home5com(2)) = [];
  Home5(2,Home5com(1)+1:Home5com(1)+Home5com(2)) = tempkids(1:Home5com(2));
  tempkids(1:Home5com(2)) = [];
  Home5(3,Home5com(1)+1:Home5com(1)+Home5com(2)) = tempkids(1:Home5com(2));
  tempkids(1:Home5com(2)) = [];
  Home5(4,Home5com(1)+1:Home5com(1)+Home5com(2)) = tempkids(1:Home5com(2));
  tempkids(1:Home5com(2)) = [];
  Home5(5,Home5com(1)+1:Home5com(1)+Home5com(2)) = tempkids(1:Home5com(2));
  tempkids(1:Home5com(2)) = [];
%5.3 3A2S
  Home5(1,Home5com(1)+Home5com(2)+1:end) = tempadult(1:Home5com(3));
  tempadult(1:Home5com(3)) = [];
  Home5(2,Home5com(1)+Home5com(2)+1:end) = tempadult(1:Home5com(3));
  tempadult(1:Home5com(3)) = [];
  Home5(3,Home5com(1)+Home5com(2)+1:end) = tempadult(1:Home5com(3));
  tempadult(1:Home5com(3)) = [];
  Home5(4,Home5com(1)+Home5com(2)+1:end) = tempold(1:Home5com(3));
  tempold(1:Home5com(3)) = [];
  Home5(5,Home5com(1)+Home5com(2)+1:end) = tempold(1:Home5com(3));
  tempold(1:Home5com(3)) = [];

%%6. compose home6
%6.1 2A4C
  Home6(1,1:Home6com(1)) = tempadult(1:Home6com(1));
  tempadult(1:Home6com(1)) = [];
  Home6(2,1:Home6com(1)) = tempadult(1:Home6com(1));
  tempadult(1:Home6com(1)) = [];
  Home6(3,1:Home6com(1)) = tempkids(1:Home6com(1));
  tempkids(1:Home6com(1)) = [];
  Home6(4,1:Home6com(1)) = tempkids(1:Home6com(1));
  tempkids(1:Home6com(1)) = [];
  Home6(5,1:Home6com(1)) = tempkids(1:Home6com(1));
  tempkids(1:Home6com(1)) = [];
  Home6(6,1:Home6com(1)) = tempkids(1:Home6com(1));
  tempkids(1:Home6com(1)) = [];
%6.2 1A4C1S
  Home6(1,Home6com(1)+1:Home6com(1)+Home6com(2)) = tempadult(1:Home6com(2));
  tempadult(1:Home6com(2)) = [];
  Home6(2,Home6com(1)+1:Home6com(1)+Home6com(2)) = tempkids(1:Home6com(2));
  tempkids(1:Home6com(2)) = [];
  Home6(3,Home6com(1)+1:Home6com(1)+Home6com(2)) = tempkids(1:Home6com(2));
  tempkids(1:Home6com(2)) = [];
  Home6(4,Home6com(1)+1:Home6com(1)+Home6com(2)) = tempkids(1:Home6com(2));
  tempkids(1:Home6com(2)) = [];
  Home6(5,Home6com(1)+1:Home6com(1)+Home6com(2)) = tempkids(1:Home6com(2));
  tempkids(1:Home6com(2)) = [];
  Home6(6,Home6com(1)+1:Home6com(1)+Home6com(2)) = tempold(1:Home6com(2));
  tempold(1:Home6com(2)) = [];
%6.3 4A2S
  Home6(1,Home6com(1)+Home6com(2)+1:end) = tempadult(1:Home6com(3));
  tempadult(1:Home6com(3)) = [];
  Home6(2,Home6com(1)+Home6com(2)+1:end) = tempadult(1:Home6com(3));
  tempadult(1:Home6com(3)) = [];
  Home6(3,Home6com(1)+Home6com(2)+1:end) = tempadult(1:Home6com(3));
  tempadult(1:Home6com(3)) = [];
  Home6(4,Home6com(1)+Home6com(2)+1:end) = tempadult(1:Home6com(3));
  tempadult(1:Home6com(3)) = [];
  Home6(5,Home6com(1)+Home6com(2)+1:end) = tempold(1:Home6com(3));
  tempold(1:Home6com(3)) = [];
  Home6(6,Home6com(1)+Home6com(2)+1:end) = tempold(1:Home6com(3));
  tempold(1:Home6com(3)) = [];
  
%%7. compose home7
%7.1 2A5C
  Home7(1,1:Home7com(1)) = tempadult(1:Home7com(1));
  tempadult(1:Home7com(1)) = [];
  Home7(2,1:Home7com(1)) = tempadult(1:Home7com(1));
  tempadult(1:Home7com(1)) = [];
  Home7(3,1:Home7com(1)) = tempkids(1:Home7com(1));
  tempkids(1:Home7com(1)) = [];
  Home7(4,1:Home7com(1)) = tempkids(1:Home7com(1));
  tempkids(1:Home7com(1)) = [];
  Home7(5,1:Home7com(1)) = tempkids(1:Home7com(1));
  tempkids(1:Home7com(1)) = [];
  Home7(6,1:Home7com(1)) = tempkids(1:Home7com(1));
  tempkids(1:Home7com(1)) = [];
  Home7(7,1:Home7com(1)) = tempkids(1:Home7com(1));
  tempkids(1:Home7com(1)) = []; 
%7.2 1A5C1S
  Home7(1,Home7com(1)+1:Home7com(1)+Home7com(2)) = tempadult(1:Home7com(2));
  tempadult(1:Home7com(2)) = [];
  Home7(2,Home7com(1)+1:Home7com(1)+Home7com(2)) = tempkids(1:Home7com(2));
  tempkids(1:Home7com(2)) = [];
  Home7(3,Home7com(1)+1:Home7com(1)+Home7com(2)) = tempkids(1:Home7com(2));
  tempkids(1:Home7com(2)) = [];
  Home7(4,Home7com(1)+1:Home7com(1)+Home7com(2)) = tempkids(1:Home7com(2));
  tempkids(1:Home7com(2)) = [];
  Home7(5,Home7com(1)+1:Home7com(1)+Home7com(2)) = tempkids(1:Home7com(2));
  tempkids(1:Home7com(2)) = [];
  Home7(6,Home7com(1)+1:Home7com(1)+Home7com(2)) = tempkids(1:Home7com(2));
  tempkids(1:Home7com(2)) = [];
  Home7(7,Home7com(1)+1:Home7com(1)+Home7com(2)) = tempold(1:Home7com(2));
  tempold(1:Home7com(2)) = [];
%7.3 5A2S
  Home7(1,Home7com(1)+Home7com(2)+1:end) = tempadult(1:Home7com(3));
  tempadult(1:Home7com(3)) = [];
  Home7(2,Home7com(1)+Home7com(2)+1:end) = tempadult(1:Home7com(3));
  tempadult(1:Home7com(3)) = [];
  Home7(3,Home7com(1)+Home7com(2)+1:end) = tempadult(1:Home7com(3));
  tempadult(1:Home7com(3)) = [];
  Home7(4,Home7com(1)+Home7com(2)+1:end) = tempadult(1:Home7com(3));
  tempadult(1:Home7com(3)) = [];
  Home7(5,Home7com(1)+Home7com(2)+1:end) = tempadult(1:Home7com(3));
  tempadult(1:Home7com(3)) = [];
  Home7(6,Home7com(1)+Home7com(2)+1:end) = tempold(1:Home7com(3));
  tempold(1:Home7com(3)) = [];
  Home7(7,Home7com(1)+Home7com(2)+1:end) = tempold(1:Home7com(3));
  tempold(1:Home7com(3)) = [];
  
  adjHouse = [Home1 Home2 Home3 Home4 Home5 Home6 Home7];
end