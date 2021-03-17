a=0.02; b=-0.1; c=-55; d=6;
V=-60; u=b*V;
VV=[]; uu=[];
tau = 0.25; tspan = 0:tau:300;
T1=30;
for t=tspan
    if (t>T1) 
        I=(0.075*(t-T1)); 
    else
        I=0;
    end;
    V = V + tau*(0.04*V^2+4.1*V+108-u+I);
    u = u + tau*a*(b*V-u);
    if V > 30
        VV(end+1)=30;
        V = c;
        u = u + d;
    else
        VV(end+1)=V;
    end;
    uu(end+1)=u;
end;
plot(tspan,VV,[0 T1 max(tspan) max(tspan)],-90+[0 0 20 0]);
axis([0 max(tspan) -90 30])
axis off;
title('(G) Class 1 excitable');