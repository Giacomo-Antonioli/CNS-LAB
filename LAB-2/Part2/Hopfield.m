function [states,energies,overlaps] = Hopfield(mu,distorted)
%UNTITLED Summary of this function goes here

N=size(mu{1},1); %Input length
M=size(mu,2); % Number of training examples


newstate=zeros(N,1);
overlap=zeros(M,1);

states={};
overlaps={};
energies={};
flag=0;
%%%%%%% TRAINING
for i=1:N
    for j=1:N
    w=0;%weight ij of the Weight matrix
        if not(j==i) %simmetric matrix, i compute just once and duplicate, i exclude diagonal
            for cell=1:size(mu,2)
        w=w+mu{cell}(j)*mu{cell}(i);
            end
            w=w/N;
            W(j,i)=w;
            
    
        end
    end
end

%%%%CONVERSION
state=distorted;%probe state
while 1
   disp("IN")
  
   randp = randperm(N);%randomly select neurons
   %%%%%%RETRIVE
   for neuron=1:N %for each neuron
    j=randp(neuron);%randomly select neuron
    sum=0;
    for i=1:N%update cycle
    sum=sum+W(j)*state(i);%update equation
    end
    newstate(j) = sign(sum);
    if newstate(j)~=state(j)
        flag=1;
    end
   end
   states{end+1}=newstate;
   state=newstate;
   
   
   
   
   
   %%%%%%%%%%%%%%%%%%OVERLAP
   for j=1:M
   sum=0;
       for i=1:N
       sum=sum+mu{j}(i)*state(i);
       end
       m=sum/N;
       overlap(j)=m;
   
   end
   overlaps{end+1}=overlap;
   
   
   
   %%%%%%ENERGY
   energy=0;
   for i=1:N
       for j=1:N
        energy=energy+W(j,i)*state(i)*state(j);
       end
   end
   energy=-0.5*energy;
   energies{end+1}=energy;
   
   
   
   if(flag==0)
       break
   end
   flag=0;
end


end

