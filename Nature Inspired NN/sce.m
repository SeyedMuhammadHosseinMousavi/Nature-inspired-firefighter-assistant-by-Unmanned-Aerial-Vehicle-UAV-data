function [x,err]=sce(CostFunction,nVar)

VarSize = [1 nVar];     % Unknown Variables Matrix Size

VarMin = -10;           % Lower Bound of Unknown Variables
VarMax = 10;           % Upper Bound of Unknown Variables


%% SCE-UA Parameters

MaxIt = 50;        % Maximum Number of Iterations

nPopComplex = 3;                       % Complex Size
nPopComplex = max(nPopComplex, nVar+1); % Nelder-Mead Standard

nComplex = 3;                   % Number of Complexes
nPop = nComplex*nPopComplex;    % Population Size

I = reshape(1:nPop, nComplex, []);

% CCE Parameters
cce_params.q = max(round(0.5*nPopComplex), 2);   % Number of Parents
cce_params.alpha = 3;   % Number of Offsprings
cce_params.beta = 5;    % Maximum Number of Iterations
cce_params.CostFunction = CostFunction;
cce_params.VarMin = VarMin;
cce_params.VarMax = VarMax;

%% Initialization

% Empty Individual Template
empty_individual.Position = [];
empty_individual.Cost = [];

% Initialize Population Array
pop = repmat(empty_individual, nPop, 1);

% Initialize Population Members
for i = 1:nPop
pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
pop(i).Cost = CostFunction(pop(i).Position);
end

% Sort Population
pop = SortPopulation(pop);

% Update Best Solution Ever Found
BestSol = pop(1);

% Initialize Best Costs Record Array
BestCosts = nan(MaxIt, 1);

%% SCE-UA Main Loop

for it = 1:MaxIt

% Initialize Complexes Array
Complex = cell(nComplex, 1);

% Form Complexes and Run CCE
for j = 1:nComplex
% Complex Formation
Complex{j} = pop(I(j, :));

% Run CCE
Complex{j} = RunCCE(Complex{j}, cce_params);

% Insert Updated Complex into Population
pop(I(j, :)) = Complex{j};
end

% Sort Population
pop = SortPopulation(pop);

% Update Best Solution Ever Found
BestSol = pop(1);

% Store Best Cost Ever Found
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
