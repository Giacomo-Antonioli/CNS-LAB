NARMADATASET = load('NARMA10timeseries.mat');
NARMADATASET = NARMADATASET.NARMA10timeseries;
X = cell2mat(NARMADATASET.input');
Y = cell2mat(NARMADATASET.target');

% --- Split the data into training and test set --- %
training_set = X(1:5000, :);
training_set_labels = Y(1:5000, :);
test_set = X(5001:end, :);
test_set_labels = Y(5001:end, :);

% Split the training set into training and validation set
validation_split = training_set(4001:end, :);
validation_split_labels = training_set_labels(4001:end, :);
training_split = training_set(1:4000, :);
training_split_labels = training_set_labels(1:4000, :);

% Change data types for training
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


% --- Model selection --- %
best_conf = {};
best_val_error = inf;
best_train_error = inf;
best_epoch = 0;
best_tr = {};

% First result: input_delay = 0:12, hidden_sizes = 20
% input_delays = {0:1,0:2,0:3,0:4,0:5,0:6,0:7 ,0:8, 0:9, 0:10,0:11, 0:12}; 
% hidden_sizes = {10:5:50};

input_delays = {0:10, 0:12}; 
hidden_sizes = {[10], [20]};

for i = 1:size(input_delays, 2)
    for j = 1:size(hidden_sizes, 2)
        id = cell2mat(input_delays(i));
        h  = cell2mat(hidden_sizes(j));
        
        net = timedelaynet(id, h, "trainlm");
        % Train the model on the current hyperparameter conf.
        tr_indices = 1:4000; %indices used for training
        tv_indices = 4001:5000; %indices used for validation
        ts_indices = []; % indices used for *test*
        net.divideFcn = 'divideind';
        net.divideParam.trainInd = tr_indices;
        % Test: Used for final assessment only
        net.divideParam.testInd = ts_indices;
        % Validation: Used for early stopping
        net.divideParam.valInd = tv_indices;
        
        [delayedInput,initialInput,initialStates,delayedTarget] = preparets(net, training_set, training_set_labels);
        [net, tr] = train(net,delayedInput,delayedTarget,initialInput,initialStates,'UseParallel','yes');

        % simulate it on the training data
        [delayedInput,initialInput,initialStates,delayedTarget] = preparets(net, training_split, training_split_labels);
        [train_pred_Y,Xf,Af] = net(delayedInput,initialInput,initialStates);

        train_mse = immse(cell2mat(delayedTarget), cell2mat(train_pred_Y));
        fprintf('All Training data mse = %d\n', train_mse)

        % Simulate on the val set
        [netc,Xic,Aic] = closeloop(net,Xf,Af);
        [val_pred_Y, Xf, Af] = netc(validation_split, Xic, Aic);

        val_mse = immse(cell2mat(validation_split_labels), cell2mat(val_pred_Y));
        fprintf('Val mse = %d\n', val_mse)
        
        if val_mse < best_val_error
            best_conf = {id, h};
            best_val_error = val_mse;
            best_train_error = train_mse;
            best_epoch = tr.best_epoch;
            best_tr = tr;
            tr.best_vperf;
            tr.best_perf;
        end
    end 
end

best_id = cell2mat(best_conf(1))
best_h = cell2mat(best_conf(2))
best_epoch

% --- Train the net with the best conf. onto all the training data --- % 
net = timedelaynet(best_id, best_h, "trainlm");

net.divideFcn = 'divideind';
net.divideParam.trainInd = 1:5000;    % indices used for training
net.divideParam.testInd = 5001:10000; % Test: Used for final assessment only
net.divideParam.valInd = [];          % Validation: Used for early stopping
net.trainParam.epochs = best_epoch;   % maximum number of epochs

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
saveas(fig, [dir,'/plots/time_delayed_training_signal.png'])

fig=figure
plot(cell2mat(test_set_labels))
hold on
plot(cell2mat(test_pred_Y))
xlabel('t')
ylabel('d(t)')
legend({'True signal', 'Model Prediction'})
title('Test signal')
saveas(fig,  [dir,'/plots/time_delayed_test_signal.png'])

% Plot Model selection loss function
fig=figure
plotperform(best_tr)
saveas(fig, [dir,'/plots/grid_search_loss_time_delayed.png'])

% Plot loss function
fig=figure
plotperform(tr)
saveas(fig, [dir,'/plots/loss_time_delayed.png'])
save([dir,'/plots/tr_time_delayed.png'], 'tr')
save([dir,'/plots/net_time_delayed.png'], 'net')
fileID = fopen([dir,'/plots/res.txt'],'w');
fprintf(fileID,'Best epoch = %d\n',best_epoch);
fprintf(fileID,'Train MSE | Val MSE | TEST MSE\n');
fprintf(fileID,'%d | %d | %d\n',best_train_error,best_val_error, test_mse);
fclose(fileID);