%========D GUO, Wake Forest University School of Medicine========
%this functin is to simulate people from all age levels.
%===input 1:[NumPopulation] Total population number we want to simulate
%===output 1:[SimPopulation] The simulated population
%======================================================================
function SimPopulation=Population(NumPopulation)
% according to http://quickfacts.census.gov/qfd/states/37/3775000.html, in
% 2010, there are 7.3% kids under 5 ys, 17.3% between 6-18, 62.9% between 19-64, and 12.5% for 65+ in Winston Salem
kidspop = round(0.073*NumPopulation);
youngpop = round(0.173*NumPopulation);
oldpop = round(0.125*NumPopulation);
adult = NumPopulation-(kidspop+youngpop+oldpop);

kids = randl(kidspop, 0,5);
young = randl(youngpop, 6,18);
adult = randl(adult, 19,64);
old = randl(oldpop, 65,99);

SimPopulation = [kids; young; adult; old];
SimPopulation = SimPopulation(randperm(NumPopulation));
end