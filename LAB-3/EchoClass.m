classdef EchoClass < handle
    properties
        x                   %Input
        h                   %State
        past_state=0        %Past State
        y                   %Output
        d                   %Target
        Nu {mustBeNumeric}  %Number of inputs
        Nh {mustBeNumeric}  %Number of Reservoir
        Ny {mustBeNumeric}  %Numver of readout neurons
        U                   %Input Weights Matrix
        W                   %Recurrent Weights Matrix
        V                   %Output Weights Matrix
        H                   %Reservoir States collection
        Y_vec               %Output collection
        norm_param {mustBeNumeric} %Regularization Parameter
        
    end
    methods
        function []=reset(this)
            this.x= [];
            this.h= [];
            this.past_state= 0;
            this.y= [];
            this.d= [];
            this.Nu= [];
            this.Nh= [];
            this.Ny= [];
            this.U= [];
            this.W= [];
            this.V= [];
            this.H= [];
            this.Y_vec= [];
            this.norm_param=1;
        end
        function []=set_norm_param(this,norm_param)
            this.norm_param=norm_param;
        end
        function h = compute_reservoir(this,input)
            this.x=input; %#ok<*PROP>
            this.h = tanh(this.U*[input;1] +this.W*this.past_state);
            h=this.h;
        end
        function y = compute_readout(this)
            this.V;
            this.h;
            this.y=this.V*[this.h;1];
            y=this.y;
        end
        function []=init_weights(this,input_scaling,Nu,Nh,rho_desired)
            %disp("INITIALIZING...");
            this.Nu=Nu;
            this.Nh=Nh;
            Wrandom = 2*rand(Nh,Nh)-1;
            this.W = Wrandom * (rho_desired/max(abs(eig(Wrandom))));
            this.U=input_scaling*(2*rand(Nh,Nu+1)-1);
            %disp("INITIALIZATION COMPLETE!")
        end
        function []=train(this,training_set,training_set_labels)%,lambda_r
            discard=numel(training_set)/20;%tengo il 5%
            Non_discarded_inputs=[];
            Non_discarded_labels=[];
            this.past_state=zeros(this.Nh,1);
            for i=1:numel(training_set)
                current_input=training_set(i);
                
                if i> discard
                    Non_discarded_inputs(:,end+1)=[current_input;ones(this.Nh,1)]; %#ok<*AGROW>
                    Non_discarded_labels(end+1)=training_set_labels(i);
                end
                state=this.compute_reservoir(current_input);
                if i> discard
                    this.H(:,end+1)=[state;1];
                    
                end
                this.past_state=state;
            end
            %this.V=Non_discarded_labels*pinv(this.H)
            this.V = Non_discarded_labels * this.H'*inv(this.H*this.H'+this.norm_param*eye(this.Nh+1));
        end
        function prediction=predict(this,input)
            this.compute_reservoir(input);
            prediction=this.compute_readout();
        end
        function [MSE]=evaluate(this,eval_set,eval_labels)
            preds=[];
            for evaluation_input=1:numel(eval_set)
                preds(end+1)=this.predict(eval_set(evaluation_input));
            end
            MSE=immse(preds,eval_labels);
        end
        function [best_params,best_eval_mse]=grid_search(this,train_set,train_targets,eval_set,eval_set_labels,Nh,input_scaling,rho,norm_param,number_of_guesses)
            f = waitbar(0,'Searcing for best Hyperparameters');
            best_eval_mse=1000;
            toteval=numel(Nh)*numel(input_scaling)*numel(rho)*numel(norm_param);
            index=1;
            best_params=[1,1,1,1];
            for n_neur=1:numel(Nh)
                for scale=1:numel(input_scaling)
                    for cur_rho=1:numel(rho)
                        for param =1:numel(norm_param)
                            percentage=index/toteval*100;
                            waitbar(percentage/100,f,sprintf('Searcing for best Hyperparameters %3.2f %%',percentage));
                            results=zeros(number_of_guesses,1);
                            for i=1:number_of_guesses
                                this.reset();
                                this.init_weights(input_scaling(scale),1,Nh(n_neur),rho(cur_rho));
                                this.set_norm_param(norm_param(param));
                                this.train(train_set,train_targets);
                                results(i)=this.evaluate(eval_set,eval_set_labels);
                            end
                            mean_score=mean(results);
                            if best_eval_mse>mean_score
                                best_eval_mse=mean_score;
                                best_params(1)=Nh(n_neur);
                                best_params(2)=input_scaling(scale);
                                best_params(3)=rho(cur_rho);
                                best_params(4)=norm_param(param);
                            end
                            
                            index=index+1;
                        end
                    end
                end
            end
        end
    end
end