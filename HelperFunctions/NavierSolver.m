function NavierSolver()
a = 1; b = 1; zz = 0.001;
p = -1000;
%  
%         EL = 50E9;    
%         ET = 9E9;   
%         nuLT = 0.22;    
%         GLT = 5E9; 
%         GTT = 3.2E9;     
%         nuTL = ET/EL*nuLT;
      
%         EL = 174.6E9;  ET = 7E9;  nuLT = 0.25;    GLT = 3.5E9;   GTT = 1.4E9; nuTL = ET/EL*nuLT;
        EL = 50E9;     ET = 9E9;    nuLT = 0.22;    GLT = 5E9;  GTT = 3.2E9;   nuTL = ET/EL*nuLT;  % [Pa]
        
QLT = [EL/(1-nuLT*nuTL) (nuLT*ET)/(1-nuLT*nuTL) 0;...
       (nuLT*ET)/(1-nuLT*nuTL) ET/(1-nuLT*nuTL) 0;...
       0 0 GLT];

QLTtilde = [GLT 0; 0 GTT];

ang = [0 90 0]*pi/180;
coord = linspace(-zz/2, zz/2,length(ang)+1); 

% [maxabs_a] = navier(a,b,p,QLT,QLTtilde, ang, coord);
[maxabs_a] = navier2(a,b,p,QLT,QLTtilde, ang, coord);
fprintf('Max defl: %d\n' ,maxabs_a)
end

function [maxabs_a] = navier(a,b,p,QLT,QLTtilde, ang, coord)
% Example Input can be found furthest down in the code

[A,B,D,Atilde] = ABDAtilde(QLT,QLTtilde, ang, coord);

syms x y m n

pmn = 4/(a*b) * int(int(p*sin(m*pi*x/a)*sin(n*pi*y/b),0,a),0, b);

wmn = pmn/(pi^4*(D(1,1)*(m/a)^4 + ...
            2*(D(1,2) + 2*D(3,3))*(m/a)^2*(n/b)^2 + ...
            D(2,2)*(n/b)^4));
        
toM = 20; toN = 20;
w0(x,y) = symsum(symsum(wmn * sin(m*pi*x/a)*sin(n*pi*y/b),n, 1, toN),m, 1, toM);

w0 = matlabFunction(w0);
maxabs_a = w0(a/2,b/2);
% [X,Y] = meshgrid(0:0.01:a, 0:0.01:b);
% surf(X, Y, w0(X,Y));
% maxabs_a = max(max(abs(w0(X,Y))))
end

function [maxabs_a] = navier2(a,b,q0,QLT,QLTtilde, ang, coord)
% Example Input can be found furthest down in the code

[A,B,D,Atilde] = ABDAtilde(QLT,QLTtilde, ang, coord);

xx = a/2; yy = b/2;
w = 0;
toM = 100; toN = 100;
for m = 1:2:toM
    for n = 1:2:toN
        
        qmn = 16*q0/pi^2/m/n; if(mod(m,2) == 0 || mod(n,2) == 0); qmn = 0; end;     

        wmn = qmn/(pi^4*(D(1,1)*(m/a)^4 + ...
            2*(D(1,2) + 2*D(3,3))*(m/a)^2*(n/b)^2 + ...
            D(2,2)*(n/b)^4));   
        
        w = w + wmn*sin(m*pi*xx/a)*sin(n*pi*yy/b);
        
    end
end

maxabs_a = w;
end

function [A,B,D,Atilde] = ABDAtilde(QLT,QLTtilde, ang, coord)
% Function calculating A, B and D matrix for a laminate

% Inputs:
%        QLT: Local stiffness matrix
%        ang: vector with the angles of the lamina (starting from min. z)
%        coord: vector with z-coordinates of the lamina interfaces
%        alfaLT: Local heat expansion vector
%        deltaT: Difference in temperature

%    Elias B�rjesson, Fredrik Ekre

T1 = @(theta) [cos(theta)^2 sin(theta)^2 2*sin(theta)*cos(theta);...
    sin(theta)^2 cos(theta)^2 -2*sin(theta)*cos(theta);...
    -sin(theta)*cos(theta) sin(theta)*cos(theta) (cos(theta)^2-sin(theta)^2)];

T2 = @(theta) [cos(theta)^2 sin(theta)^2 sin(theta)*cos(theta);...
    sin(theta)^2 cos(theta)^2 -sin(theta)*cos(theta);...
    -2*sin(theta)*cos(theta) 2*sin(theta)*cos(theta) (cos(theta)^2-sin(theta)^2)];

T1tilde = @(theta) [cos(theta) -sin(theta); sin(theta) cos(theta)];

A = zeros(3); B = A; D = A; Atilde = zeros(2);
Qxy = @(theta) T1(theta)^-1*QLT*T2(theta);
Qxytilde = @(theta) T1tilde(theta)^-1*QLTtilde*T1tilde(theta);
nla = length(ang);

for ii = 1:nla
    A = A + 1/1*Qxy(ang(ii))*(coord(ii+1)^1-coord(ii)^1);
    B = B + 1/2*Qxy(ang(ii))*(coord(ii+1)^2-coord(ii)^2);
    D = D + 1/3*Qxy(ang(ii))*(coord(ii+1)^3-coord(ii)^3);
    Atilde = Atilde + Qxytilde(ang(ii))*(coord(ii+1)-coord(ii));
end
end

