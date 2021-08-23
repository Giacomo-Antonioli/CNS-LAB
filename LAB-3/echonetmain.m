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

[Win,Wr,Wout]=Echo(training_split,training_split_label,1,20,0.5,1);

x=@(t) tanh(Win*[series(t);1]+Wr*xold)
y=@(t) Wout*[x(t);1]