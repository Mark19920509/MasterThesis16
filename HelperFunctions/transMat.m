function [ T ] = transMat( Jacobian )
% eps = 11 22 33 12 13 23
% %How I did it:
%-------------
% syms t11 t12 t13 t21 t22 t23 t31 t32 t33 real
% syms s11 s22 s33 s12 s13 s23
% 
% sig = [s11, s12, s13; s12, s22, s23; s13 s23 s33];
% trans = [t11 t12 t13; t21 t22 t23; t31 t32 t33]; 
% 
% sig_2 = trans*sig*trans'
% tmp = [sig_2(1);sig_2(5); sig_2(9); sig_2(4); sig_2(7); sig_2(8)];
% [A,b] = equationsToMatrix(tmp, [s11 s22 s33 s12 s13 s23])
%-----------------

    t = (Jacobian); % inv, JT etc
    t11 = t(1,1); 
    t12 = t(1,2);
    t13 = t(1,3);
    t21 = t(2,1);
    t22 = t(2,2);
    t23 = t(2,3);
    t31 = t(3,1);
    t32 = t(3,2);
    t33 = t(3,3);
    
%         T = [   t11^2, t12*t21, t13*t31, t11*t12 + t11*t21, t11*t13 + t11*t31, t13*t21 + t12*t31;...
%              t12*t21,   t22^2, t23*t32, t12*t22 + t21*t22, t12*t23 + t21*t32, t22*t23 + t22*t32;...
%              t13*t31, t23*t32,   t33^2, t13*t32 + t23*t31, t13*t33 + t31*t33, t23*t33 + t32*t33;...
%              t11*t12, t12*t22, t13*t32,   t12^2 + t11*t22, t12*t13 + t11*t32, t13*t22 + t12*t32;...
%              t11*t13, t12*t23, t13*t33, t12*t13 + t11*t23,   t13^2 + t11*t33, t13*t23 + t12*t33;...
%              t13*t21, t22*t23, t23*t33, t13*t22 + t21*t23, t13*t23 + t21*t33,   t23^2 + t22*t33];

T =    [   t11^2,   t12^2,   t13^2,         2*t11*t12,         2*t11*t13,         2*t12*t13;...
           t21^2,   t22^2,   t23^2,         2*t21*t22,         2*t21*t23,         2*t22*t23;...
           t31^2,   t32^2,   t33^2,         2*t31*t32,         2*t31*t33,         2*t32*t33;...
         t11*t21, t12*t22, t13*t23, t11*t22 + t12*t21, t11*t23 + t13*t21, t12*t23 + t13*t22;...
         t11*t31, t12*t32, t13*t33, t11*t32 + t12*t31, t11*t33 + t13*t31, t12*t33 + t13*t32;...
         t21*t31, t22*t32, t23*t33, t21*t32 + t22*t31, t21*t33 + t23*t31, t22*t33 + t23*t32];

end


%     t = (Jacobian); % inv, JT etc
%     T = [t.^2, [t(1,1)*t(2,1), t(1,1)*t(3,1), t(2,1)*t(3,1);...
%                 t(1,2)*t(2,2), t(1,2)*t(3,2), t(2,2)*t(3,2);...
%                 t(1,3)*t(2,3), t(1,3)*t(3,3), t(2,3)*t(3,3)];...
%          2*[t(1,1)*t(1,2), t(2,1)*t(2,2), t(3,1)*t(3,2);...
%             t(1,1)*t(1,3), t(2,1)*t(2,3), t(3,1)*t(3,3);...
%             t(1,2)*t(1,3), t(2,2)*t(2,3), t(3,2)*t(3,3)],...
%          [t(1,1)*t(2,2) + t(2,1)*t(1,2), t(1,1)*t(3,2) + t(3,1)*t(1,2), t(2,1)*t(3,2) + t(3,1)*t(2,2);...
%           t(1,1)*t(2,3) + t(2,1)*t(1,3), t(1,1)*t(3,3) + t(3,1)*t(1,3), t(2,1)*t(3,3) + t(3,1)*t(2,3);...
%           t(1,2)*t(2,3) + t(2,2)*t(1,3), t(1,2)*t(3,3) + t(3,2)*t(1,3), t(2,2)*t(3,3) + t(3,2)*t(2,3)]];


