classdef cruise < handle
    
    properties
        panel
        rangeEdit
        speedEdit
    end
    
    properties
        range
        speed
    end
    
    properties ( Access = 'private' )
        left
        buttom
        length
        height
        wS
    end
    
    methods
        
        function obj = cruise(left, buttom, length, height, wS)
            obj.range = 0;
            obj.speed = 0;
            obj.left = left;
            obj.buttom = buttom;
            obj.length = length;
            obj.height = height;
            obj.wS = wS;
            obj.show;
        end
        
        function show(obj)
            obj.panel = uipanel('Title', 'Cruise', ...
                'Units', 'pixels', ...
                'Pos', [obj.left, obj.buttom, obj.length, obj.height], ...
                'Parent', obj.wS);
            
            obj.rangeEdit = uicontrol('Style', 'edit', ...
                'FontSize', 12, ...
                'String', num2str(obj.range / 6076.12), ...
                'Position', [5 5 140 20], ...
                'Parent', obj.panel, ...
                'Callback', @obj.setRange);
            uicontrol('Style', 'text', ...
                'Position', [5 30 140 20], ...
                'String', 'Range in nMile', ...
                'FontSize', 12, ...
                'Parent', obj.panel);
            
            obj.speedEdit = uicontrol('Style', 'edit', ...
                'FontSize', 12, ...
                'String', num2str(obj.speed), ...
                'Position', [150 5 140 20], ...
                'Parent', obj.panel, ...
                'Callback', @obj.setSpeed);
            uicontrol('Style', 'text', ...
                'Position', [150 30 140 20], ...
                'String', 'Speed in ft/s', ...
                'FontSize', 12, ...
                'Parent', obj.panel);
        end
        
        function wf = getWF(obj, sfc, LoD, climb)
            %return W(final)/W(initial), including climb. 
            wf = exp(obj.range * sfc / (LoD * obj.speed));
            wf = 1/wf * climb;
        end
    end
        
        
    methods ( Access = 'private' )
        function setRange(obj, hObject, eventdata)
            obj.range = str2double(get(hObject, 'String'));
            %Range in nautical miles                
            obj.range = obj.range * 6076.12;
            %Convert to ft. 
        end
            
        function setSpeed(obj, hObject, eventdata)
            obj.speed = str2double(get(hObject, 'String'));
            %Speed in ft/s. 
        end
    end
end