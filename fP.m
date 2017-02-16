classdef fP < handle
    
    properties
        panel
        startEdit
        wGAccEdit
        wClimbEdit
        sfcEdit
        LoDEdit
        modeSelect
        missionList
    end
        
    properties
        mode
        currentMission
        cruise1
        cruise2
        cruise3
        loiter1
        loiter2
        combat
    end
    
    properties
        startFuel
        wGAcc
        wClimb
        sfc
        LoD
    end
    
    properties
        PoFractions%product of all other fractions
        combatFuel%amount of fuel
        pBCombat%before combat
    end
    
    methods
        
        function obj = fP(left, buttom, length, height, wS)
            obj.panel = uipanel('Title', 'Fuel', ...
                'Units', 'pixels', ...
                'Position', [left, buttom, length, height], ...
                'Parent', wS);
            
            obj.init;
            
        end
        
        function cal(obj)
            w21 = obj.wGAcc;
            w42 = obj.cruise1.getWF(obj.sfc, obj.LoD, obj.wClimb);
            w54 = 1;
            w65 = obj.loiter1.getWF(obj.sfc, obj.LoD);
            w86 = obj.cruise2.getWF(obj.sfc, obj.LoD, obj.wClimb);
            w98 = 1;
            
            w10_9 = obj.combat.getFuelWeight(obj.sfc);
            
            w12_10 = obj.cruise3.getWF(obj.sfc, obj.LoD, obj.wClimb);
            w13_12 = 1;
            w14_13 = obj.loiter2.getWF(obj.sfc, obj.LoD);
            
            obj.PoFractions = w21 * w42 * w54 * w65 * w86 * w98 * w12_10 * w13_12 * w14_13;
            obj.combatFuel = w10_9;
            obj.pBCombat = w21 * w42 * w54 * w65 * w86 * w98;
            
        end
        
    end
    
    methods ( Access = 'private' )
        function init(obj)
            obj.startEdit = uicontrol('Style', 'edit', ...
                'Position', [75, 433, 70, 15], ...
                'String', '???', ...
                'Parent', obj.panel, ...
                'Callback', @obj.setStartingFuel);
            uicontrol('Style', 'text', ...
                'Position', [5, 440, 70, 15], ...
                'Parent', obj.panel, ...
                'String', 'Starting Fuel');
            uicontrol('Style', 'text', ...
                'Position', [5, 425, 70, 15], ...
                'Parent', obj.panel, ...
                'String', 'in lbs');
            
            obj.wGAccEdit = uicontrol('Style', 'edit', ...
                'Position', [250, 433, 70, 15], ...
                'Parent', obj.panel, ...
                'Callback', @obj.setGroundAccelerate);
            uicontrol('Style', 'text', ...
                'Position', [155, 440, 95, 15], ...
                'Parent', obj.panel, ...
                'String', 'Ground Accelerate');
            uicontrol('Style', 'text', ...
                'Position', [155, 425, 95, 15], ...
                'Parent', obj.panel, ...
                'String', 'weight fraction');
            
            obj.wClimbEdit = uicontrol('Style', 'edit', ...
                'Position', [405, 433, 70, 15], ...
                'Parent', obj.panel, ...
                'Callback', @obj.setClimb);
            uicontrol('Style', 'text', ...
                'Position', [325, 440, 80, 15], ...
                'Parent', obj.panel, ...
                'String', 'Climb');
            uicontrol('Style', 'text', ...
                'Position', [325, 425, 80, 15], ...
                'Parent', obj.panel, ...
                'String', 'weight fraction');
            
            obj.wClimbEdit = uicontrol('Style', 'edit', ...
                'Position', [505, 433, 70, 15], ...
                'Parent', obj.panel, ...
                'Callback', @obj.setSfc);
            uicontrol('Style', 'text', ...
                'Position', [480, 440, 25, 15], ...
                'Parent', obj.panel, ...
                'String', 'SFC');
            uicontrol('Style', 'text', ...
                'Position', [480, 425, 25, 15], ...
                'Parent', obj.panel, ...
                'String', 'in /h');
            
            obj.wClimbEdit = uicontrol('Style', 'edit', ...
                'Position', [605, 433, 70, 15], ...
                'Parent', obj.panel, ...
                'Callback', @obj.setLoD);
            uicontrol('Style', 'text', ...
                'Position', [580, 433, 25, 15], ...
                'Parent', obj.panel, ...
                'String', 'L/D');
            
            obj.modeSelect = javax.swing.JComboBox({'Pure Cruise', 'Mission'});
            javacomponent(obj.modeSelect, [5, 400, 100, 15], obj.panel);
            set(obj.modeSelect, 'ActionPerformedCallback', @obj.setMode);
            
            obj.loiter1 = loiter(160, 5, 595, 390, obj.panel);
            obj.cruise2 = cruise(160, 5, 595, 390, obj.panel);
            obj.combat = combatt(160, 5, 595, 390, obj.panel);
            obj.cruise3 = cruise(160, 5, 595, 390, obj.panel);
            obj.loiter2 = loiter(160, 5, 595, 390, obj.panel);
            obj.cruise1 = cruise(160, 5, 595, 390, obj.panel);
            
            obj.missionList = uicontrol('Style', 'List', ...
                'String', ...
                {'Cruise 1', 'Loiter 1', 'Cruise 2', 'Combat', 'Cruise 3', 'Reserve(Loiter)'}, ...
                'Position', [5 5 150 390], ...
                'Parent', obj.panel, ...
                'Callback', @obj.setMission);
        end
        
        function setStartingFuel(obj, hObject, eventdata)
            obj.startFuel = str2double(get(hObject, 'String'));
        end
        
        function setGroundAccelerate(obj, hObject, eventdata)
            obj.wGAcc = str2double(get(hObject, 'String'));
        end
        
        function setClimb(obj, hObject, eventdata)
            obj.wClimb = str2double(get(hObject, 'String'));
        end
        
        function setSfc(obj, hObject, eventdata)
            obj.sfc = str2double(get(hObject, 'String'));
            %SFC in per hour
            
            obj.sfc = obj.sfc / 3600;
            %Convert to per second. 
        end
        
        function setLoD(obj, hObject, eventdata)
            obj.LoD = str2double(get(hObject, 'String'));
        end
        
        function setMode(obj, hObject, eventdata)
            obj.mode = get(hObject, 'Selecteditem');
            %disp(obj.mode);
        end
        
        function setMission(obj, hObject, eventdata) 
            obj.currentMission = get(hObject, 'Value');
            switch obj.currentMission
                case 1
                    obj.cruise1.show;
                case 2
                    obj.loiter1.show;
                case 3
                    obj.cruise2.show;
                case 4
                    obj.combat.show;
                case 5
                    obj.cruise3.show;
                case 6
                    obj.loiter2.show;
                otherwise
                    disp('Add more. ');
            end
        end
    end
            
end
