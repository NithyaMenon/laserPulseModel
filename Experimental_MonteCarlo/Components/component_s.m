function component_s(block)
% S-Function for generic component

  setup(block);
  
%endfunction

function setup(block)
 

  block.NumDialogPrms  = 2; % Component Type, ParamsObject


  %% Register number of input and output ports
  block.NumInputPorts  = 2;
  block.NumOutputPorts = 2;

  %% Setup functional port properties to dynamically
  %% inherited.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
 
  block.InputPort(1).DirectFeedthrough = true;
  block.InputPort(2).DirectFeedthrough = true;
  
  block.InputPort(1).SamplingMode = 'Sample';
  block.InputPort(2).SamplingMode = 'Sample';

  block.OutputPort(1).SamplingMode = 'Sample';
  block.OutputPort(2).SamplingMode = 'Sample';
  
  
  %% Set block sample time to inherited
  block.SampleTimes = [-1 0];
  
  %% Set the block simStateCompliance to default (i.e., same as a built-in block)
  block.SimStateCompliance = 'DefaultSimState';

  %% Run accelerator on TLC
  block.SetAccelRunOnTLC(true);
  
  
  
  %% Register methods
  block.RegBlockMethod('InitializeConditions',    @InitConditions);
  block.RegBlockMethod('Outputs',                 @Output);  
  block.RegBlockMethod('PostPropagationSetup',    @DoPostPropSetup);
  
  
function DoPostPropSetup(block)
 %% Setup Dwork
 block.NumDworks = 1;
 block.Dwork(1).Name = 'ComponentID';
 for i = 1:1
     
     block.Dwork(i).Dimensions = 1;
     block.Dwork(i).DatatypeID = 0;
     block.Dwork(i).Complexity = 'Real';
     block.Dwork(i).UsedAsDiscState = true;
 end
 
 
  
function InitConditions(block)  
  %% Instantiate Object  
  
  component = instantiateComponent(block.DialogPrm(1).Data, block.DialogPrm(2).Data);
  %% Initialize Dwork
  block.Dwork(1).Data = component.ID;

  
%endfunction


function Output(block)
  component = retreiveComponent(block.DialogPrm(1).Data, block.Dwork(1).Data);
  PortData = [block.InputPort(1).Data, block.InputPort(2).Data];
  ResultData = component.apply(round(PortData));
  
  block.OutputPort(1).Data = ResultData(2); % Left In goes Right Out
  block.OutputPort(2).Data = ResultData(1); % Right In goes Left Out

%endfunction

