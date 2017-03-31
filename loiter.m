%The panel for loiter type mission.
classdef loiter < handle

    properties ( Access = 'private' )
        panel
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
        time
        sfc
        %Important data for calculagtions.
    end

    methods

        function obj = loiter(left, buttom, length, height, wS)
            obj.time = 0;
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
            %Edit box for loiter time.

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

        function wf = getWF(obj, LoD)
            %return W(final)/W(initial).
            wf = exp(obj.time * obj.sfc / LoD);
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

        function setSfc(obj, hObject, eventdata)
            obj.sfc = str2double(get(hObject, 'String'));
            %SFC in per hour

            obj.sfc = obj.sfc / 3600;
            %Convert to per second.
        end

    end

end
