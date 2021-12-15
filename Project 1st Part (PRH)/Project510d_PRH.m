%part d) of project: using Steepest Descent
clc;clear;

%setup according to the problem
x = -10:0.5:10;
y = 0:0.5:20;
starts = [-9 1; -8 18; 1 19; 9 10];

%for graphing
[X, Y] = meshgrid(x,y);
p = pol(X,Y,1); %we're actually finding the maximum after all

%SETUP FOR STEEPEST DESCENT
dCx = @(x,y)x/10 + (7*y)/1000 - 13/100; %partial derivative by x
dCy =@(x,y)(7*x)/1000 + (4*y)/125 - 21/100; %partial derivative by y
%delC = [dCx;dCy]; gradient of C, informational purposes (implemented in
%loop)

for i = 1:4 %do the problem for each starting point
   
    tol = 1e-6;
    error = 1;
    n = 0;
    
    guess0 = starts(i,:);
    path = guess0;
    
    fprintf('\nSteepest Descent method with starting point (%d %d) \n\n',guess0(1),guess0(2))
    
    while error > tol
        x0 = guess0(1);
        y0 = guess0(2); %quality of life
        
        step = -[dCx(x0,y0) dCy(x0,y0)];
        
        akfind = @(a)pol(guess0(1)+a*step(1),guess0(2)+a*step(2)); 
        a = fminsearch(akfind,0); %minimize alpha_k
        
        guess = guess0 + a*step;
        error = abs(norm(guess - guess0,inf));
        
        guess0 = guess;
        path = [path; guess0];
        n = n+1;
        fval = pol(guess0(1),guess0(2),1);
        fprintf('n = %2d  x = %4.4f  y = %4.4f fval = %4.4f  error = %4.6f\n',n,guess0(1),guess0(2),fval,error);
    end
    
    figure(i);
    hold on
    
    plot(guess0(1),guess0(2),'blackx','Linewidth',2)
    plot(path(:,1),path(:,2),'r-o');
    lstring = sprintf('Maximum pollutant in channel: %4.5f',fval);
    pathstring = sprintf('Path (starting at [%d %d])',path(1,1),path(1,2));
    legend(lstring,pathstring)

    contour(X,Y,p,41)
    title('Contour map of 2-d distribution of pollutant in channel')
    xlabel('Width of channel'); ylabel('Length of channel');
    hold off
    
end
    