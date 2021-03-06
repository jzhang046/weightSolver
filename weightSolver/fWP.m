classdef fWP < handle
    
    properties
        panel
        fWEdit
        
        weight
    
    end
    
    methods
        
        function obj = fWP(left, buttom, length, height, wS)
            obj.weight = 1550;
            obj.panel = uipanel('Title', 'Fixed Weight', ...
                'Units', 'pixels', ...
                'Pos', [left, buttom, length, height], ...
                'Parent', wS);
            
            obj.fWEdit = uicontrol('Style', 'edit', ...
                'FontSize', 12, ...
                'String', num2str(obj.weight), ...
                'Position', [5 5 140 20], ...
                'Parent', obj.panel, ...
                'Callback', @obj.fWCallback);
            uicontrol('Style', 'text', ...
                'Position', [5 30 140 20], ...
                'String', 'in lbs', ...
                'FontSize', 12, ...
                'Parent', obj.panel);
        end
        
        
        function fWCallback(obj, hObject, eventdata)
            obj.weight = str2double(get(hObject, 'String'));
        end
    end
            
end
