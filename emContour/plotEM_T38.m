function [machNumbers, typAlt, matPs] = plotEM_T38(loadfactor)
    tic
    
    e = 0.87;
    AR = 3.75;
    K = 1 / (pi * e * AR);%To calculate induced drag. 
    
    Cd0 = 0.02;
    
    W = 12093;%Weight of the aircraft.
    %T0 = 14100;%Thrust at sea level, dry
    T0 = 5800;%Thrust at sea level, afterburning. 
    S = 170;
    
    air_SL = atmos(0);
    
    Ps = @(V, n, T, q) (V .* (T ./ W - (q .* Cd0) ./ (W ./ S) - (K .* n.^2 .* W) ./ (q .* S)));
    
    machNumbers = gpuArray(single(0.01:0.01:1.21));
    typAlt = (1:50000)';
    
    matMach = repmat(machNumbers, [size(typAlt, 1) 1]);
    
    matN = repmat(loadfactor, [size(typAlt, 1) size(machNumbers, 2)]);
    
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
    contourcmap('copper');
    
    title(strcat('Specific Power Contours @ n=', num2str(loadfactor), 'T38'));
    ylabel('Altitude, ft');
    xlabel('Mach Number');
    %}
    
    toc
end