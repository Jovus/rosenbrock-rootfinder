%part b) of project: using Newton's Method
clc;clear;

%setup according to the problem
x = -10:0.5:10;
y = 0:0.5:20;
starts = [-9 1; -8 18; 1 19; 9 10];

%for graphing
[X, Y] = meshgrid(x,y);
p = pol(X,Y,1); %we're actually finding the maximum after all

%SETUP FOR NEWTON'S METHOD

dCx = @(x,y)x/10 + (7*y)/1000 - 13/100; %partial derivative by x
dCy =@(x,y)(7*x)/1000 + (4*y)/125 - 21/100; %partial derivative by y
%delC = [dCx;dCy]; gradient of C, informational purposes (implemented in
%for loop)
HC = [1/10 7/1000; 7/1000 4/125]; %Hessian of C


for i = 1:4 %do the problem for each starting point
    
    guess0 = starts(i,:)';
    
    tol = 1e-6;
    error = 1;
    n = 0;
    path = [guess0];

    figure(i);
    hold on

    fprintf('\nNewton''s method starting at [%d %d]:\n\n',guess0(1),guess0(2))
    while error > tol
        x0 = guess0(1);
        y0 = guess0(2);
        step = HC\(-[dCx(x0,y0);dCy(x0,y0)]);
        guess = guess0 + step;
        error = norm(abs((guess-guess0)/guess),inf);
        guess0 = guess;
        n = n+1;
        fval = pol(guess0(1),guess0(2),1);
        path = [path guess0];
        fprintf('n = %2d  x = %4.4f  y = %4.4f fval = %4.4f  error = %4.6f\n',n,guess0(1),guess0(2),fval,error);
    end
    
    plot(guess0(1),guess0(2),'blackx','Linewidth',2)
    plot(path(1,:),path(2,:),'r-o');
    lstring = sprintf('Maximum pollutant in channel: %4.5f',fval);
    pathstring = sprintf('Path (starting at [%d %d])',path(1,1),path(2,1));
    legend(lstring,pathstring)

    contour(X,Y,p,41)
    title('Contour map of 2-d distribution of pollutant in channel')
    xlabel('Width of channel'); ylabel('Length of channel');
    hold off
    
end