function [machNumbers, typAlt, matPs] = plotEM(loadfactor)
    tic

    %e = 1 / (1 + 0.001);
    e = 0.9;
    AR = 3.5;
    K = 1 / (pi * e * AR);%To calculate induced drag. 
    
    Cd0 = 0.02;
    
    W = 32623;%Weight of the aircraft.
    %T0 = 14100;%Thrust at sea level, dry
    T0 = 22600;%Thrust at sea level, afterburning. 
    S = 447;
    
    air_SL = atmos(0);
    
    Ps = @(V, n, T, q) (V .* (T ./ W - (q .* Cd0) ./ (W ./ S) - (K .* n.^2 .* W) ./ (q .* S)));
    
    machNumbers = gpuArray(single(0.01:0.01:1.21));
    typAlt = (1:50000)';
    
    matMach = repmat(machNumbers, [size(typAlt, 1) 1]);
        
    typAltPpt = arrayfun(@atmos, typAlt);
    typRho = gpuArray(single(extractfield(typAltPpt, 'Rho')'));
    typA = gpuArray(single(extractfield(typAltPpt, 'a')'));
    
    matRho = repmat(typRho, [1 size(machNumbers, 2)]);
    
    matA = repmat(typA, [1 size(machNumbers, 2)]);
    matV = matMach .* matA;
    
    matThrust = T0 .* (matRho ./ air_SL.Rho);
    
    matQ = 0.5 .* matRho .* matV .* matV;
    
    matPs = Ps(matV, loadfactor, matThrust, matQ);
    
    %{
    figure('NumberTitle', 'off', 'Name', 'EM Contour');

    contour(machNumbers, typAlt', matPs, plotLines, 'ShowText', 'on');
    contourcmap('winter');
    
    title(strcat('Specific Power Contours @ n=', num2str(loadfactor)));
    ylabel('Altitude, ft');
    xlabel('Mach Number');
    toc
    %}
    
    toc
end