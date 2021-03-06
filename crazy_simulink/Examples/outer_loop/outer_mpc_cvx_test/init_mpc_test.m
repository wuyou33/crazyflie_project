%% Adds cvx_helpfunctions to path
addpath(genpath('.'));

%% Set up basic model
Ad = diag(A);
a1 = 4.8; a2 = 8.32; b = 8.32;
a1 = KetaD(1); a2 = KetaP(1); b = KetaP(1);

T0 = m*g;

Am1 = [zeros(10,3)];
Am2 = [eye(3); -Ad/m; zeros(4,3)];
Am3 = [zeros(3,2); T0/m 0; 0 -T0/m; zeros(3,2); -a2*eye(2)];
Am4 = [zeros(6,2); eye(2); -a1*eye(2)];
Am = [Am1 Am2 Am3 Am4];

Bm = zeros(10, 3);
Bm(9, 1) = b;
Bm(10, 2) = b;
Bm(6, 3) = 1/m;

Cm = zeros(5, 10);
Cm(1:3, 1:3) = eye(3);
Cm(4:5, 7:8) = eye(2);

Dm = zeros(5, 3);

%% Discretize
Ts = 0.1; % sample time

[Ad, Bd, Cyd, Dzd]=ssdata(c2d(ss(Am,Bm,Cm,Dm),Ts));

disp('Generate CVXGEN data struct...')
% Must be specified to run the solver eg using
% 
%   [vars, status] = csolve(CVXparameters, settings)
%

% Dynamics and initial conditions
CVXparameters.A = Ad;
CVXparameters.B = Bd;
CVXparameters.u_0 = [0;0;0];
CVXparameters.x_0 = [0;0;0;0;0;0;0;0;0;0];

% Design parameters
CVXparameters.Q = diag([2, 2, 2, 1, 1, 1,1,1,1,1,]);
CVXparameters.R = diag([2, 2, 0.1]);
CVXparameters.S_max = 1000;
CVXparameters.u_max = [0.6;0.6;5];
CVXparameters.predictionHorizon = 10;

% Must be specified to make the S-fucntion run
CVXparameters.nDiscreteStates = 10;
CVXparameters.nOutputs = 3;
CVXparameters.nInputs = CVXparameters.nDiscreteStates*(CVXparameters.predictionHorizon+2);
CVXparameters.h = Ts; % Stepsize

% Settings for the CVXsolver and debugging 
CVXparameters.verbose = 1;
CVXparameters.max_iters = 20;
CVXparameters.plot = 1;

disp('...complete!')