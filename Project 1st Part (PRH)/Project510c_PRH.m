%part c) of project: using BFGS
clc;clear;

%setup according to the problem
x = -10:0.5:10;
y = 0:0.5:20;
starts = [-9 1; -8 18; 1 19; 9 10];

%for graphing
[X, Y] = meshgrid(x,y);
p = pol(X,Y,1); %we're actually finding the maximum after all

%SETUP FOR BFGS

dCx = @(x,y)x/10 + (7*y)/1000 - 13/100; %partial derivative by x
dCy =@(x,y)(7*x)/1000 + (4*y)/125 - 21/100; %partial derivative by y
%delC = [dCx;dCy]; gradient of C, informational purposes (implemented in
%for loop)


for i = 1:4 %do the problem for each starting point
    
    guess0 = starts(i,:)';
    
    B0 = eye(2); %initial Hessian approximation
    tol = 1e-6;
    error = 1;
    n = 0;
    fval0 = pol(0,0,1);
    
    path = guess0;
        
    fprintf('\n\nBFGS method starting at (%d %d):\n',guess0(1),guess0(2))
    while error > tol
        x0 = guess0(1); %quality of life
        y0 = guess0(2);
        
        step = B0\(-[dCx(x0,y0);dCy(x0,y0)]);
        guess = guess0 + step;
    
        x1 = guess(1); %quality of life again
        y1 = guess(2);
        fval = pol(x1,y1,1);
    
        Bcorr = ([dCx(x1,y1);dCy(x1,y1)] - [dCx(x0,y0);dCy(x0,y0)]);
        B = B0 + ((Bcorr*Bcorr')/(Bcorr'*step)) - (B0*(step*step')*B0)/(step'*B0*step); %potential problem
    
        path = [path guess];
        error = abs(fval-fval0);
        B0 = B;
        guess0 = guess;
        fval0 = fval;
        n = n+1;
    
        fprintf('n = %2d  x = %4.4f  y = %4.4f  fval = %4.4f  error = %4.6f\n',n,guess(1),guess(2),fval,error)
    end
    
    figure(i)
    hold on
    plot(guess0(1),guess0(2),'blackx','Linewidth',2)
    plot(path(1,:),path(2,:),'r-o');
    lstring = sprintf('Maximum pollutant in channel: %4.5f',fval);
    pathstring = sprintf('Path (starting at [%d %d])',path(1,1),path(2,1));
    legend(lstring,pathstring)
    
    contour(X,Y,p,41)
    title('Contour map of 2-d distribution of pollutant in channel')
    xlabel('Width of channel'); ylabel('Length of channel');
    hold off;
    
end