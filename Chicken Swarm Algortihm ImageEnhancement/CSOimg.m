% -------------------------------------------------------------------------
% This is a simple demo version only implemented the basic idea of CSO for        
% solving the unconstrained problem, namely Sphere function.    
% The details about CSO are illustratred in the following paper.                                                
% Xian-Bing Meng, et al. A new bio-inspired algorithm: Chicken Swarm 
%    Optimization. The Fifth International Conference on Swarm Intelligence 
%
% The parameters in CSO are presented as follows.
% FitFunc    % The objective function
% M          % Maxmimal generations (iterations)
% pop        % Population size
% dim        % Dimension
% G          % How often the chicken swarm can be updated.
% rPercent   % The population size of roosters accounts for "rPercent" 
%   percent of the total population size
% hPercent   % The population size of hens accounts for "hPercent" percent 
%  of the total population size
% mPercent   % The population size of mother hens accounts for "mPercent" 
%  percent of the population size of hens
%
% Using the default value,CSO can be executed using the following code.
% [ bestX, fMin ] = CSO

% Main programs

function [ bestX, fMin ]= CSOimg( M,pop,dim, G,rPercent,hPercent,mPercent,hi,lamda,gamma,dh,sm )
%                               (500,100,256,10,0.15,   0.7,     0.5,     hir,lamda,gamma,D,xr);

% Display help
help CSOimg.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set the default parameters
if nargin < 1
%FitFunc = @Sphere;
%FitFunc = @Fun(u);
M = 50;  
pop = 20;  
dim = 256;  
G = 5;       
rPercent = 0.15; 
hPercent = 0.7;  
mPercent = 0.5;                  
end

rNum = round( pop * rPercent );    % The population size of roosters
hNum = round( pop * hPercent );    % The population size of hens
cNum = pop - rNum - hNum;          % The population size of chicks
mNum = round( hNum * mPercent );   % The population size of mother hens

lb= zeros( 1,dim );   % Lower bounds
ub= 255.*ones( 1,dim );    % Upper bounds

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initialization
for i = 1 : pop
x( i, : ) = lb + (ub - lb) .* rand( 1, dim ); 
fit( i ) = FitFunc( x( i, : ),hi,lamda,gamma,dh,sm ); 
end
pFit = fit; % The individual's best fitness value
pX = x;     % The individual's best position corresponding to the pFit

[ fMin, bestIndex ] = min( fit );        % fMin denotes the global optimum
% bestX denotes the position corresponding to fMin
bestX = x( bestIndex, : );   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Start the iteration.

for t = 1 : M

% This parameter is to describe how closely the chicks would follow 
% their mother to forage for food. In fact, there exist cNum chicks, 
% thus only cNum values of FL would be used. 
FL = rand( pop, 1 ) .* 0.4 + 0.5;  

% The chicken swarm'status about hierarchal order, dominance  
% relationship, mother-child relationship, the roosters, hens and the 
% chicks in a group will remain stable during a period of time. These  
% statuses can be updated every several (G) time steps.The parameter G 
% is used to simulate the situation that the chicken swarm have been  
% changed, including some chickens have died, or the chicks have grown 
% up and became roosters or hens, some mother hens have hatched new
% offspring (chicks) and so on.

if mod( t, G ) == 1 || t == 1   

[ ans, sortIndex ] = sort( pFit );   
% How the chicken swarm can be divided into groups and the identity
% of the chickens (roosters, hens and chicks) can be determined all 
% depend on the fitness values of the chickens themselves. Hence we 
% use sortIndex(i) to describe the chicken, not the index i itself.

motherLib = randperm( hNum, mNum ) + rNum;   
% Randomly select mNum hens which would be the mother hens.
% We assume that all roosters are stronger than the hens, likewise, 
% hens are stronger than the chicks.In CSO, the strong is reflected
% by the good fitness value. Here, the optimization problems is 
% minimal ones, thus the more strong ones correspond to the ones  
% with lower fitness values.

% Given the fact the 1 : rNum chickens' fitness values maybe not
% the best rNum ones. Thus we use sortIndex( 1 : rNum ) to describe
% the roosters. In turn, sortIndex( (rNum + 1) :(rNum + 1 + hNum ))
% to describle the mother hens, .....chicks.

% Here motherLib include all the mother hens. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Randomly select each hen's mate, rooster. Hence we can determine
% which group each hen inhabits using "mate".Each rooster stands
% for a group.For simplicity, we assume that there exist only one
% rooster and at least one hen in each group.
mate = randpermF( rNum, hNum );

% Randomly select cNum chicks' mother hens
mother = motherLib( randi( mNum, cNum, 1 ) );  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
for i = 1 : rNum                % Update the rNum roosters' values.

% randomly select another rooster different from the i (th) one.
anotherRooster = randiTabu( 1, rNum, i, 1 );  
if( pFit( sortIndex( i ) ) <= pFit( sortIndex( anotherRooster ) ) )
tempSigma = 1;
else
tempSigma = exp( ( pFit( sortIndex( anotherRooster ) ) - ...
pFit( sortIndex( i ) ) ) / ( abs( pFit( sortIndex(i) ) )...
+ realmin ) );
end

x( sortIndex( i ), : ) = pX( sortIndex( i ), : ) .* ( 1 + ...
tempSigma .* randn( 1, dim ) );
x( sortIndex( i ), : ) = Bounds( x( sortIndex( i ), : ), lb, ub );
fit( sortIndex( i ) ) = FitFunc( x( sortIndex( i ), : ),hi,lamda,gamma,dh,sm );
end

for i = ( rNum + 1 ) : ( rNum + hNum )  % Update the hNum hens' values.

other = randiTabu( 1,  i,  mate( i - rNum ), 1 );  
% randomly select another chicken different from the i (th)  
% chicken's mate. Note that the "other" chicken's fitness value  
% should be superior to that of the i (th) chicken. This means the   
% i (th) chicken may steal the better food found by the "other" 
% (th) chicken.

c1 = exp( ( pFit( sortIndex( i ) ) - pFit( sortIndex( mate( i - ...
rNum ) ) ) )/ ( abs( pFit( sortIndex(i) ) ) + realmin ) );

c2 = exp( ( -pFit( sortIndex( i ) ) + pFit( sortIndex( other ) )));

x( sortIndex( i ), : ) = pX( sortIndex( i ), : ) + ( pX(...
sortIndex( mate( i - rNum ) ), : )- pX( sortIndex( i ), : ) )...
.* c1 .* rand( 1, dim ) + ( pX( sortIndex( other ), : ) - ...
pX( sortIndex( i ), : ) ) .* c2 .* rand( 1, dim ); 
x( sortIndex( i ), : ) = Bounds( x( sortIndex( i ), : ), lb, ub );
fit( sortIndex( i ) ) = FitFunc( x( sortIndex( i ), : ),hi,lamda,gamma,dh,sm );
end
%added every thing from 0.4 to modify the original eq according to wu et al (2015)
% Improved Chicken Swarm Optimization from line 170
for i = ( rNum + hNum + 1 ) : pop    % Update the cNum chicks' values.
x( sortIndex( i ), : ) = pX( sortIndex( i ), : ) + ( pX( ...
sortIndex( mother( i - rNum - hNum ) ), : ) - ...
pX( sortIndex( i ), : ) ) .* FL( i );
x( sortIndex( i ), : ) = Bounds( x( sortIndex( i ), : ), lb, ub );
fit( sortIndex( i ) ) = FitFunc( x( sortIndex( i ), : ),hi,lamda,gamma,dh,sm );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Update the individual's best fitness vlaue and the global best one

for i = 1 : pop 
if ( fit( i ) < pFit( i ) )
pFit( i ) = fit( i );
pX( i, : ) = x( i, : );
end

if( pFit( i ) < fMin )
fMin = pFit( i );
bestX = pX( i, : );
end
end
end
% End of the main program

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The following functions are associated with the main program
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is the objective function

%function y = Sphere( x )
%y = sum( x .^ 2 );


function z = FitFunc(u,hi,lamda,gamma,dh,sm)
dh = dh*transpose(u);
dh = sum(dh);
s1 = sum((transpose(u)-hi).^2);
s2 = sum((transpose(u)-sm).^2);
s3 = sum(dh.^2);
z = s1 + lamda*s2 + gamma*s3;






% Application of simple limits/bounds
function s = Bounds( s, Lb, Ub)
% Apply the lower bound vector
temp = s;
I = temp < Lb;
temp(I) = Lb(I);

% Apply the upper bound vector 
J = temp > Ub;
temp(J) = Ub(J);
% Update this new move 
s = temp;

%--------------------------------------------------------------------------
% This function generate "dim" values, all of which are different from
%  the value of "tabu"
function value = randiTabu( min, max, tabu, dim )
value = ones( dim, 1 ) .* max .* 2;
num = 1;
while ( num <= dim )
temp = randi( [min, max], 1, 1 );
if( length( find( value ~= temp ) ) == dim && temp ~= tabu )
value( num ) = temp;
num = num + 1;
end
end

%--------------------------------------------------------------------------
function result = randpermF( range, dim )
% The original function "randperm" in Matlab is only confined to the
% situation that dimension is no bigger than dim. This function is 
% applied to solve that situation.

temp = randperm( range, range );
temp2 = randi( range, dim, 1 );
index = randperm( dim, ( dim - range ) );
result = [ temp, temp2( index )' ];
