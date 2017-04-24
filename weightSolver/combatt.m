%The panel for combat type mission.
%Combat may already be a keyword in matlab, thus name was set to combatt.
classdef combatt < handle

    properties ( Access = 'private' )
        panel
        thrustEdit
        timeEdit
        sfcEdit
        %GUI components.
    end

    properties ( Access = 'private' )
        left
        buttom
        length
        height
        wS
        %Information about GUI parent.
    end

    properties ( Access = 'private' )
        thrust
        time
        sfc
        %Important data for calculagtions.
    end

    methods

        function obj = combatt(left, buttom, length, height, wS)
            obj.time = 0;
            obj.thrust = 0;
            obj.sfc = 0.7 / 3600;
            %Set default data.

            obj.left = left;
            obj.buttom = buttom;
            obj.length = length;
            obj.height = height;
            obj.wS = wS;
            %Set GUI properties from parent.

            obj.show;
        end

        function show(obj)
            %Call this method to show the panel.
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
            %Edit box for thrust.

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
            %Edit box for combat time.

            obj.sfcEdit = uicontrol('Style', 'edit', ...
                'FontSize', 12, ...
                'String', num2str(obj.sfc * 3600), ...
                'Position', [150, 135, 140, 20], ...
                'Parent', obj.panel, ...
                'Callback', @obj.setSfc);
            uicontrol('Style', 'text', ...
                'Position', [150, 160, 140, 20], ...
                'String', 'SFC in /h', ...
                'FontSize', 12, ...
                'Parent', obj.panel);
            %Edit box for sfc.

        end

        function w = getFuelWeight(obj)
            %return weight of fuel burnt during combat.
            w = obj.time * obj.thrust * obj.sfc;
        end
    end


    methods ( Access = 'private' )
        function setTime(obj, hObject, eventdata)
            obj.time = str2double(get(hObject, 'String'));
            %time in mins
            obj.time = obj.time * 60;
            %Convert to seconds.
        end

        function setSfc(obj, hObject, eventdata)
            obj.sfc = str2double(get(hObject, 'String'));
            %SFC in per hour

            obj.sfc = obj.sfc / 3600;
            %Convert to per second.
        end

        function setThrust(obj, hObject, eventdata)
            obj.thrust = str2double(get(hObject, 'String'));
            %Thrust in lbs.
        end
    end
end
