classdef weightSolver < handle
    
    properties
        
        
    end
    
    properties ( Access = 'private' );
        
        mainWindow
        
        fixedWPanel
        emptyWPanel
        fuelWPanel
        
        
    end
    
    methods 
        function obj = weightSolver
            obj.mainWindow = figure('NumberTitle', 'off', ...
                'Name', 'Takeoff Weight Solver', ...
                'menubar', 'none', ...
                'Position', [40, 40, 780, 570]);
            
            obj.fixedWPanel = fWP(10, 500, 150, 70, obj.mainWindow);
            obj.emptyWPanel = eWP(170, 500, 400, 70, obj.mainWindow);
            obj.fuelWPanel = fP(10, 10, 760, 480, obj.mainWindow);
            uipanel('Title', 'Fixed Weight', ...
                'Pos', [10, 10, 20, 50], ...
                'Parent', obj.mainWindow);
            
        end
    end
    
    methods ( Access = 'private' )
        
    end
    
end