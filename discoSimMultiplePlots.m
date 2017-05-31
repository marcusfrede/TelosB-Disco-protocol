clear all;

%Prime pairs i
pi1 = [37 23 37 29];
pi2 = [43 157 43 67];

%Prime pairs j
pj1 = [37 23 31 23];
pj2 = [43 157 53 157];

figure(1)

for i =1:length(pi1)
    
    cycles = 100000;
    hits = 0;
    
    for n = 1:cycles
      nOffset = n+1;
      node1_turn_on = ((mod(n, pi1(i)) == 0) || (mod(n, pi2(i)) == 0));
      node2_turn_on = ((mod(nOffset, pj1(i)) == 0) || (mod(nOffset, pj2(i)) == 0));

      if node1_turn_on && node2_turn_on
        hits = hits + 1;
      end
    end
    
    chanceOfHit = hits/cycles;
    numOfCyclesPrHit = 1/chanceOfHit;

    j = 1;
    chance = 0;
    chanceArray = 0;
    while chance < 0.99
         chance = 1-(1-(1/numOfCyclesPrHit))^(j);
         chanceArray(j) = chance;
         j = j + 1;
    end
    timeslots = 1:j-1;
    
    legendInfo{i} = ['Simulated Disco pp_i=(' num2str(pi1(i)) ',' num2str(pi2(i)) '), pp_j=(' num2str(pj1(i)) ',' num2str(pj2(i)) ')'];
    
    %plot(timeslots./50,chanceArray, 'LineWidth', 2)
    
    %lort
    if(i == 1)
        plot(timeslots./50,chanceArray, '-', 'LineWidth', 2) 
    elseif(i == 2)
        plot(timeslots./50,chanceArray, '--', 'LineWidth', 2)
        
    elseif(i == 3)
        plot(timeslots./50,chanceArray, ':', 'LineWidth', 2)
     
    elseif(i == 4)
        plot(timeslots./50,chanceArray, '-.', 'LineWidth', 2)
    end
   
    hold on
end

grid on
h_legend = legend(legendInfo, 'Location','SouthEast');
set(h_legend,'FontSize',15);
title('Simulation of four different prime pairs')
xlabel('Discovery latency (s)', 'FontSize', 15)
ylabel('Fraction of Discoveries', 'FontSize', 15)
set(gca,'FontSize',15)
hold off
