
modelName = "BEV_system_model";

% Load the model file.
load_system(modelName)

% Set referenced subsystems and load parameters.
BEV_useComponents_Basic

% set Env
observationDim = [4 1];
observationInfo = rlNumericSpec(observationDim);

actionDim = [1 1];
actionInfo = rlNumericSpec( ...
    actionDim, ...
    'LowerLimit', -400, ...
    'UpperLimit', 400 ...
);

env = rlSimulinkEnv( ...
    'BEV_system_model_ANN_test', ...
    'BEV_system_model_ANN_test/Controller & Environment/BEV Controller/Speed Controller/Agent', ...
    observationInfo, actionInfo ...
);

% actor
actnet = [
    featureInputLayer(4, 'Name', 'obs')
    fullyConnectedLayer(64, 'Name', 'hidden1')
    reluLayer('Name', 'relu1')
    fullyConnectedLayer(64, 'Name', 'hidden2')
    reluLayer('Name', 'relu2')
    fullyConnectedLayer(64, 'Name', 'hidden3')
    reluLayer('Name', 'relu3')
    fullyConnectedLayer(1, 'Name', 'act')
];

actor = rlDeterministicActorRepresentation( ...
    actnet, ...
    observationInfo, ...
    actionInfo, ...
    "Observation",'obs','Action', 'act' ...
);

% critic
obsPath = [
    featureInputLayer(4, 'Name','obs')
    fullyConnectedLayer(64, 'Name', 'hidden1')
    reluLayer('Name', 'relu1')
    fullyConnectedLayer(64, 'Name', 'hidden2')
    reluLayer('Name', 'relu2')
    additionLayer(2, 'Name', 'add')
    reluLayer('Name', 'relu3')
    fullyConnectedLayer(64, 'Name', 'hidden3')
    reluLayer('Name', 'relu4')
    fullyConnectedLayer(1, 'Name', 'value')
];

actPath = [
    featureInputLayer(1, 'Normalization','none', 'Name','act')
    fullyConnectedLayer(64, 'Name', 'fcact')
];

qvalnet = layerGraph(obsPath);
qvalnet = addLayers(qvalnet, actPath);
qvalnet = connectLayers(qvalnet, 'fcact', 'add/in2');

critic = rlQValueRepresentation( ...
    qvalnet, observationInfo, actionInfo, ...
    'Observation', 'obs', 'Action', 'act' ...
);

% agent
agent = rlDDPGAgent(actor, critic);




