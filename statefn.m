function [z] = statefn(x,u,params)

% mv : Q
% states : Vgd,Vgq,Vod,Voq(current bus),theta,Vmag (all buses),predstep    
%f,L,R,Ts
%params : Power predictions for all buses; bus number

global nbus;
f = 50;L = 10e-3;R = 0.1;

%Current Prediction
Id = ((x(1)-x(3))*R+(x(2)-x(4))*2*pi*f*L)/(R^2+(2*pi*f*L)^2);
Iq = ((x(2)-x(4))*R+(x(3)-x(1))*2*pi*f*L)/(R^2+(2*pi*f*L)^2);

%u_old(1) = (3/2)*(Id*x(1+t)+Iq*x(2+t));
u_old = (3/2)*(x(2)*Id-x(1)*Iq);
u_old = -u_old/10e3;
step = int16(x(end));  % Current prediction step
if step < 2
    step = 2;
end
bn = int16(params(end));     %Bus Number of device
if bn < 2
    bn = 2;
end   
%Data Ordering
params = reshape(params(1:end-1),nbus-1,[]);
params = [params, params(:,end)];
theta = x(5:5+nbus-1);
V = x(5+nbus:5+2*nbus-1);

%deltaQ = zeros(nbus-1,1);
deltaP = zeros(nbus-1,1);
deltaQ = params(:,step+1) - params(:,step);
deltaQ(bn-1) = u-u_old;
deltaS = [deltaP;deltaQ];

%Correction calculation
J = jacobian(V,theta);
deltacorr = pinv(J)*deltaS;
theta(2:nbus) = theta(2:nbus) + deltacorr(1:nbus-1);
V(2:nbus) = V(2:nbus) + deltacorr(nbus:2*(nbus-1));

%Updating the voltage phasor/Prediction
x(5:5+nbus-1) = theta;
x(5+nbus:5+2*nbus-1) = V;

%State update
x(end) = x(end)+1;
x(end);
z = x;
end

