function [newV,newU,nextV] = Fourth_Order_Runge_Method_Izhikevich_Model(x,y,tau,a,b,c,d,I)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


funX =@(v,u) 0.04*v*v+5*v+140-u+I;
funY =@(v,u) a*(b*v-u);
    
k1x = tau * funX(x,y);
k1y = tau * funY(x,y);

k2x = tau * funX(x+0.5*k1x,y+0.5*k1y);
k2y = tau * funY(x+0.5*k1x,y+0.5*k1y);

k3x = tau * funX(x+0.5*k2x,y+0.5*k2y);
k3y = tau * funY(x+0.5*k2x,y+0.5*k2y);

k4x = tau * funX(x+k3x,y+k3y);
k4y = tau * funY(x+k3x,y+k3y);

newV = x+k1x/6+k2x/3+k3x/3+k4x/6;
newU = y+k1y/6+k2y/3+k3y/3+k4y/6;
nextV=newV;
if newV >= 30
        newV=30;
        nextV = c;
        newU = newU + d;  

end

