classdef Xinnovis_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        XinnovisControlUIFigure         matlab.ui.Figure
        DeviceMenu                      matlab.ui.container.Menu
        FinddeviceMenu                  matlab.ui.container.Menu
        ConnectMenu                     matlab.ui.container.Menu
        DisconnectMenu                  matlab.ui.container.Menu
        ALARMMenu                       matlab.ui.container.Menu
        ExitMenu                        matlab.ui.container.Menu
        PreferencesMenu                 matlab.ui.container.Menu
        UnitsandgastypesMenu            matlab.ui.container.Menu
        HelpMenu                        matlab.ui.container.Menu
        AboutMenu                       matlab.ui.container.Menu
        Button_3                        matlab.ui.control.Button
        Button_2                        matlab.ui.control.Button
        Button                          matlab.ui.control.Button
        CurrentportisEditField          matlab.ui.control.EditField
        CurrentportisEditFieldLabel     matlab.ui.control.Label
        FinddevicePanel                 matlab.ui.container.Panel
        xButton                         matlab.ui.control.Button
        ApplyButton_4                   matlab.ui.control.Button
        FocusingIDDropDown              matlab.ui.control.DropDown
        FocusingIDDropDownLabel         matlab.ui.control.Label
        ExhaustIDDropDown               matlab.ui.control.DropDown
        ExhaustIDDropDownLabel          matlab.ui.control.Label
        CarrierIDDropDown               matlab.ui.control.DropDown
        CarrierIDDropDownLabel          matlab.ui.control.Label
        COMportDropDown                 matlab.ui.control.DropDown
        COMportDropDownLabel            matlab.ui.control.Label
        aboutme                         matlab.ui.control.Label
        Panel                           matlab.ui.container.Panel
        UnitsandgastypesPanel           matlab.ui.container.Panel
        UnitsEditField                  matlab.ui.control.EditField
        UnitsEditFieldLabel             matlab.ui.control.Label
        GastypeEditField                matlab.ui.control.EditField
        GastypeEditFieldLabel           matlab.ui.control.Label
        OKButton                        matlab.ui.control.Button
        CarriergasPanel                 matlab.ui.container.Panel
        Carriertemp                     matlab.ui.control.NumericEditField
        oCEditFieldLabel                matlab.ui.control.Label
        Carrierscale                    matlab.ui.control.NumericEditField
        ApplyButton_3                   matlab.ui.control.Button
        ZeroButton_3                    matlab.ui.control.Button
        sccmLabel_3                     matlab.ui.control.Label
        Carrierinput                    matlab.ui.control.NumericEditField
        MassflowsetpointEditField_3Label  matlab.ui.control.Label
        Image4_3                        matlab.ui.control.Image
        horsep3_3                       matlab.ui.control.Image
        horsep2_3                       matlab.ui.control.Image
        horsep_3                        matlab.ui.control.Image
        CarrierGas                      matlab.ui.control.EditField
        GasEditField_3Label             matlab.ui.control.Label
        CarrierTotal                    matlab.ui.control.NumericEditField
        TotalEditField_3Label           matlab.ui.control.Label
        CarrierSetpoint                 matlab.ui.control.NumericEditField
        SetpointEditField_3Label        matlab.ui.control.Label
        CarrierMassflowrate             matlab.ui.control.NumericEditField
        MassflowrateEditField_3Label    matlab.ui.control.Label
        ExhaustgasPanel                 matlab.ui.container.Panel
        oCEditFieldLabel_2              matlab.ui.control.Label
        Exhausttemp                     matlab.ui.control.NumericEditField
        Exhaustscale                    matlab.ui.control.NumericEditField
        ApplyButton_2                   matlab.ui.control.Button
        ZeroButton_2                    matlab.ui.control.Button
        sccmLabel_2                     matlab.ui.control.Label
        Exhaustinput                    matlab.ui.control.NumericEditField
        MassflowsetpointEditField_2Label  matlab.ui.control.Label
        Image4_2                        matlab.ui.control.Image
        horsep3_2                       matlab.ui.control.Image
        horsep2_2                       matlab.ui.control.Image
        horsep_2                        matlab.ui.control.Image
        ExhaustGas                      matlab.ui.control.EditField
        GasEditField_2Label             matlab.ui.control.Label
        ExhaustTotal                    matlab.ui.control.NumericEditField
        TotalEditField_2Label           matlab.ui.control.Label
        ExhaustSetpoint                 matlab.ui.control.NumericEditField
        SetpointEditField_2Label        matlab.ui.control.Label
        ExhaustMassflowrate             matlab.ui.control.NumericEditField
        MassflowrateEditField_2Label    matlab.ui.control.Label
        FocusinggasPanel                matlab.ui.container.Panel
        oCEditFieldLabel_3              matlab.ui.control.Label
        Focusingtemp                    matlab.ui.control.NumericEditField
        Focusingscale                   matlab.ui.control.NumericEditField
        ApplyButton                     matlab.ui.control.Button
        ZeroButton                      matlab.ui.control.Button
        sccmLabel                       matlab.ui.control.Label
        Focusinginput                   matlab.ui.control.NumericEditField
        MassflowsetpointEditFieldLabel  matlab.ui.control.Label
        Image4                          matlab.ui.control.Image
        horsep3                         matlab.ui.control.Image
        horsep2                         matlab.ui.control.Image
        horsep                          matlab.ui.control.Image
        FocusingGas                     matlab.ui.control.EditField
        GasEditFieldLabel               matlab.ui.control.Label
        FocusingTotal                   matlab.ui.control.NumericEditField
        TotalEditFieldLabel             matlab.ui.control.Label
        FocusingSetpoint                matlab.ui.control.NumericEditField
        SetpointEditFieldLabel          matlab.ui.control.Label
        FocusingMassflowrate            matlab.ui.control.NumericEditField
        MassflowrateEditFieldLabel      matlab.ui.control.Label
        UIAxes                          matlab.ui.control.UIAxes
        Image2                          matlab.ui.control.Image
        Image                           matlab.ui.control.Image
        ConnectionLamp                  matlab.ui.control.Lamp
        ConnectionLampLabel             matlab.ui.control.Label
        ContextMenu                     matlab.ui.container.ContextMenu
        CloseMenu                       matlab.ui.container.Menu
    end

    properties (Access = private)
        %Modbus settings
        m = [];
        port = 'COM1';
        ID1 = 1;
        ID2 = 2;
        ID3 = 3;

        % Cyclic polling
        pollTimer
        isRunning = false

        % Internal buffers (vectorized form)
        read = zeros(1,3)
        set  = zeros(1,3)
        total = zeros(1,3)
        scale = zeros(1,3)
        gas = string();
        units = zeros(1,3)
        temp = zeros(1, 3)

    end

    methods (Access = private)

        function pollDevices(app)

            if isempty(app.m)
                return
            end

            IDs = [app.ID1 app.ID2 app.ID3];

            for l = 1:1
                try
                    % Example register map (adjust to your device)
                    data = read(app.m, 'holdingregs', 21, [2, 1, 1, 6, 1, 2], IDs(l), {'uint16', 'uint32', 'uint64', 'uint16', 'uint32', 'uint16'});

                    app.temp(l) = data(2)/10;
                    app.read(l) = data(3);
                    app.total(l) = data(4);
                    app.set(l) = data(11)/1e3;

                catch
                    % silent fail to avoid timer crash
                    return
                end
            end

            % Update UI

            %Carrier gas
            app.CarrierSetpoint.Value = app.set(1);
            app.CarrierMassflowrate.Value = app.read(1);
            app.CarrierTotal.Value = app.total(1);


            %Exhaust gas
            app.ExhaustSetpoint.Value = app.set(2);
            app.ExhaustMassflowrate.Value = app.read(2);
            app.ExhaustTotal.Value = app.total(2);

            %Focusing gas
            app.FocusingSetpoint.Value = app.set(3);
            app.FocusingMassflowrate.Value = app.read(3);
            app.FocusingTotal.Value = app.total(3);

            app.Carriertemp.Value = app.temp(1);
            app.Exhausttemp.Value = app.temp(2);
            app.Focusingtemp.Value = app.temp(3);
        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Menu selected function: ConnectMenu
        function ConnectMenuSelected(app, event)
            app.m = modbus('serialrtu', app.port);
            app.m.Timeout = 0.3;

            % Create timer AFTER connection
            app.pollTimer = timer( ...
                'ExecutionMode','fixedRate', ...
                'Period',0.2, ...          % 200 ms cycle
                'BusyMode','queue', ...
                'TimerFcn',@(~,~)app.pollDevices());

            app.ConnectionLamp.Enable = "on";
            app.DisconnectMenu.Enable = "on";
            app.ConnectMenu.Enable = 'off';
            app.Button.Enable = "on";
            app.Button_2.Enable = "on";
        end

        % Menu selected function: ExitMenu
        function ExitMenuSelected(app, event)
            clear app.m
            app.ConnectionLamp.Enable = "off";
            pause(0.2)

            if ~isempty(app.pollTimer) && isvalid(app.pollTimer)
                stop(app.pollTimer);
                delete(app.pollTimer);
            end

            if ~isempty(app.m)
                clear app.m
            end

            delete(app);
        end

        % Callback function: AboutMenu, Button_3
        function AboutMenuSelected(app, event)
            app.aboutme.Enable = "on";
            app.aboutme.Visible = "on";
        end

        % Menu selected function: CloseMenu
        function CloseMenuSelected(app, event)
            app.aboutme.Enable = "off";
            app.aboutme.Visible = "off";
        end

        % Menu selected function: ALARMMenu
        function ALARMMenuSelected(app, event)
            uialert(app.XinnovisControlUIFigure, 'АХТУНГ БЛЯТЬ!!!!!', 'АШЫПКА НАХУЙ!!!')
        end

        % Menu selected function: UnitsandgastypesMenu
        function UnitsandgastypesMenuSelected(app, event)
            app.UnitsandgastypesPanel.Enable = "on";
            app.UnitsandgastypesPanel.Visible = "on";
        end

        % Button pushed function: OKButton
        function OKButtonPushed(app, event)
            app.UnitsandgastypesPanel.Enable = "off";
            app.UnitsandgastypesPanel.Visible = "off";
        end

        % Menu selected function: DisconnectMenu
        function DisconnectMenuSelected(app, event)
            if app.isRunning
                stop(app.pollTimer);
                delete(app.pollTimer);
                app.isRunning = false;
            end

            clear app.m

            app.ConnectionLamp.Enable = "off";
            app.DisconnectMenu.Enable = "off";
            app.ConnectMenu.Enable = 'off';
            app.Panel.Visible = "off";
            app.FinddeviceMenu.Enable = "off";
        end

        % Button pushed function: Button
        function ButtonPushed(app, event)
            IDs = [app.ID1 app.ID2 app.ID3];

            for k = 1:1
                data = read(app.m, 'holdingregs', 4, [1, 2], IDs(k), {'int16', 'uint16'});

                app.scale(k) = data(2);
                app.units(k) = data(3);

                gt = data(1);
                switch gt
                    case 1
                        app.gas(k) = 'He';
                    case 2
                        app.gas(k) = 'CO';
                    case 4
                        app.gas(k) = 'Ar';
                    case 7
                        app.gas(k) = 'H2';
                    case 8
                        app.gas(k) = 'Air';
                    case 13
                        app.gas(k) = 'N2';
                    case 15
                        app.gas(k) = 'O2';
                    case 25
                        app.gas(k) = 'CO2';
                    case 28
                        app.gas(k) = 'CH4';
                    otherwise
                        app.gas(k) = 'Undefined';
                end

            end

            % Assign to UI properly
            app.Carrierscale.Value  = app.scale(1);
            app.Exhaustscale.Value  = app.scale(2);
            app.Focusingscale.Value = app.scale(3);

            app.Carrierinput.Limits = [0 app.scale(1)];
            app.Exhaustinput.Limits = [0 app.scale(2)];
            app.Focusinginput.Limits = [0 app.scale(3)];

            app.CarrierGas.Value = app.gas(1);
            % app.ExhaustGas.Value = app.gas(2);
            % app.FocusingGas.Value = app.gas(3);

            app.Panel.Visible = "on";
        end

        % Menu selected function: FinddeviceMenu
        function FinddeviceMenuSelected(app, event)
            app.FinddevicePanel.Visible = "on";
        end

        % Button pushed function: xButton
        function xButtonPushed(app, event)
            app.FinddevicePanel.Visible = "off";
        end

        % Button pushed function: ApplyButton_4
        function ApplyButton_4Pushed(app, event)
            app.port = app.COMportDropDown.Value;

            app.ID1 = str2double(app.CarrierIDDropDown.Value);
            app.ID2 = str2double(app.ExhaustIDDropDown.Value);
            app.ID3 = str2double(app.FocusingIDDropDown.Value);

            app.CurrentportisEditField.Value = app.port;

            app.ConnectMenu.Enable = "on";
            app.FinddevicePanel.Visible = "off";
        end

        % Button pushed function: Button_2
        function Button_2Pushed(app, event)
            if ~app.isRunning
                start(app.pollTimer);
                app.isRunning = true;
            end
        end

        % Value changed function: Focusinginput
        function FocusinginputValueChanged(app, event)
            value = app.Focusinginput.Value;
            % write(app.m,'holdingregs',10,value,app.ID3);
        end

        % Callback function: ApplyButton_3, Carrierinput
        function CarriersetpointValueChanged(app, event)
            value = app.Carrierinput.Value*1e3;
            write(app.m,'holdingregs', 35, value, 'uint32');
        end

        % Button pushed function: ZeroButton_3
        function ZeroButton_3Pushed(app, event)
            write(app.m,'holdingregs', 35, 0, 'uint32');
            app.Carrierinput.Value = 0;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create XinnovisControlUIFigure and hide until all components are created
            app.XinnovisControlUIFigure = uifigure('Visible', 'off');
            app.XinnovisControlUIFigure.Color = [0.2314 0.2314 0.2314];
            app.XinnovisControlUIFigure.Position = [500 500 1280 720];
            app.XinnovisControlUIFigure.Name = 'Xinnovis Control';
            app.XinnovisControlUIFigure.Icon = fullfile(pathToMLAPP, 'xinnovis_logo.jpg');
            app.XinnovisControlUIFigure.Resize = 'off';

            % Create DeviceMenu
            app.DeviceMenu = uimenu(app.XinnovisControlUIFigure);
            app.DeviceMenu.Text = 'Device';

            % Create FinddeviceMenu
            app.FinddeviceMenu = uimenu(app.DeviceMenu);
            app.FinddeviceMenu.MenuSelectedFcn = createCallbackFcn(app, @FinddeviceMenuSelected, true);
            app.FinddeviceMenu.Text = 'Find device';

            % Create ConnectMenu
            app.ConnectMenu = uimenu(app.DeviceMenu);
            app.ConnectMenu.MenuSelectedFcn = createCallbackFcn(app, @ConnectMenuSelected, true);
            app.ConnectMenu.Enable = 'off';
            app.ConnectMenu.Separator = 'on';
            app.ConnectMenu.Accelerator = 'C';
            app.ConnectMenu.Text = 'Connect';

            % Create DisconnectMenu
            app.DisconnectMenu = uimenu(app.DeviceMenu);
            app.DisconnectMenu.MenuSelectedFcn = createCallbackFcn(app, @DisconnectMenuSelected, true);
            app.DisconnectMenu.Enable = 'off';
            app.DisconnectMenu.Separator = 'on';
            app.DisconnectMenu.Accelerator = 'D';
            app.DisconnectMenu.Text = 'Disconnect';

            % Create ALARMMenu
            app.ALARMMenu = uimenu(app.DeviceMenu);
            app.ALARMMenu.MenuSelectedFcn = createCallbackFcn(app, @ALARMMenuSelected, true);
            app.ALARMMenu.Separator = 'on';
            app.ALARMMenu.Text = 'ALARM';

            % Create ExitMenu
            app.ExitMenu = uimenu(app.DeviceMenu);
            app.ExitMenu.MenuSelectedFcn = createCallbackFcn(app, @ExitMenuSelected, true);
            app.ExitMenu.Separator = 'on';
            app.ExitMenu.Accelerator = 'Q';
            app.ExitMenu.Text = 'Exit';

            % Create PreferencesMenu
            app.PreferencesMenu = uimenu(app.XinnovisControlUIFigure);
            app.PreferencesMenu.Text = 'Preferences';

            % Create UnitsandgastypesMenu
            app.UnitsandgastypesMenu = uimenu(app.PreferencesMenu);
            app.UnitsandgastypesMenu.MenuSelectedFcn = createCallbackFcn(app, @UnitsandgastypesMenuSelected, true);
            app.UnitsandgastypesMenu.Enable = 'off';
            app.UnitsandgastypesMenu.Text = 'Units and gas types';

            % Create HelpMenu
            app.HelpMenu = uimenu(app.XinnovisControlUIFigure);
            app.HelpMenu.Text = 'Help';

            % Create AboutMenu
            app.AboutMenu = uimenu(app.HelpMenu);
            app.AboutMenu.MenuSelectedFcn = createCallbackFcn(app, @AboutMenuSelected, true);
            app.AboutMenu.Text = 'About';

            % Create ConnectionLampLabel
            app.ConnectionLampLabel = uilabel(app.XinnovisControlUIFigure);
            app.ConnectionLampLabel.HorizontalAlignment = 'center';
            app.ConnectionLampLabel.FontName = 'Segoe UI Light';
            app.ConnectionLampLabel.FontColor = [0.9412 0.9412 0.9412];
            app.ConnectionLampLabel.Position = [1151 684 63 22];
            app.ConnectionLampLabel.Text = 'Connection';

            % Create ConnectionLamp
            app.ConnectionLamp = uilamp(app.XinnovisControlUIFigure);
            app.ConnectionLamp.Enable = 'off';
            app.ConnectionLamp.Position = [1245 683 20 20];

            % Create Image
            app.Image = uiimage(app.XinnovisControlUIFigure);
            app.Image.Position = [10 626 80 80];
            app.Image.ImageSource = fullfile(pathToMLAPP, 'xinnovis_logo.jpg');

            % Create Image2
            app.Image2 = uiimage(app.XinnovisControlUIFigure);
            app.Image2.Position = [57 1 100 720];
            app.Image2.ImageSource = fullfile(pathToMLAPP, 'sep_white_1pt.svg');

            % Create Panel
            app.Panel = uipanel(app.XinnovisControlUIFigure);
            app.Panel.BorderColor = [0.2314 0.2314 0.2314];
            app.Panel.Visible = 'off';
            app.Panel.BackgroundColor = [0.2314 0.2314 0.2314];
            app.Panel.Position = [156 13 1100 661];

            % Create UIAxes
            app.UIAxes = uiaxes(app.Panel);
            xlabel(app.UIAxes, 'time, s')
            ylabel(app.UIAxes, 'Mass flow, sccm')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.FontName = 'Segoe UI Light';
            app.UIAxes.GridLineWidth = 1;
            app.UIAxes.XColor = [1 1 1];
            app.UIAxes.YColor = [1 1 1];
            app.UIAxes.LineWidth = 2;
            app.UIAxes.Color = 'none';
            app.UIAxes.GridColor = [1 1 1];
            app.UIAxes.GridAlpha = 1;
            app.UIAxes.YGrid = 'on';
            app.UIAxes.FontSize = 14;
            app.UIAxes.Position = [560 27 501 606];

            % Create FocusinggasPanel
            app.FocusinggasPanel = uipanel(app.Panel);
            app.FocusinggasPanel.BorderColor = [1 1 1];
            app.FocusinggasPanel.ForegroundColor = [1 1 1];
            app.FocusinggasPanel.BorderWidth = 3;
            app.FocusinggasPanel.TitlePosition = 'centertop';
            app.FocusinggasPanel.Title = 'Focusing gas';
            app.FocusinggasPanel.BackgroundColor = [0.2314 0.2314 0.2314];
            app.FocusinggasPanel.FontName = 'Segoe UI';
            app.FocusinggasPanel.FontSize = 18;
            app.FocusinggasPanel.Position = [29 20 500 200];

            % Create MassflowrateEditFieldLabel
            app.MassflowrateEditFieldLabel = uilabel(app.FocusinggasPanel);
            app.MassflowrateEditFieldLabel.FontName = 'Segoe UI Light';
            app.MassflowrateEditFieldLabel.FontSize = 14;
            app.MassflowrateEditFieldLabel.FontColor = [1 1 1];
            app.MassflowrateEditFieldLabel.Position = [18 131 89 22];
            app.MassflowrateEditFieldLabel.Text = 'Mass flow rate';

            % Create FocusingMassflowrate
            app.FocusingMassflowrate = uieditfield(app.FocusinggasPanel, 'numeric');
            app.FocusingMassflowrate.Editable = 'off';
            app.FocusingMassflowrate.FontName = 'Segoe UI Light';
            app.FocusingMassflowrate.FontSize = 14;
            app.FocusingMassflowrate.FontColor = [1 1 1];
            app.FocusingMassflowrate.BackgroundColor = [0.2314 0.2314 0.2314];
            app.FocusingMassflowrate.Position = [127 131 100 22];

            % Create SetpointEditFieldLabel
            app.SetpointEditFieldLabel = uilabel(app.FocusinggasPanel);
            app.SetpointEditFieldLabel.FontName = 'Segoe UI Light';
            app.SetpointEditFieldLabel.FontSize = 14;
            app.SetpointEditFieldLabel.FontColor = [0.4667 0.6745 0.1882];
            app.SetpointEditFieldLabel.Position = [18 93 53 22];
            app.SetpointEditFieldLabel.Text = 'Setpoint';

            % Create FocusingSetpoint
            app.FocusingSetpoint = uieditfield(app.FocusinggasPanel, 'numeric');
            app.FocusingSetpoint.Editable = 'off';
            app.FocusingSetpoint.FontName = 'Segoe UI Light';
            app.FocusingSetpoint.FontSize = 14;
            app.FocusingSetpoint.FontColor = [0.4667 0.6745 0.1882];
            app.FocusingSetpoint.BackgroundColor = [0.2314 0.2314 0.2314];
            app.FocusingSetpoint.Position = [127 95 100 22];

            % Create TotalEditFieldLabel
            app.TotalEditFieldLabel = uilabel(app.FocusinggasPanel);
            app.TotalEditFieldLabel.FontName = 'Segoe UI Light';
            app.TotalEditFieldLabel.FontSize = 14;
            app.TotalEditFieldLabel.FontColor = [1 1 1];
            app.TotalEditFieldLabel.Position = [18 53 32 22];
            app.TotalEditFieldLabel.Text = 'Total';

            % Create FocusingTotal
            app.FocusingTotal = uieditfield(app.FocusinggasPanel, 'numeric');
            app.FocusingTotal.Editable = 'off';
            app.FocusingTotal.FontName = 'Segoe UI Light';
            app.FocusingTotal.FontSize = 14;
            app.FocusingTotal.FontColor = [1 1 1];
            app.FocusingTotal.BackgroundColor = [0.2314 0.2314 0.2314];
            app.FocusingTotal.Position = [127 57 100 22];

            % Create GasEditFieldLabel
            app.GasEditFieldLabel = uilabel(app.FocusinggasPanel);
            app.GasEditFieldLabel.BackgroundColor = [0.2314 0.2314 0.2314];
            app.GasEditFieldLabel.FontName = 'Segoe UI Light';
            app.GasEditFieldLabel.FontSize = 14;
            app.GasEditFieldLabel.FontColor = [1 1 1];
            app.GasEditFieldLabel.Position = [18 17 27 22];
            app.GasEditFieldLabel.Text = 'Gas';

            % Create FocusingGas
            app.FocusingGas = uieditfield(app.FocusinggasPanel, 'text');
            app.FocusingGas.Editable = 'off';
            app.FocusingGas.FontName = 'Segoe UI Light';
            app.FocusingGas.FontSize = 14;
            app.FocusingGas.FontColor = [1 1 1];
            app.FocusingGas.BackgroundColor = [0.2314 0.2314 0.2314];
            app.FocusingGas.Position = [127 17 100 22];

            % Create horsep
            app.horsep = uiimage(app.FocusinggasPanel);
            app.horsep.Position = [18 119 209 10];
            app.horsep.ImageSource = fullfile(pathToMLAPP, 'horizontal_sep.svg');

            % Create horsep2
            app.horsep2 = uiimage(app.FocusinggasPanel);
            app.horsep2.Position = [18 81 209 10];
            app.horsep2.ImageSource = fullfile(pathToMLAPP, 'horizontal_sep.svg');

            % Create horsep3
            app.horsep3 = uiimage(app.FocusinggasPanel);
            app.horsep3.Position = [18 41 209 10];
            app.horsep3.ImageSource = fullfile(pathToMLAPP, 'horizontal_sep.svg');

            % Create Image4
            app.Image4 = uiimage(app.FocusinggasPanel);
            app.Image4.Position = [246 16 239 141];
            app.Image4.ImageSource = fullfile(pathToMLAPP, 'control_box.svg');

            % Create MassflowsetpointEditFieldLabel
            app.MassflowsetpointEditFieldLabel = uilabel(app.FocusinggasPanel);
            app.MassflowsetpointEditFieldLabel.FontName = 'Segoe UI Light';
            app.MassflowsetpointEditFieldLabel.FontSize = 14;
            app.MassflowsetpointEditFieldLabel.FontColor = [1 1 1];
            app.MassflowsetpointEditFieldLabel.Position = [264 112 113 22];
            app.MassflowsetpointEditFieldLabel.Text = 'Mass flow setpoint';

            % Create Focusinginput
            app.Focusinginput = uieditfield(app.FocusinggasPanel, 'numeric');
            app.Focusinginput.ValueChangedFcn = createCallbackFcn(app, @FocusinginputValueChanged, true);
            app.Focusinginput.FontName = 'Segoe UI Light';
            app.Focusinginput.FontSize = 14;
            app.Focusinginput.FontColor = [0.4667 0.6745 0.1882];
            app.Focusinginput.BackgroundColor = [0.2314 0.2314 0.2314];
            app.Focusinginput.Position = [264 79 140 22];

            % Create sccmLabel
            app.sccmLabel = uilabel(app.FocusinggasPanel);
            app.sccmLabel.FontName = 'Segoe UI Light';
            app.sccmLabel.FontSize = 14;
            app.sccmLabel.FontColor = [1 1 1];
            app.sccmLabel.Position = [430 79 34 22];
            app.sccmLabel.Text = 'sccm';

            % Create ZeroButton
            app.ZeroButton = uibutton(app.FocusinggasPanel, 'push');
            app.ZeroButton.BackgroundColor = [0.2314 0.2314 0.2314];
            app.ZeroButton.FontName = 'Segoe UI Light';
            app.ZeroButton.FontColor = [1 1 1];
            app.ZeroButton.Position = [264 29 85 35];
            app.ZeroButton.Text = 'Zero';

            % Create ApplyButton
            app.ApplyButton = uibutton(app.FocusinggasPanel, 'push');
            app.ApplyButton.BackgroundColor = [0.7176 0.1137 0.1216];
            app.ApplyButton.FontName = 'Segoe UI Light';
            app.ApplyButton.FontColor = [1 1 1];
            app.ApplyButton.Position = [379 29 85 35];
            app.ApplyButton.Text = 'Apply';

            % Create Focusingscale
            app.Focusingscale = uieditfield(app.FocusinggasPanel, 'numeric');
            app.Focusingscale.Editable = 'off';
            app.Focusingscale.HorizontalAlignment = 'center';
            app.Focusingscale.FontColor = [0.9412 0.9412 0.9412];
            app.Focusingscale.BackgroundColor = [0.2314 0.2314 0.2314];
            app.Focusingscale.Position = [393 171 100 22];

            % Create Focusingtemp
            app.Focusingtemp = uieditfield(app.FocusinggasPanel, 'numeric');
            app.Focusingtemp.Editable = 'off';
            app.Focusingtemp.HorizontalAlignment = 'center';
            app.Focusingtemp.FontColor = [1 1 1];
            app.Focusingtemp.BackgroundColor = [0.2314 0.2314 0.2314];
            app.Focusingtemp.Position = [18 171 100 22];

            % Create oCEditFieldLabel_3
            app.oCEditFieldLabel_3 = uilabel(app.FocusinggasPanel);
            app.oCEditFieldLabel_3.Interpreter = 'tex';
            app.oCEditFieldLabel_3.HorizontalAlignment = 'right';
            app.oCEditFieldLabel_3.FontColor = [1 1 1];
            app.oCEditFieldLabel_3.Position = [120 171 29 22];
            app.oCEditFieldLabel_3.Text = '^o C';

            % Create ExhaustgasPanel
            app.ExhaustgasPanel = uipanel(app.Panel);
            app.ExhaustgasPanel.BorderColor = [1 1 1];
            app.ExhaustgasPanel.ForegroundColor = [1 1 1];
            app.ExhaustgasPanel.BorderWidth = 3;
            app.ExhaustgasPanel.TitlePosition = 'centertop';
            app.ExhaustgasPanel.Title = 'Exhaust gas';
            app.ExhaustgasPanel.BackgroundColor = [0.2314 0.2314 0.2314];
            app.ExhaustgasPanel.FontName = 'Segoe UI';
            app.ExhaustgasPanel.FontSize = 18;
            app.ExhaustgasPanel.Position = [29 230 500 200];

            % Create MassflowrateEditField_2Label
            app.MassflowrateEditField_2Label = uilabel(app.ExhaustgasPanel);
            app.MassflowrateEditField_2Label.FontName = 'Segoe UI Light';
            app.MassflowrateEditField_2Label.FontSize = 14;
            app.MassflowrateEditField_2Label.FontColor = [1 1 1];
            app.MassflowrateEditField_2Label.Position = [18 131 89 22];
            app.MassflowrateEditField_2Label.Text = 'Mass flow rate';

            % Create ExhaustMassflowrate
            app.ExhaustMassflowrate = uieditfield(app.ExhaustgasPanel, 'numeric');
            app.ExhaustMassflowrate.Editable = 'off';
            app.ExhaustMassflowrate.FontName = 'Segoe UI Light';
            app.ExhaustMassflowrate.FontSize = 14;
            app.ExhaustMassflowrate.FontColor = [1 1 1];
            app.ExhaustMassflowrate.BackgroundColor = [0.2314 0.2314 0.2314];
            app.ExhaustMassflowrate.Position = [127 131 100 22];

            % Create SetpointEditField_2Label
            app.SetpointEditField_2Label = uilabel(app.ExhaustgasPanel);
            app.SetpointEditField_2Label.FontName = 'Segoe UI Light';
            app.SetpointEditField_2Label.FontSize = 14;
            app.SetpointEditField_2Label.FontColor = [0.4667 0.6745 0.1882];
            app.SetpointEditField_2Label.Position = [18 93 53 22];
            app.SetpointEditField_2Label.Text = 'Setpoint';

            % Create ExhaustSetpoint
            app.ExhaustSetpoint = uieditfield(app.ExhaustgasPanel, 'numeric');
            app.ExhaustSetpoint.Editable = 'off';
            app.ExhaustSetpoint.FontName = 'Segoe UI Light';
            app.ExhaustSetpoint.FontSize = 14;
            app.ExhaustSetpoint.FontColor = [0.4667 0.6745 0.1882];
            app.ExhaustSetpoint.BackgroundColor = [0.2314 0.2314 0.2314];
            app.ExhaustSetpoint.Position = [127 95 100 22];

            % Create TotalEditField_2Label
            app.TotalEditField_2Label = uilabel(app.ExhaustgasPanel);
            app.TotalEditField_2Label.FontName = 'Segoe UI Light';
            app.TotalEditField_2Label.FontSize = 14;
            app.TotalEditField_2Label.FontColor = [1 1 1];
            app.TotalEditField_2Label.Position = [18 53 32 22];
            app.TotalEditField_2Label.Text = 'Total';

            % Create ExhaustTotal
            app.ExhaustTotal = uieditfield(app.ExhaustgasPanel, 'numeric');
            app.ExhaustTotal.Editable = 'off';
            app.ExhaustTotal.FontName = 'Segoe UI Light';
            app.ExhaustTotal.FontSize = 14;
            app.ExhaustTotal.FontColor = [1 1 1];
            app.ExhaustTotal.BackgroundColor = [0.2314 0.2314 0.2314];
            app.ExhaustTotal.Position = [127 57 100 22];

            % Create GasEditField_2Label
            app.GasEditField_2Label = uilabel(app.ExhaustgasPanel);
            app.GasEditField_2Label.BackgroundColor = [0.2314 0.2314 0.2314];
            app.GasEditField_2Label.FontName = 'Segoe UI Light';
            app.GasEditField_2Label.FontSize = 14;
            app.GasEditField_2Label.FontColor = [1 1 1];
            app.GasEditField_2Label.Position = [18 17 27 22];
            app.GasEditField_2Label.Text = 'Gas';

            % Create ExhaustGas
            app.ExhaustGas = uieditfield(app.ExhaustgasPanel, 'text');
            app.ExhaustGas.Editable = 'off';
            app.ExhaustGas.FontName = 'Segoe UI Light';
            app.ExhaustGas.FontSize = 14;
            app.ExhaustGas.FontColor = [1 1 1];
            app.ExhaustGas.BackgroundColor = [0.2314 0.2314 0.2314];
            app.ExhaustGas.Position = [127 17 100 22];

            % Create horsep_2
            app.horsep_2 = uiimage(app.ExhaustgasPanel);
            app.horsep_2.Position = [18 119 209 10];
            app.horsep_2.ImageSource = fullfile(pathToMLAPP, 'horizontal_sep.svg');

            % Create horsep2_2
            app.horsep2_2 = uiimage(app.ExhaustgasPanel);
            app.horsep2_2.Position = [18 81 209 10];
            app.horsep2_2.ImageSource = fullfile(pathToMLAPP, 'horizontal_sep.svg');

            % Create horsep3_2
            app.horsep3_2 = uiimage(app.ExhaustgasPanel);
            app.horsep3_2.Position = [18 41 209 10];
            app.horsep3_2.ImageSource = fullfile(pathToMLAPP, 'horizontal_sep.svg');

            % Create Image4_2
            app.Image4_2 = uiimage(app.ExhaustgasPanel);
            app.Image4_2.Position = [246 16 239 141];
            app.Image4_2.ImageSource = fullfile(pathToMLAPP, 'control_box.svg');

            % Create MassflowsetpointEditField_2Label
            app.MassflowsetpointEditField_2Label = uilabel(app.ExhaustgasPanel);
            app.MassflowsetpointEditField_2Label.FontName = 'Segoe UI Light';
            app.MassflowsetpointEditField_2Label.FontSize = 14;
            app.MassflowsetpointEditField_2Label.FontColor = [1 1 1];
            app.MassflowsetpointEditField_2Label.Position = [264 112 113 22];
            app.MassflowsetpointEditField_2Label.Text = 'Mass flow setpoint';

            % Create Exhaustinput
            app.Exhaustinput = uieditfield(app.ExhaustgasPanel, 'numeric');
            app.Exhaustinput.FontName = 'Segoe UI Light';
            app.Exhaustinput.FontSize = 14;
            app.Exhaustinput.FontColor = [0.4667 0.6745 0.1882];
            app.Exhaustinput.BackgroundColor = [0.2314 0.2314 0.2314];
            app.Exhaustinput.Position = [264 79 140 22];

            % Create sccmLabel_2
            app.sccmLabel_2 = uilabel(app.ExhaustgasPanel);
            app.sccmLabel_2.FontName = 'Segoe UI Light';
            app.sccmLabel_2.FontSize = 14;
            app.sccmLabel_2.FontColor = [1 1 1];
            app.sccmLabel_2.Position = [430 79 34 22];
            app.sccmLabel_2.Text = 'sccm';

            % Create ZeroButton_2
            app.ZeroButton_2 = uibutton(app.ExhaustgasPanel, 'push');
            app.ZeroButton_2.BackgroundColor = [0.2314 0.2314 0.2314];
            app.ZeroButton_2.FontName = 'Segoe UI Light';
            app.ZeroButton_2.FontColor = [1 1 1];
            app.ZeroButton_2.Position = [264 29 85 35];
            app.ZeroButton_2.Text = 'Zero';

            % Create ApplyButton_2
            app.ApplyButton_2 = uibutton(app.ExhaustgasPanel, 'push');
            app.ApplyButton_2.BackgroundColor = [0.7176 0.1137 0.1216];
            app.ApplyButton_2.FontName = 'Segoe UI Light';
            app.ApplyButton_2.FontColor = [1 1 1];
            app.ApplyButton_2.Position = [379 29 85 35];
            app.ApplyButton_2.Text = 'Apply';

            % Create Exhaustscale
            app.Exhaustscale = uieditfield(app.ExhaustgasPanel, 'numeric');
            app.Exhaustscale.Editable = 'off';
            app.Exhaustscale.HorizontalAlignment = 'center';
            app.Exhaustscale.FontColor = [0.9412 0.9412 0.9412];
            app.Exhaustscale.BackgroundColor = [0.2314 0.2314 0.2314];
            app.Exhaustscale.Position = [393 171 100 22];

            % Create Exhausttemp
            app.Exhausttemp = uieditfield(app.ExhaustgasPanel, 'numeric');
            app.Exhausttemp.Editable = 'off';
            app.Exhausttemp.HorizontalAlignment = 'center';
            app.Exhausttemp.FontColor = [1 1 1];
            app.Exhausttemp.BackgroundColor = [0.2314 0.2314 0.2314];
            app.Exhausttemp.Position = [18 171 100 22];

            % Create oCEditFieldLabel_2
            app.oCEditFieldLabel_2 = uilabel(app.ExhaustgasPanel);
            app.oCEditFieldLabel_2.Interpreter = 'tex';
            app.oCEditFieldLabel_2.HorizontalAlignment = 'right';
            app.oCEditFieldLabel_2.FontColor = [1 1 1];
            app.oCEditFieldLabel_2.Position = [120 171 29 22];
            app.oCEditFieldLabel_2.Text = '^o C';

            % Create CarriergasPanel
            app.CarriergasPanel = uipanel(app.Panel);
            app.CarriergasPanel.BorderColor = [1 1 1];
            app.CarriergasPanel.ForegroundColor = [1 1 1];
            app.CarriergasPanel.BorderWidth = 3;
            app.CarriergasPanel.TitlePosition = 'centertop';
            app.CarriergasPanel.Title = 'Carrier gas';
            app.CarriergasPanel.BackgroundColor = [0.2314 0.2314 0.2314];
            app.CarriergasPanel.FontName = 'Segoe UI';
            app.CarriergasPanel.FontSize = 18;
            app.CarriergasPanel.Position = [29 440 500 200];

            % Create MassflowrateEditField_3Label
            app.MassflowrateEditField_3Label = uilabel(app.CarriergasPanel);
            app.MassflowrateEditField_3Label.FontName = 'Segoe UI Light';
            app.MassflowrateEditField_3Label.FontSize = 14;
            app.MassflowrateEditField_3Label.FontColor = [1 1 1];
            app.MassflowrateEditField_3Label.Position = [18 131 89 22];
            app.MassflowrateEditField_3Label.Text = 'Mass flow rate';

            % Create CarrierMassflowrate
            app.CarrierMassflowrate = uieditfield(app.CarriergasPanel, 'numeric');
            app.CarrierMassflowrate.Editable = 'off';
            app.CarrierMassflowrate.FontName = 'Segoe UI Light';
            app.CarrierMassflowrate.FontSize = 14;
            app.CarrierMassflowrate.FontColor = [1 1 1];
            app.CarrierMassflowrate.BackgroundColor = [0.2314 0.2314 0.2314];
            app.CarrierMassflowrate.Position = [127 131 100 22];

            % Create SetpointEditField_3Label
            app.SetpointEditField_3Label = uilabel(app.CarriergasPanel);
            app.SetpointEditField_3Label.FontName = 'Segoe UI Light';
            app.SetpointEditField_3Label.FontSize = 14;
            app.SetpointEditField_3Label.FontColor = [0.4667 0.6745 0.1882];
            app.SetpointEditField_3Label.Position = [18 93 53 22];
            app.SetpointEditField_3Label.Text = 'Setpoint';

            % Create CarrierSetpoint
            app.CarrierSetpoint = uieditfield(app.CarriergasPanel, 'numeric');
            app.CarrierSetpoint.Editable = 'off';
            app.CarrierSetpoint.FontName = 'Segoe UI Light';
            app.CarrierSetpoint.FontSize = 14;
            app.CarrierSetpoint.FontColor = [0.4667 0.6745 0.1882];
            app.CarrierSetpoint.BackgroundColor = [0.2314 0.2314 0.2314];
            app.CarrierSetpoint.Position = [127 95 100 22];

            % Create TotalEditField_3Label
            app.TotalEditField_3Label = uilabel(app.CarriergasPanel);
            app.TotalEditField_3Label.FontName = 'Segoe UI Light';
            app.TotalEditField_3Label.FontSize = 14;
            app.TotalEditField_3Label.FontColor = [1 1 1];
            app.TotalEditField_3Label.Position = [18 53 32 22];
            app.TotalEditField_3Label.Text = 'Total';

            % Create CarrierTotal
            app.CarrierTotal = uieditfield(app.CarriergasPanel, 'numeric');
            app.CarrierTotal.Editable = 'off';
            app.CarrierTotal.FontName = 'Segoe UI Light';
            app.CarrierTotal.FontSize = 14;
            app.CarrierTotal.FontColor = [1 1 1];
            app.CarrierTotal.BackgroundColor = [0.2314 0.2314 0.2314];
            app.CarrierTotal.Position = [127 57 100 22];

            % Create GasEditField_3Label
            app.GasEditField_3Label = uilabel(app.CarriergasPanel);
            app.GasEditField_3Label.BackgroundColor = [0.2314 0.2314 0.2314];
            app.GasEditField_3Label.FontName = 'Segoe UI Light';
            app.GasEditField_3Label.FontSize = 14;
            app.GasEditField_3Label.FontColor = [1 1 1];
            app.GasEditField_3Label.Position = [18 17 27 22];
            app.GasEditField_3Label.Text = 'Gas';

            % Create CarrierGas
            app.CarrierGas = uieditfield(app.CarriergasPanel, 'text');
            app.CarrierGas.Editable = 'off';
            app.CarrierGas.FontName = 'Segoe UI Light';
            app.CarrierGas.FontSize = 14;
            app.CarrierGas.FontColor = [1 1 1];
            app.CarrierGas.BackgroundColor = [0.2314 0.2314 0.2314];
            app.CarrierGas.Position = [127 17 100 22];

            % Create horsep_3
            app.horsep_3 = uiimage(app.CarriergasPanel);
            app.horsep_3.Position = [18 119 209 10];
            app.horsep_3.ImageSource = fullfile(pathToMLAPP, 'horizontal_sep.svg');

            % Create horsep2_3
            app.horsep2_3 = uiimage(app.CarriergasPanel);
            app.horsep2_3.Position = [18 81 209 10];
            app.horsep2_3.ImageSource = fullfile(pathToMLAPP, 'horizontal_sep.svg');

            % Create horsep3_3
            app.horsep3_3 = uiimage(app.CarriergasPanel);
            app.horsep3_3.Position = [18 41 209 10];
            app.horsep3_3.ImageSource = fullfile(pathToMLAPP, 'horizontal_sep.svg');

            % Create Image4_3
            app.Image4_3 = uiimage(app.CarriergasPanel);
            app.Image4_3.Position = [246 16 239 141];
            app.Image4_3.ImageSource = fullfile(pathToMLAPP, 'control_box.svg');

            % Create MassflowsetpointEditField_3Label
            app.MassflowsetpointEditField_3Label = uilabel(app.CarriergasPanel);
            app.MassflowsetpointEditField_3Label.FontName = 'Segoe UI Light';
            app.MassflowsetpointEditField_3Label.FontSize = 14;
            app.MassflowsetpointEditField_3Label.FontColor = [1 1 1];
            app.MassflowsetpointEditField_3Label.Position = [264 112 113 22];
            app.MassflowsetpointEditField_3Label.Text = 'Mass flow setpoint';

            % Create Carrierinput
            app.Carrierinput = uieditfield(app.CarriergasPanel, 'numeric');
            app.Carrierinput.ValueChangedFcn = createCallbackFcn(app, @CarriersetpointValueChanged, true);
            app.Carrierinput.FontName = 'Segoe UI Light';
            app.Carrierinput.FontSize = 14;
            app.Carrierinput.FontColor = [0.4667 0.6745 0.1882];
            app.Carrierinput.BackgroundColor = [0.2314 0.2314 0.2314];
            app.Carrierinput.Position = [264 79 140 22];

            % Create sccmLabel_3
            app.sccmLabel_3 = uilabel(app.CarriergasPanel);
            app.sccmLabel_3.FontName = 'Segoe UI Light';
            app.sccmLabel_3.FontSize = 14;
            app.sccmLabel_3.FontColor = [1 1 1];
            app.sccmLabel_3.Position = [430 79 34 22];
            app.sccmLabel_3.Text = 'sccm';

            % Create ZeroButton_3
            app.ZeroButton_3 = uibutton(app.CarriergasPanel, 'push');
            app.ZeroButton_3.ButtonPushedFcn = createCallbackFcn(app, @ZeroButton_3Pushed, true);
            app.ZeroButton_3.BackgroundColor = [0.2314 0.2314 0.2314];
            app.ZeroButton_3.FontName = 'Segoe UI Light';
            app.ZeroButton_3.FontColor = [1 1 1];
            app.ZeroButton_3.Position = [264 29 85 35];
            app.ZeroButton_3.Text = 'Zero';

            % Create ApplyButton_3
            app.ApplyButton_3 = uibutton(app.CarriergasPanel, 'push');
            app.ApplyButton_3.ButtonPushedFcn = createCallbackFcn(app, @CarriersetpointValueChanged, true);
            app.ApplyButton_3.BackgroundColor = [0.7176 0.1137 0.1216];
            app.ApplyButton_3.FontName = 'Segoe UI Light';
            app.ApplyButton_3.FontColor = [1 1 1];
            app.ApplyButton_3.Position = [379 29 85 35];
            app.ApplyButton_3.Text = 'Apply';

            % Create Carrierscale
            app.Carrierscale = uieditfield(app.CarriergasPanel, 'numeric');
            app.Carrierscale.Editable = 'off';
            app.Carrierscale.HorizontalAlignment = 'center';
            app.Carrierscale.FontColor = [0.9412 0.9412 0.9412];
            app.Carrierscale.BackgroundColor = [0.2314 0.2314 0.2314];
            app.Carrierscale.Position = [393 171 100 22];

            % Create oCEditFieldLabel
            app.oCEditFieldLabel = uilabel(app.CarriergasPanel);
            app.oCEditFieldLabel.Interpreter = 'tex';
            app.oCEditFieldLabel.HorizontalAlignment = 'right';
            app.oCEditFieldLabel.FontColor = [1 1 1];
            app.oCEditFieldLabel.Position = [120 171 29 22];
            app.oCEditFieldLabel.Text = '^o C';

            % Create Carriertemp
            app.Carriertemp = uieditfield(app.CarriergasPanel, 'numeric');
            app.Carriertemp.Editable = 'off';
            app.Carriertemp.HorizontalAlignment = 'center';
            app.Carriertemp.FontColor = [1 1 1];
            app.Carriertemp.BackgroundColor = [0.2314 0.2314 0.2314];
            app.Carriertemp.Position = [18 171 100 22];

            % Create UnitsandgastypesPanel
            app.UnitsandgastypesPanel = uipanel(app.Panel);
            app.UnitsandgastypesPanel.BorderColor = [1 1 1];
            app.UnitsandgastypesPanel.Enable = 'off';
            app.UnitsandgastypesPanel.ForegroundColor = [1 1 1];
            app.UnitsandgastypesPanel.BorderWidth = 2;
            app.UnitsandgastypesPanel.TitlePosition = 'centertop';
            app.UnitsandgastypesPanel.Title = 'Units and gas types';
            app.UnitsandgastypesPanel.Visible = 'off';
            app.UnitsandgastypesPanel.BackgroundColor = [0.502 0.502 0.502];
            app.UnitsandgastypesPanel.FontName = 'Segoe UI';
            app.UnitsandgastypesPanel.FontSize = 14;
            app.UnitsandgastypesPanel.Position = [798 436 260 221];

            % Create OKButton
            app.OKButton = uibutton(app.UnitsandgastypesPanel, 'push');
            app.OKButton.ButtonPushedFcn = createCallbackFcn(app, @OKButtonPushed, true);
            app.OKButton.FontName = 'Segoe UI';
            app.OKButton.FontSize = 14;
            app.OKButton.Position = [82 21 100 26];
            app.OKButton.Text = 'OK';

            % Create GastypeEditFieldLabel
            app.GastypeEditFieldLabel = uilabel(app.UnitsandgastypesPanel);
            app.GastypeEditFieldLabel.Position = [46 138 56 22];
            app.GastypeEditFieldLabel.Text = 'Gas  type';

            % Create GastypeEditField
            app.GastypeEditField = uieditfield(app.UnitsandgastypesPanel, 'text');
            app.GastypeEditField.Editable = 'off';
            app.GastypeEditField.Position = [117 138 100 22];

            % Create UnitsEditFieldLabel
            app.UnitsEditFieldLabel = uilabel(app.UnitsandgastypesPanel);
            app.UnitsEditFieldLabel.Position = [46 92 32 22];
            app.UnitsEditFieldLabel.Text = 'Units';

            % Create UnitsEditField
            app.UnitsEditField = uieditfield(app.UnitsandgastypesPanel, 'text');
            app.UnitsEditField.Editable = 'off';
            app.UnitsEditField.Position = [117 92 100 22];

            % Create aboutme
            app.aboutme = uilabel(app.XinnovisControlUIFigure);
            app.aboutme.BackgroundColor = [0.302 0.302 0.302];
            app.aboutme.HorizontalAlignment = 'center';
            app.aboutme.FontName = 'Segoe UI';
            app.aboutme.FontSize = 14;
            app.aboutme.FontColor = [1 1 1];
            app.aboutme.Enable = 'off';
            app.aboutme.Visible = 'off';
            app.aboutme.Position = [108 217 1109 305];
            app.aboutme.Text = {'Xinnovis Mass Flow Control software v.0.1'; ''; ''; 'This program is designed to accurately operate Xinnovis S500 Mass Flow Controllers with better experience than original shitsoft from manufacturer.'; ''; 'THE SOFTWARE IS PROVIDED ''AS IS'', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, '; 'FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, '; 'DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH '; 'THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.'; ''; 'Copyright: D.A. Labutov, MIPT'; ''; 'Credits and requests: labutov.da@phystech.edu'};

            % Create FinddevicePanel
            app.FinddevicePanel = uipanel(app.XinnovisControlUIFigure);
            app.FinddevicePanel.ForegroundColor = [0 0.4471 0.7412];
            app.FinddevicePanel.BorderWidth = 5;
            app.FinddevicePanel.TitlePosition = 'centertop';
            app.FinddevicePanel.Title = 'Find device';
            app.FinddevicePanel.Visible = 'off';
            app.FinddevicePanel.BackgroundColor = [0.902 0.902 0.902];
            app.FinddevicePanel.FontName = 'Segoe UI Light';
            app.FinddevicePanel.FontWeight = 'bold';
            app.FinddevicePanel.FontSize = 14;
            app.FinddevicePanel.Position = [125 409 250 300];

            % Create COMportDropDownLabel
            app.COMportDropDownLabel = uilabel(app.FinddevicePanel);
            app.COMportDropDownLabel.FontName = 'Segoe UI';
            app.COMportDropDownLabel.Position = [35 201 58 22];
            app.COMportDropDownLabel.Text = 'COM port';

            % Create COMportDropDown
            app.COMportDropDown = uidropdown(app.FinddevicePanel);
            app.COMportDropDown.Items = {'COM1', 'COM2', 'COM3', 'COM4', 'COM5', 'COM6', 'COM7', 'COM8', 'COM9', 'COM10', 'COM11', 'COM12', 'COM13', 'COM14', 'COM15', 'COM16', 'COM17', 'COM18', 'COM19', 'COM20'};
            app.COMportDropDown.FontName = 'Segoe UI';
            app.COMportDropDown.Position = [107 201 100 22];
            app.COMportDropDown.Value = 'COM9';

            % Create CarrierIDDropDownLabel
            app.CarrierIDDropDownLabel = uilabel(app.FinddevicePanel);
            app.CarrierIDDropDownLabel.FontName = 'Segoe UI';
            app.CarrierIDDropDownLabel.Position = [35 162 55 22];
            app.CarrierIDDropDownLabel.Text = 'Carrier ID';

            % Create CarrierIDDropDown
            app.CarrierIDDropDown = uidropdown(app.FinddevicePanel);
            app.CarrierIDDropDown.Items = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10'};
            app.CarrierIDDropDown.FontName = 'Segoe UI';
            app.CarrierIDDropDown.Position = [107 162 100 22];
            app.CarrierIDDropDown.Value = '1';

            % Create ExhaustIDDropDownLabel
            app.ExhaustIDDropDownLabel = uilabel(app.FinddevicePanel);
            app.ExhaustIDDropDownLabel.FontName = 'Segoe UI';
            app.ExhaustIDDropDownLabel.Position = [35 124 57 22];
            app.ExhaustIDDropDownLabel.Text = 'ExhaustID';

            % Create ExhaustIDDropDown
            app.ExhaustIDDropDown = uidropdown(app.FinddevicePanel);
            app.ExhaustIDDropDown.Items = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10'};
            app.ExhaustIDDropDown.FontName = 'Segoe UI';
            app.ExhaustIDDropDown.Position = [107 124 100 22];
            app.ExhaustIDDropDown.Value = '2';

            % Create FocusingIDDropDownLabel
            app.FocusingIDDropDownLabel = uilabel(app.FinddevicePanel);
            app.FocusingIDDropDownLabel.FontName = 'Segoe UI';
            app.FocusingIDDropDownLabel.Position = [35 86 67 22];
            app.FocusingIDDropDownLabel.Text = 'Focusing ID';

            % Create FocusingIDDropDown
            app.FocusingIDDropDown = uidropdown(app.FinddevicePanel);
            app.FocusingIDDropDown.Items = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10'};
            app.FocusingIDDropDown.FontName = 'Segoe UI';
            app.FocusingIDDropDown.Position = [107 86 100 22];
            app.FocusingIDDropDown.Value = '3';

            % Create ApplyButton_4
            app.ApplyButton_4 = uibutton(app.FinddevicePanel, 'push');
            app.ApplyButton_4.ButtonPushedFcn = createCallbackFcn(app, @ApplyButton_4Pushed, true);
            app.ApplyButton_4.BackgroundColor = [0 0.4471 0.7412];
            app.ApplyButton_4.FontName = 'Segoe UI';
            app.ApplyButton_4.FontColor = [1 1 1];
            app.ApplyButton_4.Position = [72 29 100 23];
            app.ApplyButton_4.Text = 'Apply';

            % Create xButton
            app.xButton = uibutton(app.FinddevicePanel, 'push');
            app.xButton.ButtonPushedFcn = createCallbackFcn(app, @xButtonPushed, true);
            app.xButton.BackgroundColor = [0.6353 0.0784 0.1843];
            app.xButton.FontColor = [0.9412 0.9412 0.9412];
            app.xButton.Position = [218 268 25 25];
            app.xButton.Text = 'x';

            % Create CurrentportisEditFieldLabel
            app.CurrentportisEditFieldLabel = uilabel(app.XinnovisControlUIFigure);
            app.CurrentportisEditFieldLabel.HorizontalAlignment = 'right';
            app.CurrentportisEditFieldLabel.FontName = 'Segoe UI Light';
            app.CurrentportisEditFieldLabel.FontColor = [0.9412 0.9412 0.9412];
            app.CurrentportisEditFieldLabel.Position = [927 684 78 22];
            app.CurrentportisEditFieldLabel.Text = 'Current port is';

            % Create CurrentportisEditField
            app.CurrentportisEditField = uieditfield(app.XinnovisControlUIFigure, 'text');
            app.CurrentportisEditField.Editable = 'off';
            app.CurrentportisEditField.FontName = 'Segoe UI Light';
            app.CurrentportisEditField.FontWeight = 'bold';
            app.CurrentportisEditField.FontColor = [0.9412 0.9412 0.9412];
            app.CurrentportisEditField.BackgroundColor = [0.2314 0.2314 0.2314];
            app.CurrentportisEditField.Position = [1020 684 100 22];
            app.CurrentportisEditField.Value = 'null';

            % Create Button
            app.Button = uibutton(app.XinnovisControlUIFigure, 'push');
            app.Button.ButtonPushedFcn = createCallbackFcn(app, @ButtonPushed, true);
            app.Button.Icon = fullfile(pathToMLAPP, 'MFC_icon_white.svg');
            app.Button.BackgroundColor = [0.2314 0.2314 0.2314];
            app.Button.FontWeight = 'bold';
            app.Button.FontColor = [0.9412 0.9412 0.9412];
            app.Button.Enable = 'off';
            app.Button.Tooltip = {'Devices operation'};
            app.Button.Position = [10 451 80 80];
            app.Button.Text = '';

            % Create Button_2
            app.Button_2 = uibutton(app.XinnovisControlUIFigure, 'push');
            app.Button_2.ButtonPushedFcn = createCallbackFcn(app, @Button_2Pushed, true);
            app.Button_2.Icon = fullfile(pathToMLAPP, 'start.svg');
            app.Button_2.BackgroundColor = [0.2314 0.2314 0.2314];
            app.Button_2.FontWeight = 'bold';
            app.Button_2.FontColor = [0.9412 0.9412 0.9412];
            app.Button_2.Enable = 'off';
            app.Button_2.Tooltip = {'Start'};
            app.Button_2.Position = [10 321 80 80];
            app.Button_2.Text = '';

            % Create Button_3
            app.Button_3 = uibutton(app.XinnovisControlUIFigure, 'push');
            app.Button_3.ButtonPushedFcn = createCallbackFcn(app, @AboutMenuSelected, true);
            app.Button_3.BackgroundColor = [0.2314 0.2314 0.2314];
            app.Button_3.FontName = 'Segoe UI Light';
            app.Button_3.FontSize = 48;
            app.Button_3.FontWeight = 'bold';
            app.Button_3.FontColor = [0.9412 0.9412 0.9412];
            app.Button_3.Tooltip = {'About'};
            app.Button_3.Position = [7 191 86 80];
            app.Button_3.Text = '?';

            % Create ContextMenu
            app.ContextMenu = uicontextmenu(app.XinnovisControlUIFigure);

            % Create CloseMenu
            app.CloseMenu = uimenu(app.ContextMenu);
            app.CloseMenu.MenuSelectedFcn = createCallbackFcn(app, @CloseMenuSelected, true);
            app.CloseMenu.Text = 'Close';
            
            % Assign app.ContextMenu
            app.aboutme.ContextMenu = app.ContextMenu;

            % Show the figure after all components are created
            app.XinnovisControlUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Xinnovis_exported

            runningApp = getRunningApp(app);

            % Check for running singleton app
            if isempty(runningApp)

                % Create UIFigure and components
                createComponents(app)

                % Register the app with App Designer
                registerApp(app, app.XinnovisControlUIFigure)
            else

                % Focus the running singleton app
                figure(runningApp.XinnovisControlUIFigure)

                app = runningApp;
            end

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.XinnovisControlUIFigure)
        end
    end
end