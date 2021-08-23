function [w_out,w_history,norm_history,diff] = hebbian(xtrain,eta,rule)
    
    training_size = size(xtrain,2); % Checking training set dimension
    w = -1 + 2.*rand(2,1); % Weights random initialization
    max_epochs = 1000; % Maximum number of iterations
    w_history = [];
    norm_history = [];
    diff = [];
    tol=10e-5;
    iter=1;
    alpha=0.1;
    tethav=1;
    umean=mean(xtrain,2);
    while true
        
        w_old = w;
        randp = randperm(training_size); % Generating random index
        for k=1:training_size
        
            xtrain_k = xtrain(:,randp(k));% Shuffling training set
            % Computing output via linear firing rate model
            v = w'*xtrain_k;
           
            switch rule
                case 'Naive'
                     deltaW=v*xtrain_k;
                case 'Oja'
                     deltaW=v*xtrain_k-alpha*(v^2)*w;
                case 'Sub_Norm'
                     deltaW=v*xtrain_k-(v*sum(xtrain_k)*xtrain_k)/length(xtrain_k);
                case 'BCM'
                     deltaW=v*xtrain_k*(v-tethav);
                     tethav=tethav+(v*v-tethav);
                case 'Cov'
                    
                     deltaW=((xtrain_k-umean).*xtrain_k).*w;%%%???????????????
                
            end
           
            w = w_old + eta*deltaW; % Updating weights
            
        end
        diff(end+1)=norm(w-w_old);
        w_out = w;
        w_history(:,end+1) = w;
        norm_history(:,end+1) = norm(w);
        iter=iter+1;
        if norm(w-w_old)<tol ||  iter>max_epochs
            disp('MAX IT')
            disp(iter)
            break
        end
        
    end
end

