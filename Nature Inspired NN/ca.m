function [x,err]=ca(CostFunction,nVar)

VarSize = [1 nVar];   % Decision Variables Matrix Size

VarMin = -10;         % Decision Variables Lower Bound
VarMax = 10;         % Decision Variables Upper Bound

%% Cultural Algorithm Settings

MaxIt = 100;         % Maximum Number of Iterations

nPop = 10;            % Population Size

pAccept = 0.35;                   % Acceptance Ratio
nAccept = round(pAccept*nPop);    % Number of Accepted Individuals

alpha = 0.3;

beta = 0.5;

%% Initialization

% Initialize Culture
Culture.Situational.Cost = inf;
Culture.Normative.Min = inf(VarSize);
Culture.Normative.Max = -inf(VarSize);
Culture.Normative.L = inf(VarSize);
Culture.Normative.U = inf(VarSize);

% Empty Individual Structure
empty_individual.Position = [];
empty_individual.Cost = [];

% Initialize Population Array
pop = repmat(empty_individual, nPop, 1);

% Generate Initial Solutions
for i = 1:nPop
pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
pop(i).Cost = CostFunction(pop(i).Position);
end

% Sort Population
[~, SortOrder] = sort([pop.Cost]);
pop = pop(SortOrder);

% Adjust Culture using Selected Population
spop = pop(1:nAccept);
Culture = AdjustCulture(Culture, spop);

% Update Best Solution Ever Found
BestSol = Culture.Situational;

% Array to Hold Best Costs
BestCost = zeros(MaxIt, 1);

%% Cultural Algorithm Main Loop

for it = 1:MaxIt

% Influnce of Culture
for i = 1:nPop


for j = 1:nVar
sigma = alpha*Culture.Normative.Size(j);
dx = sigma*randn;
if pop(i).Position(j)<Culture.Situational.Position(j)
dx = abs(dx);
elseif pop(i).Position(j)>Culture.Situational.Position(j)
dx = -abs(dx);
end
pop(i).Position(j) = pop(i).Position(j)+dx;
end        

pop(i).Cost = CostFunction(pop(i).Position);

end

% Sort Population
[~, SortOrder] = sort([pop.Cost]);
pop = pop(SortOrder);

% Adjust Culture using Selected Population
spop = pop(1:nAccept);
Culture = AdjustCulture(Culture, spop);

% Update Best Solution Ever Found
BestSol = Culture.Situational;

% Store Best Cost Ever Found
BestCost(it) = BestSol.Cost;

% Show Iteration Information
disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);

end
x=BestSol.Position';
err=BestSol.Cost;
%% Results

figure;
%plot(BestCost, 'LineWidth', 2);
semilogy(BestCost, 'LineWidth', 2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;

