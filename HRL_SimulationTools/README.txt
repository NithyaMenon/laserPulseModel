README

This document briefly goes over the file directory structure. Please see ‘Final Report Appendix B: How To Use The Simulation’ for a more in depth tour of the code.

HRL_SimulationTools – contains high level code used to run designs, Monte Carlo initialization
scripts, and output plotting scripts. This directory also contains all of the Simulink models (.slx files). Please see 'Basics of a Simulation Design.PDF', 'RunningModelBasics.PDF' and then the video 'BuildingAModelTutorial' on the provided CD for more information on design tools. Please see the Components folder below for a background understanding on Components first. Finally, please see the video 'AdaptingAnMCDesignTutorial' video on the provided CD for more information on adapting designs for Monte Carlo simulations.


HRL_SimulationTools/Components – this directory stores all of the components used by the
Simulink models. Each component is commented describing its parameters and appropriate usage. See
Component Abstraction.pdf for details. This directory also contains the necessary methods to initialize
component objects in the model. Please see 'Component Abstraction.PDF' file located in this folder for more inofrmation.


HRL_SimulationTools/Automation_Optimization – contains automation and optimization code.
The runExperiment scripts serve as a wrapper which call the optimization and automation codes. The
automation code uses the results from the delay optimization to calculate the EOM on/off times and
control powers. See the code for more details.


HRL_SimulationTools/Automation_Optimization/Delay-Optimizating Code – contains all of the
code necessary to choose the best delays for a given N and T for the digitizing design using the overlap
integral as an evaluation metric. See delay optimization README.txt for details. The delOp.m script is
primarily responsible for delay optimization. Please see the file 'delay optimization README.txt' for more information.
