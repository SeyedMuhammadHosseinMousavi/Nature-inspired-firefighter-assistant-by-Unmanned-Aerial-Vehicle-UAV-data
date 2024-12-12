%% Bio + LPQ Image Feature Selection

%% Making Things Ready !!!
clc;
clear; 
warning('off');

%% LPQ Feature Extraction
% Read input images
path='Dat';
fileinfo = dir(fullfile(path,'*.jpg'));
filesnumber=size(fileinfo);
for i = 1 : filesnumber(1,1)
images{i} = imread(fullfile(path,fileinfo(i).name));
disp(['Loading image No :   ' num2str(i) ]);
end;
% Color to Gray Conversion
for i = 1 : filesnumber(1,1)
images{i}=rgb2gray(images{i});
disp(['To Gray :   ' num2str(i) ]);end;
% Contrast Adjustment
for i = 1 : filesnumber(1,1)
adjusted2{i}=imadjust(images{i});
disp(['Contrast Adjust :   ' num2str(i) ]);end;
% Resize Image
for i = 1 : filesnumber(1,1)
resized2{i}=imresize(adjusted2{i}, [256 256]);
disp(['Image Resized :   ' num2str(i) ]);end;

%% LPQ Features
clear LPQ_tmp;clear LPQ_Features;

winsize=9;

for i = 1 : filesnumber(1,1)
LPQ_tmp{i}=lpq(resized2{i},winsize);
disp(['Extract LPQ :   ' num2str(i) ]);end;
for i = 1 : filesnumber(1,1)
LPQ_Features(i,:)=LPQ_tmp{i};end;

%% Labeling for Classification
sizefinal=size(LPQ_Features);
sizefinal=sizefinal(1,2);
%
LPQ_Features(1:10,sizefinal+1)=1;
LPQ_Features(11:20,sizefinal+1)=2;
LPQ_Features(21:30,sizefinal+1)=3;
LPQ_Features(31:40,sizefinal+1)=4;
LPQ_Features(41:50,sizefinal+1)=5;

%% Feature Selection
% Data Preparation
x=LPQ_Features(:,1:end-1)';
t=LPQ_Features(:,end)';
data.x=x;
data.t=t;
data.nx=size(x,1);
data.nt=size(t,1);
data.nSample=size(x,2);

%% Number of Desired Features
nf=64;

%% Cost Function
CostFunction=@(u) FeatureSelectionCost(u,nf,data);
% Number of Decision Variables
nVar=data.nx;
% Size of Decision Variables Matrix
VarSize=[1 nVar];
% Lower Bound of Variables
VarMin=0;
% Upper Bound of Variables
VarMax=1;


%% Cultural Algorithm Settings

MaxIt = 10;         % Maximum Number of Iterations
nPop = 2;            % Population Size
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
empty_individual.Out = [];
% Initialize Population Array
pop = repmat(empty_individual, nPop, 1);
% Generate Initial Solutions
for i = 1:nPop
pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
[pop(i).Cost pop(i).Out] = CostFunction(pop(i).Position);
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
% % 3rd Method (using Normative and Situational components)
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
[pop(i).Cost pop(i).Out] = CostFunction(pop(i).Position);
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

% Plot ---------------------------------------------- 
plot(BestCost, '--k','linewidth',2);
xlabel('Iteration');
ylabel('Bees Cost');

%---------------------------------------------------
%% Creating Features Matrix
% Extracting Data
RealData=data.x';
% Extracting Labels
RealLbl=data.t';
FinalFeaturesInd=BestSol.Out.S;
% Sort Features
FFI=sort(FinalFeaturesInd);
% Select Final Features
Bio_Features=RealData(:,FFI);
% Adding Labels
Bio_Features_Lbl=Bio_Features;
Bio_Features_Lbl(:,end+1)=RealLbl;
LPQ_Bio=Bio_Features_Lbl;
