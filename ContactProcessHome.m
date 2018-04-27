%========D GUO, Wake Forest University School of Medicine========
%this functin is to find people may be intubating directly.
%===input 1:[HomeMat] the matrix of homes, currently 6 types of homes,
%according to the population of each home
%===input 2:[InfectiousID] infectious id
%===output 1:[InfectionMat] the infected id and the corresponding
%id of infectious source
%===output 2:[InfectedID] the infected id
%======================================================================
function [InfectionMat, InfectedID]=ContactProcessHome(HomeMat, InfectiousID)
InfectionMat = [];
c = [];
Ia = [];
InfectedID = [];

for i=1:length(InfectiousID)
    MatIdTemp = [];
    PHomeID = [];
    HomeID = [];
    MatIdTemp = [];
    PHomeID = find(HomeMat==InfectiousID(i));
    HomeID = ceil(PHomeID/7);
    InfectedID = HomeMat(:, HomeID);
    InfectedID(find(InfectedID==0))=[];
    if ~isempty(InfectedID)
        MatIdTemp(:,1) = InfectedID;
        MatIdTemp(:,2) = InfectiousID(i);
        InfectionMat = [InfectionMat; MatIdTemp];
    end
end

if ~isempty(InfectionMat)
    [c,Ia] = intersect(InfectionMat(:,1),InfectionMat(:,2));
    InfectionMat(Ia,:) = [];
    InfectedID = InfectionMat(:,1);
end

end