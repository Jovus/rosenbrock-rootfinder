%part c) of project: using BFGS
clc;clear;

%setup according to the problem
x = -2:0.01:3;
y = -2:0.01:4;
starts = [-1 1; 0 1; 2 1];

%for graphing
[X, Y] = meshgrid(x,y);
p = rose(X,Y); %we're actually finding the maximum after all

%SETUP FOR BFGS

dCx =  @(x,y)2*x - 400*x*(- x.^2 + y) - 2; %partial derivative by x
dCy =@(x,y)-200*x.^2 + 200*y; %partial derivative by y
%delC = [dCx;dCy]; gradient of C, informational purposes (implemented in
%for loop)


for i = 1:3 %do the problem for each starting point
    
    guess0 = starts(i,:)';
    
    B0 = eye(2); %initial Hessian approximation
    tol = 1e-6;
    error = 1;
    n = 0;
    fval0 = rose(guess0(1),guess0(2));
    
    path = guess0;
        
    fprintf('\n\nBFGS method:\n')
    while error > tol
        x0 = guess0(1); %quality of life
        y0 = guess0(2);
        
        step = B0\(-[dCx(x0,y0);dCy(x0,y0)]);
        guess = guess0 + step;
    
        x1 = guess(1); %quality of life again
        y1 = guess(2);
        fval = rose(x1,y1);
    
        Bcorr = ([dCx(x1,y1);dCy(x1,y1)] - [dCx(x0,y0);dCy(x0,y0)]);
        B = B0 + ((Bcorr*Bcorr')/(Bcorr'*step)) - (B0*step*step'*B0)/(step'*B0*step); %potential problem
    
        path = [path guess];
        error = abs(norm(B0-B,2));
        B0 = B;
        guess0 = guess;
        fval0 = fval;
        n = n+1;
    
        fprintf('n = %2d  x = %4.4f  y = %4.4f  fval = %4.4f  error = %4.6f\n',n,guess(1),guess(2),fval,error)
    end
    
    figure(i)
    hold on
    %plot(guess0(1),guess0(2),'blackx','Linewidth',2)
    plot(path(1,:),path(2,:),'r-o');
    lstring = sprintf('Minimum of Rosenbrock''s function: %4.5f',fval);
    pathstring = sprintf('Path (starting at [%d %d])',path(1,1),path(2,1));
    plot(guess0(1),guess0(2),'blackx','Linewidth',2)
    legend(pathstring,lstring)
    
    
    contour(X,Y,p,80)
    title('Contour map Rosenbrock''s function')
    axis([-2 3 -2 4])
    hold off;
    
end