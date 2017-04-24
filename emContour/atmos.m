%Copyright 2017, Jinyan Zhang, All rights reserved.
%Jinyan Zhang, Student ID# 2447878
%Course AE413, Homework 1, Question 1. 

function ATMOS = atmos(h) 
    %Input: height in feet. 
    ATMOS = struct('H', {}, 'T', {}, 'P', {}, 'Rho', {}, 'a', {});
    g=9.80665;
    h0=0;
    h1=11000;
    h2=20000;
    
    T0=288.15;
    R=287.053;
    
    ATMOS(1).H=h/3.2808;
    if (ATMOS.H>=h0)&&(ATMOS.H<=h1)
        ATMOS.T=288.15-6.5*ATMOS.H/1000;
                
    elseif ATMOS.H>h1&&ATMOS.H<=h2
        ATMOS.T=216.65;
    
    end
    

    
    if ATMOS.H>=h0&&ATMOS.H<=h1
        ATMOS.P=101325*(ATMOS.T/T0)^(g/0.0065/R);
                
	elseif ATMOS.H>h1&&ATMOS.H<=h2
        ATMOS.P=22632*exp(-g/(R*216.65)*(ATMOS.H-h1));
        
    end

    
    ATMOS.Rho=ATMOS.P/(R*ATMOS.T)*0.00194;
    %Density in slug/ft^3
    
    ATMOS.a=20.05*sqrt(ATMOS.T)*3.2808;
    %Speed of sound in ft/s
    
    
    ATMOS.H=ATMOS.H*3.2808;
    %Height in feet
    ATMOS.T=ATMOS.T*1.8;
    %Temperature: Units in rankine. 
    ATMOS.P=ATMOS.P*0.020885;
    %Pressure in lb/ft^2
    
end