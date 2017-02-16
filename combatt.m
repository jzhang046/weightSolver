classdef combatt < handle
    
    properties
        panel
        thrustEdit
        timeEdit
    end
    
    properties
        thrust
        time
    end
        properties ( Access = 'private' )
        left
        buttom
        length
        height
        wS
    end
    
    methods
        
        function obj = combatt(left, buttom, length, height, wS)
            obj.time = 0;
            obj.thrust = 0;
            obj.left = left;
            obj.buttom = buttom;
            obj.length = length;
            obj.height = height;
            obj.wS = wS;
            obj.show;
        end
        
        function show(obj)
            obj.panel = uipanel('Title', 'Combat', ...
                'Units', 'pixels', ...
                'Pos', [obj.left, obj.buttom, obj.length, obj.height], ...
                'Parent', obj.wS);
            
            obj.thrustEdit = uicontrol('Style', 'edit', ...
                'FontSize', 12, ...
                'String', num2str(obj.thrust), ...
                'Position', [5 5 140 20], ...
                'Parent', obj.panel, ...
                'Callback', @obj.setThrust);
            uicontrol('Style', 'text', ...
                'Position', [5 30 140 20], ...
                'String', 'Tmax in lbs', ...
                'FontSize', 12, ...
                'Parent', obj.panel);
            
            obj.timeEdit = uicontrol('Style', 'edit', ...
                'FontSize', 12, ...
                'String', num2str(obj.time / 60), ...
                'Position', [150 5 140 20], ...
                'Parent', obj.panel, ...
                'Callback', @obj.setTime);
            uicontrol('Style', 'text', ...
                'Position', [150 30 140 20], ...
                'String', 'Time in mins', ...
                'FontSize', 12, ...
                'Parent', obj.panel);
        end
        
        function w = getFuelWeight(obj, sfc)
            %return W(final)/W(initial), including climb. 
            w = obj.time * obj.thrust * sfc;
        end
    end
        
        
    methods ( Access = 'private' )
        function setTime(obj, hObject, eventdata)
            obj.time = str2double(get(hObject, 'String'));
            %time in mins              
            obj.time = obj.time * 60;
            %Convert to seconds. 
        end
            
        function setThrust(obj, hObject, eventdata)
            obj.thrust = str2double(get(hObject, 'String'));
        end
    end
end
