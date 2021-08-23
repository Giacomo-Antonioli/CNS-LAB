load('lab2_2_data.mat')
N=size(p0,1);

W=zeros(N,N);
mu={p0,p1,p2};
state=zeros(N,1);
M=size(mu,2);
d_0_1=distort_image(p0,0.05);

[a,b,c]=Hopfield(mu,d_0_1);

img1=reshape(p0,32,32);
img2=reshape(d_0_1,32,32);
img3=reshape(a{end},32,32);
% figure
% imagesc(img1)
% figure
% imagesc(img2)
% figure
% imagesc(img3)
% for i=1:N
%     for j=1:N
%     sum=0;
%         if j<i
%             for cell=1:size(mu,2)
%         sum=sum+mu{cell}(i)*mu{cell}(j);
%             end
%             w=sum/N;
%             W(j,i)=w;
%            % W(i,j)=w;
%             
%         end
%     end
% end


%state=probe_vec;
% newstate=zeros(N,1);
% overlap=zeros(M,1);
% 
% states={};
% overlaps={};
% energies={};
% flag=0;
% % while 1
%    randp = randperm(N);
%    %%%%%%%%%%%%%%%%%%OVERLAP
%    for j=1:M
%    sum=0;
%        for i=1:N
%        sum=sum+mu{j}(i)*state(i);
%        end
%        m=sum/N;
%        overlap(j)=m;
%    
%    end
%    overlaps{end+1}=overlap;
%    
%    
%    
%    %%%%%%ENERGY
%    energy=0;
%    for i=1:N
%        for j=1:N
%         sum=sum+W(i,j)*state(i)*state(j);
%        end
%    end
%    energy=-0.5*energy;
%    energies{end+1}=energy;
%    
%    %%%%%%RETRIVE
%    for i=1:N
%     j=randp(i);
%     sum=0;
%     for index=1:N
%     sum=sum+W(j,index)*state(i);
%     end
%     newstate(j) = sign(sum);
%     if newstate(j)~=state(j)
%         flag=1
%    end
%    states{end+1}=newstate;
%    state=newstate;
%    if(flag==0)
%        break
%    end
%    flag=0
%    end
%    
%    
%    
% end
