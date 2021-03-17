a=0.02; b=-0.1; c=-55; d=6;
x=-60; y=b*x;
example_title='(G) Class 1';
Membrane_potential_vector=[];  Recovery_Variable_vector=[];
tau = 0.25; tspan = 0:tau:300;
T1=30;
for t=tspan
    if (t>T1) 
         I=(0.075*(t-T1));
    else
        I=0;
    end;
    [tmp1,tmp2,next]=Fourth_Order_Runge_Method_Izhikevich_Model(x,y,tau,a,b,c,d,I);
    Membrane_potential_vector(end+1)=tmp1;
    Recovery_Variable_vector(end+1)=tmp2;
    x=next;
    y=tmp2;
end;
figure
plot(tspan,Membrane_potential_vector,[0 T1 max(tspan) max(tspan)],-90+[0 0 20 0]);
axis([0 max(tspan) -90 30])
title(example_title);
subtitle('Membrane Potential Dynamics');
xlabel('Time (t)');
ylabel('Membrane Potential (u)')
figure
plot(Membrane_potential_vector,Recovery_Variable_vector)
title(example_title);
subtitle('Phase Portrait');
xlabel('Membrane Potential (u)')
xlabel('Recovery Variable (w)');