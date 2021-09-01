function [w_out,w_history,norm_history,diff] = hebbian(xtrain,eta,rule)
    
    training_size = size(xtrain,2); % Checking training set dimension
    w = unifrnd(-1,1,2,1); % Weights random initialization
    max_epochs = 1000; % Maximum number of iterations
    
    w_history = [w];
    norm_history = [norm(w)];
    diff = [];
    tol=10e-5;
    iter=1;
    alpha=0.1;
    tethav=1;
    umean=mean(xtrain,2);
    while true
        
        randp = randperm(training_size); % Generating random index
        for k=1:training_size
            w_old = w;
            u_k = xtrain(:,randp(k));% Shuffling training set
            % Computing output via linear firing rate model
            v_k = w'*u_k;
           
            switch rule
                case 'Naive'
                     deltaW=v_k*u_k;
                case 'Oja'
                     deltaW=v_k*u_k-alpha*(v_k^2)*w;
                case 'Sub_Norm'
                     deltaW=v_k*u_k-(v_k*sum(u_k)*u_k)/length(u_k);
                case 'BCM'
                     deltaW=v_k*u_k*(v_k-tethav);
                     tethav=tethav+(v_k*v_k-tethav);
                case 'Cov'
                    
                     deltaW=((u_k-umean).*u_k).*w;%%%???????????????
                
            end
           
            w = w_old + eta*deltaW; % Updating weights
            
        end
        diff(end+1)=norm(w-w_old);
        w_out = w;
        w_history(:,end+1) = w;
        norm_history(:,end+1) = norm(w);
        
        if norm(w-w_old)<tol ||  iter>max_epochs
            disp('MAX IT')
            disp(iter)
            break
        end
        iter=iter+1;
        
    end
end

