%part a) of project: using fminsearch
clc;clear;

%setup according to the problem
x = -2:0.01:2;
y = -2:0.01:2;
starts = [-1 1; 0 1; 2 1];

%for graphing
[X, Y] = meshgrid(x,y);
p = rose(X,Y,1); %we're actually finding the maximum after all

fwrap = @(A)rose(A(:,1),A(:,2)); %wrapper function to pass to fminsearch
options=optimset('display','iter','TolX',1e-6); %options to pass to fminsearch

for i = 1:3 %do the problem for each starting point
    
    guess0 = starts(i,:);

    [xy,fval] = fminsearch(fwrap,guess0,options); %[0 0 starting guess for x y]
    
    fval = -fval; %we want the maximum, not minimum
    
    figure(i);
    plot(xy(1),xy(2),'blackx','Linewidth',2)
    hold on;
    contour(X,Y,p,80)
    lstring = sprintf('Minimum of Rosenbrock''s function: %4.5f',fval);
    legend(lstring)
    titlestring = sprintf('Fminsearch on contour map, starting at (%d %d)',guess0(1),guess0(2));
    title(titlestring)
    hold off;
    
end