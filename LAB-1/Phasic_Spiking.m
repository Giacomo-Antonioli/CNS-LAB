a=0.02; b=0.25;  c=-65;  d=6;
x=-70; y=b*x;
example_title='(B) Phasic Spiking';
Membrane_potential_vector=[];  Recovery_Variable_vector=[];
tau = 0.25; tspan = 0:tau:200;
T1=20;
for t=tspan
    if (t>T1) 
        I=0.5;
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
plot(tspan,Membrane_potential_vector,[0 T1 T1 max(tspan)],-90+[0 0 10 10]);
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