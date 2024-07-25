global nbus ph ch;

%Parameters definition
Ts = 80e-3;
simTs = 1e-6;
ph = 6; ch = 4; nbus = 4;
nx = 4+2*nbus+1; ny = 1; nu = 1;

% Model Definition
dmpcobj = nlmpc(nx,ny,nu);
dmpcobj.Ts = Ts;
dmpcobj.PredictionHorizon = ph;
dmpcobj.ControlHorizon = ch;
dmpcobj.Model.StateFcn = "statefn";
dmpcobj.Model.IsContinuousTime = false;
%dmpcobj.Model.NumberOfParameters = (ph+1)*(nbus-1)+1;
dmpcobj.Model.NumberOfParameters = 1;
dmpcobj.Model.OutputFcn = "outfn";


dmpcobj.OV = struct('Min',0.92,'Max',1.01);
dmpcobj.MV = struct('Min',-0.5,'Max',0.5);

dmpcobj.Weights.OutputVariables = 7;
dmpcobj.Weights.ManipulatedVariablesRate = 1;

%Model Validation
x0 = [-320;0;-300;0;0.02;0;0.021;0.022;1;0.95;0.96;0.92;2];
u0 = 0;
p0 = zeros((ph+2)*(nbus-1),1);
p0 = [p0;2]; 
p0 = {p0};
ref = 1;
validateFcns(dmpcobj,x0,u0,[],p0)

%Model test
nloptions = nlmpcmoveopt;
nloptions.Parameters = p0;
[~,~,info] = nlmpcmove(dmpcobj,x0,u0,ref,[],nloptions);

if exist('paramBus','var') == 0
    createParameterBus(dmpcobj,['dmpc' '/EV1/MPC/Nonlinear MPC Controller'],'paramBus',p0);
end
