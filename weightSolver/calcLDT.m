%A function to calculat L/D and thrust required for straight level cruise
%condidions. 
%Constants defined: cD0=0.02 AR=3.5 e=0.91 S=300ft^2
%Usage: [LoverD, thrust] = calcLDT(cL, altitute, speed)
%Altitude in ft, speed in Mach number

function [LoD, thrust] = calcLDT(cL, alt, speed)
appts = atmos(alt);
speed = speed * appts.a;
%Conver to ft/s. 

AR = 3.5;
e = 0.91;
K = 1 / (pi * AR * e);
cD0 = 0.02;
S = 300;
%Wing area in ft^2

cD = @(CL) (cD0 + K * CL^2);

LoD = cL / cD(cL);

q = @(V) (0.5 * appts.Rho * V^2);
thrust = q(speed) * S * cD(cL);
%Thrust shoudl be equal to drag for straight level flight. 

end