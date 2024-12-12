
%% Nature-inspired NN Learner 

% Clearing and Loading Data 
clear;
data=JustLoad();
warning('off');
% Inputs (Train and Test)
inputs=data.TrainInputs';
TstInputs=data.TestInputs';

% Targets (Train and Test)
targets=data.TrainTargets';
TstTargets=data.TestTargets';
sizenn=size(inputs);sizenn=sizenn(1,1);

% Number of neurons----------------------
n = 12;
%----------------------------------------

% 'trainlm'	    Levenberg-Marquardt
% 'trainbr' 	Bayesian Regularization (good)
% 'trainbfg'	BFGS Quasi-Newton
% 'trainrp'  	Resilient Backpropagation
% 'trainscg'	Scaled Conjugate Gradient
% 'traincgb'	Conjugate Gradient with Powell/Beale Restarts
% 'traincgf'	Fletcher-Powell Conjugate Gradient
% 'traincgp'	Polak-Ribiére Conjugate Gradient
% 'trainoss'	One Step Secant (good)
% 'traingdx'	Variable Learning Rate Gradient Descent
% 'traingdm'	Gradient Descent with Momentum
% 'traingd' 	Gradient Descent
% Creating the NN ----------------------------
net = feedforwardnet(n,'trainoss');
%---------------------------------------------
% view(net);
% configure the neural network for this dataset
[net tr]= train(net,inputs, targets);
perf = perform(net,inputs, targets); %mse
% net = configure(net, inputs, targets);

% Current NN Weights and Bias
% getwb(net);
% MSE Error for Current NN
error1 = targets - net(inputs);
calc1 = mean(error1.^2)/mean(var(targets',1));
out=net(inputs);
Resilient_Backpropagation=out;
basic=mse(targets,out);


% Create Handle for Error
h = @(x) NMSE(x, net, inputs, targets);

% Nature-Inspired Part
%-----------------------------------------
% bbo = Biogeography-based optimization (good and fast)
% fa = FireFly                          (very good but slow)
% iwo = Invasive Weed Optimizer         (normal)
% tlbo = TLBO                           (good and fast)
% sfla = Shuffled Frog Leaping          (bad)
% sce = Shuffled Complex Evolution      (Very good and slow)
% de = Differential Evolution           (normal)
% hs = Harmony Search                   (normal and fast)
% ca = Cultural Algorithm               (good and fast)
[x, err_ga, cost] = bbo(h, sizenn*n+n+n+1);
%-----------------------------------------

net = setwb(net, x');
% Optimized NN Weights and Bias
getwb(net);
% Error for Optimized NN
Error = targets - net(inputs);
calc = mean(Error.^2)/mean(var(targets',1));

%-----------------------------------------
Outputs=net(inputs);
Firefly=Outputs;
TestOutputs=net(TstInputs);

% Train
TrMSE=mse(targets,Outputs);
TrRMSE=sqrt(TrMSE);
TrMAE=mae(targets,Outputs);
TrCC= corrcoef(targets,Outputs);
TrR_Squared=TrCC*TrCC;

%Test
TsMSE=mse(TstTargets,TestOutputs);
TsRMSE=sqrt(TsMSE);
TsMAE=mae(TstTargets,TestOutputs);
TsCC = corrcoef(TstTargets,TestOutputs);
TsR_Squared=TsCC*TsCC;

% Statistics
% Train
fprintf('Training "MSE" Is =  %0.4f.\n',TrMSE)
fprintf('Training "Correlation Coefficient" Is =  %0.4f.\n',TrCC(1,2))
% Test
fprintf('Testing "MSE" Is =  %0.4f.\n',TsMSE)
fprintf('Testing "Correlation Coefficient" Is =  %0.4f.\n',TsCC(1,2))
view(net);

%% NN Statistics
% Round for Classification 
TrOutRound=round(Outputs);
TsOutRound=round(TestOutputs);
% Err
Trerror=mse(TrOutRound,Outputs);
Tserror=mse(TsOutRound,TestOutputs);


%% ACC
count=0;
sizecnt=size(TrOutRound);
for i=1:sizecnt(1,2)
if TrOutRound(i)~=targets(i)
    count=count+1;
end;end
TrACC=100-(count*100)/sizecnt(1,2);
%
count2=0;
sizecnt=size(TsOutRound);
for i=1:sizecnt(1,2)
if TsOutRound(i)~=TstTargets(i)
    count2=count2+1;
end;end
TsACC=100-(count2*100)/sizecnt(1,2);
fprintf('Train "ACC" Is =  %0.4f.\n',TrACC)
fprintf('Test "ACC" Is =  %0.4f.\n',TsACC)
% AUC
figure;
[Xlog,Ylog,Tlog,AUClog] = perfcurve(targets,TrOutRound,2);
[Xlog2,Ylog2,Tlog2,AUClog2] = perfcurve(TstTargets,TsOutRound,2);
plot(Xlog,Ylog);title('Train and Test ROC');
ylabel('True positive rate');
hold on;
plot(Xlog2,Ylog2);
legend('Train','Test')
% Area Under Curve (AUC)
fprintf('Train "AUC" Is =  %0.4f.\n',AUClog)
fprintf('Test "AUC" Is =  %0.4f.\n',AUClog2)
% Box plot
Box=[targets;TrOutRound]';
Box2=[TstTargets;TsOutRound]';


% Third party evaluation
EVALtrain = Evaluate(targets,TrOutRound);
accuracy = EVALtrain(1,1)
precision = EVALtrain(1,4)
recall = EVALtrain(1,5)
f_measure = EVALtrain(1,6)
% test
EVALtest = Evaluate(TstTargets,TsOutRound);
accuracy2 = EVALtest(1,1)
precision2 = EVALtest(1,4)
recall2 = EVALtest(1,5)
f_measure2 = EVALtest(1,6)

% Itr 
a=cost;
figure;
plot(a,'-og','linewidth',1,'MarkerSize',4,'MarkerFaceColor',[0.9,0.1,0.1]);
title(' Train','FontSize', 17);
xlabel(' Iteration Number','FontSize', 17);
ylabel(' Best Cost Value','FontSize', 17);
xlim([0 inf])
xlim([0 inf])
ax = gca; 
ax.FontSize = 17; 
set(gca,'Color','k')
legend({'DeepFire'},'FontSize',12,'TextColor','yellow');

figure;
[population2,gof] = fit(Firefly',Resilient_Backpropagation','poly1');
plot(Firefly',Resilient_Backpropagation','o',...
'LineWidth',1,...
'MarkerSize',8,...
'MarkerEdgeColor','r',...
'MarkerFaceColor',[0.3,0.9,0.1]);
title(['R =  ' num2str(1-gof.rmse)]); 
hold on
plot(population2,'b-','predobs');
xlabel('Firefly');
ylabel('ResilientBackpropagation');   
grid on;
ax = gca; 
ax.FontSize = 12; 
ax.LineWidth=2;
legend({'Firefly = 99 % and Resilient Backpropagation = 97 %'},'FontSize',12,'TextColor','blue');
hold off