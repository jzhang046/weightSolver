%Panel object to calculate weight fractions.
classdef fP < handle

    properties
        %GUI components.
        panel
        startEdit
        wGAccEdit
        missionList
    end

    properties
        %Panel objects for specific missions.
        currentMission
        cruise1
        cruise2
        cruise3
        TankerRende
        Refueling
        loiter2
        combat
    end

    properties
        %Data for calculations, used by all the missions.
        startFuel
        wGAcc
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
            %The fuel weight fraction panel.
            %It is a uipanel object.

            obj.wGAcc = 0.97;
            %Initial value.

            obj.init;
        end

        function cal(obj)
            %This function is used to generate corresponding weight fractions with the input data.
            %Calculations are unable to perform unless all the data has been properlly typed,
            %And it's meaningless to update the result everytime when user key in some value.

            w21 = obj.wGAcc;
            w42 = obj.cruise1.getWF();
            w54 = 1;
            w65 = obj.TankerRende.getWF() * obj.Refueling.getWF();
            w86 = obj.cruise2.getWF();
            w98 = 1;

            w10_9 = obj.combat.getFuelWeight;

            w12_10 = obj.cruise3.getWF();
            w13_12 = 1;
            w14_13 = obj.loiter2.getWF();
            %Weight fractions during the mission.
            %Numbers indicate the position in the mission.

            obj.PoFractions = w21 * w42 * w54 * w65 * w86 * w98 * w12_10 * w13_12 * w14_13;
            obj.combatFuel = w10_9;
            obj.pBCombat = w21 * w42 * w54 * w65 * w86 * w98;

        end

    end

    methods ( Access = 'private' )
        function init(obj)
            %GUI components initializatiopn.
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
            %Start fuel edit box. 
            %Current not in use. 

            obj.wGAccEdit = uicontrol('Style', 'edit', ...
                'Position', [250, 433, 70, 15], ...
                'Parent', obj.panel, ...
                'String', num2str(obj.wGAcc), ...
                'Callback', @obj.setGroundAccelerate);
            uicontrol('Style', 'text', ...
                'Position', [155, 440, 95, 15], ...
                'Parent', obj.panel, ...
                'String', 'Ground Accelerate');
            uicontrol('Style', 'text', ...
                'Position', [155, 425, 95, 15], ...
                'Parent', obj.panel, ...
                'String', 'weight fraction');
            
            obj.cruise1 = cruise(160, 5, 595, 390, obj.panel);
            obj.TankerRende = cruise(160, 5, 595, 390, obj.panel);
            obj.Refueling = cruise(160, 5, 595, 390, obj.panel);
            obj.cruise2 = cruise(160, 5, 595, 390, obj.panel);
            obj.combat = combatt(160, 5, 595, 390, obj.panel);
            obj.cruise3 = cruise(160, 5, 595, 390, obj.panel);
            obj.loiter2 = loiter(160, 5, 595, 390, obj.panel);

            obj.missionList = uicontrol('Style', 'List', ...
                'String', ...
                {'Cruise 1', 'Tanker Rendezvous', 'Air Refueling', 'Cruise 2', 'Combat', 'Cruise 3', 'Reserve(Loiter)'}, ...
                'Position', [5 5 150 390], ...
                'Parent', obj.panel, ...
                'Callback', @obj.setMission);
            
            obj.currentMission = 1;
            obj.cruise1.show();
        end
        
        %Callback functions. 
        function setStartingFuel(obj, hObject, eventdata)
            obj.startFuel = str2double(get(hObject, 'String'));
        end

        function setGroundAccelerate(obj, hObject, eventdata)
            obj.wGAcc = str2double(get(hObject, 'String'));
        end

        function setClimb(obj, hObject, eventdata)
            obj.wClimb = str2double(get(hObject, 'String'));
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
                    obj.TankerRende.show;
                case 3
                    obj.Refueling.show;
                case 4
                    obj.cruise2.show;
                case 5
                    obj.combat.show;
                case 6
                    obj.cruise3.show;
                case 7
                    obj.loiter2.show;
                otherwise
                    disp('Add more. ');
            end
        end
    end

end
