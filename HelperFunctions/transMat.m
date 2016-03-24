function [ T ] = transMat( Jacobian )
% eps = 11 22 33 12 13 23
    t = (Jacobian); % inv, JT etc
    T = [t.^2, [t(1,1)*t(2,1), t(1,1)*t(3,1), t(2,1)*t(3,1);...
                t(1,2)*t(2,2), t(1,2)*t(3,2), t(2,2)*t(3,2);...
                t(1,3)*t(2,3), t(1,3)*t(3,3), t(2,3)*t(3,3)];...
         2*[t(1,1)*t(1,2), t(2,1)*t(2,2), t(3,1)*t(3,2);...
            t(1,1)*t(1,3), t(2,1)*t(2,3), t(3,1)*t(3,3);...
            t(1,2)*t(1,3), t(2,2)*t(2,3), t(3,2)*t(3,3)],...
         [t(1,1)*t(2,2) + t(2,1)*t(1,2), t(1,1)*t(3,2) + t(3,1)*t(1,2), t(2,1)*t(3,2) + t(3,1)*t(2,2);...
          t(1,1)*t(2,3) + t(2,1)*t(1,3), t(1,1)*t(3,3) + t(3,1)*t(1,3), t(2,1)*t(3,3) + t(3,1)*t(2,3);...
          t(1,2)*t(2,3) + t(2,2)*t(1,3), t(1,2)*t(3,3) + t(3,2)*t(1,3), t(2,2)*t(3,3) + t(3,2)*t(2,3)]];
      
end

