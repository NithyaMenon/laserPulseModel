function fourwaycomponent_s(block)
% S-Function for generic 4-port I/O component (ex. BeamSplitter)
% See also: component_s, retreiveComponent, instantiateComponent

  setup(block);
  
%endfunction

function setup(block)
  
  % This method defines the block's properties, such as the number of
  % ports, etc. It is run on model loading, but before you have access to
  % any information from mask parameters.

  block.NumDialogPrms  = 2; % Component Type, ParamsObject
  
  % The stuff below is mostly just S-function setup stuff for a generic
  % block.

  %% Register number of input and output ports
  block.NumInputPorts  = 4; % This is for beamsplitters, others use 2 I/O
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

 % This function lets you do stuff after the block setup, but before you
 % have access to the mask parameters. 
 %% Setup Dwork
 block.NumDworks = 1; 
 block.Dwork(1).Name = 'ComponentID'; % Basically a persistent variable of
  % the block, which will hold the ComponentID.
 for i = 1:1
     
     block.Dwork(i).Dimensions = 1;
     block.Dwork(i).DatatypeID = 0;
     block.Dwork(i).Complexity = 'Real';
     block.Dwork(i).UsedAsDiscState = true;
 end
 
  
function InitConditions(block)  
  %% Instantiate Object  
  % This is the initialization of the block. The mask params are used to
  % call a function that returns the requested component. See
  % instantiateComponent
  component = instantiateComponent(block.DialogPrm(1).Data, block.DialogPrm(2).Data);
  %% Initialize Dwork
  block.Dwork(1).Data = component.ID;
  
%endfunction


function Output(block)
  % At each timestep, Simulink calls this methof of the S-function
  % We retreive the component object using its ID (since Simulink doesn't
  % let you hold data types that are object references.
  component = retreiveComponent(block.DialogPrm(1).Data, block.Dwork(1).Data);
  % And then pass the input data into the component's "apply" method, which
  % each component has.
  PortData = [block.InputPort(1).Data, block.InputPort(2).Data,...
      block.InputPort(3).Data, block.InputPort(4).Data];
  ResultData = component.apply(round(PortData));
  % The "data" is another ID pointing to a "PulseArray" object which holds
  % an array of pulses to be acted on at that timestep. A lot of these
  % "reference things by ID" are just to get around Simulink's data type
  % restrictions. See "PulseArray" in the Components folder
  
  % Send the output data back into Simulink. These data are also PulseArray
  % IDs
  block.OutputPort(1).Data = ResultData(1); % Signal routing done internal to components
  block.OutputPort(2).Data = ResultData(2); % This is unlike what is done in component_s.m
  block.OutputPort(3).Data = ResultData(3); 
  block.OutputPort(4).Data = ResultData(4); 
  

%endfunction

