%========D GUO, Wake Forest University School of Medicine========
%this functin is to determine any susceptible individuals who becomes
%intubating due to its neighbours.
%===input 1:[CommunitiesMat] the matrix of communities, the lower triangular components are all
%zeros
%===input 2:[MatIdEDirect] individual ids who are contacted with infectious
%individuals 
%===input 3-5:[H1,J1,H2,J2,alfa,tao]parameters to calculate the probability that any susceptible individual becomes
%intubating due to its neighbours 
%===output 1:[IndividualId] indicates the status of all ids 
%======================================================================
function [LatentPara, InfectionPara, RecoveryPara, LatentId, InfectedId, RecoveredId, reproductnumtemp]=InfectionProcessWeekend(NetWeekend, GooutRate, LatentPara, InfectionPara, RecoveryPara, LatentId, InfectedId, RecoveredId, awarenessWend, precautionWend,immuneresp)

global PeopleId
global NumPopulation

MatIdEWeekend = [];
MatIdEDirectAllWeekend = [];
MatIdEDirect = [];
cL = [];
IacL = [];
cI = [];
IacI = [];
cR = [];
IacR = [];

if isempty(InfectedId)
    reproductnumtemp = 0;
    return;
else
    AllId = randperm(NumPopulation);
    NoninfectedId = AllId;
    NoninfectedId(InfectedId) = [];
        
    rateofinfection = size(InfectedId, 2)/size(InfectionPara, 2);
    rateofhealthout = GooutRate*exp(-(rateofinfection^2)/(2*(0.2)^2));
    rateofinfectionout = 0.1;
    numofInfectedout = round(rateofinfectionout*size(InfectedId, 2));
    numofHealth = 3000-size(InfectedId, 2);
    numofHealthout = round(rateofhealthout*numofHealth);
    InfectedOutId = InfectedId(1:numofInfectedout);
    NoninfectedOutId = NoninfectedId(1:numofHealth);
    OutId = [InfectedOutId NoninfectedOutId];
    StayhomeId = setdiff(AllId, OutId);
    for idnum = 1:length(StayhomeId)
        NetWeekend(StayhomeId(idnum),:) = 0;
        NetWeekend(:,StayhomeId(idnum)) = 0;        
    end
end

%================================ for shopping ============================
LatentedDays = LatentPara(1,:);
InfectedDays = InfectionPara(1,:);  
RecoveredDays = RecoveryPara(1,:);  

TotalLatencyDays = LatentPara(2,:);
TotalInfectionDays = InfectionPara(2,:);  
TotalRecoveryDays = RecoveryPara(2,:); 

[MatIdEWeekend, MatIdEDirectAllWeekend]=ContactProcess(NetWeekend, InfectedOutId);
    MatIdEDirect = unique(MatIdEDirectAllWeekend);
        
    [cL,IacL] = intersect(MatIdEDirect, LatentId); 
    MatIdEDirect(IacL) = []; % delete Ids who has been latent

    
    [cI,IacI] = intersect(MatIdEDirect, InfectedId); 
    MatIdEDirect(IacI) = []; % delete Ids who has been infected

    
    [cR,IacR] = intersect(MatIdEDirect, RecoveredId); 
    MatIdEDirect(IacR) = []; % delete Ids who are recovering
    
    [PeopleId, reproductnumtemp]=IntubationProcessWeekend(NetWeekend, InfectedOutId, InfectionPara, MatIdEDirect, awarenessWend, precautionWend,immuneresp);
 
   % LatentId = find(PeopleId==1);
    for ii = 1:length(LatentId)
        if LatentedDays(LatentId(ii))<=(TotalLatencyDays(LatentId(ii))-1)  %latented days should be smaller than latent period
            LatentedDays(LatentId(ii)) = LatentedDays(LatentId(ii))+1;
        else
            PeopleId(LatentId(ii)) = 2;  %when latent period expired, intubating people becomes infectious
        end
    end
    
   % InfectedId = find(PeopleId==2);
    for jj = 1:length(InfectedId)
        if InfectedDays(InfectedId(jj))<=(TotalInfectionDays(InfectedId(jj))-1)  %infected days should be smaller than infection days
            InfectedDays(InfectedId(jj)) = InfectedDays(InfectedId(jj))+1;
        else
            PeopleId(InfectedId(jj)) = 3;  %when infection days expired, infectious people becomes recovered
        end
    end
    
   % RecoveredId = find(PeopleId==3);
    for kk = 1:length(RecoveredId)
        if RecoveredDays(RecoveredId(kk))<=(TotalRecoveryDays(RecoveredId(kk))-1)  %recovered days should be smaller than recovery period
            RecoveredDays(RecoveredId(kk)) = RecoveredDays(RecoveredId(kk))+1;
        else
            PeopleId(RecoveredId(kk)) = 0;  %when recovery period expired, recovered people becomes suspecious again
            LatentedDays(RecoveredId(kk)) = 0;
            InfectedDays(RecoveredId(kk)) = 0;
            RecoveredDays(RecoveredId(kk)) = 0;
        end
    end

    LatentId = [];
    InfectedId = [];
    RecoveredId = [];
    
    LatentId = find(PeopleId==1);
    InfectedId = find(PeopleId==2);
    RecoveredId = find(PeopleId==3);
    
%================================ for at home =============================


end