tic
clear;clc;

loadfactor = 1;
plotLines = -200:100:300;


[machNumbers, typAlt, matPsRev] = plotEM(loadfactor);
[~,~,matPsT38] = plotEM_T38(loadfactor);

figure('NumberTitle', 'off', 'Name', 'EM Contour');
ax1 = axes;
contour(machNumbers, typAlt, matPsRev, plotLines, 'ShowText', 'on');

ax2 = axes;
contour(machNumbers, typAlt, matPsT38, plotLines, 'ShowText', 'on');

linkaxes([ax1,ax2]);
ax2.Visible = 'off';
ax2.XTick = [];
ax2.YTick = [];

title(strcat('Specific Power Contours (Dry) @ n=', num2str(loadfactor)));
ylabel('Altitude, ft');
xlabel('Mach Number');

mapBlue = [0 0 1];
mapRed = [1 0 0];

colormap(ax1, mapRed);
colormap(ax2, mapBlue);
toc