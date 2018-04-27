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
function [LatentPara, InfectionPara, RecoveryPara, LatentId, InfectedId, RecoveredId, reproductnumtemp]=InfectionProcessHome(adjHouse, LatentPara, InfectionPara, RecoveryPara, LatentId, InfectedId, RecoveredId, awarenessHome, precautionHome,immuneresp)

global PeopleId

cL = [];
IacL = [];
cI = [];
IacI = [];
cR = [];
IacR = [];

LatentedDays = LatentPara(1,:);
InfectedDays = InfectionPara(1,:);  
RecoveredDays = RecoveryPara(1,:);  

TotalLatencyDays = LatentPara(2,:);
TotalInfectionDays = InfectionPara(2,:);  
TotalRecoveryDays = RecoveryPara(2,:); 

    [InfectionMatHome, InfectedIDHome]=ContactProcessHome(adjHouse, InfectedId);
    InfectedIDHome = unique(InfectedIDHome);

    [cL,IacL] = intersect(InfectedIDHome, LatentId); 
    InfectedIDHome(IacL) = []; % delete Ids who has been latent

    
    [cI,IacI] = intersect(InfectedIDHome, InfectedId); 
    InfectedIDHome(IacI) = []; % delete Ids who has been infected

    
    [cR,IacR] = intersect(InfectedIDHome, RecoveredId); 
    InfectedIDHome(IacR) = []; % delete Ids who are recovering
    
    [PeopleId, reproductnumtemp]=IntubationProcessHome(adjHouse, InfectedId, InfectionPara, InfectedIDHome, awarenessHome, precautionHome,immuneresp);
    
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
    
    LatentPara(1,:) = LatentedDays;
    InfectionPara(1,:) = InfectedDays;  
    RecoveryPara(1,:) = RecoveredDays;  
    
%     LatentPara = [LatentId; LatentedDays(LatentId); TotalLatencyDays(LatentId)];
%     InfectionPara = [InfectedId; InfectedDays(InfectedId); TotalInfectionDays(InfectedId)];    
%     RecoveryPara = [RecoveredId; RecoveredDays(RecoveredId); TotalRecoveryDays(RecoveredId)];
    
end