clc;
clear all;

%Prime pair i
pi1 = 23;
pi2 = 157;%103;

%Prime pair j
pj1 = 29;%53;
pj2 = 67;%883;

% Dutycycles
DutycycleM_i = ((1/pi1)+(1/pi2))
DutycycleM_j = ((1/pj1)+(1/pj2))
%DutycycleCombined = ((1/m_j)*(1/m_i))*100

% Milliseconds on timer
timerdelay = 1;

% Co-prime check
if((gcd(pi1,pj1) ~= 1) || (gcd(pi1,pj2) ~= 1) || (gcd(pi2,pj1) ~= 1) || (gcd(pi2,pj2) ~= 1))
    disp('Numbers are not co-prime')
    return
end

chanceOfHit = DutycycleM_i*DutycycleM_j;

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
