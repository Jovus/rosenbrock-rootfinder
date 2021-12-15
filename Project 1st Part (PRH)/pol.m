function [ c ] = pol( x,y,rev )
%Returns the function for a pollutant in a channel as defined by the
%project
%   x is x in c(x,y)
%   y is y in c(x,y)
%   x,y elementwise multiplied, since we should be dealing with vectors
%   rev is a bool that determines whether to return c(x,y) or -c(x,y).
%   0: return -c(x,y). Default
%   1: return c(x,y)
if not(exist('rev','var'))
    rev = 0;
end

c = 7.9 + 0.13*x + 0.21*y - 0.05*x.^2 - 0.016*y.^2 - 0.007*x.*y;

if not(rev)
    c = -c;
end

end

