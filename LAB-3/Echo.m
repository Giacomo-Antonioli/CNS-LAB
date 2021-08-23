function [Win,Wr,Wout] = Echo(series,target,inputScaling,Nr,rho_desired,readout_ridge_reg)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
Nu=1;
Ny=1;
xold=zeros(Nr,1);

Win = inputScaling*(2*rand(Nr,Nu+1)-1);

Wrandom = 2*rand(Nr,Nr)-1;
Wr = Wrandom * (rho_desired/max(abs(eig(Wrandom))));
x=@(t) tanh(Win*[series(t);1]+Wr*xold)

discard=numel(series)/20;%tengo il 5%
X=[];
Ytarget=[];
for i=1:numel(series)
x_curr=x(i);
series(i)
if i> discard
    x_curr
X(:,end+1)=[x_curr;1];
Ytarget(end+1)=target(i);
end
xold=x_curr;

end
Wout = Ytarget * pinv(X);
y=@(t) Wout*[x(t);1]
end

