load("./NARMA10timeseries.mat")
input_seq=(cell2mat(NARMA10timeseries.input));
label_seq=(cell2mat(NARMA10timeseries.target));
training_input=input_seq(1:5000);
test_set=input_seq(5001:end);
training_label=label_seq(1:5000);
test_label=label_seq(5001:end);
training_split=training_input(1:4000);
validating_split=training_input(4001:5000);
training_split_label=training_label(1:4000);
validating_split_label=training_label(4001:5000);

Nh=[10,100,200,300];
input_scaling=[0.5:0.5:2];
rho=[0.1:0.2:1];
norm_param=[0.1:0.2:0.9];
number_of_guesses=5;
ESN=EchoClass();

[best_params,best_eval_mse]=ESN.grid_search(training_split,training_split_label,validating_split,validating_split_label,Nh,input_scaling,rho,norm_param,number_of_guesses)

