function pockels_cell_s(block)
% Level-2 MATLAB file S-Function for times two demo.
%   Copyright 1990-2009 The MathWorks, Inc.

  setup(block);
  
%endfunction

function setup(block)
 

  block.NumDialogPrms  = 2;


  %% Register number of input and output ports
  block.NumInputPorts  = 1;
  block.NumOutputPorts = 1;

  %% Setup functional port properties to dynamically
  %% inherited.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
 
  block.InputPort(1).DirectFeedthrough = true;
  
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
 block.Dwork(1).Name = 'x0';
 block.Dwork(1).Dimensions = 1;
 block.Dwork(1).DatatypeID = 0;
 block.Dwork(1).Complexity = 'Real';
 block.Dwork(1).UsedAsDiscState = true;
  
function InitConditions(block)  
  %% Instantiate Pockels Cell
  
%   PCtimings1 = [-1,1,38,40,103,105,168,170,220,222,272,274]*1e-9;
%   controlPowers1 = ones(1,length(PCtimings1)/2);
%   controlPowers1(1) = 0.5;
%   controlPowers1(end) = 0.5;
  PC1 = PockelsObject(block.DialogPrm(1).Data,block.DialogPrm(2).Data);
  
  
  %% Initialize Dwork
  block.Dwork(1).Data = PC1.ID;
  
%endfunction


function Output(block)
  tim = block.InputPort(1).Data * 1e-9;
  PC = PockelsObject.getPockelsObject(block.Dwork(1).Data);
  block.OutputPort(1).Data = PC.curve( tim );
%   block.OutputPort(1).Data = sin(block.InputPort(1).Data);

%endfunction

