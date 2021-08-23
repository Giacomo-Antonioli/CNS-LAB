load laser_dataset
whole_dataset=cell2mat(laserTargets);
input_dataset = whole_dataset(:,1:end-1);
target_dataset = whole_dataset(:,2:end);
input_dataset_train=input_dataset(1:1500);
input_dataset_test=input_dataset(1500:2000);
target_dataset_train=target_dataset(1:1500);
target_dataset_test=target_dataset(1500:2000);
figure;
plot(input_dataset_train);
figure;
plot(target_dataset_train);

[states,firings] = modified_lsm(input_dataset_train);

w_out=target_dataset_train*pinv(states);
trainOutput = w_out * states;

mean(abs(trainOutput-targetTraining))
