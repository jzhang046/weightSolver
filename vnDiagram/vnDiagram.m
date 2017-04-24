function vnDiagram(alt, Clmax, Clmin)
%This function is used to plot an V-N diagram.
%Usage: vnDiagram(wingLoading, Clmax, Clmin);
%Input: 
%   Wing loading, W/S in psf
%   Clmax and Clmin for the wing
%default dynamic pressure limit is 2133 psf. 
%default limit load factors are +9 and -3. 
%Airspeed is in terms of EAS, in order to eliminate the change in density
%   under different altitude. 

WoS = 72.9821; %Wing loading

qLimit = 2133;
%dynamic pressure limit in psf. 
nMax = 9;
nMin = -3;
%Maximum and minimum load factor limit. 
airp_sea = atmos(0);
Rho0 = airp_sea.Rho;
%Density of air at sea level, in slug/(cu ft). 

vMax = sqrt(qLimit * 2 / Rho0);
vAtNMax = sqrt(nMax * 2 * WoS / (Clmax * Rho0));
vAtNMin = sqrt(nMin * 2 * WoS / (Clmin * Rho0));

xPosStall = 0:vAtNMax;
yPosStall = Rho0 * xPosStall.^2 *Clmax / (2 * WoS);

xNegStall = 0:vAtNMin;
yNegStall = Rho0 * xNegStall.^2 *Clmin / (2 * WoS);

x = [xPosStall, vAtNMax, vMax, vMax, vAtNMin, fliplr(xNegStall)];
y = [yPosStall, nMax, nMax, nMin, nMin, fliplr(yNegStall)];
%data for common vn diagram. 

fig = figure('NumberTitle', 'off', ...
    'Name', 'VN Diagram');
axe = axes('Parent', fig);
%figure and axis for plot. 

plot(x, y, 'Parent', axe);
title(strcat('VN Diagram, gust@', num2str(alt/1000), 'kft'));
ylabel('Load factor');
xlabel('Equivalent Airspeed in ft/s');
grid on;
hold on;
%plot common vn diagram. 
%========common vn diagram above
%========gust vn diagram below

g = 32.174;
airp = atmos(alt);
Rho = airp.Rho;

%to plot dashed line: plot(x,y, '--');
gust_dive = getGust(alt, 'dive')
gust_cruise = getGust(alt, 'cruise')
gust_rough = getGust(alt, 'rough')
%Equivalent gust velocity below 20000ft alt. 

ClAlpha = 2 * pi;
warning('Adjust lift curve slope');
%Lift curve slope, should be change later; 

cr = 16.621;
ct = 5.817;
%root and tip chord of wing. 
lanta = ct / cr;%taper ratio

cbar = 2 / 3 * cr * (1 + lanta + lanta^2) / (1 + lanta);
%mean aerodynamic chord. 

miu = (2 * WoS) / (Rho * cbar * ClAlpha * g);
Kg = (0.88 * miu) / (5.3 + miu);
%gust alleviation factor. 

gustLoadFactor_P = @(ue, ve) 1 + ((Kg * ClAlpha .* ue .* ve) ./ (498 * WoS));
gustLoadFactor_N = @(ue, ve) 1 - ((Kg * ClAlpha .* ue * ve) / (498 * WoS));
%Positive and Negative gust load factor. 

plotGustVN(gust_dive, (vMax + 80), gustLoadFactor_P, gustLoadFactor_N);
plotGustVN(gust_cruise, (vMax + 80), gustLoadFactor_P, gustLoadFactor_N);
plotGustVN(gust_rough, (vMax + 80), gustLoadFactor_P, gustLoadFactor_N);

xlim(axe, [0 vMax + 210]);

end

function plotGustVN(gust, vmax, positive, negative)

    x = [vmax 0 vmax];
    positiveY = positive(gust, x(1:2));
    negativeY = negative(gust, x(3));
    
    y = [positiveY, negativeY];
    
    plot(x, y, '--');

    txt_P = strcat('+', sprintf('%0.1f', gust), 'ft/s');
    txt_N = strcat('-', sprintf('%0.1f', gust), 'ft/s');
    text(x(1) - 50, y(1) + 0.6, txt_P);
    text(x(3) - 50, y(3) + 0.8, txt_N);
    
end

function gust = getGust(alt, type)

    if alt > 50000
        alt = 50000;
    end

    switch type
        case 'dive'
            if alt <= 20000
                gust = 25;
            else
                gust = interp1q([20000;50000], [25;12.5], alt);
            end
            disp('dive');
        case 'cruise'
            if alt <= 20000
                gust = 50;
            else
                gust = interp1q([20000;50000], [50;25], alt);
            end
        case 'rough'
            if alt <= 20000
                gust = 66;
            else
                gust = interp1q([20000;50000], [66;38], alt);
            end
    end
end