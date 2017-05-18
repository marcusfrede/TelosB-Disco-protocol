clc;
clear all;

%Prime pair i
pi1 = 23;
pi2 = 157;%103;

%Prime pair j
pj1 = 29;%53;
pj2 = 67;%883;

% Dutycycles
DutycycleM_i = 1/pi1+1/pi2;
DutycycleM_j = 1/pj1+1/pj2;
%DutycycleCombined = ((1/m_j)*(1/m_i))*100

cycles = 100000;
hits = 0;

need = 0;
for n = 1:cycles 
  n2 = n;
  node1_turn_on = ((mod(n, pi1) == need) || (mod(n, pi2) == need));
  node2_turn_on = ((mod(n2, pj1) == need) || (mod(n2, pj2) == need));
  
  if node1_turn_on && node2_turn_on
    hits = hits + 1;
  end
end

hits
chanceOfHit = hits/cycles


% Milliseconds on timer
timerdelay = 1;

% Co-prime check
% if((gcd(pi1,pj1) ~= 1) || (gcd(pi1,pj2) ~= 1) || (gcd(pi2,pj1) ~= 1) || (gcd(pi2,pj2) ~= 1))
%     disp('Numbers are not co-prime')
%     return
% end

%chanceOfHit = DutycycleM_i*DutycycleM_j;

numOfCyclesPrHit = 1/chanceOfHit;

for n = 1:4000
    chance = 1-(1-(1/numOfCyclesPrHit))^n;
    chanceArray(n) = chance;
end

secBetweenHits = numOfCyclesPrHit*(timerdelay/1000)
minutesBetweenHits = secBetweenHits/60

figure
plot(chanceArray)
grid on
title('Chance of hit')
xlabel('Number of cycles')
ylabel('Chance of minimum 1 hit')
