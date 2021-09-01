NARMADATASET = load('NARMA10timeseries.mat');
NARMADATASET = NARMADATASET.NARMA10timeseries;
H = cell2mat(NARMADATASET.input');
Y = cell2mat(NARMADATASET.target');

training_set = H(1:5000, :);
training_set_labels = Y(1:5000, :);
test_set = H(5001:end, :);
test_set_labels = Y(5001:end, :);

validation_split = training_set(4001:end, :);
validation_split_labels = training_set_labels(4001:end, :);
training_split = training_set(1:4000, :);
training_split_labels = training_set_labels(1:4000, :);


N_input_units = 1; N_output_units = 1;


input_scaling_values = {0.5,1,1.5};
n_reservoir_units_values = {100,300, 500,};
rho_desired_values = {0.8, 0.9};
regularization_values = {1e-8, 1e-7};


n_transient = numel(training_set)/100;%I discard 1%

best_val_error = inf;
best_conf = {};
perc=size(input_scaling_values, 2)*size(n_reservoir_units_values, 2)*size(rho_desired_values, 2)*size(regularization_values, 2)*number_of_guesses;
count=1;
number_of_guesses = 5;
 wait_bar= waitbar(0,'Searcing for best Hyperparameters');
for input_scaling = 1:size(input_scaling_values, 2)
    for reservoir_units = 1:size(n_reservoir_units_values, 2)
        for rho_value = 1:size(rho_desired_values, 2)
            for reg_param = 1:size(regularization_values, 2)
                
                input_scaling_val = cell2mat(input_scaling_values(input_scaling));
                n_reservoir_units = cell2mat(n_reservoir_units_values(reservoir_units));
                rho_desired = cell2mat(rho_desired_values(rho_value));
                reg = cell2mat(regularization_values(reg_param));
                
                val_error = 0;
                for t = 1:number_of_guesses
                    percentage=count/perc;
                    waitbar(percentage,wait_bar,sprintf('Searcing for best Hyperparameters %3.2f %%',percentage*100));

                    count=count+1;
                    [Win, Wr] = ESN(N_input_units, n_reservoir_units, input_scaling_val, rho_desired);
                    [Wout, H] = train_esn(training_split, training_split_labels, n_reservoir_units, Win, Wr, n_transient, reg);
                    %{
                    train_pred_Y = Wout * H;
                    train_mse = immse(train_pred_Y, training_split_labels(n_transient:end, :)');
                   %}
                   
                    H = ESN_states(validation_split, n_reservoir_units, Win, Wr, n_transient);
                    val_pred_Y = Wout * H;
                    val_mse = immse(val_pred_Y, validation_split_labels(n_transient:end, :)');
                    
                    val_error = val_error + val_mse;
                end
                
                val_error = val_error / number_of_guesses;
                if val_error < best_val_error
                    best_val_error = val_error;
                    best_conf = {input_scaling, n_reservoir_units, rho_desired, reg};
                end
            end
        end
    end
end



input_scaling = cell2mat(best_conf(1))
n_reservoir_units = cell2mat(best_conf(2))
rho_desired = cell2mat(best_conf(3))
reg = cell2mat(best_conf(4))



train_error = 0;
test_error = 0;

for t = 1:number_of_guesses
    [Win, Wr] = ESN(N_input_units, n_reservoir_units, input_scaling, rho_desired);
    [Wout, H] = train_esn(training_set, training_set_labels, n_reservoir_units, Win, Wr, n_transient, reg);
    % Training MSE
    train_pred_Y = Wout * H;
    train_mse = immse(train_pred_Y, training_set_labels(n_transient:end, :)');
    fprintf('Train mse = %d\n', train_mse)
    train_error = train_error + train_mse;
    % Test MSE
    H = ESN_states(test_set, n_reservoir_units, Win, Wr, n_transient);
    test_pred_Y = Wout * H;
    test_mse = immse(test_pred_Y, test_set_labels(n_transient:end, :)');
    fprintf('Test mse = %d\n', test_mse)
    val_error = val_error + test_mse;
end

fprintf('\n(Avg) Train mse = %d\n', train_mse)
fprintf('(Avg) Test mse = %d\n', test_mse)

dir=pwd;

save([dir,'/plots/W_input.mat'], 'Win')
save([dir,'/plots/W_reservoir.mat'], 'Wr')
save([dir,'/plots/W_output.mat'], 'Wout')

file = fopen([dir,'/plots/hyperparams.txt'],'w');
fprintf(file,'input scaling = %f\n',input_scaling);
fprintf(file,'reservoir_untis = %d\n',n_reservoir_units);
fprintf(file,'rho = %f\n',rho_desired);
fprintf(file,'regularization param= %f\n',reg);
fclose(file);

file = fopen([dir,'/plots/errors.txt'],'w');
fprintf(file,'Train and Test error averaged \n');
fprintf(file,'train_mse val_mse test_mse\n');
fprintf(file,'%d %d %d\n',train_mse, best_val_error, test_mse);
fclose(file);

fig=figure
plot(training_set_labels(n_transient:end, :))
hold on
plot(train_pred_Y')
xlabel('t')
ylabel('d(t)')
legend({'True signal', 'Model Prediction'})
title('Training signal')
saveas(fig, [dir,'/plots/train_sig.fig'])

fig=figure
plot(test_set_labels(n_transient:end, :))
hold on
plot(test_pred_Y')
xlabel('t')
ylabel('d(t)')
legend({'True signal', 'Model Prediction'})
title('Test signal')
saveas(fig, [dir,'/plots/test_sig.fig'])


function [Win, Wr] = ESN(N_input_units, Nr, input_scaling, rho_desired)

Win = input_scaling*(2*rand(Nr,N_input_units+1)-1);
Wrandom = 2*rand(Nr,Nr)-1;
Wr = Wrandom * (rho_desired/max(abs(eig(Wrandom))));
end

function [Wout, H] = train_esn(training_split, training_split_labels, Nr, Win, Wr, n_transient, lambda_r)


H = zeros(Nr, size(training_split, 1) + 1);
for t = 1:size(training_split, 1)
    u_t = training_split(t);
    H(:, t + 1) = tanh(Win * [u_t ; 1] + Wr * H(:, t));
end

H = [H ; ones(1, size(H,2))];
H = H(:, n_transient+1:end);

Ytarget = training_split_labels(n_transient:end, :)';
Wout = Ytarget * H' * inv(H * H' + lambda_r*eye(Nr+1));
end

function H = ESN_states(inputs, Nr, Win, Wr, n_transient)
H = zeros(Nr, 1001);
for t = 1:size(inputs, 1)
    u_t = inputs(t);
    H(:, t + 1) = tanh(Win * [u_t ; 1] + Wr * H(:, t));
end
H = [H ; ones(1, size(H,2))];
H = H(:, n_transient+1:end);
end