%========D GUO, Wake Forest University School of Medicine========
%this functin is to find out which community an individual comes from.
%===input 1:[ComPara]
%===input 2:[IndividualID]
%===output 1:[ComunityID]
%======================================================================
function CommunityID=CheckCommunity(IndividualID)

AdjustedPopuCompose = [198 720 1011 1071];

if IndividualID<=AdjustedPopuCompose(1)
    CommunityID=1;
elseif (IndividualID>AdjustedPopuCompose(1))&(IndividualID<=sum(AdjustedPopuCompose(1:2)))
    CommunityID=2;
elseif (IndividualID>sum(AdjustedPopuCompose(1:2)))&(IndividualID<=sum(AdjustedPopuCompose(1:3)))
    CommunityID=3;
else
    CommunityID=4;
end

end