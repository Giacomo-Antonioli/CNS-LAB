NARMADATASET = load('NARMA10timeseries.mat');
NARMADATASET = NARMADATASET.NARMA10timeseries;
X = cell2mat(NARMADATASET.input');
Y = cell2mat(NARMADATASET.target');

training_set = X(1:5000, :);
training_set_labels = Y(1:5000, :);
test_set = X(5001:end, :);
test_set_labels = Y(5001:end, :);

validation_split = training_set(4001:end, :);
validation_split_labels = training_set_labels(4001:end, :);
training_split = training_set(1:4000, :);
training_split_labels = training_set_labels(1:4000, :);

X = num2cell(X');
Y = num2cell(Y');
training_split = num2cell(training_split');
training_split_labels = num2cell(training_split_labels');
validation_split = num2cell(validation_split');
validation_split_labels = num2cell(validation_split_labels');
training_set = num2cell(training_set');
training_set_labels = num2cell(training_set_labels');
test_set = num2cell(test_set');
test_set_labels = num2cell(test_set_labels');



best_conf = {};
best_val_error = inf;
best_train_error = inf;
best_epoch = 0;
best_tr = {};


hidden_sizes = {[5], [10], [15], [20]};
MAX_EPOCHS = 400;

for j = 1:size(hidden_sizes, 2)

    h  = cell2mat(hidden_sizes(j));
    
    net = layrecnet(1:1, h, "trainlm");
    net.trainParam.epochs = MAX_EPOCHS;
    tr_indices = 1:4000; 
    tv_indices = 4001:5000; 
    ts_indices = []; 
    net.divideFcn = 'divideind';
    net.divideParam.trainInd = tr_indices;

    net.divideParam.testInd = ts_indices;

    net.divideParam.valInd = tv_indices;
    
    [delayedInput,initialInput,initialStates,delayedTarget] = preparets(net, training_set, training_set_labels);
    [net, tr] = train(net,delayedInput,delayedTarget,initialInput,initialStates);
    

    [delayedInput,initialInput,initialStates,delayedTarget] = preparets(net, training_split, training_split_labels);
    [train_pred_Y,Xf,Af] = net(delayedInput,initialInput,initialStates);
    
    train_mse = immse(cell2mat(delayedTarget), cell2mat(train_pred_Y));
    fprintf('Training mse = %d\n', train_mse)
    

    [netc,Xic,Aic] = closeloop(net,Xf,Af);
    [val_pred_Y, Xf, Af] = netc(validation_split, Xic, Aic);
    
    val_mse = immse(cell2mat(validation_split_labels), cell2mat(val_pred_Y));
    fprintf('Validation mse = %d\n', val_mse)
    
    if val_mse < best_val_error
        best_conf = {h};
        best_val_error = val_mse;
        best_train_error = train_mse;
        best_epoch = tr.best_epoch;
        best_tr = tr;
        tr.best_vperf;
        tr.best_perf;
    end
end


best_h = cell2mat(best_conf(1))
best_epoch


net = timedelaynet(1:1, best_h, "trainlm");

net.divideFcn = 'divideind';
net.divideParam.trainInd = 1:5000;   
net.divideParam.testInd = 5001:10000; 
net.divideParam.valInd = [];          
net.trainParam.epochs = best_epoch;   

[delayedInput,initialInput,initialStates,delayedTarget] = preparets(net, X, Y);
[net, tr] = train(net,delayedInput,delayedTarget,initialInput,initialStates);


[delayedInput,initialInput,initialStates,delayedTarget] = preparets(net, training_set, training_set_labels);
[train_pred_Y,Xf,Af] = net(delayedInput,initialInput,initialStates);

mse = immse(cell2mat(delayedTarget), cell2mat(train_pred_Y));
fprintf('Training data mse = %d\n', mse)

[netc,Xic,Aic] = closeloop(net,Xf,Af);
[test_pred_Y, Xf, Af] = netc(test_set, Xic, Aic);

test_mse = immse(cell2mat(test_set_labels), cell2mat(test_pred_Y));
fprintf('Test mse = %d\n', test_mse)

dir=pwd;
fig=figure
plot(cell2mat(delayedTarget))
hold on
plot(cell2mat(train_pred_Y))
xlabel('t')
ylabel('d(t)')
legend({'True signal', 'Model Prediction'})
title('Training signal')
saveas(fig, [dir,'/plots/recurrent_net_training_signal.png'])

fig=figure
plot(cell2mat(test_set_labels))
hold on
plot(cell2mat(test_pred_Y))
xlabel('t')
ylabel('d(t)')
legend({'True signal', 'Model Prediction'})
title('Test signal')
saveas(fig,  [dir,'/plots/recurrent_net_test_signal.png'])

fig=figure
plotperform(best_tr)
saveas(fig, [dir,'/plots/grid_search_loss_recurrent_net.png'])


fig=figure
plotperform(tr)
saveas(fig, [dir,'/plots/loss_recurrent_net.png'])

save([dir,'/plots/tr_RNN.png'], 'tr')
save([dir,'/plots/net_RNN.png'], 'net')

fileID = fopen([dir,'/plots/res_recurrent_net.txt'],'w');
fprintf(fileID,'Best epoch = %d\n',best_epoch);
fprintf(fileID,'Train MSE | Val MSE | TEST MSE\n');
fprintf(fileID,'%d | %d | %d\n',best_train_error,best_val_error, test_mse);
fclose(fileID);