%========D GUO, Wake Forest University School of Medicine========
%this functin is to find people may be intubating directly.
%===input 1:[CommunitiesMat] the matrix of communities, the lower triangular components are all
%zeros
%===input 2:[InfectiousID] infectious id in the matrix of communities
%===output 1:[InfectionMat] the infected id and the corresponding
%id of infectious source
%===output 2:[InfectedID] the infected id
%======================================================================
function [InfectionMat, InfectedID]=ContactProcess(CommunitiesMat, InfectiousID)
InfectionMat = [];
c = [];
Ia = [];
InfectedID = [];

if isempty(InfectiousID) 
    return;
else
    for i=1:length(InfectiousID)
        IdEx = [];
        IdEy = [];
        IdE = [];
        MatIdTemp = [];
        IdEx = find(CommunitiesMat(:,InfectiousID(i))==1);
        IdEy = find(CommunitiesMat(InfectiousID(i),:)==1);
        [IdExc, IdExIa] = intersect(IdEx,IdEy);
        IdEx(IdExIa) = [];
        IdE = [IdEx' IdEy];
        MatIdTemp = zeros(length(IdE),2);
        if ~isempty(MatIdTemp)
            MatIdTemp(:,1) = IdE;
            MatIdTemp(:,2) = InfectiousID(i);
            InfectionMat = [InfectionMat; MatIdTemp];
        end
    end
end

if ~isempty(InfectionMat)
    [c,Ia] = intersect(InfectionMat(:,1),InfectionMat(:,2));
    InfectionMat(Ia,:) = [];
    InfectedID = InfectionMat(:,1);
end

end