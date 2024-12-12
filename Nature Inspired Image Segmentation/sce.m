function [BestCost,x,f] = sce(img_gray, NS, itr, popl)

CostFunction=@(x,img_gray) imagethresh(x,img_gray);    % Cost Function

nVar=NS;            % Number of Decision Variables

VarSize = [1 nVar];       % Decision Variables Matrix Size

VarMin = 0;             % Decision Variables Lower Bound
VarMax = 254;             % Decision Variables Upper Bound

%% SCE-UA Parameters

MaxIt = itr;        % Maximum Number of Iterations

nPopComplex = popl;                       % Complex Size

nPopComplex = max(nPopComplex, nVar+1); % Nelder-Mead Standard

nComplex = 5;                   % Number of Complexes
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
pop(i).Cost = CostFunction(pop(i).Position,img_gray);
end

% Sort Population
pop = SortPopulation(pop);

% Update Best Solution Ever Found
BestSol = pop(1);

% Initialize Best Costs Record Array
 BestCost = nan(MaxIt, 1);

%% SCE-UA Main Loop

for it = 1:MaxIt

% Initialize Complexes Array
Complex = cell(nComplex, 1);

% Form Complexes and Run CCE
for j = 1:nComplex
% Complex Formation
Complex{j} = pop(I(j, :));

% Run CCE
Complex{j} = RunCCE(Complex{j}, cce_params, img_gray);

% Insert Updated Complex into Population
pop(I(j, :)) = Complex{j};
end

% Sort Population
pop = SortPopulation(pop);

% Update Best Solution Ever Found
BestSol = pop(1);

% Store Best Cost Ever Found
 BestCost(it) = BestSol.Cost;

% Show Iteration Information
disp(['Iteration ' num2str(it) ': Best Cost = ' num2str( BestCost(it))]);

end
f= BestCost(end);
x= BestSol.Position;
end

