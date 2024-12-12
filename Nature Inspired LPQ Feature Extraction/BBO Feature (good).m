%% Bio + LPQ Image Feature Selection

%% Making Things Ready !!!
clc;
clear; 
warning('off');

%% LPQ Feature Extraction
% Read input images
path='ds';
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

winsize=19;

for i = 1 : filesnumber(1,1)
LPQ_tmp{i}=lpq(resized2{i},winsize);
disp(['Extract LPQ :   ' num2str(i) ]);end;
for i = 1 : filesnumber(1,1)
LPQ_Features(i,:)=LPQ_tmp{i};end;



LPQ_Features=load('ggg.mat');
LPQ_Features=LPQ_Features.d;

%% Labeling for Classification
sizefinal=size(LPQ_Features);
sizefinal=sizefinal(1,2);
%
LPQ_Features(1:300,sizefinal+1)=1;
LPQ_Features(301:600,sizefinal+1)=2;




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
nf=500;

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

%% BBO Parameters
MaxIt = 20;          % Maximum Number of Iterations
nPop = 3;            % Number of Habitats (Population Size)
KeepRate = 0.2;                   % Keep Rate
nKeep = round(KeepRate*nPop);     % Number of Kept Habitats
nNew = nPop-nKeep;                % Number of New Habitats
% Migration Rates
mu = linspace(1, 0, nPop);          % Emmigration Rates
lambda = 1-mu;                    % Immigration Rates
alpha = 0.9;
pMutation = 0.1;
sigma = 0.02*(VarMax-VarMin);

%% Initialization
% Empty Habitat
habitat.Position = [];
habitat.Cost = [];
habitat.Out = [];
% Create Habitats Array
pop = repmat(habitat, nPop, 1);
% Initialize Habitats
for i = 1:nPop
pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
[pop(i).Cost pop(i).Out] = CostFunction(pop(i).Position);
end
% Sort Population
[~, SortOrder] = sort([pop.Cost]);
pop = pop(SortOrder);
% Best Solution Ever Found
BestSol = pop(1);
% Array to Hold Best Costs
BestCost = zeros(MaxIt, 1);

%% BBO Main Loop
for it = 1:MaxIt
newpop = pop;
for i = 1:nPop
for k = 1:nVar
% Migration
if rand <= lambda(i)
% Emmigration Probabilities
EP = mu;
EP(i) = 0;
EP = EP/sum(EP);
% Select Source Habitat
j = RouletteWheelSelection(EP);
% Migration
newpop(i).Position(k) = pop(i).Position(k) ...
+alpha*(pop(j).Position(k)-pop(i).Position(k));
end
% Mutation
if rand <= pMutation
newpop(i).Position(k) = newpop(i).Position(k)+sigma*randn;
end
end
% Apply Lower and Upper Bound Limits
newpop(i).Position = max(newpop(i).Position, VarMin);
newpop(i).Position = min(newpop(i).Position, VarMax);
% Evaluation
[newpop(i).Cost newpop(i).Out]= CostFunction(newpop(i).Position);
end
% Sort New Population
[~, SortOrder] = sort([newpop.Cost]);
newpop = newpop(SortOrder);
% Select Next Iteration Population
pop = [pop(1:nKeep)
newpop(1:nNew)];
% Sort Population
[~, SortOrder] = sort([pop.Cost]);
pop = pop(SortOrder);
% Update Best Solution Ever Found
BestSol = pop(1);
% Store Best Cost Ever Found
BestCost(it) = BestSol.Cost;
% Show Iteration Information
disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
end



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
%
% a=BestCost;
% figure;
% plot(a,'-og','linewidth',1,'MarkerSize',7,'MarkerFaceColor',[0.9,0.1,0.1]);
% title(' Train','FontSize', 17);
% xlabel(' Iteration Number','FontSize', 17);
% ylabel(' Best Cost Value','FontSize', 17);
% xlim([0 inf])
% xlim([0 inf])
% ax = gca; 
% ax.FontSize = 17; 
% set(gca,'Color','k')
% legend({'DeepFire'},'FontSize',12,'TextColor','yellow');
% 
% 
% % Feature Box Plot
% figure;
% boxplot(Bio_Features)
% FinalFeaturesInd
