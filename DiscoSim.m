clc

% Co-primes
m_i = 13;
m_j = 14;

% Milliseconds on timer
timerdelay = 50;

% Counters
c_i = 0;
c_j = 0;

% Start times
a_i = 0;
a_j = 6;

% Co-prime check
if(gcd(m_i,m_j) ~= 1)
    disp('Numbers are not co-prime')
    return
end

cycles = 10000;
chanceOfHit = (1/m_i)*(1/m_j)
predictedNumberOfHits = chanceOfHit*cycles

numOfCyclesPrHit = 1/chanceOfHit

secBetweenHits = numOfCyclesPrHit*(timerdelay/1000)
minutesBetweenHits = secBetweenHits/60

for n = 1:cycles
    if(a_i <= n)
       c_i = c_i + 1;
    end
    
    if(a_j <= n)
       c_j = c_j + 1;
    end
    
    if(mod(c_i+a_i,m_i) == 0 && mod(c_j+a_j,m_j) == 0)
       disp(['Its a match - ' num2str(n)]) 
    end
end