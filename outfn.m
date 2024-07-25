function [z] = outfn(x,u,params)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
% mv : Q
% states : Vgd,Vgq,Vod,Voq(current bus),theta,Vmag (all buses),predstep    
%f,L,R,Ts
%params : deltaQ for all buses; bus number

global nbus;

bn = int16(params(end)); %Bus Number of device
z = x(4+nbus+bn);
end

