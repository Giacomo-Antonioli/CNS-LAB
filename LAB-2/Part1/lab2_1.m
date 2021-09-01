T = readtable(['lab2_1_data.csv']);
X=table2array(T);

eta=0.001;
figure
[w,w_history,norm_history,diff]=hebbian(X,eta,'Naive');
scatter(X(1,:),X(2,:))
hold on
plotv(w,'-')
Q=X*X';
[Evec,Eval]=eig(Q);
maxeval=max(diag(Eval))
eval=diag(Eval)==maxeval;
vec=(Evec(:,eval));
plotv(vec)
legend("Training Data","Weight Vector", "Principal Eigenvector")
hold off
figure
plot([1:length(w_history(1,:))],w_history(1,:))
title("Weight evolution first component")
xlabel("Time")
ylabel("Weight")
figure
plot([1:length(w_history(2,:))],w_history(2,:))
title("Weight evolution second component")
xlabel("Time")
ylabel("Weight")
figure
plot([1:length(norm_history(1,:))],norm_history(1,:))
title("Norm of the weight")
xlabel("Time")
ylabel("Weight's Norm")

figure
disp('--------------------')
[w,w_history,norm_history,diff1]=hebbian(X,eta,'Oja');
scatter(X(1,:),X(2,:))
hold on
plotv(w,'-')
[Evec,Eval]=eig(Q);
maxeval=max(diag(Eval))
eval=find(diag(Eval)==maxeval);
vec=(Evec(:,eval));
plotv(vec(:,end))
plot(eval);
hold off
figure
plot([1:length(w_history(1,:))],w_history(1,:))
title("Weight evolution first component")
xlabel("Time")
ylabel("Weight")
figure
plot([1:length(w_history(2,:))],w_history(2,:))
title("Weight evolution second component")
xlabel("Time")
ylabel("Weight")
figure
plot([1:length(norm_history(1,:))],norm_history(1,:))
title("Norm of the weight")
xlabel("Time")
ylabel("Weight's Norm")
%%
figure
disp('--------------------')
[w,w_history,norm_history,diff1]=hebbian(X,eta,'Sub_Norm');
scatter(X(1,:),X(2,:))
hold on
plotv(w,'-')
[Evec,Eval]=eig(Q);
maxeval=max(diag(Eval))
eval=find(diag(Eval)==maxeval);
vec=(Evec(:,eval));
plotv(vec(:,end))
hold off
figure
plot([1:length(w_history(1,:))],w_history(1,:))
title("Weight evolution first component")
xlabel("Time")
ylabel("Weight")
figure
plot([1:length(w_history(2,:))],w_history(2,:))
title("Weight evolution second component")
xlabel("Time")
ylabel("Weight")
figure
plot([1:length(norm_history(1,:))],norm_history(1,:))
title("Norm of the weight")
xlabel("Time")
ylabel("Weight's Norm")
%%
figure
disp('--------------------')
[w,w_history,norm_history,diff1]=hebbian(X,eta,'BCM');
scatter(X(1,:),X(2,:))
hold on
plotv(w,'-')
[Evec,Eval]=eig(Q);
maxeval=max(diag(Eval))
eval=find(diag(Eval)==maxeval);
vec=(Evec(:,eval));
plotv(vec(:,end))
hold off
figure
plot([1:length(w_history(1,:))],w_history(1,:))
title("Weight evolution first component")
xlabel("Time")
ylabel("Weight")
figure
plot([1:length(w_history(2,:))],w_history(2,:))
title("Weight evolution second component")
xlabel("Time")
ylabel("Weight")
figure
plot([1:length(norm_history(1,:))],norm_history(1,:))
title("Norm of the weight")
xlabel("Time")
ylabel("Weight's Norm")
%%
figure
disp('--------------------')
[w,w_history,norm_history,diff1]=hebbian(X,eta,'Cov');
scatter(X(1,:),X(2,:))
hold on
plotv(w,'-')

[Evec,Eval]=eig(Q);
maxeval=max(diag(Eval))
eval=find(diag(Eval)==maxeval);
vec=(Evec(:,eval));
plotv(vec(:,end))
hold off
figure
plot([1:length(w_history(1,:))],w_history(1,:))
title("Weight evolution first component")
xlabel("Time")
ylabel("Weight")
figure
plot([1:length(w_history(2,:))],w_history(2,:))
title("Weight evolution second component")
xlabel("Time")
ylabel("Weight")
figure
plot([1:length(norm_history(1,:))],norm_history(1,:))
title("Norm of the weight")
xlabel("Time")
ylabel("Weight's Norm")
