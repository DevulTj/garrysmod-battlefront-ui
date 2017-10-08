--[[
    Battlefront UI
    Created by http://steamcommunity.com/id/Devul/
    Do not redistribute this software without permission from authors

    Developer information: {{ user_id }} : {{ script_id }} : {{ script_version_id }}
]]--

local gradient = Material( "gui/gradient" )
local gradientr = Material( "vgui/gradient-r" )
local glowMat = Material( "particle/Particle_Glow_04_Additive" )
local blur = Material( "pp/blurscreen" )

function bfUI.getMenu()
    return bfUIMenu
end

bfUI.toggleMenu = function()
    if IsValid( bfUIMenu ) then
        bfUIMenu:fadeOut()
    else
        bfUIMenu = vgui.Create( "bfUIFrame" )
        bfUIMenu:fadeIn()
    end
end

local FRAME = {}

function FRAME:Init()
    self:StretchToParent( 0, 0, 0, 0 )
    self:SetDraggable( false )
    self:ShowCloseButton( false )
    self:SetTitle( "" )

    self:MakePopup()

    self:setUp()
    self:SetKeyboardInputEnabled( false )
end

function FRAME:canFade()
    if self.fadingIn or self.fadingOut then return false end

    return true
end

function FRAME:fadeIn()
    if not self:canFade() then return end

    self.fadingIn = true

    self:refreshBackground()

    self:SetAlpha( 0 )
    self:AlphaTo( 255, bfUI.getClientData( "fade_time", 0.5 ), 0, function()
        self.fadingIn = false
    end )
end

function FRAME:fadeOut()
    if not self:canFade() then return end

    self.fadingOut = true

    local isAtZero = select( 1, self.background:GetPos() ) == 0 and true or false
    self.background:MoveTo( 0.1, 0, isAtZero and 0 or bfUI.getClientData( "element_pressed_fade_time", 0.5 ), 0, -1, function()
        self:AlphaTo( 0, bfUI.getClientData( "fade_time", 0.5 ), 0, function()
            self.fadingOut = false
            self:Close()
        end )
    end )
end

function FRAME:refreshBackground()
    if bfUI.getUnEditableData( "background_material_disabled", false ) then return end

    local backgroundMaterial = bfUI.getClientData( "background_material", "bfui/bfui_background.jpg" )

    if istable( backgroundMaterial ) then
        backgroundMaterial = table.Random( backgroundMaterial )
    end

    self.backgroundMaterial = Material( backgroundMaterial )
end

function FRAME:setUp()
    self:refreshBackground()

    local buttonDisabledColor = bfUI.getClientData( "element_button_disabled_color", Color( 125, 125, 125 ) )
    local buttonDownColor = bfUI.getClientData( "element_button_down_color", Color( 235, 235, 235 ) )
    local buttonHoverColor = bfUI.getClientData( "element_button_hover_color", Color( 215, 215, 215 ) )
    local buttonColor = bfUI.getClientData( "element_button_color", color_white )

    self.background = self:Add( "DPanel" )
    self.background:SetSize( self:GetWide() * 3, self:GetTall() )

    local color = bfUI.getClientData( "main_color", color_black )
    local gradientCol = bfUI.getClientData( "gradient_color", color_black )

    self.background.Paint = function( pnl, w, h )
        local scrW, scrH = ScrW(), ScrH()

        draw.RoundedBox( 0, 0, 0, w, h, color )
        draw.RoundedBox( 0, scrW, 0, w - scrW, h, gradientCol )

        if self.backgroundMaterial then
            surface.SetDrawColor( Color( 255, 255, 255, self:GetAlpha() ) )
            surface.SetMaterial( self.backgroundMaterial )
            surface.DrawTexturedRect( 0, 0, scrW, scrH )
        end

        surface.SetDrawColor( gradientCol )
        surface.SetMaterial( gradientr )
        surface.DrawTexturedRect( scrW * 0.75, 0, scrW * 0.25, h )
    end

    self.leftPanel = self:Add( "DPanel" )
    self.leftPanel:Dock( LEFT )
    self.leftPanel:DockMargin( 0, -24, 0, 0 )
    self.leftPanel:SetWide( 24 )

    local elementsCol = bfUI.getClientData( "theme_elements_color", color_white )
    elementsCol = Color( elementsCol.r, elementsCol.g, elementsCol.b, 75 )
    self.leftPanel.Paint = function( pnl, w, h )

    end

    self.buttonLayout = self:Add( "DIconLayout" )
    self.buttonLayout:Dock( TOP )
    self.buttonLayout:DockMargin( 24, 48, 0, 0 )
    self.buttonLayout:DockPadding( 0, 0, 0, 16 )
    self.buttonLayout:SetTall( 64 )
    self.buttonLayout:SetSpaceX( 4 )

    self.buttonLayout.Paint = function( pnl, w, h )

    end

    self.panel = self:Add( "EditablePanel" )
    self.panel:Dock( FILL )
    self.panel:DockMargin( 20, 12, 0, 0 )
    self.panel.Paint = function( pnl, w, h ) end

    local buttonW = 144

    self.elements = {}
    for Id, data in SortedPairs( bfUI.config.ELEMENTS ) do
        self.elements[ Id ] = self.buttonLayout:Add( "DButton" )
        local button = self.elements[ Id ]

        button:SetText(
        bfUI.getUnEditableData( "element_title_force_uppercase", false ) and string.upper( data.name )
        or data.name )

        button:Dock( LEFT )

        if Id > 1 then
            button:DockMargin( -2, 0, 0, 0 )
        end

        button:SetWide( buttonW )
        button:SetFont( "bfUIMedium" )
        button:SetExpensiveShadow( 1, Color( 0, 0, 0, 185 ) )

        button.alpha = 0
        button.Paint = function( pnl, w, h )
            surface.SetDrawColor( color_white )
            surface.DrawRect( 0, 0, 2, h - 5 )
            surface.DrawRect( w - 2, 0, 2, h - 5 )

            if pnl.isActive then
                -- Left tip
                surface.DrawRect( 0, h - 3, 2, 3 )
                -- Right tip
                surface.DrawRect( w - 2, h - 3, 2, 3 )

                -- Background
                surface.SetDrawColor( Color( 150, 150, 150, 50 ) )
                surface.DrawRect( 2, 0, w - 4, h - 5 )
            end
        end

        local customCheck = data.customCheck and data.customCheck( LocalPlayer(), button )
        button:SetDisabled( customCheck == false )

        button.UpdateColours = function( pnl, skin )
            if pnl:GetDisabled() then return pnl:SetTextStyleColor( buttonDisabledColor ) end
            if pnl.Depressed or pnl.m_bSelected then return pnl:SetTextStyleColor( buttonDownColor ) end
            if pnl:IsHovered() then return pnl:SetTextStyleColor( buttonHoverColor ) end

            return pnl:SetTextStyleColor( buttonColor )
        end

        local increaseAmount = ScrW() / 6
        button.DoClick = function( pnl )
            local fadeTime = bfUI.getClientData( "element_pressed_fade_time", 0.5 )
            self.panel:AlphaTo( 0, fadeTime, 0 )
            self.background:MoveTo( - ( increaseAmount * ( Id - 1 ) ), nil, fadeTime, 0, -1, function()
                self.panel:Clear()
                self.panel:AlphaTo( 255, fadeTime, 0 )

                bfUI.getCallback( data, self )
            end )

            for _, _button in pairs( self.elements ) do
                _button.isActive = false
            end

            pnl.isActive = true
            pnl:MoveToFront()
        end
    end

    local firstElement = bfUI.config.ELEMENTS[ 1 ]
    if firstElement then bfUI.getCallback( firstElement, self ) end
end

derma.DefineControl( "bfUIFrame", nil, FRAME, "DFrame" )

local BUTTON = {}

function BUTTON:Init()
    self:SetFont( "bfUIMedium" )
end

function BUTTON:Paint( w, h )
    local buttonColor = bfUI.getClientData( "button_bg_color", color_white )

    local isHovered = self:IsHovered()
    local xOverride, yOverride, wOverride, hOverride = self.xOverride or 0, self.yOverride or 0, self.wOverride or w, self.hOverride or h
    draw.RoundedBox( 0, xOverride, yOverride, wOverride, hOverride, Color( buttonColor.r, buttonColor.g, buttonColor.b, isHovered and 255 or 0 ) )

    surface.SetDrawColor( Color( buttonColor.r, buttonColor.g, buttonColor.b, 255 ) )
    surface.DrawOutlinedRect( xOverride, yOverride, wOverride, hOverride )

    self:SetTextColor( isHovered and bfUI.getClientData( "button_text_color_inverted", color_black ) or bfUI.getClientData( "button_text_color", color_white ) )
end

function BUTTON:PaintOver()
    local pressed = self.Depressed or self.m_bSelected

    self.xOverride, self.yOverride = pressed and 1 or nil, pressed and 1 or nil
    self.wOverride, self.hOverride = pressed and ( self:GetWide() - 2 ) or nil, pressed and ( self:GetTall() - 2 ) or nil
end

derma.DefineControl( "bfUIDialogueButton", nil, BUTTON, "DButton" )


local BUTTON = {}

function BUTTON:Init()
    self:SetFont( "bfUIMedium" )
end

function BUTTON:Paint( w, h )
    local buttonColor = bfUI.getClientData( "button_bg_color", color_white )

    local isHovered = self:IsHovered()
    local xOverride, yOverride, wOverride, hOverride = self.xOverride or 0, self.yOverride or 0, self.wOverride or w, self.hOverride or h
    draw.RoundedBox( 0, xOverride, yOverride, wOverride, hOverride, Color( buttonColor.r, buttonColor.g, buttonColor.b, isHovered and 255 or 0 ) )

    surface.SetDrawColor( Color( buttonColor.r, buttonColor.g, buttonColor.b, 255 ) )
    surface.DrawOutlinedRect( xOverride, yOverride, wOverride, hOverride )

    self:SetTextColor( isHovered and bfUI.getClientData( "button_text_color_inverted", color_black ) or bfUI.getClientData( "button_text_color", color_white ) )
end

function BUTTON:PaintOver()
    local pressed = self.Depressed or self.m_bSelected

    self.xOverride, self.yOverride = pressed and 1 or nil, pressed and 1 or nil
    self.wOverride, self.hOverride = pressed and ( self:GetWide() - 2 ) or nil, pressed and ( self:GetTall() - 2 ) or nil
end

derma.DefineControl( "bfUIButton", nil, BUTTON, "DButton" )

FRAME = {}

function FRAME:Init()
    self:StretchToParent( 0, 0, 0, 0 )
    self:SetDraggable( false )
    self:ShowCloseButton( false )

    self:SetTitle( "" )

    self:MakePopup()
end

function FRAME:Paint( w, h )
    draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )

    surface.SetMaterial( blur )
    surface.SetDrawColor( color_white )

    local x, y = self:LocalToScreen( 0, 0 )

    local scrW, scrH = ScrW(), ScrH()
    for i = 0.2, 1, 0.2 do
        blur:SetFloat( "$blur", i * 4 )
        blur:Recompute()

        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect( x * - 1, y * - 1, scrW, scrH )
    end
end

function FRAME:setUp()
    self.container = self:Add( "EditablePanel" )
    self.container:SetSize( ScrH() * 0.3, ScrH() * 0.3 )
    self.container:Center()

    self.title = self.container:Add( "DLabel" )
    self.title:Dock( TOP )
    self.title:SetText( self.titleText or "THIS IS A TITLE" )
    self.title:SetFont( "bfUILarge" )
    self.title:SetTextColor( color_white )
    self.title:SetContentAlignment( 5 )
    self.title:SetHeight( 20 )

    self.text = self.container:Add( "DLabel" )
    self.text:Dock( TOP )
    self.text:SetText( self.textText or "This is some text" )
    self.text:SetFont( "bfUIMedium" )
    self.text:SetTextColor( color_white )
    self.text:SetContentAlignment( 5 )
    self.text:SetHeight( 40 )

    self.option1 = self.container:Add( "bfUIDialogueButton" )
    self.option1:Dock( TOP )
    self.option1:SetText( self.option1Text or "YES" )
    self.option1:SetHeight( 40 )
    self.option1.DoClick = function( pnl )
        if self.callback1 then return self.callback1( self ) end
    end

    self.option2 = self.container:Add( "bfUIDialogueButton" )
    self.option2:Dock( TOP )
    self.option2:DockMargin( 0, 4, 0, 0 )
    self.option2:SetText( self.option2Text or "NO" )
    self.option2:SetHeight( 40 )
    self.option2.DoClick = function( pnl )
        if self.callback2 then return self.callback2( self ) end
    end
end

derma.DefineControl( "bfUIDialogueFrame", nil, FRAME, "DFrame" )

bfUI.createDialogue = function( title, text, option1, callback1, option2, callback2 )
    bfUI.dialogueFrame = vgui.Create( "bfUIDialogueFrame" )

    bfUI.dialogueFrame.titleText = title
    bfUI.dialogueFrame.textText = text

    bfUI.dialogueFrame.option1Text = option1
    bfUI.dialogueFrame.callback1 = callback1

    bfUI.dialogueFrame.option2Text = option2
    bfUI.dialogueFrame.callback2 = callback2

    bfUI.dialogueFrame:setUp()

    bfUI.dialogueFrame:SetAlpha( 0 )
    bfUI.dialogueFrame:AlphaTo( 255, bfUI.getClientData( "fade_time", 0.5 ), 0 )
end

FRAME = {}

function FRAME:Init()
    self:StretchToParent( 0, 0, 0, 0 )
    self:SetDraggable( false )
    self:ShowCloseButton( false )

    self:SetTitle( "" )

    self:MakePopup()
end

function FRAME:Paint( w, h )
    draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )

    surface.SetMaterial( blur )
    surface.SetDrawColor( color_white )

    local x, y = self:LocalToScreen( 0, 0 )

    for i = 0.2, 1, 0.2 do
        blur:SetFloat( "$blur", i * 4 )
        blur:Recompute()

        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect( x * - 1, y * - 1, ScrW(), ScrH() )
    end
end

function FRAME:setUp()
    self.container = self:Add( "Panel" )
    self.container:SetSize( ScrH() * 0.75, ScrH() * 0.75 )
    self.container:Center()

    self.title = self.container:Add( "DLabel" )
    self.title:Dock( TOP )
    self.title:SetText( "SETTINGS" )
    self.title:SetFont( "bfUILarge" )
    self.title:SetTextColor( color_white )
    self.title:SetContentAlignment( 4 )
    self.title:SetHeight( 20 )

    self.spacer = self.container:Add( "DPanel" )
    self.spacer:Dock( TOP )
    self.spacer:DockMargin( 0, 8, 0, 0 )
    self.spacer:SetHeight( 1 )

    self.spacer.Paint = function( pnl, w, h )
        surface.SetDrawColor( color_white )
        surface.SetMaterial( gradient )
        surface.DrawTexturedRect( 0, 0, w, h )
    end

    self.closeBtn = self.container:Add( "bfUIDialogueButton" )
    self.closeBtn:Dock( BOTTOM )
    self.closeBtn:DockMargin( 0, 4, 0, 0 )
    self.closeBtn:SetText( "CLOSE" )
    self.closeBtn:SetHeight( 40 )
    self.closeBtn.DoClick = function( pnl )
        self:Close()
    end

    self.resetBtn = self.container:Add( "bfUIDialogueButton" )
    self.resetBtn:Dock( BOTTOM )
    self.resetBtn:DockMargin( 0, 4, 0, 4 )
    self.resetBtn:SetText( "RESET TO DEFAULTS" )
    self.resetBtn:SetHeight( 40 )
    self.resetBtn.DoClick = function( pnl )
        bfUI.createDialogue( "RESET", "Reset to defaults settings?", "YES", function( dialogue )
            for a, b in pairs( bfUI.data.stored ) do
                bfUI.setClientData( a, b.default )
            end

            dialogue:Close()

            self:Close()
            bfUI.createSettingsFrame()
        end, "NO", function( dialogue ) dialogue:Close() end )
    end

    self.scroll = self.container:Add( "DScrollPanel" )
    self.scroll:Dock( FILL )
    self.scroll:SetSize( ScrH() * 0.75, ScrH() * 0.75 - 112 )
    self.scroll:InvalidateParent( true )

    self.properties = self.scroll:Add( "DProperties" )
    self.properties:SetSize( self.scroll:GetSize() )

    local varsSaved = {}
    for k, v in pairs( bfUI.data.stored ) do
        local index = v.data and v.data.category or "misc"

        varsSaved[ index ] = varsSaved[ index ] or {}
        varsSaved[ index ][ k ] = v
    end

    for category, settings in SortedPairs( varsSaved ) do
        for k, v in SortedPairs( settings ) do
            local form = v.data and v.data.form
            local value = bfUI.getClientData( k, bfUI.data.stored[ k ].default )

            local _type = type( value )

            if not form then
                if _type == "number" then
                    form = "Int"
                    value = tonumber( value )
                elseif _type == "boolean" then
                    form = "Boolean"
                    value = tobool( value )
                elseif _type == "table" then
                    if not value.r then
                        form = "Combo"
                    else
                        form = "VectorColor"
                        value = Vector( value.r / 255, value.g / 255, value.b / 255 )
                        _type = type( value )
                    end
                else
                    form = "Generic"
                end
            end

            local row = self.properties:CreateRow( category, k )
            row:Setup( form, v.data and v.data.data or {} )
            row:SetTooltip( v.description )

            if form == "Combo" then
                for _, rowValue in pairs( value ) do
                    row:AddChoice( rowValue, rowValue, true )
                    print(rowValue)
                end
            end

            if form ~= "Combo" then
                row:SetValue( value )
            end

            local beforeVal = value
            row.DataChanged = function( this, data )
                if form == "VectorColor" then
                    local vector = Vector( data )

                    data = Color( math.floor( vector.x * 255 ), math.floor( vector.y * 255 ), math.floor( vector.z * 255 ) )
                elseif form == "Int" or form == "Float" then
                    data = tonumber( data )

                    if form == "Int" then
                        data = math.Round( data )
                    end
                elseif form == "Boolean" then
                    data = tobool( data )
                end

                bfUI.setClientData( k, data )
                if v.callback then v.callback( beforeVal, data ) end
            end
        end
    end
end

derma.DefineControl( "bfUISettingsFrame", nil, FRAME, "DFrame" )

bfUI.createSettingsFrame = function()
    bfUI.settingsFrame = vgui.Create( "bfUISettingsFrame" )
    bfUI.settingsFrame:setUp()

    bfUI.settingsFrame:SetAlpha( 0 )
    bfUI.settingsFrame:AlphaTo( 255, bfUI.getClientData( "fade_time", 0.5 ), 0 )
end

BUTTON = {}

function BUTTON:Init()
    self:SetText( "" )
end

function BUTTON:setText( text )
    self.textText = text
end

function BUTTON:getText()
    return self.textText
end

function BUTTON:setDesc( desc )
    self.descText = desc
end

function BUTTON:getDesc()
    return self.descText
end

function BUTTON:setJoinText( text )
    self.joinText = text
end

function BUTTON:getJoinText()
    return self.joinText
end

function BUTTON:setServerIcon( mat )
    self.serverIcon = mat
end

function BUTTON:getServerIcon()
    return self.serverIcon
end

function BUTTON:setIP( ip )
    self.ip = ip
end

function BUTTON:getIP()
    return self.ip
end

function BUTTON:setUp()
    self.topPanel = self:Add( "DPanel" )
    self.topPanel:SetSize( self:GetWide(), self:GetTall() / 2 )

    self.bottomPanel = self:Add( "DButton" )
    self.bottomPanel:SetText( "" )
    self.bottomPanel:SetSize( self:GetWide(), self:GetTall() / 2 )
    self.bottomPanel:SetPos( 0, self:GetTall() / 2 )

    self.bottomPanel.boxY = self.bottomPanel:GetTall()
    self.bottomPanel.textCol = 255

    self.bottomPanel.Paint = function( pnl, w, h )
        local hovered = pnl:IsHovered()

        pnl.boxY = math.Clamp( hovered and ( pnl.boxY - 4 ) or ( pnl.boxY + 3 ), 0, self.bottomPanel:GetTall() )
        pnl.textCol = math.Clamp( hovered and ( pnl.textCol - 10 ) or ( pnl.textCol + 10 ), 0, 255 )

        draw.RoundedBox( 0, 0, pnl.boxY, w, h, bfUI.getClientData( "button_bg_color", color_white ) )
        draw.RoundedBox( 0, 0, h - 32, w, 1, Color( 150, 150, 150, 255 ) )

        draw.SimpleText( self.joinText or "JOIN", "bfUIMedium", w / 2, h - 4, Color( pnl.textCol, pnl.textCol, pnl.textCol, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
        draw.SimpleText( self.textText or "SERVER NAME", "bfUIMedium", 12, 10, Color( pnl.textCol, pnl.textCol, pnl.textCol, 255 ) )

        draw.SimpleText( self.descText or "A garry's mod server.", "bfUISmall", 12, 36, Color( pnl.textCol, pnl.textCol, pnl.textCol, 255 ) )
    end

    local icon = self:getServerIcon()

    self.topPanel.iconW, self.topPanel.iconH = self.topPanel:GetSize()
    self.topPanel.PaintOver = function( pnl, w, h )
        local hovered = self.bottomPanel:IsHovered()
        pnl.iconW = math.Clamp( hovered and ( pnl.iconW + 0.25 ) or ( pnl.iconW - 0.25 ), self.topPanel:GetWide(), self.topPanel:GetWide() * 1.02 )
        pnl.iconH = math.Clamp( hovered and ( pnl.iconH + 0.25 ) or ( pnl.iconH - 0.25 ), self.topPanel:GetTall(), self.topPanel:GetTall() * ( 1 + ( 0.02 * ( self.topPanel:GetWide() / self.topPanel:GetTall() ) ) ) )

        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial( icon )
        surface.DrawTexturedRect( 0, 0, pnl.iconW, pnl.iconH )
    end

    self.bottomPanel.DoClick = function( pnl )
        bfUI.createDialogue(
            "JOIN SERVER",
            "Do you want join " .. self.textText .. "?" ,
            "Yes",
            function( dialogue )
                dialogue:Close()
                LocalPlayer():ConCommand( "connect " .. self:getIP() )
            end,
            "No",
            function( dialogue )
                dialogue:Close()
            end )
    end
end

function BUTTON:Paint( w, h )
    draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 75 ) )
    surface.SetMaterial( blur )
    surface.SetDrawColor( color_white )

    local x, y = self:LocalToScreen( 0, 0 )

    local scrW, scrH = ScrW(), ScrH()
    for i = 2, 1, 0.2 do
        blur:SetFloat( "$blur", i * 5 )
        blur:Recompute()

        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect( x * - 1, y * - 1, scrW, scrH )
    end
end

function BUTTON:PaintOver( width, height )
    local pressed = self.Depressed or self.m_bSelected

    self.xOverride, self.yOverride = pressed and 1 or nil, pressed and 1 or nil
    self.wOverride, self.hOverride = pressed and ( width - 2 ) or nil, pressed and ( height - 2 ) or nil
end

derma.DefineControl( "bfUIServerButton", nil, BUTTON, "DButton" )
