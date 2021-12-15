%part f) of project: using Nelder-Mead
clc;clear;

%setup according to the problem
x = -2:0.01:2;
y = -2:0.01:2;
starts = [-1 1; 0 1; 2 1];

%for graphing
[X, Y] = meshgrid(x,y);
p = rose(X,Y,1); %we're actually finding the maximum after all

%SETUP FOR NELDER MEAD

for i = 1:3 %do the problem for each starting point
   
    tol = 1e-6;
    error = 1;
    n = 0;
    
    guess0 = starts(i,:);
    path = guess0;
    
    %GENERATE STARTING TRIANGLE around initial guess
    v1 = guess0;
    v2 = [guess0(1),guess0(2)+5];
    v3 = [guess0(1)+5,guess0(2)];
    gon = [v1;v2;v3]; %starting triangle, because I have to pick some other three arbitrary points
    
    %needs to be initially sorted. We'll repeat this inside the while loop
    %at the end, but it needs to happen once at the beginning, too
    
    fval_v1 = rose(gon(1,1),gon(1,2)); %fval at point 1
    fval_v2 = rose(gon(2,1),gon(2,2)); %fval at point 2
    fval_v3 = rose(gon(3,1),gon(3,2)); %fval at point 3
        
    %next, find which is best, middle, and worst point
    vals = [fval_v1; fval_v2; fval_v3];
    augon = sortrows([vals gon]); %triangle augmented with fvals at the points of the triangle   
        
    %Best, good, and worst points
    B = augon(1,2:end);
    G = augon(2,2:end);
    W = augon(3,2:end);
        
    %function values at those points
    fvalB = augon(1,1);
    fvalG = augon(2,1);
    fvalW = augon(3,1);
    
    fprintf('\nNelder-Mead method with starting point (%d %d) \n\n',guess0(1),guess0(2))
    
    while error > tol 
                   
        %now we're ready to actually manipulate the triangle...finally
        
        M = (B + G)./2; %midpoint of the good side
        fvalM = rose(M(1),M(2));
        
        R = 2*M-W; %reflection across good side. Might go out of x-y range, but that's fine for now
        fvalR = rose(R(1),R(2));
        
        %begin logic. This seems likely to be inefficient, but it follows
        %the algorithm as laid out. I can't help thinking it could be
        %optimized with fewer comparisons and nests, though
        
        if fvalR < fvalG %what the book calls case i - reflect or extend
            if fvalB < fvalR
                W = R;
                
            else
                E = 2*R - M; %extension point
                fvalE = rose(E(1),E(2));
                if fvalE < fvalB
                    W = E;
                else
                    W = R;
                end
            end
        else %what the book calls case ii - contract or shrink
            if fvalR < fvalW
                W = R;
            end
            
            %figure out which contraction point to use
            C1 = (W + M)./2;
            C2 = (M + R)./2;
            fvalC1 = rose(C1(1),C1(2));
            fvalC2 = rose(C2(1),C2(2));
            if fvalC1 < fvalC2
                C = C1;
                fvalC = fvalC1;
            else
                C = C2;
                fvalC = fvalC2;
            end
            
            if fvalC < fvalW
                W = C;
            else
                S = (B + W)./2;
                fvalS = rose(S(1),S(2)); %is this even necessary?
                W = S;
                G = M;
            end
        end
        
        %Now set up for the next iteration
        
        gon = [B; G; W];
        fval_v1 = rose(gon(1,1),gon(1,2)); %fval at point 1
        fval_v2 = rose(gon(2,1),gon(2,2)); %fval at point 2
        fval_v3 = rose(gon(3,1),gon(3,2)); %fval at point 3
        
        %next, find which is best, middle, and worst point
        vals = [fval_v1; fval_v2; fval_v3];
        augon = sortrows([vals gon]); %triangle augmented with fvals at the points of the triangle   
        
        %Best, good, and worst points
        B = augon(1,2:end);
        G = augon(2,2:end);
        W = augon(3,2:end);
        
        %function values at those points
        fvalB = augon(1,1);
        fvalG = augon(2,1);
        fvalW = augon(3,1);
        
        %clean up; find our error, etc.
                
        n = n+1;
        path = [path; B];
        error = abs(fvalW - fvalB); %not the most efficient, but I'll take it
                      
        fprintf('n = %2d  x = %4.4f  y = %4.4f fval = %4.4f  error = %4.6f\n',n,B(1),B(2),-fvalB,error);
    end
    
    figure(i);
    hold on
    
    %plot(B(1),B(2),'blackx','Linewidth',2)
    plot(path(:,1),path(:,2),'r-o');
    plot(B(1),B(2),'blackx','Linewidth',2)
    lstring = sprintf('Minimum of Rosenbrock''s function: %4.5f',fvalB);
    pathstring = sprintf('Path (starting at [%d %d])',path(1,1),path(1,2));
    legend(pathstring,lstring)

    contour(X,Y,p,41)
    title('Contour map of Rosenbrock''s function')
    axis([-2 2 -2 2])
    hold off
    
end

