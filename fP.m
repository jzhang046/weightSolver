%Panel object to calculate weight fractions.
classdef fP < handle

    properties
        %GUI components.
        panel
        startEdit
        wGAccEdit
        sfcEdit
        LoDEdit
        missionList
    end

    properties
        %Panel objects for specific missions.
        currentMission
        cruise1
        cruise2
        cruise3
        loiter1
        loiter2
        combat
    end

    properties
        %Data for calculations, used by all the missions.
        startFuel
        wGAcc
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
            %The fuel weight fraction panel.
            %It is a uipanel object.

            obj.wGAcc = 0.97;
            obj.sfc = 0.7 / 3600;
            obj.LoD = 9;
            %Initial values.

            obj.init;

        end

        function cal(obj)
            %This function is used to generate corresponding weight fractions with the input data.
            %Calculations are unable to perform unless all the data has been properlly typed,
            %And it's meaningless to update the result everytime when user key in some value.

            w21 = obj.wGAcc;
            w42 = obj.cruise1.getWF(obj.sfc, obj.LoD);
            w54 = 1;
            w65 = obj.loiter1.getWF(obj.sfc, obj.LoD);
            w86 = obj.cruise2.getWF(obj.sfc, obj.LoD);
            w98 = 1;

            w10_9 = obj.combat.getFuelWeight(obj.sfc);

            w12_10 = obj.cruise3.getWF(obj.sfc, obj.LoD);
            w13_12 = 1;
            w14_13 = obj.loiter2.getWF(obj.sfc, obj.LoD);
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

            obj.sfcEdit = uicontrol('Style', 'edit', ...
                'Position', [350, 433, 70, 15], ...
                'Parent', obj.panel, ...
                'String', num2str(obj.sfc * 3600), ...
                'Callback', @obj.setSfc);
            uicontrol('Style', 'text', ...
                'Position', [325, 440, 25, 15], ...
                'Parent', obj.panel, ...
                'String', 'SFC');
            uicontrol('Style', 'text', ...
                'Position', [325, 425, 25, 15], ...
                'Parent', obj.panel, ...
                'String', 'in /h');

            obj.LoDEdit = uicontrol('Style', 'edit', ...
                'Position', [450, 433, 70, 15], ...
                'Parent', obj.panel, ...
                'String', num2str(obj.LoD), ...
                'Callback', @obj.setLoD);
            uicontrol('Style', 'text', ...
                'Position', [425, 433, 25, 15], ...
                'Parent', obj.panel, ...
                'String', 'L/D');

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
