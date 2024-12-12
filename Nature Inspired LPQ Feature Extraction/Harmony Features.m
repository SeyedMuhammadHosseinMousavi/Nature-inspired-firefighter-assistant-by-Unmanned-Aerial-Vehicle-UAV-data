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
nf=128;

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


%% Harmony Search Parameters

MaxIt = 10;     % Maximum Number of Iterations
HMS = 2;         % Harmony Memory Size
nNew = 2;        % Number of New Harmonies
HMCR = 0.9;       % Harmony Memory Consideration Rate
PAR = 0.1;        % Pitch Adjustment Rate
FW = 0.02*(VarMax-VarMin);    % Fret Width (Bandwidth)
FW_damp = 0.995;              % Fret Width Damp Ratio

%% Initialization

% Empty Harmony Structure
empty_harmony.Position = [];
empty_harmony.Cost = [];
empty_harmony.Out = [];

% Initialize Harmony Memory
HM = repmat(empty_harmony, HMS, 1);

% Create Initial Harmonies
for i = 1:HMS
HM(i).Position = unifrnd(VarMin, VarMax, VarSize);
[HM(i).Cost HM(i).Out] = CostFunction(HM(i).Position);
end
% Sort Harmony Memory
[~, SortOrder] = sort([HM.Cost]);
HM = HM(SortOrder);
% Update Best Solution Ever Found
BestSol = HM(1);
% Array to Hold Best Cost Values
BestCost = zeros(MaxIt, 1);

%% Harmony Search Main Loop
for it = 1:MaxIt
% Initialize Array for New Harmonies
NEW = repmat(empty_harmony, nNew, 1);
% Create New Harmonies
for k = 1:nNew
% Create New Harmony Position
NEW(k).Position = unifrnd(VarMin, VarMax, VarSize);
for j = 1:nVar
if rand <= HMCR
% Use Harmony Memory
i = randi([1 HMS]);
NEW(k).Position(j) = HM(i).Position(j);
end
% Pitch Adjustment
if rand <= PAR
%DELTA = FW*unifrnd(-1, +1);    % Uniform
DELTA = FW*randn();            % Gaussian (Normal) 
NEW(k).Position(j) = NEW(k).Position(j)+DELTA;
end
end
% Apply Variable Limits
NEW(k).Position = max(NEW(k).Position, VarMin);
NEW(k).Position = min(NEW(k).Position, VarMax);

% Evaluation
[NEW(k).Cost NEW(k).Out] = CostFunction(NEW(k).Position);
end
% Merge Harmony Memory and New Harmonies
HM = [HM
NEW]; %#ok
% Sort Harmony Memory
[~, SortOrder] = sort([HM.Cost]);
HM = HM(SortOrder);
% Truncate Extra Harmonies
HM = HM(1:HMS);
% Update Best Solution Ever Found
BestSol = HM(1);
% Store Best Cost Ever Found
BestCost(it) = BestSol.Cost;
% Show Iteration Information
disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
% Damp Fret Width
FW = FW*FW_damp;

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
