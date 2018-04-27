clear all;
close all;
clc
tic
%suspectious:0, intubating:1, infectious:2, recovered:3
%in flu season, everyone is suspectious
%once the suspectious individual contacts with infectious patients, he might be intubating (with certain probabilty)
%intubation time = 1 - 2 days
%infectious time = 5 - 7 days

%Approximately 33% of people with influenza are asymptomatic.[22]
%Symptoms of influenza can start quite suddenly one to two days after infection.

%==================
%important parameters changing the transmission rate of influenza:
% 1. changepara, the larger, the maximum is later, meanwhile, the basic
% shape can be changed
% 2. SimulatedCommPara, the less, the maximum is later
%==================

Mathea = [];
Matlat = [];
Matinf = [];
Matrec = [];
Matinfectiony = [];
MatinfecpplID = [];

for num=1:1
    
    num
%==========parameters=========
global PeopleId
global MatPeopleId
global NumPopulation
global adjHouse
global PopuCompose
global precautionComm
global awarenessComm
global precautionHome
global awarenessHome

%baselineH = 0.4;

kidspop = 198; %round(percensus(1)*NumPopulation);
youngpop = 522; %round(percensus(2)*NumPopulation);
adult = 1872; %NumPopulation-(kidspop+youngpop+oldpop);
oldpop = 408; %round(percensus(4)*NumPopulation);

kidsrand = randperm(kidspop+youngpop);
adultrand = randperm(adult);
oldrand = randperm(oldpop);
kidscoverate = 0.3777;
adultcoverate = 0.3733;
oldcoverate = 0.6993;
kidsve = 0.25;
adultve = 0.44;
oldve = 0.35;

%learned by mcmc: -0.0010   -0.0093    0.5040   -0.1337   -0.1121 3.1329    1.5034    3.8051    4.1409    3.7333
paralist = [-0.0010   -0.0093    0.5440   -0.1255   -0.1025  6.329    1.3004    6.0051    6.1409    6.4333]; %6.429    1.2034    6.1551    6.1409    6.4333

bias1 = paralist(1);
bias2 = paralist(2);
bias3 = paralist(3);
bias4 = paralist(4);
bias5 = paralist(5);
awarenesscoef = paralist(6);
coldcoef = paralist(7);
degreecoefC = paralist(8);
degreecoefH = paralist(9);
degreecoefW = paralist(10);

awacoef = awarenesscoef*ones(1,3000);

Vaccdata = load('.\MatVacc.mat'); % This one got the best result
totalvaccined = Vaccdata.MatVacc;

immuneresp = load('./immuneresp.mat'); % This one got the best result
immuneresp = immuneresp.immuneresp;
immuneresp = immuneresp';

%y2009 = [84.8 79.6 57.8 52.0 37.9 35.8 36.0 50.3 62.4 69.7 79.0]; %
%  y2009 = [79.9 73.4 61.0 49.1 44.9 45.3 49.7 61.9 67.8 77.4 78.0];
% z = 5*(y2009-32)/9;
% t1 = sort(randr(28, min(z(1), z(2)), max(z(1), z(2))), 'descend');
% t2 = sort(randr(28, min(z(3), z(2)), max(z(3), z(2))), 'descend');
% t3 = sort(randr(28, min(z(3), z(4)), max(z(3), z(4))), 'descend');
% t4 = sort(randr(28, min(z(4), z(5)), max(z(4), z(5))), 'descend');
% t5 = sort(randr(28, min(z(5), z(6)), max(z(5), z(6))));
% t6 = sort(randr(28, min(z(6), z(7)), max(z(6), z(7))));
% t7 = sort(randr(28, min(z(7), z(8)), max(z(7), z(8))));
% t8 = sort(randr(28, min(z(9), z(8)), max(z(9), z(8))));
% t9 = sort(randr(28, min(z(10), z(9)), max(z(10), z(9))));
% t10 = sort(randr(28, min(z(11), z(10)), max(z(11), z(10))));
% 
% coldfactor09 = [z(1) t1' z(2) t2' z(3) t3' z(4) t4' z(5) t5' z(6) t6' z(7) t7' z(8) t8' z(9) t9' z(10) t10'];
% coldfactor09 = 1.5*coldfactor09/max(coldfactor09);
cold = load('./coldfactor09.mat'); % This one got the best result
coldfactor09 = cold.coldfactor09;
coldfactorday = coldcoef./(1+exp(-coldfactor09))-bias3;




precaucomm = load('./precaucomm.mat'); % This one got the best result
baselineC = bias1 + precaucomm.precaucomm;

precauhome = load('./precauhome.mat'); % This one got the best result
baselineH = bias2 + precauhome.precauhome;

baselineW = baselineC;

PopuCompose = [kidspop youngpop adult oldpop];

NumPopulation = 3000;
RateOuthealth = 0.6;
RateOutsick = 0.1;
GooutrateSat = 0.5;
GooutrateSun = 0.5;
NumofInfection = 8; % 3 is the better parameter

%% for weekend
% ContactdegSat = 2;
% NetSat = SFNG(round(NumPopulation*GooutrateSat), ContactdegSat, seed);
NetSat = load('./Weekend_1sa.mat');
NetSat = NetSat.Net;
NetSat = triu(NetSat);

NetSat(totalvaccined,:)=0;
NetSat(:,totalvaccined)=0;

% ContactdegSun = 3;
%NetSun = SFNG(round(NumPopulation*GooutrateSun), ContactdegSun, seed);
NetSun = load('./Weekend_1su.mat');
NetSun = NetSun.Net;
NetSun = triu(NetSun);

NetSun(totalvaccined,:)=0;
NetSun(:,totalvaccined)=0;
%%

%% for household
Housedata = load('./adjHouse.mat'); % This one got the best result
adjHouse = Housedata.adjHouse;
%%

%% for weekday
changepara = 0.01;  % the social network changes 0.5% every day
UsefulAdj = [];    
UsefulAdj=BuildNetwork;
% % %drawGraph(adj);
% UsefulAdj = triu (adj);
%  Usefuldata = load('./UsefulAdjtest.mat'); %This one got the best result
%  UsefulAdj = Usefuldata.UsefulAdj;
 
UsefulAdj(totalvaccined,:)=0;
UsefulAdj(:,totalvaccined)=0;
 %.
%%

%% for four states
%1. latent
incubtime = [ones(1, 2000) 2*ones(1, 1000)];
incubtime = incubtime(randperm(NumPopulation));

%2. infectious
infectimekids = [7*ones(1, 123) 8*ones(1, 123) 9*ones(1, 123) 10*ones(1, 123) 11*ones(1, 123) 12*ones(1, 26) 13*ones(1, 26) 14*ones(1, 26) 15*ones(1, 27)];
infectimeadults = [5*ones(1, 630) 6*ones(1, 550) 7*ones(1, 550) 8*ones(1, 550)];

infectimekids = infectimekids(randperm(length(infectimekids)));
infectimeadults = infectimeadults(randperm(length(infectimeadults)));
infectime = [infectimekids infectimeadults];

R0P = mean(infectime); % This may not right

% 3. define period of four states for individuals               
%% 3.1===create the latent period===
TotalLatencyDays = incubtime; %Each person in this community has a specific intubating period (1-2 days)
LatentPara = [];
LatentId = [];
LatentedDays = zeros(1, NumPopulation); %Recorded how many days have gone during the period

%% 3.2===create the infection period===
% 3.2.1. randomly assign people being infectious    
TotalInfectionDays = infectime; %Each person in this community has a specific infectious period (7-10 days)
Id_temp = randperm(NumPopulation);
%InfectedId = Id_temp(1:NumofInfection);

Notvacciated = setdiff(1:3000, totalvaccined); % those are not infected;
Notvaccrandid = randperm(length(Notvacciated));
%InfectedId = [1601 710 1289 1829 1484 575 2309 2222 2739 1068 2239 1866 2848 724 312 1085 1929 2366 1763 1182];
InfectedId = Notvacciated(Notvaccrandid(1:8));%[1203 2989]; % make sure the two persons are not vaccined
Day_temp = randl(NumofInfection, 1, 4); % randly set a infection day, it is between 1 day and 4 days;
InfectedDays = zeros(1, NumPopulation); 
InfectedDays(InfectedId) = Day_temp; %Recorded how many days have gone during the period

% 3.2.2. initial status of the network
PeopleId = zeros(1, NumPopulation);  % initially, every one is in suspecious status
PeopleId(InfectedId) = 2; % except some of them are initially infected
MatPeopleId = [];

% 3.2.3. create the infection period===
for i=1:length(InfectedId)
    if InfectedDays(InfectedId(i))>TotalInfectionDays(InfectedId(i))
        InfectedDays(InfectedId(i))=TotalInfectionDays(InfectedId(i));
    end
end

%% 3.3===create the recovered period===
TotalRecoveryDays = ones(1, NumPopulation); %Each person in this community has a recovery period (1 day)  
RecoveryPara = [];
RecoveredId = []; %totalvaccined;
PeopleId(RecoveredId) = 3; % except some of them are initially infected
RecoveredDays = zeros(1, NumPopulation); %Recorded how many days have gone during the period

LatentPara = [LatentedDays; TotalLatencyDays];
InfectionPara = [InfectedDays; TotalInfectionDays];    
RecoveryPara = [RecoveredDays; TotalRecoveryDays];
%%

reproductnumall = [];
everydegree = [];
AwareCMat = [];
PrecauCMat = [];
AwareHMat = [];
PrecauHMat = [];
AwareWMat = [];
PrecauWMat = [];
AwareMat = [];
PrecauMat = [];

%initially parameters
%%1.community parameters
awarenessComm = baselineC; % related to individual's age and reproductive number
for indi = 1:3000
    everydegree(indi) = length(find(UsefulAdj(indi, :)==1))+length(find(UsefulAdj(:, indi)==1)); %precaution is related to the number of individual's connection
end
precautionComm = 0.9*exp(-1./everydegree); % related to individual's connection number and reproductive number
%%2.home parameters
awarenessHome = baselineH;
precautionHome = 0.7 + 0.2.*rand(1,3000); % precautionHome is in [0.4 0.6];
%%3.weekend parameters
for indisa = 1:3000
    everydegreesa(indisa) = length(find(NetSat(indisa, :)==1))+length(find(NetSat(:, indisa)==1)); %precaution is related to the number of individual's connection
end
for indisu = 1:3000
    everydegreesu(indisu) = length(find(NetSun(indisu, :)==1))+length(find(NetSun(:, indisu)==1)); %precaution is related to the number of individual's connection
end
awarenessWend = baselineC; % related to individual's age and reproductive number
precautionWend = 0.9*exp(-1./everydegreesa); % related to individual's connection number and reproductive number
    
AwareCMat = [AwareCMat; awarenessComm];
PrecauCMat = [PrecauCMat; precautionComm];
AwareHMat = [AwareHMat; awarenessHome];
PrecauHMat = [PrecauHMat; precautionHome];
AwareWMat = [AwareWMat; awarenessWend];
PrecauWMat = [PrecauWMat; precautionWend];
AwareMat = [AwareMat; awarenessComm];
PrecauMat = [PrecauMat; precautionComm];

InfecPPLid = zeros(1,3000);
storelamda = [];
index = 0;
noofday = 0; 
%%
for week=1:37 % whole flu season

    adj = [];
    MatIdEDirectAll = [];
    MatIdEDirect = [];
    MatIdE = [];
    reproductnumweek = [];
    
    week

%%%Monday-Friday
    for workday = 1:5
        noofday = noofday+1;
        
         MatPeopleId = [MatPeopleId; PeopleId]; % record people's condition before working day morning
         infecratetemp0 = length(InfectedId);
        
         [LatentPara, InfectionPara, RecoveryPara, LatentId, InfectedId, RecoveredId]=InfectionProcessComm(UsefulAdj, LatentPara, InfectionPara, RecoveryPara, LatentId, InfectedId, RecoveredId, awarenessComm, precautionComm,immuneresp);
       
         infecratetemp1 = length(InfectedId);
        
         infrate = ((infecratetemp1-infecratetemp0)/(abs((infecratetemp1-infecratetemp0))+1))*max([infecratetemp0, infecratetemp1])/(min([infecratetemp0, infecratetemp1])+1);
         %(infecratetemp1-infecratetemp0)/(infecratetemp0+1)+((infecratetemp1-infecratetemp0)/(abs((infecratetemp1-infecratetemp0))+1))*infecratetemp0/30;
         awarenessHome = awacoef*(awarefun(infrate)-bias4)*coldfactorday(noofday); % related to individual's age and reproductive number
         UsefulAdj=ChangeSocialNetwork(UsefulAdj, changepara);
         UsefulAdj(totalvaccined,:)=0;
         UsefulAdj(:,totalvaccined)=0;

         for indi = 1:3000
             everydegree(indi) = length(find(UsefulAdj(indi, :)==1))+length(find(UsefulAdj(:, indi)==1)); %precaution is related to the number of individual's connection
         end
         precautionHome = degreecoefH*baselineH.*(exp(-1./everydegreesu)-bias5)*(awarefun(infrate)-bias4); % related to individual's connection number and reproductive number
                          
         AwareMat = [AwareMat; awarenessHome];
         PrecauMat = [PrecauMat; precautionHome];
         
         MatPeopleId = [MatPeopleId; PeopleId]; % record people's condition before working day night
         [LatentPara, InfectionPara, RecoveryPara, LatentId, InfectedId, RecoveredId]=InfectionProcessHome(adjHouse, LatentPara, InfectionPara, RecoveryPara, LatentId, InfectedId, RecoveredId, awarenessHome, precautionHome,immuneresp);
         infecratetemp0 = length(InfectedId);
         infrate = ((infecratetemp0-infecratetemp1)/(abs((infecratetemp1-infecratetemp0))+1))*max([infecratetemp0, infecratetemp1])/min([infecratetemp0, infecratetemp1]+1);
         awarenessComm = awacoef*(awarefun(infrate)-bias4)*coldfactorday(noofday); % related to individual's age and reproductive number
         precautionComm = degreecoefC*baselineC.*(exp(-1./everydegreesu)-bias5)*(awarefun(infrate)-bias4);

        AwareMat = [AwareMat; awarenessComm];
        PrecauMat = [PrecauMat; precautionComm];
         
    end
    
%%%Saturday
  %%daytime
          noofday = noofday+1;
    MatPeopleId = [MatPeopleId; PeopleId]; % record people's condition before saturday morning
    awarenessWend = awarenessComm;
    precautionWend = precautionComm;
    [LatentPara, InfectionPara, RecoveryPara, LatentId, InfectedId, RecoveredId]=InfectionProcessWeekend(NetSat, GooutrateSat, LatentPara, InfectionPara, RecoveryPara, LatentId, InfectedId, RecoveredId, awarenessWend, precautionWend,immuneresp);  
    %%%=====add this part for dynamically calculate parameters
    %% this calculation is for Sunday, so here using "everydegreesu"
         infecratetemp1 = length(InfectedId);
         infrate = ((infecratetemp1-infecratetemp0)/(abs((infecratetemp1-infecratetemp0))+1))*max([infecratetemp0, infecratetemp1])/min([infecratetemp0, infecratetemp1]+1);
%    InfectedId     
    awarenessHome = awacoef*(awarefun(infrate)-bias4)*coldfactorday(noofday); % related to individual's age and reproductive number 
    precautionHome = degreecoefH*baselineH.*(exp(-1./everydegreesu)-bias5)*(awarefun(infrate)-bias4); % related to individual's connection number and reproductive number
%     AwareWMat = [AwareWMat; awarenessWend];
%     PrecauWMat = [PrecauWMat; precautionWend];
    AwareMat = [AwareMat; awarenessHome];
    PrecauMat = [PrecauMat; precautionHome];
    %%%=====  
    
  %%nighttime 
    MatPeopleId = [MatPeopleId; PeopleId]; % record people's condition before saturday night
    [LatentPara, InfectionPara, RecoveryPara, LatentId, InfectedId, RecoveredId]=InfectionProcessHome(adjHouse, LatentPara, InfectionPara, RecoveryPara, LatentId, InfectedId, RecoveredId, awarenessHome, precautionHome,immuneresp);
    %%%=====add this part for dynamically calculate parameters
         infecratetemp0 = length(InfectedId);
         infrate = ((infecratetemp0-infecratetemp1)/(abs((infecratetemp1-infecratetemp0))+1))*max([infecratetemp0, infecratetemp1])/min([infecratetemp0, infecratetemp1]+1);
    awarenessWend = awacoef*(awarefun(infrate)-bias4)*coldfactorday(noofday); % related to individual's age and reproductive number
    precautionWend = degreecoefW*baselineW.*(exp(-1./everydegreesu)-bias5)*(awarefun(infrate)-bias4);
%     AwareHMat = [AwareHMat; awarenessHome];
%     PrecauHMat = [PrecauHMat; precautionHome];
        AwareMat = [AwareMat; awarenessWend];
        PrecauMat = [PrecauMat; precautionWend];

%Sunday
  %%daytime
          noofday = noofday+1;
    MatPeopleId = [MatPeopleId; PeopleId]; % record people's condition before sunday morning
        infecratetemp0 = length(InfectedId);
   
    [LatentPara, InfectionPara, RecoveryPara, LatentId, InfectedId, RecoveredId]=InfectionProcessWeekend(NetSun, GooutrateSun, LatentPara, InfectionPara, RecoveryPara, LatentId, InfectedId, RecoveredId, awarenessWend, precautionWend,immuneresp);  
    %%%=====add this part for dynamically calculate parameters
    %% this calculation is for next Saturday, so here using "everydegreesa"
         infecratetemp1 = length(InfectedId);
         infrate = ((infecratetemp1-infecratetemp0)/(abs((infecratetemp1-infecratetemp0))+1))*max([infecratetemp0, infecratetemp1])/min([infecratetemp0, infecratetemp1]+1);
         
    awarenessHome = awacoef*(awarefun(infrate)-bias4)*coldfactorday(noofday); % related to individual's age and reproductive number
    precautionHome = degreecoefH*baselineH.*(exp(-1./everydegreesu)-bias5)*(awarefun(infrate)-bias4); % related to individual's connection number and reproductive number
%     AwareWMat = [AwareWMat; awarenessWend];
%     PrecauWMat = [PrecauWMat; precautionWend];
    AwareMat = [AwareMat; awarenessHome];
    PrecauMat = [PrecauMat; precautionHome];
    
    %%%=====
    
  %%nighttime  
    MatPeopleId = [MatPeopleId; PeopleId]; % record people's condition before sunday night
    [LatentPara, InfectionPara, RecoveryPara, LatentId, InfectedId, RecoveredId]=InfectionProcessHome(adjHouse, LatentPara, InfectionPara, RecoveryPara, LatentId, InfectedId, RecoveredId, awarenessHome, precautionHome,immuneresp);
    %%%=====add this part for dynamically calculate parameters
         infecratetemp0 = length(InfectedId);
         infrate = ((infecratetemp0-infecratetemp1)/(abs((infecratetemp1-infecratetemp0))+1))*max([infecratetemp0, infecratetemp1])/min([infecratetemp0, infecratetemp1]+1);
    awarenessComm = awacoef*(awarefun(infrate)-bias4)*coldfactorday(noofday); % related to individual's age and reproductive number  
    precautionComm = degreecoefC*baselineC.*(exp(-1./everydegreesu)-bias5)*(awarefun(infrate)-bias4);
%     AwareHMat = [AwareHMat; awarenessHome];
%     PrecauHMat = [PrecauHMat; precautionHome];
        AwareMat = [AwareMat; awarenessComm];
        PrecauMat = [PrecauMat; precautionComm];
    
    HealthId = find(PeopleId==0);
    randhealthid = randperm(length(HealthId));
    PeopleId(randhealthid(1))=1;
    InfectedId = [InfectedId randhealthid(1)];

    creatinfeday = randperm(4);
    InfectionPara(1,randhealthid(1)) = creatinfeday(1);          
end
%% end of iterations

MatPeopleId = [MatPeopleId; PeopleId];  % we should add the last day in the matrix

Mathealth = [];
Matlatent = [];
Matinfection = [];
Matrecover = [];

for dayflu = 1:size(MatPeopleId,1)
    conditionperday = MatPeopleId(dayflu, :);
    peoplehealth = length(find(conditionperday==0));
    peoplelatent = length(find(conditionperday==1));
    peopleinfection = length(find(conditionperday==2));
    peoplerecover = length(find(conditionperday==3));
    Mathealth = [Mathealth peoplehealth];
    Matlatent = [Matlatent peoplelatent];
    Matinfection = [Matinfection peopleinfection];
    Matrecover = [Matrecover peoplerecover];
end

Math = imresize(Mathealth, 0.5);
Matl = imresize(Matlatent, 0.5);
Mati = imresize(Matinfection, 0.5);
Matr = imresize(Matrecover, 0.5);

MatPeopleIdReal = MatPeopleId;

for i=1:(size(MatPeopleIdReal,1)-1)
    for j = 1:size(MatPeopleIdReal,2)
        if(MatPeopleIdReal(i,j)==1)&(MatPeopleIdReal(i+1,j)==2)
            MatPeopleIdReal(i+1,j)=5;
        end
    end
end

%size(MatPeopleIdReal,1)

MatinfectionReal = [];

for dayflur = 1:size(MatPeopleIdReal,1)
    conditionperdayr = MatPeopleIdReal(dayflur, :); 
    peopleinfectionr = length(find(conditionperdayr==5));
    MatinfectionReal = [MatinfectionReal peopleinfectionr];
end

y = imresize(MatinfectionReal, 0.5);

for kk = 1:fix(length(y)/7)
    yw(kk) = sum(y(((kk-1)*7+1):kk*7));
end
yw(kk+1) = sum(y(kk*7+1:end));

figure(1)
plot(yw,'LineWidth',2);
xlabel('Days','fontsize',12,'fontweight','b');
ylabel('Population','fontsize',12,'fontweight','b');
title('Infectious','fontsize',12,'fontweight','b'); 
set(gca,'FontSize',12,'fontweight','b')

figure(2)
plot(Mati,'LineWidth',2);
xlabel('Days','fontsize',12,'fontweight','b');
ylabel('Population','fontsize',12,'fontweight','b');
title('Infectious','fontsize',12,'fontweight','b'); 
set(gca,'FontSize',12,'fontweight','b')

Mathea = [Mathea; Math];
Matlat = [Matlat; Matl];
Matinf = [Matinf; Mati];
Matrec = [Matrec; Matr];
Matinfectiony = [Matinfectiony; y];

InfecPPLid = any(MatPeopleId);
MatinfecpplID = [MatinfecpplID; InfecPPLid];
end
% xlswrite('./results/Mathea0.xls', Mathea);
% xlswrite('./results/Matlat0.xls', Matlat);
% xlswrite('./results/Matinf0.xls', Matinf);
% xlswrite('./results/Matrec0.xls', Matrec);
% xlswrite('./results/Matinfectiony.xls', Matinfectiony);
toc

ttt0 = MatinfecpplID;
totalinfection = length(find(ttt0==1));

tttk = ttt0(:,1:198);
ttty = ttt0(:,199:720);
ttta = ttt0(:,721:2592);
ttto = ttt0(:,2593:3000);
results = zeros(size(ttt0,1),4);

for i=1:size(ttt0,1)
    results(i,1) = length(find(tttk(i,:)==1))
    results(i,2) = length(find(ttty(i,:)==1))
    results(i,3) = length(find(ttta(i,:)==1))
    results(i,4) = length(find(ttto(i,:)==1))
    results1 = [results(i,1)/totalinfection results(i,2)/totalinfection results(i,3)/totalinfection results(i,4)/totalinfection]
    results2 = [results(i,1)/198 results(i,2)/522 results(i,3)/1872 results(i,4)/408]
end