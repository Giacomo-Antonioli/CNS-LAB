function [] = Izhikevich_Simulator(model,params,other_params)
%UNTITLED13 Summary of this function goes here
%   Detailed explanation goes here

a=params(1); b=params(2); c=params(3);d=params(4);
tau=other_params(1);maxtspan=other_params(2);
x=other_params(3); y=b*x;

Membrane_potential_vector=[];  Recovery_Variable_vector=[];
tspan = 0:tau:maxtspan;

disp("Computing Model: "+ model);
disp("a: "+a+" b: "+b+" c: "+c+" d: "+d);
disp("V: "+x+" u:"+y);
disp("tau: "+tau+" tspan= 0:"+tau+":"+maxtspan);
switch model
    case 'Tonic Spiking'
        
        T1=tspan(end)/10;
        vector1=[0 T1 T1 max(tspan)];
        vector2=-90+[0 0 10 10];
        for t=tspan
            if (t>T1)
                I=14;
            else
                I=0;
            end
            [tmp1,tmp2,next]=Fourth_Order_Runge_Method_Izhikevich_Model(x,y,tau,a,b,c,d,I,model);
            Membrane_potential_vector(end+1)=tmp1;
            Recovery_Variable_vector(end+1)=tmp2;
            x=next;
            y=tmp2;
        end
        
        
    case 'Phasic Spiking'
        T1=20;
        vector1=[0 T1 T1 max(tspan)];
        vector2=-90+[0 0 10 10];
        for t=tspan
            if (t>T1)
                I=0.5;
            else
                I=0;
            end;
            [tmp1,tmp2,next]=Fourth_Order_Runge_Method_Izhikevich_Model(x,y,tau,a,b,c,d,I,model);
            Membrane_potential_vector(end+1)=tmp1;
            Recovery_Variable_vector(end+1)=tmp2;
            x=next;
            y=tmp2;
        end;
    case 'Tonic Bursting'
        T1=22;
        vector1=[0 T1 T1 max(tspan)];
        vector2=-90+[0 0 10 10];
        for t=tspan
            if (t>T1)
                I=15;
            else
                I=0;
            end;
            [tmp1,tmp2,next]=Fourth_Order_Runge_Method_Izhikevich_Model(x,y,tau,a,b,c,d,I,model);
            Membrane_potential_vector(end+1)=tmp1;
            Recovery_Variable_vector(end+1)=tmp2;
            x=next;
            y=tmp2;
        end;
    case'Phasic Bursting'
        T1=20;
        for t=tspan
            if (t>T1)
                I=0.6;
            else
                I=0;
            end;
            [tmp1,tmp2,next]=Fourth_Order_Runge_Method_Izhikevich_Model(x,y,tau,a,b,c,d,I,model);
            Membrane_potential_vector(end+1)=tmp1;
            Recovery_Variable_vector(end+1)=tmp2;
            x=next;
            y=tmp2;
        end;
        vector1=[0 T1 T1 max(tspan)];vector2=-90+[0 0 10 10];
        
        
    case 'Mixed mode'
        T1=tspan(end)/10;
        for t=tspan
            if (t>T1)
                I=10;
            else
                I=0;
            end;
            [tmp1,tmp2,next]=Fourth_Order_Runge_Method_Izhikevich_Model(x,y,tau,a,b,c,d,I,model);
            Membrane_potential_vector(end+1)=tmp1;
            Recovery_Variable_vector(end+1)=tmp2;
            x=next;
            y=tmp2;
        end;
        vector1=[0 T1 T1 max(tspan)];vector2=-90+[0 0 10 10];
    case 'Spike Frequency Adaptation'
        T1=tspan(end)/10;
        for t=tspan
            if (t>T1)
                I=30;
            else
                I=0;
            end;
            [tmp1,tmp2,next]=Fourth_Order_Runge_Method_Izhikevich_Model(x,y,tau,a,b,c,d,I,model);
            Membrane_potential_vector(end+1)=tmp1;
            Recovery_Variable_vector(end+1)=tmp2;
            x=next;
            y=tmp2;
        end;
        vector1=[0 T1 T1 max(tspan)];vector2=-90+[0 0 10 10];
    case 'Class 1 excitability'
        T1=30;
        for t=tspan
            if (t>T1)
                I=(0.075*(t-T1));
            else
                I=0;
            end;
            [tmp1,tmp2,next]=Fourth_Order_Runge_Method_Izhikevich_Model(x,y,tau,a,b,c,d,I,model,108,4.1);
            Membrane_potential_vector(end+1)=tmp1;
            Recovery_Variable_vector(end+1)=tmp2;
            x=next;
            y=tmp2;
        end;
        vector1=[0 T1 max(tspan) max(tspan)];vector2=-90+[0 0 20 0];
    case 'Class 2 excitability'
        T1=30;
        for t=tspan
            if (t>T1)
                I=-0.5+(0.015*(t-T1));
            else
                I=-0.5;
            end;
            [tmp1,tmp2,next]=Fourth_Order_Runge_Method_Izhikevich_Model(x,y,tau,a,b,c,d,I,model);
            Membrane_potential_vector(end+1)=tmp1;
            Recovery_Variable_vector(end+1)=tmp2;
            x=next;
            y=tmp2;
        end;
        vector1=[0 T1 max(tspan) max(tspan)];vector2=-90+[0 0 20 0];
    case 'Spike Latency'
        %%
        % Here the Fourth Order Runge Method does not let the neuron fire
        % so for correctness purpose I've implemented Euler's method.
        % Update: Runge method lets the neuron fire by halving tau (and for
        % proportions even maxspan). The Runge Approximation is left
        % commented
        %%
        T1=tspan(end)/10;
        for t=tspan
        if t>T1 & t < T1+3 
            I=7.04;
        else
            I=0;
        end;
        x = x + tau*(0.04*x^2+5*x+140-y+I);
        y = y + tau*a*(b*x-y);
        if x > 30
            Membrane_potential_vector(end+1)=30;
            x = c;
            y= y + d;
        else
            Membrane_potential_vector(end+1)=x;
        end;
        Recovery_Variable_vector(end+1)=y;
        end;
        %{      
                tau=0.1;
                maxpsan=50;
                tspan=1:tau:maxspan;
                for t=tspan
                    if t>T1 & t < T1+3
                        I=7.04;
                    else
                        I=0;
                    end
                    [tmp1,tmp2,next]=Fourth_Order_Runge_Method_Izhikevich_Model(x,y,tau,a,b,c,d,I,model);
                    Membrane_potential_vector(end+1)=tmp1;
                    Recovery_Variable_vector(end+1)=tmp2;
                    x=next;
                    y=tmp2;
                end;
        %}
        vector1=[0 T1 T1 T1+3 T1+3 max(tspan)];vector2=-90+[0 0 10 10 0 0];
    case 'Subthreshold oscillations'
        T1=tspan(end)/10;
        for t=tspan
            if (t>T1) & (t < T1+5)
                I=2;
            else
                I=0;
            end;
            [tmp1,tmp2,next]=Fourth_Order_Runge_Method_Izhikevich_Model(x,y,tau,a,b,c,d,I,model);
            Membrane_potential_vector(end+1)=tmp1;
            Recovery_Variable_vector(end+1)=tmp2;
            x=next;
            y=tmp2;
        end;
        vector1=[0 T1 T1 (T1+5) (T1+5) max(tspan)];vector2=-90+[0 0 10 10 0 0];
    case 'Frequency Preference – Resonators'
        T1=tspan(end)/10;
        T2=T1+20;
        T3 = 0.7*tspan(end);
        T4 = T3+40;
        for t=tspan
            if ((t>T1) & (t < T1+4)) | ((t>T2) & (t < T2+4)) | ((t>T3) & (t < T3+4)) | ((t>T4) & (t < T4+4))
                I=0.65;
            else
                I=0;
            end;
            [tmp1,tmp2,next]=Fourth_Order_Runge_Method_Izhikevich_Model(x,y,tau,a,b,c,d,I,model);
            Membrane_potential_vector(end+1)=tmp1;
            Recovery_Variable_vector(end+1)=tmp2;
            x=next;
            y=tmp2;
        end;
        vector1=[0 T1 T1 (T1+8) (T1+8) T2 T2 (T2+8) (T2+8) T3 T3 (T3+8) (T3+8) T4 T4 (T4+8) (T4+8) max(tspan)];vector2=-90+[0 0 10 10 0 0 10 10 0 0 10 10 0 0 10 10 0 0];
    case 'Integration'
        T1=tspan(end)/11;
        T2=T1+5;
        T3 = 0.7*tspan(end);
        T4 = T3+10;
        for t=tspan
            if ((t>T1) & (t < T1+2)) | ((t>T2) & (t < T2+2)) | ((t>T3) & (t < T3+2)) | ((t>T4) & (t < T4+2))
                I=9;
            else
                I=0;
            end;
            [tmp1,tmp2,next]=Fourth_Order_Runge_Method_Izhikevich_Model(x,y,tau,a,b,c,d,I,model,108,4.1);
            Membrane_potential_vector(end+1)=tmp1;
            Recovery_Variable_vector(end+1)=tmp2;
            x=next;
            y=tmp2;
        end;
        vector1=[0 T1 T1 (T1+2) (T1+2) T2 T2 (T2+2) (T2+2) T3 T3 (T3+2) (T3+2) T4 T4 (T4+2) (T4+2) max(tspan)];vector2=-90+[0 0 10 10 0 0 10 10 0 0 10 10 0 0 10 10 0 0];
    case 'Rebound Spike'
        T1=20;
        for t=tspan
            if (t>T1) & (t < T1+5)
                I=-15;
            else
                I=0;
            end;
            [tmp1,tmp2,next]=Fourth_Order_Runge_Method_Izhikevich_Model(x,y,tau,a,b,c,d,I,model);
            Membrane_potential_vector(end+1)=tmp1;
            Recovery_Variable_vector(end+1)=tmp2;
            x=next;
            y=tmp2;
        end;
        vector1=[0 T1 T1 (T1+5) (T1+5) max(tspan)];vector2=-85+[0 0 -5 -5 0 0];
    case 'Rebound Burst'
        T1=20;
        for t=tspan
            if (t>T1) & (t < T1+5)
                I=-15;
            else
                I=0;
            end;
            [tmp1,tmp2,next]=Fourth_Order_Runge_Method_Izhikevich_Model(x,y,tau,a,b,c,d,I,model);
            Membrane_potential_vector(end+1)=tmp1;
            Recovery_Variable_vector(end+1)=tmp2;
            x=next;
            y=tmp2;
        end;
        vector1=[0 T1 T1 (T1+5) (T1+5) max(tspan)];vector2=-85+[0 0 -5 -5 0 0];
    case 'Threshold Variability'
        for t=tspan
            if ((t>10) & (t < 15)) | ((t>80) & (t < 85))
                I=1;
            elseif (t>70) & (t < 75)
                I=-6;
            else
                I=0;
            end;
            [tmp1,tmp2,next]=Fourth_Order_Runge_Method_Izhikevich_Model(x,y,tau,a,b,c,d,I,model);
            Membrane_potential_vector(end+1)=tmp1;
            Recovery_Variable_vector(end+1)=tmp2;
            x=next;
            y=tmp2;
        end;
        vector1=[0 10 10 15 15 70 70 75 75 80 80 85 85 max(tspan)];
        vector2=-85+[0 0  5  5  0  0  -5 -5 0  0  5  5  0  0];
    case 'Bistability'
        %%
        % Here the Fourth Order Runge Method does not let the neuron fire
        % so for correctness purpose I've implemented Euler's method.
        %% 
        T1=tspan(end)/8;
        T2 = 216;
        for t=tspan
            if ((t>T1) & (t < T1+5)) | ((t>T2) & (t < T2+5))
                I=1.24;
            else
                I=0.24;
            end;
            x = x + tau*(0.04*x^2+5*x+140-y+I);
            y = y + tau*a*(b*x-y);
            if x > 30
                Membrane_potential_vector(end+1)=30;
                x = c;
                y= y + d;
            else
                Membrane_potential_vector(end+1)=x;
            end;
            Recovery_Variable_vector(end+1)=y;
        end;
        
        %{
        
        for t=tspan
            if ((t>T1) & (t < T1+5)) | ((t>T2) & (t < T2+5))
                I=1.24;
            else
                I=0.24;
            end;
            [tmp1,tmp2,next]=Fourth_Order_Runge_Method_Izhikevich_Model(x,y,tau,a,b,c,d,I,model);
            Membrane_potential_vector(end+1)=tmp1;
            Recovery_Variable_vector(end+1)=tmp2;
            x=next;
            y=tmp2;
        end;
        
        %}
        vector1=[0 T1 T1 (T1+5) (T1+5) T2 T2 (T2+5) (T2+5) max(tspan)];vector2=-90+[0 0 10 10 0 0 10 10 0 0];
    case 'Depolarizing After-Potential'
        %%
        % Here the Fourth Order Runge Method does not let the neuron fire
        % so for correctness purpose I've implemented Euler's method.
        %% 
        T1 = 10;
        for t=tspan
            if abs(t-T1)<1
                I=20;
            else
                I=0;
            end;
            x = x + tau*(0.04*x^2+5*x+140-y+I);
            y = y + tau*a*(b*x-y);
            if x > 30
                Membrane_potential_vector(end+1)=30;
                x = c;
                y= y + d;
            else
                Membrane_potential_vector(end+1)=x;
            end;
            Recovery_Variable_vector(end+1)=y;
        end;
        
        %{
        
         [tmp1,tmp2,next]=Fourth_Order_Runge_Method_Izhikevich_Model(x,y,tau,a,b,c,d,I,model);
            Membrane_potential_vector(end+1)=tmp1;
            Recovery_Variable_vector(end+1)=tmp2;
            x=next;
            y=tmp2;
        
        %}
        vector1=[0 T1-1 T1-1 T1+1 T1+1 max(tspan)];vector2=-90+[0 0 10 10 0 0];
    case 'Accomodation'
        II=[];
        y=-16;
        for t=tspan
            if (t < 200)
                I=t/25;
            elseif t < 300
                I=0;
            elseif t < 312.5
                I=(t-300)/12.5*4;
            else
                I=0;
            end;
            [tmp1,tmp2,next]=Fourth_Order_Runge_Method_Izhikevich_Model(x,y,tau,a,b,c,d,I,model);
            Membrane_potential_vector(end+1)=tmp1;
            Recovery_Variable_vector(end+1)=tmp2;
            x=next;
            y=tmp2;
            II(end+1)=I;
        end;
        vector1=tspan;vector2=II*1.5-90;
    case 'Inhibition-induced Spiking'    
        %%
        % Here the Fourth Order Runge Method does not let the neuron fire
        % so for correctness purpose I've implemented Euler's method.
        %% 
        for t=tspan
            if (t < 50) | (t>250)
                I=80;
            else
                I=75;
            end;
            [tmp1,tmp2,next]=Fourth_Order_Runge_Method_Izhikevich_Model(x,y,tau,a,b,c,d,I,model);
            Membrane_potential_vector(end+1)=tmp1;
            Recovery_Variable_vector(end+1)=tmp2;
            x=next;
            y=tmp2;
        end;
        vector1=[0 50 50 250 250 max(tspan)];vector2=-80+[0 0 -10 -10 0 0];
    case 'Inhibition-induced Bursting'
        for t=tspan
            if (t < 50) | (t>250)
                I=80;
            else
                I=75;
            end;
            x = x + tau*(0.04*x^2+5*x+140-y+I);
            y = y + tau*a*(b*x-y);
            if x > 30
                Membrane_potential_vector(end+1)=30;
                x = c;
                y= y + d;
            else
                Membrane_potential_vector(end+1)=x;
            end;
            Recovery_Variable_vector(end+1)=y;
        end;
        
        %{
        
            [tmp1,tmp2,next]=Fourth_Order_Runge_Method_Izhikevich_Model(x,y,tau,a,b,c,d,I,model);
            Membrane_potential_vector(end+1)=tmp1;
            Recovery_Variable_vector(end+1)=tmp2;
            x=next;
            y=tmp2;
        
        %}
        vector1=[0 50 50 250 250 max(tspan)];vector2=-80+[0 0 -10 -10 0 0];
end

folder=pwd;

fig_spike=figure;
spike=plot(tspan,Membrane_potential_vector,vector1,vector2);
axis([0 max(tspan) -90 30]);
title(model);
subtitle('Membrane Potential Dynamics');
xlabel('Time (t)');
ylabel('Membrane Potential (u)');
saveas(fig_spike,[folder,sprintf('/Membrane_Potential_Imgs/Membrane_Potential_Dynamics_for_%s.fig',model)])

fig_phase=figure;
phase=plot(Membrane_potential_vector,Recovery_Variable_vector);
title(model);
subtitle('Phase Portrait');
xlabel('Membrane Potential (u)');
ylabel('Recovery Variable (w)');
saveas(fig_phase,[folder,sprintf('/Phase_Portrait_Imgs/Phase_Portrait_for_%s.fig',model)])



end

