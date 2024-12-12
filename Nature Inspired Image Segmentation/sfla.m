function [BestCost,x,f] = sfla(img_gray, NS, itr, popl)

CostFunction=@(x,img_gray) imagethresh(x,img_gray);    % Cost Function

nVar=NS;            % Number of Decision Variables

VarSize = [1 nVar];       % Decision Variables Matrix Size

VarMin = 0;             % Decision Variables Lower Bound
VarMax = 254;             % Decision Variables Upper Bound



%% SFLA Parameters

MaxIt = itr;        % Maximum Number of Iterations

nPopMemeplex = popl;                          % Memeplex Size

nPopMemeplex = max(nPopMemeplex, nVar+1);   % Nelder-Mead Standard

nMemeplex = 5;                  % Number of Memeplexes
nPop = nMemeplex*nPopMemeplex;	% Population Size

I = reshape(1:nPop, nMemeplex, []);

% FLA Parameters
fla_params.q = max(round(0.3*nPopMemeplex), 2);   % Number of Parents
fla_params.alpha = 3;   % Number of Offsprings
fla_params.beta = 5;    % Maximum Number of Iterations
fla_params.sigma = 2;   % Step Size
fla_params.CostFunction = CostFunction;
fla_params.VarMin = VarMin;
fla_params.VarMax = VarMax;

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

%% SFLA Main Loop

for it = 1:MaxIt

fla_params.BestSol = BestSol;

% Initialize Memeplexes Array
Memeplex = cell(nMemeplex, 1);

% Form Memeplexes and Run FLA
for j = 1:nMemeplex
% Memeplex Formation
Memeplex{j} = pop(I(j, :));

% Run FLA
Memeplex{j} = RunFLA(Memeplex{j}, fla_params,img_gray);

% Insert Updated Memeplex into Population
pop(I(j, :)) = Memeplex{j};
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
