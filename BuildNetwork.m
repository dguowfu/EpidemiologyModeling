%========D GUO, Wake Forest University School of Medicine========
%this functin is to create a network, including several communities.
%======================================================================
function UsefulAdj=BuildNetwork

% 1. 1:100 kids at home
% 2. 101:150 kids go out   50
% 3. 151:198 kids in daycare
% 4. 199:720 kids in school
% 5. 721:1973 adults at workplace  1253
% 6. 1974:2367 adults go out    394
% 7. 2368:2592 adults at home   225
% 8. 2593:2814 old at home    222
% 9. 2815:2900 old at workplace 86
% 10. 2901:3000 old go out   100

%WholeComPara=SimulatedCommPara(Indiciator); % Indiciator is used to indiciate if the community is daycare, school, etc.,
kidspop = 198; %round(percensus(1)*NumPopulation);
youngpop = 522; %round(percensus(2)*NumPopulation);
adultspop = 1872; %NumPopulation-(kidspop+youngpop+oldpop);
oldpop = 408; %round(percensus(4)*NumPopulation);
adultsworknum = 1253;
adultsnojob = 132;
oldworknum = 86;
kidhomenum = 100;
kidoutnum = 50;
kiddaycarenum = 48;
oldoutnum = 100; % 100 aged will go out
PublicPop = 544; % 50% percentage of population would like to go out in daytime

Housedata = load('.\adjHouse.mat'); % This one got the best result
HomeMat = Housedata.adjHouse;

KidsId = 1:kidspop;
YoungId = kidspop+1:kidspop+youngpop;
AdultsId = kidspop+youngpop+1:kidspop+youngpop+adultspop;
OldId = kidspop+youngpop+adultspop+1:kidspop+youngpop+adultspop+oldpop;

NumofPopulation = 3000;
KidsId = KidsId(randperm(length(KidsId)));
YoungId = YoungId(randperm(length(YoungId)));
AdultsId = AdultsId(randperm(length(AdultsId)));
OldId = OldId(randperm(length(OldId)));

Kidsnodaycare = KidsId(1:150);
Kidsdaycare = KidsId(151:end);

Withkids = [];

for i=1:length(Kidsnodaycare)
    PHomeID = find(HomeMat==Kidsnodaycare(i)); % patient home id
    HomeID = ceil(PHomeID/7);
    PPLID = HomeMat(:,HomeID);
    Adultsathome = PPLID(find(PPLID>720));
    Adultsathome = sort(Adultsathome, 'descend');
    Withkids(i) = Adultsathome(1);
end

Withkids = [Kidsnodaycare; Withkids];
Withkidsout = Withkids(:,1:50);

Adultswithkids = Withkids(2, find(Withkids(2,:)<2593));
Oldwithkids = Withkids(2, find(Withkids(2,:)>2592));

Adultswithkidsout = Withkidsout(2, find(Withkidsout(2,:)<2593));
Oldwithkidsout = Withkidsout(2, find(Withkidsout(2,:)>2592));

Adultswithkids = unique(Adultswithkids);
Oldwithkids = unique(Oldwithkids);
Adultswithkidsout = unique(Adultswithkidsout);
Oldwithkidsout = unique(Oldwithkidsout);
Adultswithkidshome = setdiff(Adultswithkids, Adultswithkidsout);
Oldwithkidshome = setdiff(Oldwithkids, Oldwithkidsout);

Kidsout = Withkidsout(1, :);
Kidshome = setdiff(Kidsnodaycare, Kidsout);

Adultsworkhome = setdiff(AdultsId, Adultswithkids);
Adultsworkhome = Adultsworkhome(randperm(length(Adultsworkhome)));
Adultswork = Adultsworkhome(1:adultsworknum);
Adultsnowork = Adultsworkhome(adultsworknum+1:end);

Adultsnokidsout = Adultsnowork(1:(PublicPop-oldoutnum-length(Adultswithkidsout)-50));
Adultsnokidshome = Adultsnowork(length(Adultsnokidsout)+1:end);
Adultsout = [Adultswithkidsout Adultsnokidsout];
Adultshome = [Adultswithkidshome Adultsnokidshome];


Oldworkhome = setdiff(OldId, Oldwithkids);
Oldworkhome = Oldworkhome(randperm(length(Oldworkhome)));
Oldwork = Oldworkhome(1:oldworknum);
Oldnowork = setdiff(Oldworkhome, Oldwork);
Oldnowork = Oldnowork(randperm(length(Oldnowork)));
Oldout = [Oldwithkidsout Oldnowork(1:(100-length(Oldwithkidsout)))];
Oldhome = [Oldwithkidshome Oldnowork((100-length(Oldwithkidsout))+1:end)];

Publicplace = [Kidsdaycare YoungId Adultswork Oldwork];
Home = [Kidshome Adultshome Oldhome];
Publicarea = [Kidsout Adultsout Oldout];

adjHome = zeros(length(Home), length(Home));
adjDaycare=BuildDaycare;
adjSchool=BuildSchool;
adjWorkplace=BuildWorkplace;
adjPublic=BuildPublic;

%SubPublication = [size(adjDaycare, 1) size(adjSchool, 1) size(adjWorkplace, 1) size(adjPublic, 1) size(adjHome, 1)];
%adjRestathome = zeros(3000-100-sum(SubPublication), 3000-100-sum(SubPublication));
TotalSubPublication = [size(adjDaycare, 1) size(adjSchool, 1) size(adjWorkplace, 1) size(adjPublic, 1) size(adjHome, 1)];

SimWholeMat = zeros(sum(TotalSubPublication), sum(TotalSubPublication)); % for the whole matrix
SimWholeMatS = mat2cell(SimWholeMat, TotalSubPublication, TotalSubPublication); % split into several submatrix

% totally, only four big communities: daycare, school, workplace, and public area
SimWholeMatS(1, 1) = {adjDaycare};
SimWholeMatS(2, 2) = {adjSchool};
SimWholeMatS(3, 3) = {adjWorkplace};
SimWholeMatS(4, 4) = {adjPublic};
SimWholeMatS(5, 5) = {adjHome};

AbsID = [Publicplace Publicarea Home];
adjWhole = cell2mat(SimWholeMatS);
adjWhole1 = [AbsID; adjWhole];
AbsI0D = [0 AbsID]';
adjWhole2 = [AbsI0D adjWhole1];

adjWhole3 = sortrows(adjWhole2);
adjWhole4 = sortrows(adjWhole3');
adjWhole4 = adjWhole4';
UsefulAdjt = adjWhole4(2:end, 2:end);

%UsefulAdjtt = UsefulAdjt|UsefulAdjt';

UsefulAdj = triu (UsefulAdjt);

%UsefulAdj = UsefulAdjtt-UsefulAdjtt.*eye(size(UsefulAdjtt));

end

% b=0;
% for i=1:3000
%     if ~isempty(find(UsefulAdjt(i,i)==1))
%         b = b+1;
%     end
% end
