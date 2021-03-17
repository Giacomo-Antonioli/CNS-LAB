function [newV,newU,nextV] = Izhikevich_Model(v,u,a,b,c,I)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

newV = 0.04*v*v+5*v+140-u+I;
newU = a*(b*v-u);
nextV=newV;

if newV >= 30
        newV=30;
        nextV = c;
        newU = newU + d;     


end
end
