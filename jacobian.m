function [J] = jacobian(V,del)

Y = ybus;
G = real(Y);                
B = imag(Y);                
nbus = 4;

P = zeros(nbus,1);
Q = zeros(nbus,1);
   % Calculate P and Q
   for i = 1:nbus
       for k = 1:nbus
           P(i) = P(i) + V(i)* V(k)*(G(i,k)*cos(del(i)-del(k)) + B(i,k)*sin(del(i)-del(k)));
           Q(i) = Q(i) + V(i)* V(k)*(G(i,k)*sin(del(i)-del(k)) - B(i,k)*cos(del(i)-del(k)));
       end
   end
    
J11 = zeros(nbus-1,nbus-1);
    for m = 1:(nbus-1)
        i = m+1;
        for n = 1:(nbus-1)
            k = n+1;
            if i == k
                J11(m,n) = -Q(i)-(V(i)^2)*B(i,i); 
            else
                J11(m,n) = -V(i)*V(k)*abs(Y(i,k))*sin(angle(Y(i,k)+del(k)-del(i))); 
            end  
        end
    end
J21 = zeros(nbus-1,nbus-1);
    for m = 1:(nbus-1)
        i = m+1;
        for n = 1:(nbus-1)
            k = n+1;
            if i == k
                J21(m,n) = -P(i)-(V(i)^2)*G(i,i); 
            else
                J21(m,n) = -V(i)*V(k)*abs(Y(i,k))*cos(angle(Y(i,k)+del(k)-del(i))); 
            end  
        end
    end
J12 = zeros(nbus-1,nbus-1);
    for m = 1:(nbus-1)
        i = m+1;
        for n = 1:(nbus-1)
            k = n+1;
            if i == k
                J12(m,n) = 2*G(i,i)*V(i)^2+J21(m,n);
            else
                J12(m,n) = -J21(m,n);
            end  
        end
    end
J22 = zeros(nbus-1,nbus-1);
    for m = 1:(nbus-1)
        i = m+1;
        for n = 1:(nbus-1)
            k = n+1;
            if i == k
                J22(m,n) = -2*B(i,i)*V(i)^2-J11(m,n);
            else
                J22(m,n) = J11(m,n);
            end  
        end
    end

J = [J11 J12;J21 J22];
