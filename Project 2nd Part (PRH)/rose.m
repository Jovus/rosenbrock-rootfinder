function [ c ] = rose( x,y,rev )
%Rosenbrock's function
%   x is x in c(x,y)
%   y is y in c(x,y)
%   x,y elementwise multiplied, since we should be dealing with vectors
%   rev does nothing. It's left in for easy copy and paste from a previous
%   function
if not(exist('rev','var'))
    rev = 0;
end

c = 100*((y - x.^2).^2) + (1 - x).^2;

end

