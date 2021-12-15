%PHYS 301 Assignment 8 Patrick Halter
%Checking 12.2.1 by computer
clc;clear;
syms x

P1 = legendreP(1,x)
P2 = legendreP(2,x)
P3 = legendreP(3,x)
P4 = legendreP(4,x)

%P1 = x
%P2 = (3*x^2)/2 - 1/2
%P3 = (5*x^3)/2 - (3*x)/2
%P4 = (35*x^4)/8 - (15*x^2)/4 + 3/8