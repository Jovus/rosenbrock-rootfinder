%part a) of project: using fminsearch
clc;clear;

%setup according to the problem
x = -10:0.5:10;
y = 0:0.5:20;
starts = [-9 1; -8 18; 1 19; 9 10];

%for graphing
[X, Y] = meshgrid(x,y);
p = pol(X,Y,1); %we're actually finding the maximum after all

fwrap = @(A)pol(A(:,1),A(:,2)); %wrapper function to pass to fminsearch
options=optimset('display','iter','TolX',1e-6); %options to pass to fminsearch

for i = 1:4 %do the problem for each starting point
    
    guess0 = starts(i,:);

    [xy,fval] = fminsearch(fwrap,guess0,options); %[0 0 starting guess for x y]
    
    fval = -fval; %we want the maximum, not minimum
    
    figure(i);
    plot(xy(1),xy(2),'blackx','Linewidth',2)
    hold on;
    contour(X,Y,p,41)
    lstring = sprintf('Maximum pollutant in channel: %4.5f',fval);
    legend(lstring)
    titlestring = sprintf('Fminsearch on contour map, starting at (%d %d)',guess0(1),guess0(2));
    title(titlestring)
    xlabel('Width of channel'); ylabel('Length of channel');
    hold off;
    
end