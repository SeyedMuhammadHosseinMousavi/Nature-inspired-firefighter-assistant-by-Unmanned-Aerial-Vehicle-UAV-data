function [x,err]=tlbo(CostFunction,nVar)

VarSize = [1 nVar]; % Unknown Variables Matrix Size

VarMin = -5;       % Unknown Variables Lower Bound
VarMax =  5;       % Unknown Variables Upper Bound

%% TLBO Parameters

MaxIt = 200;        % Maximum Number of Iterations

nPop = 15;           % Population Size

%% Initialization 

% Empty Structure for Individuals
empty_individual.Position = [];
empty_individual.Cost = [];

% Initialize Population Array
pop = repmat(empty_individual, nPop, 1);

% Initialize Best Solution
BestSol.Cost = inf;

% Initialize Population Members
for i=1:nPop
pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
pop(i).Cost = CostFunction(pop(i).Position);

if pop(i).Cost < BestSol.Cost
BestSol = pop(i);
end
end

% Initialize Best Cost Record
BestCosts = zeros(MaxIt,1);

%% TLBO Main Loop

for it=1:MaxIt

% Calculate Population Mean
Mean = 0;
for i=1:nPop
Mean = Mean + pop(i).Position;
end
Mean = Mean/nPop;

% Select Teacher
Teacher = pop(1);
for i=2:nPop
if pop(i).Cost < Teacher.Cost
Teacher = pop(i);
end
end

% Teacher Phase
for i=1:nPop
% Create Empty Solution
newsol = empty_individual;

% Teaching Factor
TF = randi([1 2]);

% Teaching (moving towards teacher)
newsol.Position = pop(i).Position ...
+ rand(VarSize).*(Teacher.Position - TF*Mean);

% Clipping
newsol.Position = max(newsol.Position, VarMin);
newsol.Position = min(newsol.Position, VarMax);

% Evaluation
newsol.Cost = CostFunction(newsol.Position);

% Comparision
if newsol.Cost<pop(i).Cost
pop(i) = newsol;
if pop(i).Cost < BestSol.Cost
BestSol = pop(i);
end
end
end

% Learner Phase
for i=1:nPop

A = 1:nPop;
A(i)=[];
j = A(randi(nPop-1));

Step = pop(i).Position - pop(j).Position;
if pop(j).Cost < pop(i).Cost
Step = -Step;
end

% Create Empty Solution
newsol = empty_individual;

% Teaching (moving towards teacher)
newsol.Position = pop(i).Position + rand(VarSize).*Step;

% Clipping
newsol.Position = max(newsol.Position, VarMin);
newsol.Position = min(newsol.Position, VarMax);

% Evaluation
newsol.Cost = CostFunction(newsol.Position);

% Comparision
if newsol.Cost<pop(i).Cost
pop(i) = newsol;
if pop(i).Cost < BestSol.Cost
BestSol = pop(i);
end
end
end

% Store Record for Current Iteration
BestCosts(it) = BestSol.Cost;

% Show Iteration Information
disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCosts(it))]);

end

x=BestSol.Position';
err=BestSol.Cost;
%% Results

figure;
%plot(BestCosts, 'LineWidth', 2);
semilogy(BestCosts, 'LineWidth', 2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;
