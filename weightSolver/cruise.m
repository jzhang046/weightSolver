%The panel for cruise type mission.
classdef cruise < handle

    properties ( Access = 'private' )
        panel
        rangeEdit
        climbEdit
        sfcEdit
        LoDEdit
        altitudeEdit
        machEdit
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
        range
        speed
        climbWF
        sfc
        LoD
        %Important data for calculagtions.
    end
    
    properties ( Access = 'private' )
        mach
        altitude
        %Data used to calculate for important data. 
    end

    methods

        function obj = cruise(left, buttom, length, height, wS)
            obj.range = 0;
            obj.speed = 871;%Default setting, to avoid crash. Setted to Mach 0.9 at 36000 ft. 
            obj.mach = 0.9;
            obj.altitude = 36000;
            obj.climbWF = 1;
            obj.sfc = 0.7 / 3600;
            obj.LoD = 12;
            %Set default values.

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
            %Edit box for range.

            obj.climbEdit = uicontrol('Style', 'edit', ...
                'FontSize', 12, ...
                'String', num2str(obj.climbWF), ...
                'Position', [150 70 140 20], ...
                'Parent', obj.panel, ...
                'Callback', @obj.setClimbWF);
            uicontrol('Style', 'text', ...
                'Position', [150 95 140 20], ...
                'String', 'Climb Weight Fraction', ...
                'FontSize', 10, ...
                'Parent', obj.panel);
            %Edit box for climb.

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
            
            obj.LoDEdit = uicontrol('Style', 'edit', ...
                'FontSize', 12, ...
                'String', num2str(obj.LoD), ...
                'Position', [150, 200, 140, 20], ...
                'Parent', obj.panel, ...
                'Callback', @obj.setLoD);
            uicontrol('Style', 'text', ...
                'Position', [150, 225, 140, 20], ...
                'String', 'L/D', ...
                'FontSize', 12, ...
                'Parent', obj.panel);
            %Edit box for L/D.
            
            obj.machEdit = uicontrol('Style', 'edit', ...
                'FontSize', 12, ...
                'String', num2str(obj.mach), ...
                'Position', [5, 135, 140, 20], ...
                'Parent', obj.panel, ...
                'Callback', @obj.setMach);
            uicontrol('Style', 'text', ...
                'Position', [5, 160, 140, 20], ...
                'String', 'Mach Number', ...
                'FontSize', 12, ...
                'Parent', obj.panel);
            %Edit box for flight mach number.
            
            obj.altitudeEdit = uicontrol('Style', 'edit', ...
                'FontSize', 12, ...
                'String', num2str(obj.altitude), ...
                'Position', [5, 200, 140, 20], ...
                'Parent', obj.panel, ...
                'Callback', @obj.setAltitude);
            uicontrol('Style', 'text', ...
                'Position', [5, 225, 140, 20], ...
                'String', 'Altitude in ft', ...
                'FontSize', 12, ...
                'Parent', obj.panel);
            %Edit box for altitude.

            uicontrol('Style', 'text', ...
                'Position', [5 95 100 20], ...
                'String', 'Never set mach', ...
                'FontSize', 10, ...
                'Parent', obj.panel);
            uicontrol('Style', 'text', ...
                'Position', [5 70 100 20], ...
                'String', 'to zero', ...
                'FontSize', 10, ...
                'Parent', obj.panel);
            %Indication for speed settings.

        end

        function wf = getWF(obj)
            %return W(final)/W(initial), including climb.
            
            airPpt = atmos(obj.altitude);
            obj.speed = obj.mach * airPpt.a;
            wf = exp(obj.range * obj.sfc / (obj.LoD * obj.speed));
            wf = 1/wf * obj.climbWF;
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

        function setClimbWF(obj, hObject, eventdata)
            obj.climbWF = str2double(get(hObject, 'String'));
            %Climb weight fraction
            %disp(obj.climbWF);
        end

        function setSfc(obj, hObject, eventdata)
            obj.sfc = str2double(get(hObject, 'String'));
            %SFC in per hour

            obj.sfc = obj.sfc / 3600;
            %Convert to per second.
        end
        
        function setLoD(obj, hObject, eventdata)
            obj.LoD = str2double(get(hObject, 'String'));
            %Lift/Drag
        end

        function setAltitude(obj, hObject, eventdata)
            obj.altitude = str2double(get(hObject, 'String'));
            %Altitude and air properties
        end
        
        function setMach(obj, hObject, eventdata)
            obj.mach = str2double(get(hObject, 'String'));
            %Flight mach numebr
            
            %Uncomment this to display and verify calculated speed of sound. 
            %Unit in m/s. 
            %disp(obj.mach * obj.airPpt.a * 0.3048);
        end
        
    end
end
