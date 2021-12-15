%part b) of project: using Newton's Method
clc;clear;

%setup according to the problem
x = -2:0.01:2;
y = -2:0.01:2;
starts = [-1 1; 0 1; 2 1];

%for graphing
[X, Y] = meshgrid(x,y);
p = rose(X,Y,1); %we're actually finding the maximum after all

%SETUP FOR NEWTON'S METHOD

dCx = @(x,y)2*x - 400*x*(- x.^2 + y) - 2; %partial derivative by x
dCy =@(x,y)-200*x.^2 + 200*y; %partial derivative by y
%delC = [dCx;dCy]; gradient of C, informational purposes (implemented in
%for loop)
HC = @(x,y)[(1200*(x.^2))-(400*y)+2 -400*x; -400*x 200]; %Hessian of C


for i = 1:size(starts) %do the problem for each starting point
    
    guess0 = starts(i,:)';
    
    tol = 1e-6;
    error = 1;
    maxIter = 500;
    n = 0;
    path = guess0;

    figure(i);
    hold on

    fprintf('\nNewton''s method starting at [%d %d]:\n\n',guess0(1),guess0(2))
    while error > tol && n < maxIter
        x0 = guess0(1);
        y0 = guess0(2);
        step = HC(x0,y0)\(-[dCx(x0,y0);dCy(x0,y0)]);
        guess = guess0 + step;
        error = norm(abs((guess-guess0)),inf);
        guess0 = guess;
        n = n+1;
        fval = rose(guess0(1),guess0(2));
        path = [path guess0];
        fprintf('n = %2d  x = %4.4f  y = %4.4f fval = %4.4f  error = %4.6f\n',n,guess0(1),guess0(2),fval,error);
        if n == maxIter
            fprintf('Newton''s method hit max number of iterations (%d) without converging on an answer\n',maxIter)
        end
    end
    
    plot(guess0(1),guess0(2),'blackx','Linewidth',2)
    plot(path(1,:),path(2,:),'r-o');
    lstring = sprintf('Minimum of Rosenbrock''s function: %4.5f',fval);
    pathstring = sprintf('Path (starting at [%d %d])',path(1,1),path(2,1));
    legend(lstring,pathstring)
    axis([-2 2 -2 2]);

    contour(X,Y,p,41)
    title('Contour map of Rosenbrock''s function')
    hold off
    
end