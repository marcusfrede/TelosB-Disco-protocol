clc;
clear all;

%Prime pair i
pi1 = 37;
pi2 = 43;

%Prime pair j
pj1 = 31;
pj2 = 53;

% Dutycycles
DutycycleM_i = 1/pi1+1/pi2;
DutycycleM_j = 1/pj1+1/pj2;

cycles = 100000;
hits = 0;

need = 0;
for n = 1:cycles
  n2 = n+1;
  node1_turn_on = ((mod(n, pi1) == need) || (mod(n, pi2) == need));
  node2_turn_on = ((mod(n2, pj1) == need) || (mod(n2, pj2) == need));
  
  if node1_turn_on && node2_turn_on
    hits = hits + 1;
  end
end

chanceOfHit = hits/cycles;

%chanceOfHit = DutycycleM_i*DutycycleM_j;
numOfCyclesPrHit = 1/chanceOfHit;
timeslots = 1:20:4000;
i = 1;

for n = timeslots
    chance = 1-(1-(1/numOfCyclesPrHit))^(i);
    chanceArray(i) = chance;
    i = i + 1;
end

%%%
MILLI_PERIOD = 20;
sim3 = [13780 1720 620 2960 760 6660 160 12400 3720 2800 7740 8680 3720 3100 11160 4960 3720 6820 2040 7420 1700 1240 3720 10540 8680 2480 3440 7420 4640 4960 3720 2480 15500 500 740 3720 1900 1060 3240 9480 3540 2480 1240 9920 1900 7400 3720 1600 880 11160 1740 3840 3720 5160 1040 6380 4780 1860 3720 1300 8620 5160 4140 1860 360 1500 13640 5580 3720 1000 860 12920 4440 2980 740 5580 13640 1860 1860 700 7420 1180 5180 1060 3680 5580 11160 6220 3700 400 1060 4120 3300 5300 2560 2480 3720 9300 8440 1480];
sim3_hist = cumsum(hist(sim3, 200))/100;

%%%

figure
plot(timeslots,chanceArray)
hold on
plot(timeslots,sim3_hist)
grid on
title('Chance of hit')
xlabel('Number of cycles')
ylabel('Chance of minimum 1 hit')
