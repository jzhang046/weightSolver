classdef loiter < handle
    
    properties
        panel
        timeEdit
    end
    
    properties
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
        
        function obj = loiter(left, buttom, length, height, wS)
            obj.time = 0;
            obj.left = left;
            obj.buttom = buttom;
            obj.length = length;
            obj.height = height;
            obj.wS = wS;
            obj.show;
        end
        
        function show(obj)
            obj.panel = uipanel('Title', 'Loiter', ...
                'Units', 'pixels', ...
                'Pos', [obj.left, obj.buttom, obj.length, obj.height], ...
                'Parent', obj.wS);
            
            obj.timeEdit = uicontrol('Style', 'edit', ...
                'FontSize', 12, ...
                'String', num2str(obj.time / 60), ...
                'Position', [5 5 140 20], ...
                'Parent', obj.panel, ...
                'Callback', @obj.setTime);
            uicontrol('Style', 'text', ...
                'Position', [5 30 140 20], ...
                'String', 'Time in mins', ...
                'FontSize', 12, ...
                'Parent', obj.panel);
            
        end
        
        function wf = getWF(obj, sfc, LoD)
            %return W(final)/W(initial). 
            wf = exp(obj.time * sfc / LoD);
            wf = 1/wf;
        end
    end
        
        
    methods ( Access = 'private' )
        function setTime(obj, hObject, eventdata)
            obj.time = str2double(get(hObject, 'String'));
            %Time in mins                
            obj.time = obj.time * 60;
            %Convert to seconds. 
        end
    end

end
