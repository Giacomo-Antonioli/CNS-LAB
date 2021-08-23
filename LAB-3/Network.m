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


netIDNN=timedelaynet((0:4));
layers=[10:5:30];
lr=linspace(0.001,0.0001,5);
mc=linspace(0.1,0.9,5);
epochs=[10,100,1000,10000,100000];
regularization=linspace(0.1,0.9,5);
min=1;max=5;
best_epoch=[1,1,1,1,1];
best_mse=1;
for i=min:max
    for j=min:max
        for k=min:max
            for l=min:max

                    for p=min:max
                        netIDNN.layers{1}.size = layers(i);
                        netIDNN.trainFcn = 'traingdx';
                        netIDNN.trainParam.lr = lr(j); %learning rate for gradient descent alg.
                        netIDNN.trainParam.mc = mc(k); %momentum constant
                        netIDNN.trainParam.epochs = epochs(l); %maximum number of epochs
                        netIDNN.performParam.regularization = regularization(p);
                        netIDNN.divideFcn = 'dividetrain';
                        [delayedInput, initialInput, initialStates, delayedTarget] = preparets(netIDNN,num2cell(training_split),num2cell(training_split_label));
                        [net,tr] = train(netIDNN, delayedInput, delayedTarget, initialInput);%'useParallel','yes'
                        pred=net(validating_split);
                        curr_mse=immse(pred,validating_split_label);
                        if(curr_mse<best_mse)
                            best_epoch=[i,j,k,l,m,p];
                            best_mse=curr_mse;
                        end
                    end
                end
            end
        end
    end

disp("Best Params:")
disp("layers: "+layers(best_epoch(1)))
disp("lr: "+lr(best_epoch(2)))
disp("mc: "+mc(best_epoch(3)))
disp("epochs: "+epochs(best_epoch(4)))
disp("regularization: "+regularization(best_epoch(5)))

