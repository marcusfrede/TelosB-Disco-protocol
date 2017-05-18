clc

% Primes less than 1000
p = primes(1000);

% Co-primes
m_i = 37;
m_j = 43;

% Dutycycles
DutycycleM_i = (1/m_i)*100
DutycycleM_j = (1/m_j)*100
DutycycleCombined = ((1/m_j)*(1/m_i))*100

% Milliseconds on timer
timerdelay = 1;

% Co-prime check
if(gcd(m_i,m_j) ~= 1)
    disp('Numbers are not co-prime')
    return
end

chanceOfHit = (1/m_i)*(1/m_j);

numOfCyclesPrHit = 1/chanceOfHit;

array = zeros(1,2000);
for n = 1:5000
    chance = 1-(1-(1/numOfCyclesPrHit))^n;
    cyclesArray(n) = n;
    chanceArray(n) = chance;
end

chanceArray
numOfCyclesPrHit

secBetweenHits = numOfCyclesPrHit*(timerdelay/1000)
minutesBetweenHits = secBetweenHits/60

figure
plot(cyclesArray,chanceArray)
title('Chance of hit')
xlabel('Number of cycles')
ylabel('Chance of minimum 1 hit')
