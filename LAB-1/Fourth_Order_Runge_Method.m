function [new_x,new_y] = Fourth_Order_Runge_Method(x,y,tau,fun)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[k1x,k1y] = tau * fun(x,y)


[k2x,k2y] = tau * fun(x+0.5*k1x,y+0.5*k1y)


[k3x,k3y] = tau * fun(x+0.5*k2x,y+0.5*k2y)


[k4x,k4y] = tau * fun(x+k3x,y+k3y)


new_x = x+k1x/6+k2x/3+k3x/3+k4x/6;
new_y = x+k1y/6+k2y/3+k3y/3+k4/6;
end

