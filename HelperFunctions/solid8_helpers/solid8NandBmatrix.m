function [N, B] = solid8NandBmatrix(Nxieta, Bxy)
nshape = size(Bxy,2);
    if(nshape == 8)
    B = [Bxy(1,1), 0, 0, Bxy(1,2), 0, 0, Bxy(1,3), 0, 0, Bxy(1,4), 0, 0, Bxy(1,5), 0, 0, Bxy(1,6), 0, 0, Bxy(1,7), 0, 0, Bxy(1,8), 0, 0;...
        0, Bxy(2,1), 0, 0, Bxy(2,2), 0, 0, Bxy(2,3), 0, 0, Bxy(2,4), 0, 0, Bxy(2,5), 0, 0, Bxy(2,6), 0, 0, Bxy(2,7), 0, 0, Bxy(2,8), 0;...
        0, 0, Bxy(3,1), 0, 0, Bxy(3,2), 0, 0, Bxy(3,3), 0, 0, Bxy(3,4), 0, 0, Bxy(3,5), 0, 0, Bxy(3,6), 0, 0, Bxy(3,7), 0, 0, Bxy(3,8);...
        Bxy(2,1), Bxy(1,1), 0, Bxy(2,2), Bxy(1,2), 0, Bxy(2,3), Bxy(1,3), 0, Bxy(2,4), Bxy(1,4), 0, Bxy(2,5), Bxy(1,5), 0, Bxy(2,6), Bxy(1,6), 0, Bxy(2,7), Bxy(1,7), 0, Bxy(2,8), Bxy(1,8), 0;...
        Bxy(3,1), 0, Bxy(1,1), Bxy(3,2), 0, Bxy(1,2), Bxy(3,3), 0, Bxy(1,3), Bxy(3,4), 0, Bxy(1,4), Bxy(3,5), 0, Bxy(1,5), Bxy(3,6), 0, Bxy(1,6), Bxy(3,7), 0, Bxy(1,7), Bxy(3,8), 0, Bxy(1,8);...
        0, Bxy(3,1), Bxy(2,1), 0, Bxy(3,2), Bxy(2,2), 0, Bxy(3,3), Bxy(2,3), 0, Bxy(3,4), Bxy(2,4), 0, Bxy(3,5), Bxy(2,5), 0, Bxy(3,6), Bxy(2,6), 0, Bxy(3,7), Bxy(2,7), 0, Bxy(3,8), Bxy(2,8)];
    
     N = [Nxieta(1)*eye(3),Nxieta(2)*eye(3),Nxieta(3)*eye(3) ,Nxieta(4)*eye(3),...
                Nxieta(5)*eye(3) ,Nxieta(6)*eye(3), Nxieta(7)*eye(3) , Nxieta(8)*eye(3)];
            
    else
       
        B = zeros(6,nshape*3);
        for in=1:nshape
            
            B(:,[1,2,3] + 3*(in-1)) = [Bxy(1,in), 0, 0;...
                                     0, Bxy(2,in), 0;...
                                     0, 0, Bxy(3,in);...
                                     Bxy(2,in), Bxy(1,in), 0;...
                                     Bxy(3,in), 0, Bxy(1,in);...
                                     0, Bxy(3,in), Bxy(2,in)];
                                 
            N(:,(1:3) + 3*(in-1)) = Nxieta(in)*eye(3);
            
        end
        
    end

end

