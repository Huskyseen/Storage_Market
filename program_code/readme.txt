Code Author:
	Xin Qin - qinxin_thu@outlook.com, xq234@cam.ac.uk
	Bolun Xu - bx2177@columbia.edu

Please use the following two main functions to run the code and perform simulation:

mainTest.m - perform energy storage market participation simulation
mainTest_rho.m - same as mainTest.m except it also iterates the ratio of storage in different market participation options

Folders - you must include all following folders into Matlab path to run the code:
    Code_Main - contains files used to perform various market simulations
    settings - contains simulation system data
    supporting_files - contains file for data processing, scenario generation, and energy storage bid generation
    YALMIP-master - YALMIP package

The code uses the YALMIP package (included in this folder) and the Gurobi optimization solver (not included, please download separately from www.gurobi.com) for solving mixed-integer linear programming. 

The ISO-NE test system data reference:
Krishnamurthy, D., Li, W., & Tesfatsion, L. (2015). An 8-zone test system based on ISO New England data: Development and application. IEEE Transactions on Power Systems, 31(1), 234-246.
