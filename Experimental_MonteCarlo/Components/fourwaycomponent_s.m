function fourwaycomponent_s(block)
% S-Function for generic component

  setup(block);
  
%endfunction

function setup(block)
 

  block.NumDialogPrms  = 2; % Component Type, ParamsObject


  %% Register number of input and output ports
  block.NumInputPorts  = 4;
  block.NumOutputPorts = 4;

  %% Setup functional port properties to dynamically
  %% inherited.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
 
  block.InputPort(1).DirectFeedthrough = true;
  block.InputPort(2).DirectFeedthrough = true;
  block.InputPort(3).DirectFeedthrough = true;
  block.InputPort(4).DirectFeedthrough = true;
  
  block.InputPort(1).SamplingMode = 'Sample';
  block.InputPort(2).SamplingMode = 'Sample';
  block.InputPort(3).SamplingMode = 'Sample';
  block.InputPort(4).SamplingMode = 'Sample';

  block.OutputPort(1).SamplingMode = 'Sample';
  block.OutputPort(2).SamplingMode = 'Sample';
  block.OutputPort(3).SamplingMode = 'Sample';
  block.OutputPort(4).SamplingMode = 'Sample';
  
  
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
  PortData = [block.InputPort(1).Data, block.InputPort(2).Data,...
      block.InputPort(3).Data, block.InputPort(4).Data];
  ResultData = component.apply(round(PortData));
  
  block.OutputPort(1).Data = ResultData(1); 
  block.OutputPort(2).Data = ResultData(2); 
  block.OutputPort(3).Data = ResultData(3); 
  block.OutputPort(4).Data = ResultData(4); 
  

%endfunction

