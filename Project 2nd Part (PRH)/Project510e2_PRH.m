%part e) of project: using Conjugate Gradient
clc;clear;

%setup according to the problem
x = -2:0.01:2;
y = -2:0.01:2;
starts = [-1 1; 0 1; 2 1];

%for graphing
[X, Y] = meshgrid(x,y);
p = rose(X,Y,1); %we're actually finding the maximum after all

%SETUP FOR CONJUGATE GRADIENT
dCx = @(x,y)x/10 + (7*y)/1000 - 13/100; %partial derivative by x
dCy =@(x,y)(7*x)/1000 + (4*y)/125 - 21/100; %partial derivative by y
%delC = [dCx;dCy]; gradient of C, informational purposes (implemented in
%for loop

for i = 1:3 %do the problem for each starting point
   
    tol = 1e-6;
    error = 1;
    n = 0;
    
    guess0 = starts(i,:)';
    path = guess0;
    
    fprintf('\nConjugate Gradient method with starting point (%d %d) \n\n',guess0(1),guess0(2))
            
    grad0 = [dCx(guess0(1),guess0(2)); dCy(guess0(1),guess0(2))];
    step = -grad0;    
    
    while error > tol
        
        akfind = @(a)rose(guess0(1)+a*step(1),guess0(2)+a*step(2)); 
        options = optimset('TolX', 1e-6, 'MaxIter', 500);
        a = fminbnd(akfind,0,1,options); %minimize alpha_k
        
        guess = guess0 + a*step;
        x1 = guess(1);
        y1 = guess(2);
        
        grad = [dCx(x1,y1);dCy(x1,y1)];
        b = (grad'*grad)/(grad0'*grad0);
        
        step = -grad + b*step;
        grad0 = grad;
        
        %reset for next loop
        error = abs(norm(guess - guess0,2));
        fval = rose(guess0(1),guess0(2),1);
        guess0 = guess;
        n = n+1;
        path = [path guess0];
        
        fprintf('n = %2d  x = %4.4f  y = %4.4f fval = %4.4f  error = %4.6f\n',n,guess0(1),guess0(2),fval,error);
    end
    
        figure(i);
    hold on
    
    plot(guess0(1),guess0(2),'blackx','Linewidth',2)
    plot(path(1,:),path(2,:),'r-o');
    lstring = sprintf('Minimum of Rosenbrock''s function: %4.5f',fval);
    pathstring = sprintf('Path (starting at [%d %d])',path(1,1),path(2,1));
    legend(lstring,pathstring)

    contour(X,Y,p,41)
    title('Contour map of Rosenbrock''s function')
    hold off
    
end