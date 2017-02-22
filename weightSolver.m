classdef weightSolver < handle
    
    properties
        
        
    end
    
    properties ( Access = 'private' );
        
        mainWindow
        
        fixedWPanel
        emptyWPanel
        fuelWPanel
        solverPanel
        
        solveButton
    end
    
    methods 
        function obj = weightSolver
            obj.mainWindow = figure('NumberTitle', 'off', ...
                'Name', 'Takeoff Weight Solver', ...
                'menubar', 'none', ...
                'Position', [40, 40, 780, 570]);
            
            obj.fixedWPanel = fWP(10, 500, 150, 70, obj.mainWindow);
            obj.emptyWPanel = eWP(170, 500, 300, 70, obj.mainWindow);
            obj.fuelWPanel = fP(10, 10, 760, 480, obj.mainWindow);
            
            obj.solverPanel = uipanel('Title', 'Solver', ...
                'Unit', 'pixels', ...
                'Pos', [480, 500, 290, 70], ...
                'Parent', obj.mainWindow);
            
            obj.solveButton = javax.swing.JButton('Solve');
            javacomponent(obj.solveButton, [5 5 60 50], obj.solverPanel);
            set(obj.solveButton, 'MouseClickedCallback', @obj.solveForWeight);
            
            uicontrol('Style', 'text', ...
                'Position', [70 42 115 15], ...
                'Parent', obj.solverPanel, ...
                'String', 'Please fill all the fields');
            uicontrol('Style', 'text', ...
                'Position', [70 25 90 15], ...
                'Parent', obj.solverPanel, ...
                'String', 'Takeoff Weight: ');
            
            uicontrol('Style', 'text', ...
                'Position', [173 25 115 15], ...
                'Parent', obj.solverPanel, ...
                'String', 'Weight before combat: ');
            
        end
    end
    
    methods ( Access = 'private' )
        
        function solveForWeight(obj, hObject, eventdata)
            
            fixedW = obj.fixedWPanel.weight;
            
            emptyC = obj.emptyWPanel.constant;
            emptyP = obj.emptyWPanel.power;
            
            obj.fuelWPanel.cal;
            fuelPoF = obj.fuelWPanel.PoFractions;
            fuelCbtF = obj.fuelWPanel.combatFuel;
            fuelFbC = obj.fuelWPanel.pBCombat;
            
            rtn = 800;
            init = 900;
            while (abs(init - rtn) > 0.00001) 
                init = rtn;
                rtn = fixedW + emptyC * init ^ emptyP + 1.06*(1-(1-fuelCbtF/(fuelFbC*init))*fuelPoF)*init;
            end
            
            uicontrol('Style', 'text', ...
                'Position', [65 5 100 20], ...
                'Parent', obj.solverPanel, ...
                'FontSize', 12, ...
                'String', num2str(rtn));
            uicontrol('Style', 'text', ...
                'Position', [173 5 100 20], ...
                'Parent', obj.solverPanel, ...
                'FontSize', 12, ...
                'String', num2str(rtn*fuelFbC));
        end
        
    end
    
end